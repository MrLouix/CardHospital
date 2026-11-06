import 'diagnostic.dart';
import 'etat.dart';

/// Maladie révélée à la sortie d'un patient.
class MaladieRevelee {
  const MaladieRevelee({required this.id, required this.nom});

  factory MaladieRevelee.fromJson(Map<String, dynamic> json) =>
      MaladieRevelee(id: json['id'] as String, nom: json['nom'] as String);

  final String id;
  final String nom;

  Map<String, dynamic> toJson() => {'id': id, 'nom': nom};
}

/// Résultat d'un passage en laboratoire (MODELE_DE_JEU.md §12.3).
class ResultatAnalyse {
  const ResultatAnalyse({
    required this.maladie,
    required this.passagesRestants,
    this.recette,
  });

  factory ResultatAnalyse.fromJson(Map<String, dynamic> json) =>
      ResultatAnalyse(
        maladie: MaladieAnalysee.fromJson(
          json['maladie'] as Map<String, dynamic>,
        ),
        passagesRestants: json['passages_restants'] as int,
        recette: json['recette'] as String?,
      );

  /// Maladie analysée, choisie par le joueur parmi les maladies suspectées.
  final MaladieAnalysee maladie;

  /// Passages encore nécessaires, tous joueurs confondus (0 : recette
  /// révélée).
  final int passagesRestants;

  /// Recette du traitement adapté, quand elle est révélée : description des
  /// cartes requises.
  final String? recette;

  bool get recetteRevelee => passagesRestants == 0;

  Map<String, dynamic> toJson() => {
    'maladie': maladie.toJson(),
    'passages_restants': passagesRestants,
    'recette': recette,
  };
}

/// Maladie choisie pour une analyse, avec de quoi l'afficher.
class MaladieAnalysee {
  const MaladieAnalysee({
    required this.id,
    required this.nom,
    required this.specialite,
  });

  factory MaladieAnalysee.fromJson(Map<String, dynamic> json) =>
      MaladieAnalysee(
        id: json['id'] as String,
        nom: json['nom'] as String,
        specialite: SpecialiteAffichee.fromJson(
          json['specialite'] as Map<String, dynamic>,
        ),
      );

  final String id;
  final String nom;
  final SpecialiteAffichee specialite;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'specialite': specialite.toJson(),
  };
}

/// Résultat d'une action confirmée (point P1 du plan de codage).
///
/// C'est aussi le contenu du message `resultat` du protocole
/// (SPECIFICATION.md §3.3), envoyé au seul client qui a confirmé. Il ne
/// contient aucune information cachée, sauf la maladie à la sortie du
/// patient et la recette révélée par une analyse (MODELE_DE_JEU.md §11 et
/// §12).
class ResultatAction {
  const ResultatAction({
    required this.numero,
    required this.action,
    required this.libelle,
    required this.phrase,
    required this.cartes,
    required this.patient,
    required this.patientNom,
    required this.pvAvant,
    required this.pvApres,
    required this.presence,
    required this.attenteDepassee,
    required this.issue,
    required this.pieces,
    required this.reputation,
    this.diagnostic,
    this.analyse,
    this.maladieRevelee,
  });

  factory ResultatAction.fromJson(Map<String, dynamic> json) => ResultatAction(
    numero: json['numero'] as int,
    action: json['action'] as String,
    libelle: json['libelle'] as String,
    phrase: json['phrase'] as String,
    cartes: (json['cartes'] as List).cast<String>(),
    patient: json['patient'] as String?,
    patientNom: json['patient_nom'] as String?,
    pvAvant: json['pv_avant'] as int?,
    pvApres: json['pv_apres'] as int?,
    presence: json['presence'] as int?,
    attenteDepassee: json['attente_depassee'] as bool,
    issue: json['issue'] == null
        ? null
        : issueDepuisNom(json['issue'] as String),
    pieces: json['pieces'] as int,
    reputation: json['reputation'] as int,
    diagnostic: json['diagnostic'] == null
        ? null
        : ResultatDiagnostic.fromJson(
            json['diagnostic'] as Map<String, dynamic>,
          ),
    analyse: json['analyse'] == null
        ? null
        : ResultatAnalyse.fromJson(json['analyse'] as Map<String, dynamic>),
    maladieRevelee: json['maladie_revelee'] == null
        ? null
        : MaladieRevelee.fromJson(
            json['maladie_revelee'] as Map<String, dynamic>,
          ),
  );

  /// Numéro d'ordre de l'action dans la partie (à partir de 1).
  final int numero;

  /// Identifiant et libellé de l'action appliquée.
  final String action;
  final String libelle;

  /// Phrase de l'action, telle qu'affichée dans l'aperçu.
  final String phrase;

  /// Cartes de la combinaison, dans l'ordre de sélection.
  final List<String> cartes;

  /// Carte patient concernée et son nom affiché.
  final String? patient;
  final String? patientNom;

  /// PV avant l'action ; nul si le patient n'était pas en jeu (admission).
  final int? pvAvant;

  /// PV après l'action (PV initiaux pour une admission).
  final int? pvApres;

  /// Durée de présence du patient à l'hôpital après l'action, en ticks.
  final int? presence;

  /// La durée de présence dépasse-t-elle l'attente maximale de la maladie ?
  final bool attenteDepassee;

  /// Issue pour le patient : en jeu, guéri ou mort.
  final IssuePatient? issue;

  /// Diagnostic, pour une action qui en comporte un.
  final ResultatDiagnostic? diagnostic;

  /// Analyse, pour un passage en laboratoire.
  final ResultatAnalyse? analyse;

  /// Maladie révélée, si le patient est sorti (guéri ou mort).
  final MaladieRevelee? maladieRevelee;

  /// Pièces gagnées par l'acteur.
  final int pieces;

  /// Impact sur la réputation de l'hôpital (signé), à reporter à la main.
  final int reputation;

  /// Variation des PV, quand le patient était déjà en jeu.
  int? get deltaPv =>
      pvAvant == null || pvApres == null ? null : pvApres! - pvAvant!;

  Map<String, dynamic> toJson() => {
    'numero': numero,
    'action': action,
    'libelle': libelle,
    'phrase': phrase,
    'cartes': cartes,
    'patient': patient,
    'patient_nom': patientNom,
    'pv_avant': pvAvant,
    'pv_apres': pvApres,
    'presence': presence,
    'attente_depassee': attenteDepassee,
    'issue': issue == null ? null : nomIssue(issue!),
    'diagnostic': diagnostic?.toJson(),
    'analyse': analyse?.toJson(),
    'maladie_revelee': maladieRevelee?.toJson(),
    'pieces': pieces,
    'reputation': reputation,
  };
}
