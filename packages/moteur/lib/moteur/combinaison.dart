import '../modeles/jeu.dart';

/// Valeur neutre « sans spécialité » (MOTEUR_EFFETS.md §2.1), réservée et
/// implicite : elle n'est jamais la spécialité d'une maladie. Une carte sans
/// champ `specialite` est polyvalente.
const specialitePolyvalent = 'polyvalent';

/// Ancien nom de [specialitePolyvalent], encore accepté à la lecture (avec
/// un avertissement du validateur).
const ancienNomPolyvalent = 'generaliste';

/// Spécialité réservée au laboratoire de recherche : portée uniquement par
/// une salle, jamais spécialité d'une maladie (MODELE_DE_JEU.md §12).
const specialiteRecherche = 'recherche';

/// Valeurs de spécialité réservées : jamais déclarées dans `specialites`,
/// jamais spécialité d'une maladie, jamais comptées dans `S(C)`.
const specialitesReservees = {
  specialitePolyvalent,
  ancienNomPolyvalent,
  specialiteRecherche,
};

/// Une combinaison de cartes, dans l'ordre de sélection, sans doublon.
///
/// Elle sert à évaluer les prédicats (traitements, conditions
/// `combinaison`), à calculer les spécialités `S(C)` et les capacités, et à
/// remplir les variables des phrases.
class Combinaison {
  /// Construit la combinaison à partir d'identifiants connus de [jeu].
  /// Les doublons sont retirés ; les identifiants inconnus sont ignorés.
  factory Combinaison(Jeu jeu, Iterable<String> ids) {
    final vus = <String>{};
    final cartes = <String, Carte>{};
    for (final id in ids) {
      final carte = jeu.cartes[id];
      if (carte != null && vus.add(id)) cartes[id] = carte;
    }
    return Combinaison._(cartes);
  }

  Combinaison._(this.cartes);

  /// Cartes de la combinaison, indexées par identifiant, dans l'ordre.
  final Map<String, Carte> cartes;

  Iterable<String> get ids => cartes.keys;

  /// Identifiant de la (première) carte patient, s'il y en a une.
  String? get patient => _idsDeType(TypeCarte.patient).firstOrNull;

  /// Médecins dans l'ordre de sélection.
  List<String> get medecins => _idsDeType(TypeCarte.medecin).toList();

  /// Première salle.
  String? get salle => _idsDeType(TypeCarte.salle).firstOrNull;

  /// Premier accessoire (objet ou diplôme).
  String? get accessoire => cartes.entries
      .where(
        (e) =>
            e.value.type == TypeCarte.objet ||
            e.value.type == TypeCarte.diplome,
      )
      .map((e) => e.key)
      .firstOrNull;

  Iterable<String> _idsDeType(TypeCarte type) =>
      cartes.entries.where((e) => e.value.type == type).map((e) => e.key);

  /// Spécialités `S(C)` portées par les cartes hors patient, hors valeurs
  /// réservées (`polyvalent`, `recherche`) (MODELE_DE_JEU.md §3.3).
  Set<String> get specialites => {
    for (final carte in cartes.values)
      if (carte.type != TypeCarte.patient &&
          carte.specialite != null &&
          !specialitesReservees.contains(carte.specialite))
        carte.specialite!,
  };

  /// Total de la capacité [id] sur les cartes hors patient.
  int capacite(String id) {
    var total = 0;
    for (final carte in cartes.values) {
      if (carte.type == TypeCarte.patient) continue;
      total += carte.capacites?[id] ?? 0;
    }
    return total;
  }

  /// Évalue un prédicat (MOTEUR_EFFETS.md §5) sur la combinaison.
  bool satisfait(Predicat p) {
    if (p.carte != null) return cartes.containsKey(p.carte);
    if (p.compte != null) {
      var compte = 0;
      for (final e in cartes.entries) {
        if (_correspond(e.key, e.value, p.compte!)) compte++;
      }
      // Sans `min` ni `max`, le prédicat demande au moins une carte
      // (MOTEUR_EFFETS.md §5) : il n'est jamais vrai d'office.
      final min = p.min ?? (p.max == null ? 1 : 0);
      if (compte < min) return false;
      if (p.max != null && compte > p.max!) return false;
      return true;
    }
    if (p.tous != null) return p.tous!.every(satisfait);
    if (p.unDe != null) return p.unDe!.any(satisfait);
    if (p.non != null) return !satisfait(p.non!);
    return false;
  }

  /// Les cartes permettent-elles la condition [c] ? Seules les conditions
  /// `combinaison` sont évaluées ; celles qui dépendent de l'état (patient
  /// en jeu, attente…) sont tenues pour favorables, y compris sous un `non`.
  ///
  /// Sert à savoir si une action peut être proposée avec ces cartes, quel
  /// que soit l'état du patient (validateur, simulateur).
  bool permet(Condition c, {bool favorable = true}) {
    if (c.constante != null) return favorable;
    bool sous(Condition x) => permet(x, favorable: favorable);
    if (c.et != null) return c.et!.every(sous);
    if (c.ou != null) return c.ou!.any(sous);
    if (c.non != null) return !permet(c.non!, favorable: !favorable);
    return satisfait(c.combinaison!);
  }

  static bool _correspond(String id, Carte carte, Filtre f) {
    if (f.type != null && !_typeCorrespond(carte, f)) return false;
    if (f.specialite != null && !f.specialite!.contains(carte.specialite)) {
      return false;
    }
    if (f.id != null && !f.id!.contains(id)) return false;
    return true;
  }

  /// Un diplôme de spécialité X, joué comme accessoire, compte comme
  /// un médecin de spécialité X quand le filtre demande `medecin` avec cette
  /// spécialité (MOTEUR_EFFETS.md §5).
  static bool _typeCorrespond(Carte carte, Filtre f) {
    if (f.type!.contains(carte.type)) return true;
    return carte.type == TypeCarte.diplome &&
        f.type!.contains(TypeCarte.medecin) &&
        f.specialite != null &&
        f.specialite!.contains(carte.specialite);
  }

  /// Remplit une phrase d'action (MOTEUR_EFFETS.md §6.2) : variables
  /// remplacées par le `nom_phrase` des cartes, segments `[…]` affichés
  /// seulement si toutes leurs variables sont présentes, première lettre en
  /// majuscule.
  String phrase(String modele) {
    final medecins = this.medecins;
    final valeurs = <String, String?>{
      'patient': _nomPhrase(patient),
      'medecin': _nomPhrase(medecins.elementAtOrNull(0)),
      'medecin2': _nomPhrase(medecins.elementAtOrNull(1)),
      'salle': _nomPhrase(salle),
      'accessoire': _nomPhrase(accessoire),
    };
    String remplir(String texte) =>
        texte.replaceAllMapped(_variable, (m) => valeurs[m.group(1)] ?? '');

    final sansSegments = modele.replaceAllMapped(_segment, (m) {
      final contenu = m.group(1)!;
      final complet = _variable
          .allMatches(contenu)
          .every((v) => valeurs[v.group(1)] != null);
      return complet ? remplir(contenu) : '';
    });
    final texte = remplir(sansSegments);
    if (texte.isEmpty) return texte;
    return texte[0].toUpperCase() + texte.substring(1);
  }

  String? _nomPhrase(String? id) => id == null ? null : cartes[id]!.nomAffiche;

  static final _variable = RegExp(r'\{(\w+)\}');
  static final _segment = RegExp(r'\[([^\]]*)\]');
}
