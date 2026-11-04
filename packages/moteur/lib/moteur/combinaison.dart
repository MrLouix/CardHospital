import '../modeles/jeu.dart';

/// Spécialité implicite, jamais type d'une maladie.
const specialiteGeneraliste = 'generaliste';

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

  /// Spécialités `S(C)` portées par les cartes hors patient, hors
  /// `generaliste` (MODELE_DE_JEU.md §3.3).
  Set<String> get specialites => {
    for (final carte in cartes.values)
      if (carte.type != TypeCarte.patient &&
          carte.specialite != null &&
          carte.specialite != specialiteGeneraliste)
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
      if (p.min != null && compte < p.min!) return false;
      if (p.max != null && compte > p.max!) return false;
      return true;
    }
    if (p.tous != null) return p.tous!.every(satisfait);
    if (p.unDe != null) return p.unDe!.any(satisfait);
    if (p.non != null) return !satisfait(p.non!);
    return false;
  }

  static bool _correspond(String id, Carte carte, Filtre f) {
    if (f.type != null && !f.type!.contains(carte.type)) return false;
    if (f.specialite != null && !f.specialite!.contains(carte.specialite)) {
      return false;
    }
    if (f.id != null && !f.id!.contains(id)) return false;
    return true;
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
