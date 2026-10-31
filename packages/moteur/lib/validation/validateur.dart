import 'dart:convert';
import 'dart:io';

import '../modeles/jeu.dart';

/// Résultat d'une validation : erreurs bloquantes et avertissements.
class RapportValidation {
  RapportValidation({this.erreurs = const [], this.avertissements = const []});

  final List<String> erreurs;
  final List<String> avertissements;

  bool get valide => erreurs.isEmpty;
}

/// Charge et valide un paquet de jeu `jeu.json`.
///
/// Le schéma formel est `docs/schema/jeu.schema.json` (référence unique,
/// chargé tel quel) ; les contrôles sémantiques de MOTEUR_EFFETS.md §7
/// s'ajoutent ensuite. Tous les messages sont en français, avec le chemin
/// dans le JSON.
class Validateur {
  Validateur({String? cheminSchema}) {
    final schema = File(cheminSchema ?? '../../docs/schema/jeu.schema.json');
    _schemaJson = schema.readAsStringSync();
  }

  late final String _schemaJson;

  /// Schéma JSON de référence, chargé tel quel depuis `docs/schema`.
  String get schemaJson => _schemaJson;

  static const int schemaVersionMax = 1;

  /// Valide le JSON brut d'un paquet. Retourne le rapport ; en cas de succès
  /// strict, [jeu] est renseigné.
  RapportValidation validerJson(
    Map<String, dynamic> brut, {
    Jeu? jeu,
    bool catalogueEmbarque = false,
  }) {
    final erreurs = <String>[];
    final avertissements = <String>[];

    erreurs.addAll(_validerSchema(brut));
    if (erreurs.isNotEmpty) {
      return RapportValidation(
        erreurs: erreurs,
        avertissements: avertissements,
      );
    }

    final j = jeu ?? Jeu.fromJson(brut);

    if (j.schemaVersion > schemaVersionMax) {
      erreurs.add(
        'schema_version : ce paquet nécessite une version plus récente de l\'application',
      );
    }
    erreurs.addAll(_verifierReferences(j));
    erreurs.addAll(_verifierPhrases(j));
    if (catalogueEmbarque) {
      erreurs.addAll(_verifierRealisabilite(j));
    }
    avertissements.addAll(_avertissements(j));

    return RapportValidation(erreurs: erreurs, avertissements: avertissements);
  }

  /// Valide le paquet de l'exemple embarqué dans le dépôt.
  RapportValidation validerExemple() {
    final fichier = File('../../docs/exemples/jeu.exemple.json');
    final brut = jsonDecode(fichier.readAsStringSync()) as Map<String, dynamic>;
    return validerJson(brut, jeu: Jeu.fromJson(brut));
  }

  List<String> _validerSchema(Map<String, dynamic> brut) {
    final erreurs = <String>[];
    if (brut['format'] != 'cardhospital') {
      erreurs.add('format : doit être "cardhospital"');
    }
    if (brut['schema_version'] != 1) {
      erreurs.add('schema_version : doit être 1');
    }
    for (final cle in [
      'id',
      'nom',
      'version',
      'parametres',
      'difficultes',
      'specialites',
      'capacites',
      'cartes',
      'maladies',
      'motifs',
      'actions',
    ]) {
      if (!brut.containsKey(cle)) {
        erreurs.add('$cle : champ obligatoire absent');
      }
    }
    final diff = (brut['difficultes'] as List?)?.length;
    if (diff != 3) {
      erreurs.add(
        'difficultes : exactement 3 niveaux requis (${diff ?? 0} trouvé(s))',
      );
    }
    for (final m in (brut['maladies'] as List? ?? const [])) {
      final poids = (m as Map)['poids'];
      if (poids is int && poids < 1) {
        final index = (brut['maladies'] as List).indexOf(m);
        erreurs.add(
          'maladies[$index].poids : une maladie doit avoir un poids d\'au moins 1 ; pour l\'écarter, retirez-la du paquet',
        );
      }
    }
    return erreurs;
  }

