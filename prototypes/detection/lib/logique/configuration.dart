/// Configuration d'un essai de détection (phase 0 de la feuille de route).
library;

/// Contenus des QR de la planche de test (`outils/planche_qr`).
const contenusPlanche = [
  'MED-001',
  'PAT-001',
  'SAL-001',
  'OBJ-001',
  'DIP-001',
  'MED-002',
  'PAT-002',
  'SAL-002',
  'OBJ-002',
  'DIP-002',
];

/// Nombre maximal de cartes d'une combinaison.
const cartesMax = 4;

/// Mode de sélection comparé (SPECIFICATION.md §4.1).
enum ModeSelection {
  /// Toutes les cartes attendues doivent figurer dans une même image.
  simultane('Simultanée', 'simultane'),

  /// Une carte entre dans la sélection quand elle est lue lors de deux
  /// détections successives, et y reste même si elle sort du champ.
  cumulatif('Cumulative', 'cumulatif');

  const ModeSelection(this.libelle, this.code);
  final String libelle;
  final String code;
}

enum Finition {
  mate('Mate', 'mate'),
  brillante('Brillante', 'brillante');

  const Finition(this.libelle, this.code);
  final String libelle;
  final String code;
}

enum TailleQr {
  t15('1,5 cm', '1.5'),
  t20('2 cm', '2.0'),
  t25('2,5 cm', '2.5');

  const TailleQr(this.libelle, this.code);
  final String libelle;
  final String code;
}

enum Correction {
  m('M', 'M'),
  q('Q', 'Q');

  const Correction(this.libelle, this.code);
  final String libelle;
  final String code;
}

enum Eclairage {
  jour('Jour', 'jour'),
  lampe('Lampe', 'lampe'),
  penombre('Pénombre', 'penombre');

  const Eclairage(this.libelle, this.code);
  final String libelle;
  final String code;
}

enum Support {
  aPlat('À plat', 'a_plat'),
  enMain('En main', 'en_main');

  const Support(this.libelle, this.code);
  final String libelle;
  final String code;
}

/// Résolution demandée à la caméra. Sans indication, Android utilise
/// 640 × 480, ce qui pénalise les petits QR.
enum Resolution {
  r480('640 × 480', 640, 480),
  r720('1280 × 720', 1280, 720),
  r1080('1920 × 1080', 1920, 1080);

  const Resolution(this.libelle, this.largeur, this.hauteur);
  final String libelle;
  final int largeur;
  final int hauteur;

  String get code => '${largeur}x$hauteur';
}

/// Angles proposés, en degrés par rapport à la verticale des cartes.
const angles = [0, 30, 45, 60];

T _parCode<T extends Enum>(
  List<T> valeurs,
  String code,
  String Function(T) f,
) => valeurs.firstWhere((v) => f(v) == code);

/// Conditions d'un essai, saisies par le testeur.
class ConfigEssai {
  const ConfigEssai({
    this.telephone = '',
    this.mode = ModeSelection.cumulatif,
    this.finition = Finition.mate,
    this.taille = TailleQr.t20,
    this.correction = Correction.m,
    this.eclairage = Eclairage.jour,
    this.support = Support.aPlat,
    this.resolution = Resolution.r720,
    this.distanceCm,
    this.angle = 0,
    this.cartesAttendues = const {},
    this.delaiMaxS = 10,
    this.ecartMaxMs = 300,
  });

  factory ConfigEssai.fromJson(Map<String, dynamic> json) => ConfigEssai(
    telephone: json['telephone'] as String,
    mode: _parCode(ModeSelection.values, json['mode'] as String, (v) => v.code),
    finition: _parCode(
      Finition.values,
      json['finition'] as String,
      (v) => v.code,
    ),
    taille: _parCode(
      TailleQr.values,
      json['taille_cm'] as String,
      (v) => v.code,
    ),
    correction: _parCode(
      Correction.values,
      json['correction'] as String,
      (v) => v.code,
    ),
    eclairage: _parCode(
      Eclairage.values,
      json['eclairage'] as String,
      (v) => v.code,
    ),
    support: _parCode(Support.values, json['support'] as String, (v) => v.code),
    resolution: _parCode(
      Resolution.values,
      json['resolution'] as String,
      (v) => v.code,
    ),
    distanceCm: json['distance_cm'] as int?,
    angle: json['angle_deg'] as int,
    cartesAttendues: {...(json['cartes_attendues'] as List).cast<String>()},
    delaiMaxS: json['delai_max_s'] as int,
    ecartMaxMs: json['ecart_max_ms'] as int,
  );

  /// Modèle du téléphone, saisi par le testeur.
  final String telephone;
  final ModeSelection mode;
  final Finition finition;
  final TailleQr taille;
  final Correction correction;
  final Eclairage eclairage;
  final Support support;
  final Resolution resolution;

  /// Distance entre le téléphone et les cartes, en centimètres.
  final int? distanceCm;
  final int angle;

  /// Cartes réellement posées : toute autre lecture est une fausse lecture.
  final Set<String> cartesAttendues;

  /// Au-delà, l'essai est un échec.
  final int delaiMaxS;

  /// Écart maximal entre deux détections pour qu'elles comptent comme
  /// « images consécutives » (mode cumulatif). La caméra ne signale pas les
  /// images sans QR : sans ce garde-fou, deux lectures séparées par un long
  /// trou compteraient comme consécutives.
  final int ecartMaxMs;

  bool get complete => cartesAttendues.isNotEmpty;

  ConfigEssai copyWith({
    String? telephone,
    ModeSelection? mode,
    Finition? finition,
    TailleQr? taille,
    Correction? correction,
    Eclairage? eclairage,
    Support? support,
    Resolution? resolution,
    int? Function()? distanceCm,
    int? angle,
    Set<String>? cartesAttendues,
    int? delaiMaxS,
    int? ecartMaxMs,
  }) => ConfigEssai(
    telephone: telephone ?? this.telephone,
    mode: mode ?? this.mode,
    finition: finition ?? this.finition,
    taille: taille ?? this.taille,
    correction: correction ?? this.correction,
    eclairage: eclairage ?? this.eclairage,
    support: support ?? this.support,
    resolution: resolution ?? this.resolution,
    distanceCm: distanceCm == null ? this.distanceCm : distanceCm(),
    angle: angle ?? this.angle,
    cartesAttendues: cartesAttendues ?? this.cartesAttendues,
    delaiMaxS: delaiMaxS ?? this.delaiMaxS,
    ecartMaxMs: ecartMaxMs ?? this.ecartMaxMs,
  );

  Map<String, dynamic> toJson() => {
    'telephone': telephone,
    'mode': mode.code,
    'finition': finition.code,
    'taille_cm': taille.code,
    'correction': correction.code,
    'eclairage': eclairage.code,
    'support': support.code,
    'resolution': resolution.code,
    'distance_cm': distanceCm,
    'angle_deg': angle,
    'cartes_attendues': [
      for (final c in contenusPlanche)
        if (cartesAttendues.contains(c)) c,
    ],
    'delai_max_s': delaiMaxS,
    'ecart_max_ms': ecartMaxMs,
  };
}
