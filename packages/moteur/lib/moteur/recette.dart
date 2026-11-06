import '../modeles/jeu.dart';

/// Rédige la recette d'un traitement : la description, en français, des
/// cartes qu'exige un prédicat (MODELE_DE_JEU.md §12.3, MOTEUR_EFFETS.md
/// §9.4).
///
/// Une conjonction (`tous`) s'écrit « cartes requises, lieu, exclusions » :
/// « 2 médecins, dont un de spécialité Cardiologie (ou muni du diplôme de
/// cette spécialité), au bloc opératoire. » ; « L'antibiotique, dans la
/// salle de consultation ou à la pharmacie. ».
class RedacteurRecette {
  RedacteurRecette(this.jeu);

  final Jeu jeu;

  /// Recette de [predicat], en une phrase.
  String decrire(Predicat predicat) {
    final texte = _conjonction(predicat.tous ?? [predicat]);
    if (texte.isEmpty) return texte;
    // Majuscule à la première lettre, après une éventuelle parenthèse.
    final i = texte.startsWith('(') ? 1 : 0;
    return '${texte.substring(0, i)}${texte[i].toUpperCase()}'
        '${texte.substring(i + 1)}.';
  }

  String _conjonction(List<Predicat> elements) {
    final requis = <String>[];
    final lieux = <String>[];
    final sans = <String>[];

    // Médecins sans spécialité et médecins d'une spécialité se lisent
    // ensemble : « 2 médecins, dont un de spécialité X ».
    final restants = [...elements];
    final tousMedecins = restants
        .where((p) => _filtreMedecins(p) && p.compte!.specialite == null)
        .firstOrNull;
    final specialises = restants
        .where((p) => _filtreMedecins(p) && p.compte!.specialite != null)
        .toList();
    if (tousMedecins != null && specialises.length == 1) {
      restants
        ..remove(tousMedecins)
        ..remove(specialises.single);
      requis.add(_medecinsDont(tousMedecins, specialises.single));
    }

    for (final p in restants) {
      final lieu = _lieu(p);
      if (lieu != null) {
        lieux.add(lieu);
      } else if (p.non != null) {
        sans.add(_sans(p.non!));
      } else if (_exclusion(p) case final e?) {
        sans.add(e);
      } else {
        requis.add(_nominal(p));
      }
    }
    return [
      if (requis.isNotEmpty) _liste(requis, 'et'),
      ...lieux,
      ...sans,
    ].join(', ');
  }

  /// Lieu d'un élément qui ne désigne que des salles : la carte d'une salle,
  /// une alternative entre salles, ou un compte de salles par identifiant.
  String? _lieu(Predicat p) {
    final salles = _salles(p);
    if (salles == null || salles.isEmpty) return null;
    return _liste([for (final id in salles) jeu.cartes[id]!.lieuAffiche], 'ou');
  }

  List<String>? _salles(Predicat p) {
    bool estSalle(String id) => jeu.cartes[id]?.type == TypeCarte.salle;
    if (p.carte != null) return estSalle(p.carte!) ? [p.carte!] : null;
    if (p.unDe != null) {
      final ids = <String>[];
      for (final sous in p.unDe!) {
        final s = _salles(sous);
        if (s == null) return null;
        ids.addAll(s);
      }
      return ids;
    }
    final f = p.compte;
    if (f != null &&
        f.id != null &&
        f.specialite == null &&
        _min(p) == 1 &&
        p.max == null &&
        f.id!.every(estSalle)) {
      return f.id;
    }
    return null;
  }

  bool _filtreMedecins(Predicat p) {
    final f = p.compte;
    return f != null &&
        f.id == null &&
        f.type != null &&
        f.type!.length == 1 &&
        f.type!.single == TypeCarte.medecin &&
        p.max == null &&
        _min(p) >= 1;
  }

  /// « k médecins, dont j de spécialité X » (j ≤ k).
  String _medecinsDont(Predicat tous, Predicat specialises) {
    final k = _min(tous);
    final j = _min(specialises);
    if (j >= k) return _nominal(specialises);
    final dont = j == 1 ? 'un' : '$j';
    return '$k médecins, dont $dont ${_qualificatif(specialises.compte!)}'
        '${_diplome(j)}';
  }

  /// Ce qu'un diplôme permet : il compte comme un médecin de sa spécialité,
  /// mais une combinaison n'a qu'un accessoire.
  static String _diplome(int n) => n == 1
      ? ' (ou muni du diplôme de cette spécialité)'
      : ' (l\'un d\'eux peut être remplacé par un médecin muni du diplôme de '
            'cette spécialité)';