  List<String> _verifierReferences(Jeu j) {
    final erreurs = <String>[];
    final specialites = {'generaliste', ...j.specialites.map((s) => s.id)};
    final capacites = j.capacites.map((c) => c.id).toSet();
    final idsCartes = j.cartes.keys.toSet();
    final idsMotifs = j.motifs.keys.toSet();

    for (final entry in j.cartes.entries) {
      final id = entry.key;
      final carte = entry.value;
      final chemin = 'cartes.$id';
      if (carte.type == TypeCarte.patient) {
        if (carte.specialite != null) {
          erreurs.add('$chemin.specialite : interdit pour un patient');
        }
        if (carte.capacites != null) {
          erreurs.add('$chemin.capacites : interdit pour un patient');
        }
      }
      if (carte.specialite != null && !specialites.contains(carte.specialite)) {
        erreurs.add(
          '$chemin.specialite : la spécialité « ${carte.specialite} » n\'est pas déclarée',
        );
      }
      for (final cap in carte.capacites?.keys ?? const <String>[]) {
        if (!capacites.contains(cap)) {
          erreurs.add(
            '$chemin.capacites.$cap : la capacité « $cap » n\'est pas déclarée',
          );
        }
      }
    }

    final typesMaladies = <String>{};
    for (var i = 0; i < j.maladies.length; i++) {
      final m = j.maladies[i];
      final chemin = 'maladies[$i]';
      typesMaladies.add(m.type);
      if (!specialites.contains(m.type)) {
        erreurs.add(
          '$chemin.type : la spécialité « ${m.type} » n\'est pas déclarée',
        );
      }
      if (m.poids != null && m.poids! < 1) {
        erreurs.add(
          '$chemin.poids : une maladie doit avoir un poids d\'au moins 1 ; pour l\'écarter, retirez-la du paquet',
        );
      }
      erreurs.addAll(
        _verifierPredicat(
          m.traitement.adapte,
          '$chemin.traitement.adapte',
          idsCartes,
          specialites,
          capacites,
        ),
      );
      final partiel = m.traitement.partiel;
      if (partiel != null) {
        erreurs.addAll(
          _verifierPredicat(
            partiel,
            '$chemin.traitement.partiel',
            idsCartes,
            specialites,
            capacites,
          ),
        );
      }
      for (final ref in _referencesValeur(m.recompenses?.toJson())) {
        erreurs.add('$chemin.recompenses : référence inconnue « $ref »');
      }
    }

    for (final s in j.specialites) {
      if (!typesMaladies.contains(s.id)) {
        erreurs.add(
          'specialites : « ${s.id} » n\'est le type d\'aucune maladie',
        );
      }
    }

    for (var i = 0; i < j.actions.length; i++) {
      final a = j.actions[i];
      final chemin = 'actions[$i]';
      if (!idsMotifs.contains(a.motif)) {
        erreurs.add(
          '$chemin.motif : le motif « ${a.motif} » n\'est pas déclaré',
        );
      }
      for (final e in a.effets) {
        erreurs.addAll(
          _verifierEffet(
            e,
            '$chemin.effets',
            idsCartes,
            specialites,
            capacites,
          ),
        );
      }
    }
    return erreurs;
  }

  List<String> _verifierPredicat(
    Predicat p,
    String chemin,
    Set<String> idsCartes,
    Set<String> specialites,
    Set<String> capacites,
  ) {
    final erreurs = <String>[];
    if (p.carte != null && !idsCartes.contains(p.carte)) {
      erreurs.add('$chemin.carte : la carte « ${p.carte} » n\'existe pas');
    }
    if (p.compte != null) {
      for (final s in p.compte!.specialite ?? const <String>[]) {
        if (!specialites.contains(s)) {
          erreurs.add(
            '$chemin.compte.specialite : la spécialité « $s » n\'est pas déclarée',
          );
        }
      }
      for (final id in p.compte!.id ?? const <String>[]) {
        if (!idsCartes.contains(id)) {
          erreurs.add('$chemin.compte.id : la carte « $id » n\'existe pas');
        }
      }
    }
    for (final sous in [...?p.tous, ...?p.unDe]) {
      erreurs.addAll(
        _verifierPredicat(sous, chemin, idsCartes, specialites, capacites),
      );
    }
    if (p.non != null) {
      erreurs.addAll(
        _verifierPredicat(p.non!, chemin, idsCartes, specialites, capacites),
      );
    }
    return erreurs;
  }

