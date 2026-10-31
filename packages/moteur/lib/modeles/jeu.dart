import 'package:json_annotation/json_annotation.dart';

part 'jeu.g.dart';

@JsonSerializable()
class Jeu {
  Jeu({
    required this.format,
    required this.schemaVersion,
    required this.id,
    required this.nom,
    required this.version,
    required this.parametres,
    required this.difficultes,
    required this.specialites,
    required this.capacites,
    required this.cartes,
    required this.maladies,
    required this.motifs,
    required this.actions,
    this.description,
  });

  factory Jeu.fromJson(Map<String, dynamic> json) => _$JeuFromJson(json);

  Map<String, dynamic> toJson() => _$JeuToJson(this);

  @JsonKey(name: 'format')
  final String format;
  @JsonKey(name: 'schema_version')
  final int schemaVersion;
  final String id;
  final String nom;
  final String version;
  final String? description;
  final Parametres parametres;
  final List<Difficulte> difficultes;
  final List<Specialite> specialites;
  final List<Capacite> capacites;
  final Map<String, Carte> cartes;
  final List<Maladie> maladies;
  final Map<String, Motif> motifs;
  final List<ActionJeu> actions;
}

@JsonSerializable()
class Parametres {
  Parametres({
    required this.attenteMaxDefaut,
    required this.diagnostic,
    required this.recompenses,
  });

  factory Parametres.fromJson(Map<String, dynamic> json) =>
      _$ParametresFromJson(json);

  Map<String, dynamic> toJson() => _$ParametresToJson(this);

  @JsonKey(name: 'attente_max_defaut')
  final int attenteMaxDefaut;
  final Diagnostic diagnostic;
  final Recompenses recompenses;
}

@JsonSerializable()
class Diagnostic {
  Diagnostic({
    required this.precisionMax,
    required this.verite,
    required this.parNiveau,
    required this.bonusSpecialite,
    required this.exclusion,
    required this.seuilAffichage,
    required this.veriteNom,
    required this.parNiveauNom,
    required this.nbNoms,
  });

  factory Diagnostic.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnosticToJson(this);

  @JsonKey(name: 'precision_max')
  final int precisionMax;
  final double verite;
  @JsonKey(name: 'par_niveau')
  final double parNiveau;
  @JsonKey(name: 'bonus_specialite')
  final double bonusSpecialite;
  final double exclusion;
  @JsonKey(name: 'seuil_affichage')
  final int seuilAffichage;
  @JsonKey(name: 'verite_nom')
  final double veriteNom;
  @JsonKey(name: 'par_niveau_nom')
  final double parNiveauNom;
  @JsonKey(name: 'nb_noms')
  final int nbNoms;
}

@JsonSerializable()
class Recompenses {
  Recompenses({
    this.piecesDiagnostic,
    this.piecesTraitement,
    this.piecesPartiel,
    this.reputationSoin,
    this.reputationEchec,
    this.reputationAttente,
    this.reputationMort,
    this.soinPartiel,
    this.pvEchec,
  });

  factory Recompenses.fromJson(Map<String, dynamic> json) =>
      _$RecompensesFromJson(json);

  Map<String, dynamic> toJson() => _$RecompensesToJson(this);

  @JsonKey(name: 'pieces_diagnostic')
  final int? piecesDiagnostic;
  @JsonKey(name: 'pieces_traitement')
  final int? piecesTraitement;
  @JsonKey(name: 'pieces_partiel')
  final int? piecesPartiel;
  @JsonKey(name: 'reputation_soin')
  final int? reputationSoin;
  @JsonKey(name: 'reputation_echec')
  final int? reputationEchec;
  @JsonKey(name: 'reputation_attente')
  final int? reputationAttente;
  @JsonKey(name: 'reputation_mort')
  final int? reputationMort;
  @JsonKey(name: 'soin_partiel')
  final int? soinPartiel;
  @JsonKey(name: 'pv_echec')
  final int? pvEchec;
}

@JsonSerializable()
class Difficulte {
  Difficulte({
    required this.id,
    required this.nom,
    required this.modificateurs,
  });

  factory Difficulte.fromJson(Map<String, dynamic> json) =>
      _$DifficulteFromJson(json);

  Map<String, dynamic> toJson() => _$DifficulteToJson(this);

  final String id;
  final String nom;
  final Modificateurs modificateurs;
}

@JsonSerializable()
class Modificateurs {
  Modificateurs({
    required this.pvPerdus,
    required this.pieces,
    required this.reputation,
  });

  factory Modificateurs.fromJson(Map<String, dynamic> json) =>
      _$ModificateursFromJson(json);

  Map<String, dynamic> toJson() => _$ModificateursToJson(this);

