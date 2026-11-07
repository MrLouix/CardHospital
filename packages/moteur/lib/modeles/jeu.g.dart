// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jeu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jeu _$JeuFromJson(Map<String, dynamic> json) => Jeu(
  format: json['format'] as String,
  schemaVersion: (json['schema_version'] as num).toInt(),
  id: json['id'] as String,
  nom: json['nom'] as String,
  version: json['version'] as String,
  parametres: Parametres.fromJson(json['parametres'] as Map<String, dynamic>),
  difficultes: (json['difficultes'] as List<dynamic>)
      .map((e) => Difficulte.fromJson(e as Map<String, dynamic>))
      .toList(),
  specialites: (json['specialites'] as List<dynamic>)
      .map((e) => Specialite.fromJson(e as Map<String, dynamic>))
      .toList(),
  capacites: (json['capacites'] as List<dynamic>)
      .map((e) => Capacite.fromJson(e as Map<String, dynamic>))
      .toList(),
  cartes: (json['cartes'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, Carte.fromJson(e as Map<String, dynamic>)),
  ),
  maladies: (json['maladies'] as List<dynamic>)
      .map((e) => Maladie.fromJson(e as Map<String, dynamic>))
      .toList(),
  motifs: (json['motifs'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, Motif.fromJson(e as Map<String, dynamic>)),
  ),
  actions: (json['actions'] as List<dynamic>)
      .map((e) => ActionJeu.fromJson(e as Map<String, dynamic>))
      .toList(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$JeuToJson(Jeu instance) => <String, dynamic>{
  'format': instance.format,
  'schema_version': instance.schemaVersion,
  'id': instance.id,
  'nom': instance.nom,
  'version': instance.version,
  'description': instance.description,
  'parametres': instance.parametres,
  'difficultes': instance.difficultes,
  'specialites': instance.specialites,
  'capacites': instance.capacites,
  'cartes': instance.cartes,
  'maladies': instance.maladies,
  'motifs': instance.motifs,
  'actions': instance.actions,
};

Parametres _$ParametresFromJson(Map<String, dynamic> json) => Parametres(
  attenteMaxDefaut: (json['attente_max_defaut'] as num).toInt(),
  paliersAggravation: (json['paliers_aggravation'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  diagnostic: Diagnostic.fromJson(json['diagnostic'] as Map<String, dynamic>),
  recompenses: Recompenses.fromJson(
    json['recompenses'] as Map<String, dynamic>,
  ),
  recherche: json['recherche'] == null
      ? null
      : ParametresRecherche.fromJson(json['recherche'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ParametresToJson(Parametres instance) =>
    <String, dynamic>{
      'attente_max_defaut': instance.attenteMaxDefaut,
      'paliers_aggravation': instance.paliersAggravation,
      'diagnostic': instance.diagnostic,
      'recompenses': instance.recompenses,
      'recherche': instance.recherche,
    };

ParametresRecherche _$ParametresRechercheFromJson(Map<String, dynamic> json) =>
    ParametresRecherche(
      bonusSpecialite: (json['bonus_specialite'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ParametresRechercheToJson(
  ParametresRecherche instance,
) => <String, dynamic>{'bonus_specialite': instance.bonusSpecialite};

Diagnostic _$DiagnosticFromJson(Map<String, dynamic> json) => Diagnostic(
  precisionMax: (json['precision_max'] as num).toInt(),
  verite: (json['verite'] as num).toDouble(),
  parNiveau: (json['par_niveau'] as num).toDouble(),
  affiniteSpecialite: (json['affinite_specialite'] as num).toDouble(),
  bonusSpecialite: (json['bonus_specialite'] as num).toDouble(),
  exclusion: (json['exclusion'] as num).toDouble(),
  tailleListe: (json['taille_liste'] as num).toInt(),
  scoreBruit: (json['score_bruit'] as num).toInt(),
  ponderationPoids: (json['ponderation_poids'] as num).toDouble(),
);

Map<String, dynamic> _$DiagnosticToJson(Diagnostic instance) =>
    <String, dynamic>{
      'precision_max': instance.precisionMax,
      'verite': instance.verite,
      'par_niveau': instance.parNiveau,
      'affinite_specialite': instance.affiniteSpecialite,
      'bonus_specialite': instance.bonusSpecialite,
      'exclusion': instance.exclusion,
      'taille_liste': instance.tailleListe,
      'score_bruit': instance.scoreBruit,
      'ponderation_poids': instance.ponderationPoids,
    };

Recompenses _$RecompensesFromJson(Map<String, dynamic> json) => Recompenses(
  piecesDiagnostic: (json['pieces_diagnostic'] as num?)?.toInt(),
  piecesTraitement: (json['pieces_traitement'] as num?)?.toInt(),
  piecesPartiel: (json['pieces_partiel'] as num?)?.toInt(),
  reputationGuerison: (json['reputation_guerison'] as num?)?.toInt(),
  reputationEchec: (json['reputation_echec'] as num?)?.toInt(),
  reputationAttente: (json['reputation_attente'] as num?)?.toInt(),
  reputationMort: (json['reputation_mort'] as num?)?.toInt(),
  pvPartiel: (json['pv_partiel'] as num?)?.toInt(),
  pvEchec: (json['pv_echec'] as num?)?.toInt(),
);

Map<String, dynamic> _$RecompensesToJson(Recompenses instance) =>
    <String, dynamic>{
      'pieces_diagnostic': instance.piecesDiagnostic,
      'pieces_traitement': instance.piecesTraitement,
      'pieces_partiel': instance.piecesPartiel,
      'reputation_guerison': instance.reputationGuerison,
      'reputation_echec': instance.reputationEchec,
      'reputation_attente': instance.reputationAttente,
      'reputation_mort': instance.reputationMort,
      'pv_partiel': instance.pvPartiel,
      'pv_echec': instance.pvEchec,
    };

Difficulte _$DifficulteFromJson(Map<String, dynamic> json) => Difficulte(
  id: json['id'] as String,
  nom: json['nom'] as String,
  modificateurs: Modificateurs.fromJson(
    json['modificateurs'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DifficulteToJson(Difficulte instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'modificateurs': instance.modificateurs,
    };

Modificateurs _$ModificateursFromJson(Map<String, dynamic> json) =>
    Modificateurs(
      pvPerdus: (json['pv_perdus'] as num).toInt(),
      pieces: (json['pieces'] as num).toInt(),
      reputation: (json['reputation'] as num).toInt(),
    );

Map<String, dynamic> _$ModificateursToJson(Modificateurs instance) =>
    <String, dynamic>{
      'pv_perdus': instance.pvPerdus,
      'pieces': instance.pieces,
      'reputation': instance.reputation,
    };

Specialite _$SpecialiteFromJson(Map<String, dynamic> json) => Specialite(
  id: json['id'] as String,
  nom: json['nom'] as String,
  couleur: json['couleur'] as String,
  icone: json['icone'] as String,
);

Map<String, dynamic> _$SpecialiteToJson(Specialite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'couleur': instance.couleur,
      'icone': instance.icone,
    };

Capacite _$CapaciteFromJson(Map<String, dynamic> json) => Capacite(
  id: json['id'] as String,
  nom: json['nom'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CapaciteToJson(Capacite instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'description': instance.description,
};

Carte _$CarteFromJson(Map<String, dynamic> json) => Carte(
  type: $enumDecode(_$TypeCarteEnumMap, json['type']),
  nom: json['nom'] as String,
  nomPhrase: json['nom_phrase'] as String?,
  lieuPhrase: json['lieu_phrase'] as String?,
  specialite: json['specialite'] as String?,
  capacites: (json['capacites'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
);

Map<String, dynamic> _$CarteToJson(Carte instance) => <String, dynamic>{
  'type': _$TypeCarteEnumMap[instance.type]!,
  'nom': instance.nom,
  'nom_phrase': instance.nomPhrase,
  'lieu_phrase': instance.lieuPhrase,
  'specialite': instance.specialite,
  'capacites': instance.capacites,
};

const _$TypeCarteEnumMap = {
  TypeCarte.medecin: 'medecin',
  TypeCarte.patient: 'patient',
  TypeCarte.salle: 'salle',
  TypeCarte.objet: 'objet',
  TypeCarte.diplome: 'diplome',
};

Traitement _$TraitementFromJson(Map<String, dynamic> json) => Traitement(
  adapte: Predicat.fromJson(json['adapte'] as Map<String, dynamic>),
  partiel: json['partiel'] == null
      ? null
      : Predicat.fromJson(json['partiel'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TraitementToJson(Traitement instance) =>
    <String, dynamic>{'adapte': instance.adapte, 'partiel': instance.partiel};

Maladie _$MaladieFromJson(Map<String, dynamic> json) => Maladie(
  id: json['id'] as String,
  nom: json['nom'] as String,
  specialite: json['specialite'] as String,
  pvInitial: (json['pv_initial'] as num).toInt(),
  aggravation: (json['aggravation'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  traitement: Traitement.fromJson(json['traitement'] as Map<String, dynamic>),
  attenteMax: (json['attente_max'] as num?)?.toInt(),
  poids: (json['poids'] as num?)?.toInt(),
  recompenses: json['recompenses'] == null
      ? null
      : Recompenses.fromJson(json['recompenses'] as Map<String, dynamic>),
  recherche: json['recherche'] == null
      ? null
      : Recherche.fromJson(json['recherche'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MaladieToJson(Maladie instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'specialite': instance.specialite,
  'pv_initial': instance.pvInitial,
  'aggravation': instance.aggravation,
  'attente_max': instance.attenteMax,
  'poids': instance.poids,
  'traitement': instance.traitement,
  'recompenses': instance.recompenses,
  'recherche': instance.recherche,
};

Recherche _$RechercheFromJson(Map<String, dynamic> json) =>
    Recherche(passages: (json['passages'] as num?)?.toInt() ?? 1);

Map<String, dynamic> _$RechercheToJson(Recherche instance) => <String, dynamic>{
  'passages': instance.passages,
};

Intervalle _$IntervalleFromJson(Map<String, dynamic> json) =>
    Intervalle((json['min'] as num).toInt(), (json['max'] as num).toInt());

Map<String, dynamic> _$IntervalleToJson(Intervalle instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

Effet _$EffetFromJson(Map<String, dynamic> json) => Effet(
  effet: json['effet'] as String,
  valeur: json['valeur'] == null ? null : Valeur.fromJson(json['valeur']),
  condition: json['condition'] == null
      ? null
      : Condition.fromJson(json['condition']),
  alors: (json['alors'] as List<dynamic>?)
      ?.map((e) => Effet.fromJson(e as Map<String, dynamic>))
      .toList(),
  sinon: (json['sinon'] as List<dynamic>?)
      ?.map((e) => Effet.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EffetToJson(Effet instance) => <String, dynamic>{
  'effet': instance.effet,
  'valeur': instance.valeur,
  'condition': instance.condition,
  'alors': instance.alors,
  'sinon': instance.sinon,
};

ActionJeu _$ActionJeuFromJson(Map<String, dynamic> json) => ActionJeu(
  id: json['id'] as String,
  libelle: json['libelle'] as String,
  motif: json['motif'] as String,
  phrase: json['phrase'] as String,
  effets: (json['effets'] as List<dynamic>)
      .map((e) => Effet.fromJson(e as Map<String, dynamic>))
      .toList(),
  precondition: json['precondition'] == null
      ? null
      : Condition.fromJson(json['precondition']),
);

Map<String, dynamic> _$ActionJeuToJson(ActionJeu instance) => <String, dynamic>{
  'id': instance.id,
  'libelle': instance.libelle,
  'motif': instance.motif,
  'precondition': instance.precondition,
  'phrase': instance.phrase,
  'effets': instance.effets,
};