  List<String> _verifierEffet(
    Effet e,
    String chemin,
    Set<String> idsCartes,
    Set<String> specialites,
    Set<String> capacites,
  ) {
    final erreurs = <String>[];
    if (e.valeur != null) {
      for (final ref in _referencesValeur(e.valeur!.toJson())) {
        final parties = ref.split('.');
        if (parties.length != 2) {
          erreurs.add('$chemin.valeur : référence invalide « $ref »');
        } else if (parties[0] == r'$recompenses') {
          const valides = {
            'pieces_diagnostic',
            'pieces_traitement',
            'pieces_partiel',
            'reputation_soin',
            'reputation_echec',
            'reputation_attente',
            'reputation_mort',
            'soin_partiel',
            'pv_echec',
          };
          if (!valides.contains(parties[1])) {
            erreurs.add('$chemin.valeur : référence inconnue « $ref »');
          }
        } else if (parties[0] == r'$capacite') {
          if (!capacites.contains(parties[1])) {
            erreurs.add(
              '$chemin.valeur : la capacité « ${parties[1]} » n\'est pas déclarée',
            );
          }
        } else {
          erreurs.add('$chemin.valeur : référence inconnue « $ref »');
        }
      }
    }
    if (e.condition != null) {
      erreurs.addAll(
        _verifierCondition(
          e.condition!,
          chemin,
          idsCartes,
          specialites,
          capacites,
        ),
      );
    }
    for (final sous in [...?e.alors, ...?e.sinon]) {
      erreurs.addAll(
        _verifierEffet(sous, chemin, idsCartes, specialites, capacites),
      );
    }
    return erreurs;
  }

  List<String> _verifierCondition(
    Condition c,
    String chemin,
    Set<String> idsCartes,
    Set<String> specialites,
    Set<String> capacites,
  ) {
    const constantes = {
      'traitement_adapte',
      'traitement_partiel',
      'attente_depassee',
      'soigne',
      'patient_en_jeu',
      'patient_hors_jeu',
    };
    final erreurs = <String>[];
    if (c.constante != null && !constantes.contains(c.constante)) {
      erreurs.add('$chemin.condition : condition inconnue « ${c.constante} »');
    }
    for (final sous in [...?c.et, ...?c.ou]) {
      erreurs.addAll(
        _verifierCondition(sous, chemin, idsCartes, specialites, capacites),
      );
    }
    if (c.non != null) {
      erreurs.addAll(
        _verifierCondition(c.non!, chemin, idsCartes, specialites, capacites),
      );
    }
    if (c.combinaison != null) {
      erreurs.addAll(
        _verifierPredicat(
          c.combinaison!,
          '$chemin.combinaison',
          idsCartes,
          specialites,
          capacites,
        ),
      );
    }
    return erreurs;
  }

  Iterable<String> _referencesValeur(dynamic json) sync* {
    if (json is String && json.startsWith(r'$')) yield json;
    if (json is Map) {
      for (final v in json.values) {
        yield* _referencesValeur(v);
      }
    }
    if (json is List) {
      for (final v in json) {
        yield* _referencesValeur(v);
      }
    }
  }