  @JsonKey(name: 'pv_perdus')
  final double pvPerdus;
  final double pieces;
  final double reputation;
}

@JsonSerializable()
class Specialite {
  Specialite({required this.id, required this.nom});

  factory Specialite.fromJson(Map<String, dynamic> json) =>
      _$SpecialiteFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialiteToJson(this);

  final String id;
  final String nom;
}

@JsonSerializable()
class Capacite {
  Capacite({required this.id, required this.nom, this.description});

  factory Capacite.fromJson(Map<String, dynamic> json) =>
      _$CapaciteFromJson(json);

  Map<String, dynamic> toJson() => _$CapaciteToJson(this);

  final String id;
  final String nom;
  final String? description;
}

enum TypeCarte { medecin, patient, salle, objet, diplome }

@JsonSerializable()
class Carte {
  Carte({
    required this.type,
    required this.nom,
    this.nomPhrase,
    this.specialite,
    this.capacites,
  });

  factory Carte.fromJson(Map<String, dynamic> json) => _$CarteFromJson(json);

  Map<String, dynamic> toJson() => _$CarteToJson(this);

  final TypeCarte type;
  final String nom;
  @JsonKey(name: 'nom_phrase')
  final String? nomPhrase;
  final String? specialite;
  final Map<String, int>? capacites;

  String get nomAffiche => nomPhrase ?? nom;
}

@JsonSerializable()
class Traitement {
  Traitement({required this.adapte, this.partiel});

  factory Traitement.fromJson(Map<String, dynamic> json) =>
      _$TraitementFromJson(json);

  Map<String, dynamic> toJson() => _$TraitementToJson(this);

  final Predicat adapte;
  final Predicat? partiel;
}

@JsonSerializable()
class Maladie {
  Maladie({
    required this.id,
    required this.nom,
    required this.type,
    required this.pvInitial,
    required this.aggravation,
    required this.traitement,
    this.attenteMax,
    this.poids,
    this.recompenses,
  });

  factory Maladie.fromJson(Map<String, dynamic> json) =>
      _$MaladieFromJson(json);

  Map<String, dynamic> toJson() => _$MaladieToJson(this);

  final String id;
  final String nom;
  final String type;
  @JsonKey(name: 'pv_initial')
  final int pvInitial;
  final List<int> aggravation;
  @JsonKey(name: 'attente_max')
  final int? attenteMax;
  final int? poids;
  final Traitement traitement;
  final Recompenses? recompenses;
}

class Motif {
  Motif(this.intervalles);

  factory Motif.fromJson(Map<String, dynamic> json) => Motif(
    json.map(
      (cle, valeur) =>
          MapEntry(cle, Intervalle.fromJson((valeur as List).cast<int>())),
    ),
  );

  Map<String, dynamic> toJson() =>
      intervalles.map((cle, intervalle) => MapEntry(cle, intervalle.toJson()));

  final Map<String, Intervalle> intervalles;
}

@JsonSerializable()
class Intervalle {
  Intervalle(this.min, this.max);

  factory Intervalle.fromJson(List<int> json) => Intervalle(json[0], json[1]);

  List<int> toJson() => [min, max];

  final int min;
  final int max;
}

class Filtre {
  Filtre({this.type, this.specialite, this.id});

  factory Filtre.fromJson(Map<String, dynamic> json) {
    return Filtre(
      type: _listeOuValeur<TypeCarte>(json['type']),
      specialite: _listeOuValeur<String>(json['specialite']),
      id: _listeOuValeur<String>(json['id']),
    );
  }

  Map<String, dynamic> toJson() => {
    if (type != null) 'type': type!.map((t) => t.name).toList(),
    if (specialite != null) 'specialite': specialite,
    if (id != null) 'id': id,
  };

  final List<TypeCarte>? type;
  final List<String>? specialite;
  final List<String>? id;

  static List<T>? _listeOuValeur<T>(dynamic valeur) {
    if (valeur == null) return null;
    if (valeur is List) return valeur.cast<T>();
    if (T == TypeCarte) return [TypeCarte.values.byName(valeur as String) as T];
    return [valeur as T];
  }
}

class Predicat {
  Predicat({
    this.carte,
    this.compte,
    this.min,
    this.max,
    this.tous,
    this.unDe,
    this.non,
  });

