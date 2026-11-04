import 'dart:math' as math;

/// Source de hasard injectée dans le moteur.
///
/// Le moteur ne tire jamais de hasard autrement : tests et simulations sont
/// donc reproductibles en injectant une source à graine fixe.
abstract interface class SourceAleatoire {
  /// Flottant uniforme dans `[0, 1[`.
  double flottant();
}

/// Générateur pseudo-aléatoire à graine (xoshiro128**).
///
/// Implémenté ici plutôt que `dart:math` `Random(graine)`, dont la suite n'est
/// garantie ni entre plateformes ni entre versions de Dart : avec ce
/// générateur, une même graine donne la même partie partout. Toutes les
/// opérations restent sur 32 bits, donc exactes aussi en JavaScript.
class Alea implements SourceAleatoire {
  /// Initialise l'état à partir de [graine] par splitmix32.
  Alea(int graine) {
    var x = graine & _masque;
    for (var i = 0; i < 4; i++) {
      x = (x + 0x9e3779b9) & _masque;
      var z = x;
      z = _mul32(z ^ (z >>> 16), 0x85ebca6b);
      z = _mul32(z ^ (z >>> 13), 0xc2b2ae35);
      _s[i] = (z ^ (z >>> 16)) & _masque;
    }
    if (_s.every((v) => v == 0)) _s[0] = 1;
  }

  static const _masque = 0xFFFFFFFF;

  final _s = List<int>.filled(4, 0);

  /// Entier uniforme sur 32 bits.
  int entier32() {
    final resultat = _mul32(_rotl(_mul32(_s[1], 5), 7), 9);
    final t = (_s[1] << 9) & _masque;
    _s[2] ^= _s[0];
    _s[3] ^= _s[1];
    _s[1] ^= _s[2];
    _s[0] ^= _s[3];
    _s[2] ^= t;
    _s[3] = _rotl(_s[3], 11);
    return resultat;
  }

  @override
  double flottant() {
    // 53 bits de mantisse à partir de deux tirages de 32 bits.
    final haut = entier32() >>> 5; // 27 bits
    final bas = entier32() >>> 6; // 26 bits
    return (haut * 67108864 + bas) / 9007199254740992;
  }

  static int _rotl(int x, int k) =>
      ((x << k) & _masque) | ((x & _masque) >>> (32 - k));

  /// Produit modulo 2^32, exact même quand les entiers sont des doubles.
  static int _mul32(int a, int b) {
    final aHaut = (a >>> 16) & 0xFFFF;
    final aBas = a & 0xFFFF;
    return ((aBas * b) + (((aHaut * b) & 0xFFFF) << 16)) & _masque;
  }
}

/// Tirages dérivés d'une [SourceAleatoire].
extension TiragesAleatoires on SourceAleatoire {
  /// Tirage selon une loi exponentielle de paramètre 1.
  double exponentielle() => -math.log(1 - flottant());

  /// Indice tiré selon des [poids] positifs (au moins un non nul).
  int indicePondere(List<num> poids) {
    final total = poids.fold<num>(0, (a, b) => a + b);
    var cible = flottant() * total;
    for (var i = 0; i < poids.length; i++) {
      cible -= poids[i];
      if (cible < 0) return i;
    }
    // Erreur d'arrondi flottant : dernier indice de poids non nul.
    return poids.lastIndexWhere((p) => p > 0);
  }
}