  String _nominal(Predicat p) {
    if (p.carte != null) return _nomCarte(p.carte!);
    if (p.compte != null) return _compte(p);
    if (p.tous != null) return '(${_conjonction(p.tous!)})';
    if (p.unDe != null) {
      return _liste([
        for (final sous in p.unDe!)
          sous.tous != null ? '(${_conjonction(sous.tous!)})' : _nominal(sous),
      ], 'ou');
    }
    return _sans(p.non!);
  }

  /// Un compte qui exclut : « au plus 0 » s'écrit « sans aucun ».
  String? _exclusion(Predicat p) {
    if (p.compte == null || p.max != 0) return null;
    return 'sans ${_aucun(p.compte!)}';
  }

  String _sans(Predicat p) {
    if (p.carte != null) return 'sans ${_nomCarte(p.carte!)}';
    if (p.compte != null && p.max == null && _min(p) == 1) {
      return 'sans ${_aucun(p.compte!)}';
    }
    return 'sans ${_nominal(p)}';
  }

  /// « aucun objet », « aucune salle de spécialité Cardiologie ».
  String _aucun(Filtre f) {
    final ids = f.id;
    if (ids != null && f.specialite == null && f.type == null) {
      return _liste([for (final id in ids) _nomCarte(id)], 'ni');
    }
    final feminin = _type(f.type).$3;
    return '${feminin ? 'aucune' : 'aucun'} ${_nom(f, 1, article: false)}';
  }

  String _compte(Predicat p) {
    final f = p.compte!;
    final min = _min(p);
    final max = p.max;
    final medecins =
        f.type != null &&
        f.type!.contains(TypeCarte.medecin) &&
        f.specialite != null;
    if (max == null) {
      return '${_nom(f, min)}${medecins ? _diplome(min) : ''}';
    }
    if (max == 0) return _aucun(f);
    if (min == max) return 'exactement ${_nom(f, min)}';
    if (min == 0) return 'au plus ${_nom(f, max)}';
    return 'de $min à ${_nom(f, max)}';
  }

  /// Nom des cartes que désigne [f], au nombre de [n] : « un médecin de
  /// spécialité Cardiologie », « 2 salles », « le stéthoscope ou
  /// l'attelle ».
  String _nom(Filtre f, int n, {bool article = true}) {
    final ids = f.id;
    if (ids != null && f.specialite == null && f.type == null) {
      final noms = [for (final id in ids) _nomCarte(id)];
      if (n <= 1) return _liste(noms, 'ou');
      return '$n cartes parmi ${_liste(noms, 'et')}';
    }
    final (singulier, pluriel, feminin) = _type(f.type);
    final qualite = f.specialite == null ? '' : ' ${_qualificatif(f)}';
    final parmi = ids == null
        ? ''
        : ' parmi ${_liste([for (final id in ids) _nomCarte(id)], 'et')}';
    if (n <= 1) {
      final un = article ? (feminin ? 'une ' : 'un ') : '';
      return '$un$singulier$qualite$parmi';
    }
    return '$n $pluriel$qualite$parmi';
  }

  /// « de spécialité Cardiologie », « de spécialité Cardiologie ou
  /// Psychiatrie ».
  String _qualificatif(Filtre f) {
    final noms = [
      for (final id in f.specialite!)
        jeu.specialites.where((s) => s.id == id).firstOrNull?.nom ?? id,
    ];
    return 'de spécialité ${_liste(noms, 'ou')}';
  }

  static (String, String, bool) _type(List<TypeCarte>? types) {
    if (types == null || types.isEmpty) return ('carte', 'cartes', true);
    final ensemble = types.toSet();
    if (ensemble.length == 2 &&
        ensemble.containsAll({TypeCarte.objet, TypeCarte.diplome})) {
      return ('accessoire', 'accessoires', false);
    }
    if (ensemble.length > 1) return ('carte', 'cartes', true);
    return switch (ensemble.single) {
      TypeCarte.medecin => ('médecin', 'médecins', false),
      TypeCarte.patient => ('patient', 'patients', false),
      TypeCarte.salle => ('salle', 'salles', true),
      TypeCarte.objet => ('objet', 'objets', false),
      TypeCarte.diplome => ('diplôme', 'diplômes', false),
    };
  }

  String _nomCarte(String id) => jeu.cartes[id]?.nomAffiche ?? id;

  static int _min(Predicat p) => p.min ?? (p.max == null ? 1 : 0);

  /// « a, b et c » ; « a ou b ».
  static String _liste(List<String> elements, String conjonction) {
    if (elements.length <= 1) return elements.join();
    return '${elements.sublist(0, elements.length - 1).join(', ')} '
        '$conjonction ${elements.last}';
  }
}
