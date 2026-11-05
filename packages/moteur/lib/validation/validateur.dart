import 'dart:convert';
import 'dart:io';

import '../modeles/jeu.dart';
import '../moteur/combinaison.dart';
import '../moteur/reconnaissance.dart';
import 'schema.dart';

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
  /// Validateur utilisant le schéma du fichier [cheminSchema] (par défaut,
  /// celui du dépôt vu depuis `packages/moteur`).
  factory Validateur({String? cheminSchema}) => Validateur.depuisSchema(
    File(cheminSchema ?? '../../docs/schema/jeu.schema.json')
        .readAsStringSync(),
  );

  /// Validateur utilisant le schéma [schemaJson] (contenu du fichier), par
  /// exemple chargé depuis les assets de l'application.
  Validateur.depuisSchema(String schemaJson)
    : _schemaJson = schemaJson,
      _schema = ValidateurSchema(schemaJson);

  final String _schemaJson;
  final ValidateurSchema _schema;

  /// Schéma JSON de référence, chargé tel quel depuis `docs/schema`.
  String get schemaJson => _schemaJson;

  /// Plage des versions du format que le moteur sait lire.
  static const int schemaVersionMin = 1;
  static const int schemaVersionMax = 1;

  /// Valide le JSON brut d'un paquet (MOTEUR_EFFETS.md §7).
  ///
  /// [jeu] évite de reconstruire le modèle s'il est déjà chargé.
  /// [catalogue] est le catalogue embarqué (identifiant de carte → type,
  /// voir [catalogueDe]) : s'il est fourni, chaque carte du paquet doit y
  /// figurer avec le même type (règle 3). Sans catalogue, la règle 3 n'est
  /// pas vérifiée (paquet de base lui-même, outils).
  RapportValidation validerJson(
    Map<String, dynamic> brut, {
    Jeu? jeu,
    Map<String, TypeCarte>? catalogue,
  }) {
    // Règle 2 : version du format, avant le schéma (qui ne connaît que la
    // version courante) pour donner un message explicite.
    final version = brut['schema_version'];
    if (version is int && version > schemaVersionMax) {
      return RapportValidation(
        erreurs: [
          'schema_version : ce paquet nécessite une version plus récente de '
              'l\'application (version $version, version $schemaVersionMax '
              'au plus)',
        ],
      );
    }
    if (version is int && version < schemaVersionMin) {
      return RapportValidation(
        erreurs: [
          'schema_version : version $version non supportée (version '
              '$schemaVersionMin au moins)',
        ],
      );
    }

    // Règle 1 : JSON Schema complet. Sans conformité, le modèle ne peut pas
    // être construit.
    final erreursSchema = _schema.valider(brut);
    if (erreursSchema.isNotEmpty) {
      return RapportValidation(erreurs: erreursSchema);
    }

    final j = jeu ?? Jeu.fromJson(brut);
    final erreurs = <String>[
      if (catalogue != null) ..._verifierCatalogue(j, catalogue),
      ..._verifierDoublons(j),
      ..._verifierReferences(j),
      ..._verifierPhrases(j),
      ..._verifierRealisabilite(j),
    ];
    return RapportValidation(
      erreurs: erreurs,
      avertissements: _avertissements(j),
    );
  }

  /// Catalogue embarqué tiré du paquet de base [base] : identifiant de carte
  /// → type.
  static Map<String, TypeCarte> catalogueDe(Jeu base) =>
      base.cartes.map((id, carte) => MapEntry(id, carte.type));

  /// Valide le paquet de l'exemple embarqué dans le dépôt.
  RapportValidation validerExemple() {
    final fichier = File('../../docs/exemples/jeu.exemple.json');
    final brut = jsonDecode(fichier.readAsStringSync()) as Map<String, dynamic>;
    return validerJson(brut, jeu: Jeu.fromJson(brut));
  }

  /// Règle 3 : en v1, une extension n'ajoute pas de carte et ne change pas
  /// le type d'une carte (MOTEUR_EFFETS.md §1.2).
  List<String> _verifierCatalogue(Jeu j, Map<String, TypeCarte> catalogue) => [
    for (final e in j.cartes.entries)
      if (!catalogue.containsKey(e.key))
        'cartes.${e.key} : carte absente du catalogue embarqué ; une '
            'extension ne peut pas ajouter de carte en v1'
      else if (catalogue[e.key] != e.value.type)
        'cartes.${e.key}.type : la carte est de type « '
            '${catalogue[e.key]!.name} » dans le catalogue embarqué, pas « '
            '${e.value.type.name} »',
  ];

  /// Règle 8 : identifiants en double dans les listes. Les cartes et les
  /// motifs sont des objets JSON, dont les clés sont uniques par
  /// construction.
  List<String> _verifierDoublons(Jeu j) {
    final erreurs = <String>[];
    void verifier(String liste, List<String> ids) {
      final vus = <String>{};
      for (var i = 0; i < ids.length; i++) {
        if (!vus.add(ids[i])) {
          erreurs.add(
            '$liste[$i].id : l\'identifiant « ${ids[i]} » est déjà utilisé',
          );
        }
      }
    }

    verifier('difficultes', [for (final d in j.difficultes) d.id]);
    verifier('specialites', [for (final x in j.specialites) x.id]);
    verifier('capacites', [for (final c in j.capacites) c.id]);
    verifier('maladies', [for (final m in j.maladies) m.id]);
    verifier('actions', [for (final a in j.actions) a.id]);
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

  /// Règle 7 : chaque traitement adapté doit être satisfait par au moins une
  /// combinaison reconnue des cartes du paquet (recherche exhaustive), parmi
  /// les motifs des actions qui testent `traitement_adapte`.
  List<String> _verifierRealisabilite(Jeu j) {
    final combinaisons = combinaisonsPossibles(j);
    final erreurs = <String>[];
    for (var i = 0; i < j.maladies.length; i++) {
      final m = j.maladies[i];
      if (!combinaisons.any((c) => c.satisfait(m.traitement.adapte))) {
        erreurs.add(
          'maladies[$i].traitement.adapte : aucune combinaison standard ne '
          'satisfait le traitement adapté de « ${m.nom} »',
        );
      }
    }
    return erreurs;
  }

  /// Toutes les combinaisons d'un patient et de cartes non patient du paquet
  /// reconnues par un motif d'action qui teste `traitement_adapte` (tous les
  /// motifs si aucune action ne le teste). Le patient étant indifférent aux
  /// prédicats, un seul suffit.
  static List<Combinaison> combinaisonsPossibles(Jeu j) {
    final patient = j.cartes.entries
        .where((e) => e.value.type == TypeCarte.patient)
        .map((e) => e.key)
        .firstOrNull;
    if (patient == null) return const [];
    final autres = j.cartes.entries
        .where((e) => e.value.type != TypeCarte.patient)
        .map((e) => e.key)
        .toList();

    final motifsTraitement = {
      for (final a in j.actions)
        if (a.effets.any(_testeTraitementAdapte)) a.motif,
    };
    final motifs = motifsTraitement.isEmpty
        ? j.motifs.keys.toSet()
        : motifsTraitement;
    var taille = 0;
    for (final id in motifs) {
      final total = j.motifs[id]?.intervalles['total']?.max ?? 5;
      if (total > taille) taille = total;
    }
    taille = (taille - 1).clamp(0, 4);

    final reconnaissance = ReconnaissanceCombinaisons(j);
    final resultat = <Combinaison>[];
    void parcourir(int debut, List<String> choisis) {
      if (choisis.isNotEmpty) {
        final ids = [patient, ...choisis];
        final r = reconnaissance.reconnaitre(ids);
        if (r is Apercu && motifs.contains(r.motif)) {
          resultat.add(Combinaison(j, ids));
        }
      }
      if (choisis.length == taille) return;
      for (var i = debut; i < autres.length; i++) {
        choisis.add(autres[i]);
        parcourir(i + 1, choisis);
        choisis.removeLast();
      }
    }

    parcourir(0, []);
    return resultat;
  }

  static bool _testeTraitementAdapte(Effet e) =>
      (e.condition != null && _conditionTesteAdapte(e.condition!)) ||
      [...?e.alors, ...?e.sinon].any(_testeTraitementAdapte);

  static bool _conditionTesteAdapte(Condition c) =>
      c.constante == 'traitement_adapte' ||
      [...?c.et, ...?c.ou, ?c.non].any(_conditionTesteAdapte);

  List<String> _avertissements(Jeu j) {
    final avertissements = <String>[];
    // Couleur et icône distinguent les spécialités dans un diagnostic.
    for (final (champ, valeur) in [
      ('couleur', (Specialite s) => s.couleur.toUpperCase()),
      ('icone', (Specialite s) => s.icone),
    ]) {
      final vues = <String, String>{};
      for (var i = 0; i < j.specialites.length; i++) {
        final s = j.specialites[i];
        final autre = vues[valeur(s)];
        if (autre != null) {
          avertissements.add(
            'specialites[$i].$champ : même $champ que « $autre » ; les '
            'deux spécialités seront difficiles à distinguer dans un '
            'diagnostic',
          );
        } else {
          vues[valeur(s)] = s.id;
        }
      }
    }
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