  factory Predicat.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('carte')) {
      return Predicat(carte: json['carte'] as String);
    }
    if (json.containsKey('compte')) {
      final compte = json['compte'] as Map<String, dynamic>;
      return Predicat(
        compte: Filtre.fromJson(
          compte['filtre'] as Map<String, dynamic>? ?? compte,
        ),
        min: compte['min'] as int?,
        max: compte['max'] as int?,
      );
    }
    if (json.containsKey('tous')) {
      return Predicat(
        tous: (json['tous'] as List)
            .map((e) => Predicat.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    if (json.containsKey('un_de')) {
      return Predicat(
        unDe: (json['un_de'] as List)
            .map((e) => Predicat.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    return Predicat(
      non: Predicat.fromJson(json['non'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    if (carte != null) return {'carte': carte};
    if (compte != null) {
      return {
        'compte': {
          ...compte!.toJson(),
          if (min != null) 'min': min,
          if (max != null) 'max': max,
        },
      };
    }
    if (tous != null) {
      return {'tous': tous!.map((p) => p.toJson()).toList()};
    }
    if (unDe != null) {
      return {'un_de': unDe!.map((p) => p.toJson()).toList()};
    }
    return {'non': non!.toJson()};
  }

  final String? carte;
  final Filtre? compte;
  final int? min;
  final int? max;
  final List<Predicat>? tous;
  final List<Predicat>? unDe;
  final Predicat? non;
}

class Condition {
  Condition({this.constante, this.et, this.ou, this.non, this.combinaison});

  factory Condition.fromJson(dynamic json) {
    if (json is String) return Condition(constante: json);
    final map = json as Map<String, dynamic>;
    if (map.containsKey('et')) {
      return Condition(
        et: (map['et'] as List).map((e) => Condition.fromJson(e)).toList(),
      );
    }
    if (map.containsKey('ou')) {
      return Condition(
        ou: (map['ou'] as List).map((e) => Condition.fromJson(e)).toList(),
      );
    }
    if (map.containsKey('non')) {
      return Condition(non: Condition.fromJson(map['non']));
    }
    return Condition(
      combinaison: Predicat.fromJson(
        map['combinaison'] as Map<String, dynamic>,
      ),
    );
  }

  dynamic toJson() {
    if (constante != null) return constante;
    if (et != null) return {'et': et!.map((c) => c.toJson()).toList()};
    if (ou != null) return {'ou': ou!.map((c) => c.toJson()).toList()};
    if (non != null) return {'non': non!.toJson()};
    return {'combinaison': combinaison!.toJson()};
  }

  final String? constante;
  final List<Condition>? et;
  final List<Condition>? ou;
  final Condition? non;
  final Predicat? combinaison;
}

class Valeur {
  Valeur.litterale(this.entier) : reference = null, sousValeurs = null;
  Valeur.reference(this.reference) : entier = null, sousValeurs = null;
  Valeur.somme(this.sousValeurs) : entier = null, reference = null;

  factory Valeur.fromJson(dynamic json) {
    if (json is int) return Valeur.litterale(json);
    if (json is String) return Valeur.reference(json);
    return Valeur.somme(
      (json['somme'] as List).map((e) => Valeur.fromJson(e)).toList(),
    );
  }

  dynamic toJson() {
    if (entier != null) return entier;
    if (reference != null) return reference;
    return {'somme': sousValeurs!.map((v) => v.toJson()).toList()};
  }

  final int? entier;
  final String? reference;
  final List<Valeur>? sousValeurs;
}

@JsonSerializable()
class Effet {
  Effet({
    required this.effet,
    this.valeur,
    this.condition,
    this.alors,
    this.sinon,
  });

  factory Effet.fromJson(Map<String, dynamic> json) {
    return Effet(
      effet: json['effet'] as String,
      valeur: json['valeur'] != null ? Valeur.fromJson(json['valeur']) : null,
      condition: json['condition'] != null
          ? Condition.fromJson(json['condition'])
          : null,
      alors: json['alors'] != null
          ? (json['alors'] as List)
                .map((e) => Effet.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      sinon: json['sinon'] != null
          ? (json['sinon'] as List)
                .map((e) => Effet.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'effet': effet,
    if (valeur != null) 'valeur': valeur!.toJson(),
    if (condition != null) 'condition': condition!.toJson(),
    if (alors != null) 'alors': alors!.map((e) => e.toJson()).toList(),
    if (sinon != null) 'sinon': sinon!.map((e) => e.toJson()).toList(),
  };

  final String effet;
  final Valeur? valeur;
  final Condition? condition;
  final List<Effet>? alors;
  final List<Effet>? sinon;
}

@JsonSerializable()
class ActionJeu {
  ActionJeu({
    required this.id,
    required this.libelle,
    required this.motif,
    required this.phrase,
    required this.effets,
    this.precondition,
  });

  factory ActionJeu.fromJson(Map<String, dynamic> json) =>
      _$ActionJeuFromJson(json);

  Map<String, dynamic> toJson() => _$ActionJeuToJson(this);

  final String id;
  final String libelle;
  final String motif;
  final Condition? precondition;
  final String phrase;
  final List<Effet> effets;
}
