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
  diagnostic: Diagnostic.fromJson(json['diagnostic'] as Map<String, dynamic>),
  recompenses: Recompenses.fromJson(
    json['recompenses'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ParametresToJson(Parametres instance) =>
    <String, dynamic>{
      'attente_max_defaut': instance.attenteMaxDefaut,
      'diagnostic': instance.diagnostic,
      'recompenses': instance.recompenses,
    };

Diagnostic _$DiagnosticFromJson(Map<String, dynamic> json) => Diagnostic(
  precisionMax: (json['precision_max'] as num).toInt(),
  verite: (json['verite'] as num).toDouble(),
  parNiveau: (json['par_niveau'] as num).toDouble(),
  bonusSpecialite: (json['bonus_specialite'] as num).toDouble(),
  exclusion: (json['exclusion'] as num).toDouble(),
  seuilAffichage: (json['seuil_affichage'] as num).toInt(),
  veriteNom: (json['verite_nom'] as num).toDouble(),
  parNiveauNom: (json['par_niveau_nom'] as num).toDouble(),
  nbNoms: (json['nb_noms'] as num).toInt(),
);

Map<String, dynamic> _$DiagnosticToJson(Diagnostic instance) =>
    <String, dynamic>{
      'precision_max': instance.precisionMax,
      'verite': instance.verite,
      'par_niveau': instance.parNiveau,
      'bonus_specialite': instance.bonusSpecialite,
      'exclusion': instance.exclusion,
      'seuil_affichage': instance.seuilAffichage,
      'verite_nom': instance.veriteNom,
      'par_niveau_nom': instance.parNiveauNom,
      'nb_noms': instance.nbNoms,
    };

Recompenses _$RecompensesFromJson(Map<String, dynamic> json) => Recompenses(
  piecesDiagnostic: (json['pieces_diagnostic'] as num?)?.toInt(),
  piecesTraitement: (json['pieces_traitement'] as num?)?.toInt(),
  piecesPartiel: (json['pieces_partiel'] as num?)?.toInt(),
  reputationSoin: (json['reputation_soin'] as num?)?.toInt(),
  reputationEchec: (json['reputation_echec'] as num?)?.toInt(),
  reputationAttente: (json['reputation_attente'] as num?)?.toInt(),
  reputationMort: (json['reputation_mort'] as num?)?.toInt(),
  soinPartiel: (json['soin_partiel'] as num?)?.toInt(),
  pvEchec: (json['pv_echec'] as num?)?.toInt(),
);

Map<String, dynamic> _$RecompensesToJson(Recompenses instance) =>
    <String, dynamic>{
      'pieces_diagnostic': instance.piecesDiagnostic,
      'pieces_traitement': instance.piecesTraitement,
      'pieces_partiel': instance.piecesPartiel,
      'reputation_soin': instance.reputationSoin,
      'reputation_echec': instance.reputationEchec,
      'reputation_attente': instance.reputationAttente,
      'reputation_mort': instance.reputationMort,
      'soin_partiel': instance.soinPartiel,
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
      pvPerdus: (json['pv_perdus'] as num).toDouble(),
      pieces: (json['pieces'] as num).toDouble(),
      reputation: (json['reputation'] as num).toDouble(),
    );

Map<String, dynamic> _$ModificateursToJson(Modificateurs instance) =>
    <String, dynamic>{
      'pv_perdus': instance.pvPerdus,
      'pieces': instance.pieces,
      'reputation': instance.reputation,
    };

Specialite _$SpecialiteFromJson(Map<String, dynamic> json) =>
    Specialite(id: json['id'] as String, nom: json['nom'] as String);

Map<String, dynamic> _$SpecialiteToJson(Specialite instance) =>
    <String, dynamic>{'id': instance.id, 'nom': instance.nom};

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
  specialite: json['specialite'] as String?,
  capacites: (json['capacites'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
);

Map<String, dynamic> _$CarteToJson(Carte instance) => <String, dynamic>{
  'type': _$TypeCarteEnumMap[instance.type]!,
  'nom': instance.nom,
  'nom_phrase': instance.nomPhrase,
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
  type: json['type'] as String,
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
);

Map<String, dynamic> _$MaladieToJson(Maladie instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'type': instance.type,
  'pv_initial': instance.pvInitial,
  'aggravation': instance.aggravation,
  'attente_max': instance.attenteMax,
  'poids': instance.poids,
  'traitement': instance.traitement,
  'recompenses': instance.recompenses,
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
