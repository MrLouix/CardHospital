import 'configuration.dart';

/// Une image de la caméra où au moins un QR a été lu.
class Detection {
  const Detection(this.instant, this.contenus);

  factory Detection.fromJson(Map<String, dynamic> json) => Detection(
    Duration(milliseconds: json['t_ms'] as int),
    (json['contenus'] as List).cast<String>(),
  );

  /// Temps écoulé depuis le top départ.
  final Duration instant;

  /// Contenus lus dans l'image, triés.
  final List<String> contenus;

  Map<String, dynamic> toJson() => {
    't_ms': instant.inMilliseconds,
    'contenus': contenus,
  };
}

enum IssueEssai {
  reussi('Réussi', 'reussi'),
  echec('Échec', 'echec');

  const IssueEssai(this.libelle, this.code);
  final String libelle;
  final String code;
}

/// Un essai terminé.
class ResultatEssai {
  const ResultatEssai({
    required this.numero,
    required this.date,
    required this.config,
    required this.issue,
    required this.duree,
    required this.detections,
    required this.faussesLectures,
    required this.faussesDansSelection,
    required this.selectionFinale,
  });

  factory ResultatEssai.fromJson(Map<String, dynamic> json) => ResultatEssai(
    numero: json['numero'] as int,
    date: DateTime.parse(json['date'] as String),
    config: ConfigEssai.fromJson(json['config'] as Map<String, dynamic>),
    issue: IssueEssai.values.firstWhere((i) => i.code == json['issue']),
    duree: Duration(milliseconds: json['duree_ms'] as int),
    detections: [
      for (final d in json['detections'] as List)
        Detection.fromJson(d as Map<String, dynamic>),
    ],
    faussesLectures: {...(json['fausses_lectures'] as List).cast<String>()},
    faussesDansSelection: {
      ...(json['fausses_dans_selection'] as List).cast<String>(),
    },
    selectionFinale: (json['selection_finale'] as List).cast<String>(),
  );

  final int numero;
  final DateTime date;
  final ConfigEssai config;
  final IssueEssai issue;

  /// Temps jusqu'à la réussite, ou jusqu'à l'abandon pour un échec.
  final Duration duree;
  final List<Detection> detections;

  /// Contenus lus qui ne sont pas des cartes attendues.
  final Set<String> faussesLectures;

  /// Fausses lectures entrées dans la sélection (mode cumulatif) : ce sont
  /// celles qui fausseraient une action en jeu.
  final Set<String> faussesDansSelection;
  final List<String> selectionFinale;

  bool get reussi => issue == IssueEssai.reussi;

  /// Critère de sortie de la phase 0 : sélection en moins de 3 s.
  bool get moinsDe3s => reussi && duree < const Duration(seconds: 3);

  Map<String, dynamic> toJson() => {
    'numero': numero,
    'date': date.toIso8601String(),
    'config': config.toJson(),
    'issue': issue.code,
    'duree_ms': duree.inMilliseconds,
    'detections': detections.map((d) => d.toJson()).toList(),
    'fausses_lectures': faussesLectures.toList()..sort(),
    'fausses_dans_selection': faussesDansSelection.toList()..sort(),
    'selection_finale': selectionFinale,
  };
}

/// Déroulement d'un essai : reçoit les images détectées, tient la sélection
/// et décide de la réussite ou de l'échec. Indépendant de la caméra.
class SuiviEssai {
  SuiviEssai(this.config);

  final ConfigEssai config;

  final _selection = <String>{};
  final _detections = <Detection>[];
  final _faussesLectures = <String>{};
  final _faussesDansSelection = <String>{};
  Set<String> _precedente = const {};
  Duration? _instantPrecedent;
  IssueEssai? _issue;
  Duration? _duree;

  /// Sélection courante, dans l'ordre d'entrée (mode cumulatif) ; en mode
  /// simultané, contenu de la dernière image.
  List<String> get selection => List.unmodifiable(_selection);
  List<Detection> get detections => List.unmodifiable(_detections);
  Set<String> get faussesLectures => Set.unmodifiable(_faussesLectures);
  IssueEssai? get issue => _issue;
  Duration? get duree => _duree;
  bool get termine => _issue != null;

  /// Enregistre une image où les QR [contenus] ont été lus, [instant] après
  /// le top départ. Retourne `true` si l'essai vient de réussir.
  bool ajouterImage(Duration instant, Iterable<String> contenus) {
    if (termine) return false;
    if (verifierDelai(instant)) return false;
    final lus = {
      for (final c in contenus)
        if (c.trim().isNotEmpty) c.trim(),
    };
    if (lus.isEmpty) return false;
    _detections.add(Detection(instant, lus.toList()..sort()));
    _faussesLectures.addAll(lus.difference(config.cartesAttendues));

    switch (config.mode) {
      case ModeSelection.simultane:
        _selection
          ..clear()
          ..addAll(lus);
      case ModeSelection.cumulatif:
        final consecutive =
            _instantPrecedent != null &&
            instant - _instantPrecedent! <=
                Duration(milliseconds: config.ecartMaxMs);
        if (consecutive) {
          for (final c in lus) {
            if (_precedente.contains(c) && _selection.add(c)) {
              if (!config.cartesAttendues.contains(c)) {
                _faussesDansSelection.add(c);
              }
            }
          }
        }
    }
    _precedente = lus;
    _instantPrecedent = instant;

    if (_selection.containsAll(config.cartesAttendues)) {
      _issue = IssueEssai.reussi;
      _duree = instant;
      return true;
    }
    return false;
  }

  /// Termine l'essai en échec si le délai maximal est dépassé à [instant].
  /// Retourne `true` si c'est le cas.
  bool verifierDelai(Duration instant) {
    if (termine) return false;
    if (instant > Duration(seconds: config.delaiMaxS)) {
      _issue = IssueEssai.echec;
      _duree = Duration(seconds: config.delaiMaxS);
      return true;
    }
    return false;
  }

  /// Le testeur arrête l'essai : échec à [instant].
  void abandonner(Duration instant) {
    if (termine) return;
    _issue = IssueEssai.echec;
    _duree = instant;
  }

  /// Retire une carte de la sélection (appui sur sa vignette).
  void retirer(String contenu) => _selection.remove(contenu);

  /// Vide la sélection.
  void vider() => _selection.clear();

  /// Résultat de l'essai terminé.
  ResultatEssai resultat({required int numero, required DateTime date}) {
    if (!termine) throw StateError('essai non terminé');
    return ResultatEssai(
      numero: numero,
      date: date,
      config: config,
      issue: _issue!,
      duree: _duree!,
      detections: detections,
      faussesLectures: faussesLectures,
      faussesDansSelection: Set.of(_faussesDansSelection),
      selectionFinale: selection,
    );
  }
}
