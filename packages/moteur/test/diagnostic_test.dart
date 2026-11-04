import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

/// Paquet d'exemple ajusté pour isoler le niveau de précision : MED-001
/// (généraliste) sans capacité et un objet généraliste OBJ-003 de précision 3.
Jeu _jeuDiagnostic([void Function(Map<String, dynamic>)? autre]) =>
    jeuExemple((brut) {
      final cartes = brut['cartes'] as Map<String, dynamic>;
      (cartes['MED-001'] as Map).remove('capacites');
      cartes['OBJ-003'] = {
        'type': 'objet',
        'nom': 'Scanner',
        'capacites': {'precision': 3},
      };
      autre?.call(brut);
    });

void main() {
  group('plus fort reste', () {
    test('somme 100 et répartition des restes', () {
      expect(pourcentagesPlusFortReste([1, 1, 1]), [34, 33, 33]);
      expect(pourcentagesPlusFortReste([2, 1, 1]), [50, 25, 25]);
      expect(pourcentagesPlusFortReste([1, 2]), [33, 67]);
      expect(pourcentagesPlusFortReste([0, 0]), [50, 50]);
      expect(pourcentagesPlusFortReste([]), isEmpty);
    });

    test('somme toujours égale à 100', () {
      final alea = Alea(11);
      for (var i = 0; i < 500; i++) {
        final poids = [for (var k = 0; k < 7; k++) alea.exponentielle()];
        final p = pourcentagesPlusFortReste(poids);
        expect(p.fold<int>(0, (a, b) => a + b), 100);
      }
    });
  });

  group('niveau de précision', () {
    test('somme des capacités « precision », plafonnée', () {
      final jeu = _jeuDiagnostic();
      final d = Diagnostiqueur(jeu, Alea(1));
      expect(d.niveau(Combinaison(jeu, ['MED-001', 'SAL-001'])), 1);
      expect(d.niveau(Combinaison(jeu, ['OBJ-003', 'SAL-001'])), 4);
      expect(
        d.niveau(Combinaison(jeu, ['OBJ-003', 'OBJ-002', 'SAL-001'])),
        5,
        reason: 'precision_max = 5',
      );
    });
  });

  group('distributions', () {
    final jeu = _jeuDiagnostic();
    final appendicite = jeu.maladies.firstWhere((m) => m.id == 'appendicite');

    test('types : 3 lignes de somme 100, triées par ordre décroissant', () {
      final d = Diagnostiqueur(jeu, Alea(9));
      for (var i = 0; i < 200; i++) {
        final r = d.diagnostiquer(
          appendicite,
          Combinaison(jeu, ['MED-001', 'SAL-001']),
        );
        expect(r.types.fold<int>(0, (s, l) => s + l.pourcentage), 100);
        for (var k = 1; k < r.types.length; k++) {
          if (r.types[k].estAutres) continue;
          expect(
            r.types[k].pourcentage,
            lessThanOrEqualTo(r.types[k - 1].pourcentage),
          );
        }
        expect(r.noms, isNull, reason: 'aucune spécialité concordante');
      }
    });

    test('types sous le seuil regroupés en « Autres », en dernier', () {
      final j = _jeuDiagnostic(
        (brut) =>
            (brut['parametres'] as Map)['diagnostic']['seuil_affichage'] = 40,
      );
      final d = Diagnostiqueur(j, Alea(4));
      var vuAutres = false;
      for (var i = 0; i < 200; i++) {
        final r = d.diagnostiquer(
          appendicite,
          Combinaison(j, ['MED-001', 'SAL-001']),
        );
        expect(r.types.fold<int>(0, (s, l) => s + l.pourcentage), 100);
        final autres = r.types.where((l) => l.estAutres).toList();
        if (autres.isNotEmpty) {
          vuAutres = true;
          expect(r.types.last.estAutres, isTrue);
          expect(autres.single.nom, 'Autres');
        }
        for (final l in r.types.where((l) => !l.estAutres)) {
          expect(l.pourcentage, greaterThanOrEqualTo(40));
        }
      }
      expect(vuAutres, isTrue);
    });

    test('noms : présents si le vrai type est dans S(C)', () {
      final d = Diagnostiqueur(jeu, Alea(5));
      final r = d.diagnostiquer(
        appendicite,
        Combinaison(jeu, ['MED-002', 'SAL-001']),
      );
      expect(r.noms, isNotNull);
      expect(
        r.noms!.map((l) => l.id),
        unorderedEquals(['appendicite', 'fracture_ouverte']),
      );
      expect(r.noms!.fold<int>(0, (s, l) => s + l.pourcentage), 100);
    });

    test('noms : au-delà de nb_noms, regroupés en « Autres »', () {
      final j = _jeuDiagnostic(
        (brut) => (brut['parametres'] as Map)['diagnostic']['nb_noms'] = 1,
      );
      final r = Diagnostiqueur(
        j,
        Alea(5),
      ).diagnostiquer(appendicite, Combinaison(j, ['MED-002', 'SAL-001']));
      expect(r.noms, hasLength(2));
      expect(r.noms!.last.estAutres, isTrue);
    });

    test('noms absents avec une spécialité discordante seule', () {
      final r = Diagnostiqueur(
        jeu,
        Alea(5),
      ).diagnostiquer(appendicite, Combinaison(jeu, ['MED-004', 'SAL-001']));
      expect(r.noms, isNull);
    });

    test('sérialisation aller-retour', () {
      final r = Diagnostiqueur(
        jeu,
        Alea(5),
      ).diagnostiquer(appendicite, Combinaison(jeu, ['MED-002', 'SAL-002']));
      final copie = ResultatDiagnostic.fromJson(r.toJson());
      expect(copie.toJson(), r.toJson());
    });

    test('reproductible : même graine, même diagnostic', () {
      final comb = Combinaison(jeu, ['MED-002', 'SAL-002']);
      final a = Diagnostiqueur(jeu, Alea(77)).diagnostiquer(appendicite, comb);
      final b = Diagnostiqueur(jeu, Alea(77)).diagnostiquer(appendicite, comb);
      expect(a.toJson(), b.toJson());
    });
  });

  // MODELE_DE_JEU.md §8.3 : comportement attendu avec 3 types, sur 20 000
  // tirages. La maladie est de type chirurgie.
  group('statistiques §8.3 (graine fixe, 20 000 tirages)', () {
    final jeu = _jeuDiagnostic();
    final appendicite = jeu.maladies.firstWhere((m) => m.id == 'appendicite');
    const tirages = 20000;

    ({double enTete, double moyenne, double psy}) mesurer(List<String> ids) {
      final d = Diagnostiqueur(jeu, Alea(2026));
      final comb = Combinaison(jeu, ids);
      var enTete = 0;
      var somme = 0;
      var psy = 0;
      for (var i = 0; i < tirages; i++) {
        final r = d.diagnostiquer(appendicite, comb);
        int pct(String id) =>
            r.types.where((l) => l.id == id).firstOrNull?.pourcentage ?? 0;
        if (r.types.first.id == 'chirurgie') enTete++;
        somme += pct('chirurgie');
        psy += pct('psychologie');
      }
      return (
        enTete: enTete / tirages * 100,
        moyenne: somme / tirages,
        psy: psy / tirages,
      );
    }

    void verifier(
      String nom,
      List<String> ids, {
      required double enTete,
      required double moyenne,
    }) {
      test(nom, () {
        final m = mesurer(ids);
        expect(m.enTete, closeTo(enTete, 2.5), reason: 'vrai type en tête');
        expect(m.moyenne, closeTo(moyenne, 2.5), reason: 'probabilité moyenne');
      });
    }

    verifier(
      'aucune spécialité, N = 1',
      ['MED-001', 'SAL-001'],
      enTete: 53,
      moyenne: 46,
    );
    verifier(
      'aucune spécialité, N = 4',
      ['MED-001', 'SAL-001', 'OBJ-003'],
      enTete: 68,
      moyenne: 56,
    );
    verifier(
      'spécialité concordante, N = 1',
      ['MED-002', 'SAL-001'],
      enTete: 79,
      moyenne: 65,
    );
    verifier(
      'spécialité concordante, N = 4',
      ['MED-002', 'SAL-001', 'OBJ-003'],
      enTete: 87,
      moyenne: 73,
    );

    test('spécialité discordante (psy sur chirurgie), N = 1', () {
      final m = mesurer(['MED-004', 'SAL-001']);
      expect(m.enTete, closeTo(66, 2.5));
      expect(m.moyenne, closeTo(57, 2.5));
      expect(m.psy, closeTo(7, 2), reason: 'psy tombe à ~7 %');
    });
  });
}
