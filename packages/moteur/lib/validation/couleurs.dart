import 'dart:math' as math;

/// Accessibilité des couleurs de spécialité (SPECIFICATION.md §9) :
/// contraste sur fond clair et sombre, et écart entre deux couleurs pour
/// les principales formes de daltonisme.

/// Fond clair et fond sombre de référence de l'appli.
const fondClair = '#FFFFFF';
const fondSombre = '#121212';

/// Contraste minimal d'une couleur de spécialité sur chacun des deux fonds
/// (WCAG 2.1, composant non textuel).
const contrasteMin = 3.0;

/// Écart minimal (ΔE CIE76) entre deux couleurs de spécialité, dans chaque
/// vision simulée.
const ecartMin = 20.0;

/// Vision simulée : normale ou dichromatie complète (Machado, Oliveira et
/// Fernandes, 2009, sévérité 1).
enum Vision {
  normale('vision normale', null),
  protanopie('protanopie', [
    [0.152286, 1.052583, -0.204868],
    [0.114503, 0.786281, 0.099216],
    [-0.003882, -0.048116, 1.051998],
  ]),
  deuteranopie('deutéranopie', [
    [0.367322, 0.860646, -0.227968],
    [0.280085, 0.672501, 0.047413],
    [-0.011820, 0.042940, 0.968881],
  ]),
  tritanopie('tritanopie', [
    [1.255528, -0.076749, -0.178779],
    [-0.078411, 0.930809, 0.147602],
    [0.004733, 0.691367, 0.303900],
  ]);

  const Vision(this.nom, this._matrice);

  final String nom;
  final List<List<double>>? _matrice;

  List<double> _simuler(List<double> rgbLineaire) {
    final m = _matrice;
    if (m == null) return rgbLineaire;
    return [
      for (final ligne in m)
        (ligne[0] * rgbLineaire[0] +
                ligne[1] * rgbLineaire[1] +
                ligne[2] * rgbLineaire[2])
            .clamp(0.0, 1.0),
    ];
  }
}

List<double> _rgbLineaire(String couleur) => [
  for (final i in [1, 3, 5])
    _lineaire(int.parse(couleur.substring(i, i + 2), radix: 16) / 255),
];

double _lineaire(double c) =>
    c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

/// Luminance relative d'une couleur `#RRGGBB`.
double luminance(String couleur) {
  final c = _rgbLineaire(couleur);
  return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
}

/// Rapport de contraste entre deux couleurs `#RRGGBB` (1 à 21).
double contraste(String a, String b) {
  final la = luminance(a), lb = luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// Écart ΔE (CIE76, Lab D65) entre deux couleurs vues dans [vision].
double ecart(String a, String b, Vision vision) {
  final la = _lab(vision._simuler(_rgbLineaire(a)));
  final lb = _lab(vision._simuler(_rgbLineaire(b)));
  return math.sqrt(
    math.pow(la[0] - lb[0], 2) +
        math.pow(la[1] - lb[1], 2) +
        math.pow(la[2] - lb[2], 2),
  );
}

List<double> _lab(List<double> rgb) {
  final x = 0.4124 * rgb[0] + 0.3576 * rgb[1] + 0.1805 * rgb[2];
  final y = 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2];
  final z = 0.0193 * rgb[0] + 0.1192 * rgb[1] + 0.9505 * rgb[2];
  double f(double t) =>
      t > 0.008856 ? math.pow(t, 1 / 3).toDouble() : 7.787 * t + 16 / 116;
  final fx = f(x / 0.95047), fy = f(y), fz = f(z / 1.08883);
  return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
}
