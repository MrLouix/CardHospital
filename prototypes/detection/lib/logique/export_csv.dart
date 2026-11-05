import 'essai.dart';

/// Export des mesures en CSV, au format attendu par un tableur français :
/// séparateur `;`, décimales avec une virgule, encodage UTF-8.
///
/// Deux fichiers : un essai par ligne, et une détection (image) par ligne.
class ExportCsv {
  static const enTetesEssais = [
    'numero',
    'date',
    'telephone',
    'mode',
    'finition',
    'taille_cm',
    'correction',
    'eclairage',
    'support',
    'distance_cm',
    'angle_deg',
    'resolution',
    'cartes_attendues',
    'nb_cartes',
    'issue',
    'temps_s',
    'moins_de_3s',
    'images',
    'fausses_lectures',
    'fausses_dans_selection',
    'selection_finale',
    'ecart_max_ms',
  ];

  static const enTetesDetections = ['numero_essai', 't_ms', 'contenus'];

  /// Un essai par ligne.
  static String essais(Iterable<ResultatEssai> essais) {
    final lignes = [enTetesEssais.join(';')];
    for (final e in essais) {
      final c = e.config;
      lignes.add(
        [
          e.numero,
          e.date.toIso8601String(),
          _texte(c.telephone),
          c.mode.code,
          c.finition.code,
          c.taille.code.replaceAll('.', ','),
          c.correction.code,
          c.eclairage.code,
          c.support.code,
          c.distanceCm ?? '',
          c.angle,
          c.resolution.code,
          c.toJson()['cartes_attendues'].join('+'),
          c.cartesAttendues.length,
          e.issue.code,
          (e.duree.inMilliseconds / 1000)
              .toStringAsFixed(3)
              .replaceAll('.', ','),
          e.moinsDe3s ? 1 : 0,
          e.detections.length,
          (e.faussesLectures.toList()..sort()).join('+'),
          (e.faussesDansSelection.toList()..sort()).join('+'),
          e.selectionFinale.join('+'),
          c.ecartMaxMs,
        ].join(';'),
      );
    }
    return '${lignes.join('\n')}\n';
  }

  /// Une image détectée par ligne.
  static String detections(Iterable<ResultatEssai> essais) {
    final lignes = [enTetesDetections.join(';')];
    for (final e in essais) {
      for (final d in e.detections) {
        lignes.add(
          [
            e.numero,
            d.instant.inMilliseconds,
            d.contenus.map(_texte).join('+'),
          ].join(';'),
        );
      }
    }
    return '${lignes.join('\n')}\n';
  }

  /// Protège un texte libre : guillemets si besoin, guillemets doublés.
  static String _texte(String valeur) {
    if (!valeur.contains(RegExp(r'[;"\n\r+]'))) return valeur;
    return '"${valeur.replaceAll('"', '""')}"';
  }
}
