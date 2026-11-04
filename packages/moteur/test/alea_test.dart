import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

void main() {
  test('une même graine donne la même suite', () {
    final a = Alea(42);
    final b = Alea(42);
    for (var i = 0; i < 100; i++) {
      expect(a.entier32(), b.entier32());
    }
  });

  test('deux graines différentes donnent des suites différentes', () {
    final a = Alea(1);
    final b = Alea(2);
    final sa = [for (var i = 0; i < 10; i++) a.entier32()];
    final sb = [for (var i = 0; i < 10; i++) b.entier32()];
    expect(sa, isNot(sb));
  });

  test('suite figée (xoshiro128**, vérifiée contre une implémentation de '
      'référence) : protège la reproductibilité des simulations', () {
    final a = Alea(2026);
    expect(
      [for (var i = 0; i < 3; i++) a.entier32()],
      [1436751614, 742089593, 1736781944],
    );
  });

  test('flottant uniforme dans [0, 1[, moyenne proche de 0,5', () {
    final a = Alea(7);
    var somme = 0.0;
    for (var i = 0; i < 20000; i++) {
      final x = a.flottant();
      expect(x, greaterThanOrEqualTo(0));
      expect(x, lessThan(1));
      somme += x;
    }
    expect(somme / 20000, closeTo(0.5, 0.01));
  });

  test('entiers sur 32 bits', () {
    final a = Alea(0);
    for (var i = 0; i < 1000; i++) {
      final x = a.entier32();
      expect(x, inInclusiveRange(0, 0xFFFFFFFF));
    }
  });

  test('loi exponentielle de paramètre 1 : moyenne proche de 1', () {
    final a = Alea(3);
    var somme = 0.0;
    for (var i = 0; i < 20000; i++) {
      somme += a.exponentielle();
    }
    expect(somme / 20000, closeTo(1, 0.03));
  });

  test('tirage pondéré proportionnel aux poids, poids nul jamais tiré', () {
    final a = Alea(5);
    final comptes = [0, 0, 0];
    for (var i = 0; i < 30000; i++) {
      comptes[a.indicePondere([1, 0, 3])]++;
    }
    expect(comptes[1], 0);
    expect(comptes[0] / 30000, closeTo(0.25, 0.015));
    expect(comptes[2] / 30000, closeTo(0.75, 0.015));
  });
}