  List<String> _verifierPhrases(Jeu j) {
    final erreurs = <String>[];
    final variablesAutorisees = {
      'patient',
      'medecin',
      'medecin2',
      'salle',
      'accessoire',
    };
    for (var i = 0; i < j.actions.length; i++) {
      final a = j.actions[i];
      final motif = j.motifs[a.motif];
      final variablesDuMotif = <String>{};
      if (motif != null) {
        for (final cle in motif.intervalles.keys) {
          if (cle == 'total') continue;
          for (final type in cle.split('|')) {
            if (type == 'medecin') {
              variablesDuMotif.add('medecin');
              if ((motif.intervalles[cle]?.max ?? 0) >= 2) {
                variablesDuMotif.add('medecin2');
              }
            } else if (type == 'objet' || type == 'diplome') {
              variablesDuMotif.add('accessoire');
            } else {
              variablesDuMotif.add(type);
            }
          }
        }
      }
      for (final v in RegExp(r'\{(\w+)\}').allMatches(a.phrase)) {
        final nom = v.group(1)!;
        if (!variablesAutorisees.contains(nom)) {
          erreurs.add('actions[$i].phrase : variable inconnue « {$nom} »');
        } else if (!variablesDuMotif.contains(nom)) {
          erreurs.add(
            'actions[$i].phrase : la variable « {$nom} » est incompatible avec le motif « ${a.motif} »',
          );
        }
      }
    }
    return erreurs;
  }

  List<String> _verifierRealisabilite(Jeu j) {
    final erreurs = <String>[];
    final medecins = j.cartes.values
        .where((c) => c.type == TypeCarte.medecin)
        .toList();
    final salles = j.cartes.values
        .where((c) => c.type == TypeCarte.salle)
        .toList();
    final accessoires = j.cartes.values
        .where((c) => c.type == TypeCarte.objet || c.type == TypeCarte.diplome)
        .toList();
    for (var i = 0; i < j.maladies.length; i++) {
      final m = j.maladies[i];
      var realisable = false;
      outer:
      for (final a in medecins) {
        for (final b in medecins) {
          for (final s in salles) {
            for (final acc in [null, ...accessoires]) {
              final combinaison = <Carte>[
                a,
                b,
                s,
                ...[acc].whereType<Carte>(),
              ];
              if (_evaluePredicat(m.traitement.adapte, combinaison, j)) {
                realisable = true;
                break outer;
              }
            }
          }
        }
      }
      if (!realisable) {
        erreurs.add(
          'maladies[$i].traitement.adapte : aucun combinaison standard ne satisfait le traitement adapté de « ${m.nom} »',
        );
      }
    }
    return erreurs;
  }

  bool _evaluePredicat(Predicat p, List<Carte> combinaison, Jeu j) {
    if (p.carte != null) {
      return combinaison.any(
        (c) => j.cartes.entries.any((e) => e.key == p.carte && e.value == c),
      );
    }
    if (p.compte != null) {
      final compte = combinaison
          .where((c) => _correspond(c, p.compte!, j))
          .length;
      if (p.min != null && compte < p.min!) return false;
      if (p.max != null && compte > p.max!) return false;
      return true;
    }
    if (p.tous != null) {
      return p.tous!.every((s) => _evaluePredicat(s, combinaison, j));
    }
    if (p.unDe != null) {
      return p.unDe!.any((s) => _evaluePredicat(s, combinaison, j));
    }
    if (p.non != null) {
      return !_evaluePredicat(p.non!, combinaison, j);
    }
    return false;
  }

  bool _correspond(Carte c, Filtre f, Jeu j) {
    if (f.type != null && !f.type!.contains(c.type)) return false;
    if (f.specialite != null &&
        (c.specialite == null || !f.specialite!.contains(c.specialite))) {
      return false;
    }
    if (f.id != null) {
      final id = j.cartes.entries
          .firstWhere((e) => identical(e.value, c) || e.value == c)
          .key;
      if (!f.id!.contains(id)) return false;
    }
    return true;
  }

  List<String> _avertissements(Jeu j) {
    final avertissements = <String>[];
    for (final m in j.maladies) {
      if (m.traitement.partiel == null) {
        avertissements.add(
          'maladies : « ${m.nom} » n\'a pas de traitement partiel',
        );
      }
    }
    final specialitesPortees = j.cartes.values
        .map((c) => c.specialite)
        .whereType<String>()
        .toSet();
    for (final s in j.specialites) {
      if (!specialitesPortees.contains(s.id)) {
        avertissements.add(
          'specialites : « ${s.id} » n\'est portée par aucune carte',
        );
      }
    }
    return avertissements;
  }
}
