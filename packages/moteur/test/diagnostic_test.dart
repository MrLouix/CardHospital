import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

/// Paquet d'exemple ajusté pour isoler le niveau de précision : MED-001
/// (généraliste) sans capacité et un objet généraliste OBJ-003 de précision 3.
/// [maladies] remplace les maladies : nombre de maladies par type.
Jeu _jeuDiagnostic({
  Map<String, int>? maladies,
  void Function(Map<String, dynamic>)? autre,
}) => jeuExemple((brut) {
  final cartes = brut['cartes'] as Map<String, dynamic>;
  (cartes['MED-001'] as Map).remove('capacites');
  cartes['OBJ-003'] = {
    'type': 'objet',
    'nom': 'Scanner',
    'capacites': {'precision': 3},
  };
  if (maladies != null) {
    brut['maladies'] = [
      for (final e in maladies.entries)
        for (var i = 0; i < e.value; i++)
          {
            'id': '${e.key}_$i',
            'nom': '${e.key} $i',
            'type': e.key,
            'pv_initial': 10,
            'aggravation': [1],
            'traitement': {
              'adapte': {'carte': 'OBJ-010'},
            },
          },
    ];
  }
  autre?.call(brut);
});

/// Catalogue cible du paquet de base : 100 maladies sur 3 spécialités.
final _catalogueCible = {'chirurgie': 34, 'psychologie': 33, 'pharmacie': 33};

void main() {
  group('maximum attendu du bruit', () {
    test('nombres harmoniques pour n entier, croissant entre les deux', () {
      expect(maximumAttenduBruit(1), closeTo(1, 1e-9));
      expect(maximumAttenduBruit(2), closeTo(1.5, 1e-9));
      expect(maximumAttenduBruit(4), closeTo(25 / 12, 1e-9));
      var h = 0.0;
      for (var k = 1; k <= 25; k++) {
        h += 1 / k;
      }
      expect(maximumAttenduBruit(25), closeTo(h, 1e-9));
      expect(maximumAttenduBruit(2.5), inExclusiveRange(1.5, 25 / 12 - 0.25));
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

  group('liste', () {
    final jeu = _jeuDiagnostic();
    final appendicite = jeu.maladies.firstWhere((m) => m.id == 'appendicite');

    test('taille_liste maladies distinctes, pourcentages décroissants '
        'entre 0 et 99, couleur et icône de leur spécialité', () {
      final d = Diagnostiqueur(jeu, Alea(9));
      final specialites = {for (final s in jeu.specialites) s.id: s};
      final types = {for (final m in jeu.maladies) m.id: m.type};
      for (var i = 0; i < 300; i++) {
        final r = d.diagnostiquer(
          appendicite,
          Combinaison(jeu, ['MED-001', 'SAL-001']),
        );
        expect(r.maladies, hasLength(5));
        expect(r.maladies.map((l) => l.id).toSet(), hasLength(5));
        for (var k = 0; k < r.maladies.length; k++) {
          final l = r.maladies[k];
          expect(l.pourcentage, inInclusiveRange(0, pourcentageMax));
          if (k > 0) {
            expect(
              l.pourcentage,
              lessThanOrEqualTo(r.maladies[k - 1].pourcentage),
            );
          }
          final s = specialites[types[l.id]]!;
          expect(l.specialite.id, s.id);
          expect(l.specialite.couleur, s.couleur);
          expect(l.specialite.icone, s.icone);
          expect(l.nom, jeu.maladies.firstWhere((m) => m.id == l.id).nom);
        }
      }
    });

    test('liste plus longue que le paquet : toutes les maladies', () {
      final j = _jeuDiagnostic(
        autre: (brut) =>
            (brut['parametres'] as Map)['diagnostic']['taille_liste'] = 10,
      );
      final r = Diagnostiqueur(
        j,
        Alea(2),
      ).diagnostiquer(appendicite, Combinaison(j, ['MED-001', 'SAL-001']));
      expect(r.maladies, hasLength(6));
    });

    test(
      'pourcentage : score_bruit au maximum attendu du bruit, plafond 99',
      () {
        final cible = _jeuDiagnostic(maladies: _catalogueCible);
        final d = Diagnostiqueur(cible, Alea(1));
        final h = maximumAttenduBruit(100 / 3);
        expect(d.pourcentage(h), 50, reason: 'score_bruit = 50');
        expect(d.pourcentage(0), 0);
        expect(d.pourcentage(1e6), pourcentageMax);
        expect(d.pourcentage(2 * h), 75, reason: '1 − (1 − 0,5)²');
      },
    );

    test('sérialisation aller-retour', () {
      final r = Diagnostiqueur(
        jeu,
        Alea(5),
      ).diagnostiquer(appendicite, Combinaison(jeu, ['MED-002', 'SAL-002']));
      final copie = ResultatDiagnostic.fromJson(r.toJson());
      expect(copie.toJson(), r.toJson());
      expect(r.toJson()['maladies'][0]['specialite'].keys, [
        'id',
        'nom',
        'couleur',
        'icone',
      ]);
    });

    test('reproductible : même graine, même diagnostic', () {
      final comb = Combinaison(jeu, ['MED-002', 'SAL-002']);
      final a = Diagnostiqueur(jeu, Alea(77)).diagnostiquer(appendicite, comb);
      final b = Diagnostiqueur(jeu, Alea(77)).diagnostiquer(appendicite, comb);
      expect(a.toJson(), b.toJson());
    });
  });

  test('correction : sans indice, chaque spécialité a la même chance d\'être '
      'en tête, quel que soit son nombre de maladies', () {
    final j = _jeuDiagnostic(
      maladies: {'chirurgie': 60, 'psychologie': 25, 'pharmacie': 15},
      autre: (brut) {
        final p = (brut['parametres'] as Map)['diagnostic'] as Map;
        p['verite'] = 0;
        p['par_niveau'] = 0;
        p['affinite_type'] = 0;
      },
    );
    final d = Diagnostiqueur(j, Alea(4));
    final vraie = j.maladies.first;
    final comb = Combinaison(j, ['MED-001', 'SAL-001']);
    final enTete = <String, int>{};
    const tirages = 30000;
    for (var i = 0; i < tirages; i++) {
      final t = d.diagnostiquer(vraie, comb).maladies.first.specialite.id;
      enTete[t] = (enTete[t] ?? 0) + 1;
    }
    for (final t in ['chirurgie', 'psychologie', 'pharmacie']) {
      expect(
        enTete[t]! / tirages * 100,
        closeTo(100 / 3, 1.5),
        reason: 'sans correction : 60 / 25 / 15 %',
      );
    }
  });

  // MODELE_DE_JEU.md §8.4 : comportement attendu sur le catalogue cible
  // (100 maladies sur 3 spécialités), 20 000 tirages sur graine fixe. La
  // maladie est de type chirurgie, tirée au hasard parmi les 34.
  group('comportement attendu §8.4 (catalogue cible, 20 000 tirages)', () {
    final jeu = _jeuDiagnostic(maladies: _catalogueCible);
    final chirurgie = jeu.maladies.where((m) => m.type == 'chirurgie').toList();
    const tirages = 20000;

    void verifier(
      String nom,
      List<String> ids, {
      required double tete,
      required double liste,
      required double couleur,
      required double dominante,
      required double scoreJuste,
      required double scoreFaux,
    }) {
      test(nom, () {
        final alea = Alea(2026);
        final d = Diagnostiqueur(jeu, alea);
        final comb = Combinaison(jeu, ids);
        var nTete = 0, nListe = 0, nCouleur = 0, nDominante = 0;
        var sJuste = 0, sFaux = 0;
        for (var i = 0; i < tirages; i++) {
          final vraie = chirurgie[(alea.flottant() * chirurgie.length).floor()];
          final r = d.diagnostiquer(vraie, comb);
          final premiere = r.maladies.first;
          if (premiere.id == vraie.id) {
            nTete++;
            sJuste += premiere.pourcentage;
          } else {
            sFaux += premiere.pourcentage;
          }
          if (r.maladies.any((l) => l.id == vraie.id)) nListe++;
          if (premiere.specialite.id == 'chirurgie') nCouleur++;
          if (r.specialiteDominante == 'chirurgie') nDominante++;
        }
        double pct(int x) => x / tirages * 100;
        expect(pct(nTete), closeTo(tete, 2), reason: 'vraie maladie en tête');
        expect(pct(nListe), closeTo(liste, 2), reason: 'dans la liste');
        expect(pct(nCouleur), closeTo(couleur, 2), reason: '1re couleur');
        expect(pct(nDominante), closeTo(dominante, 2), reason: 'dominante');
        expect(sJuste / nTete, closeTo(scoreJuste, 2), reason: 'tête juste');
        expect(
          sFaux / (tirages - nTete),
          closeTo(scoreFaux, 2),
          reason: 'tête fausse',
        );
      });
    }

    verifier(
      'aucune spécialité, N = 1',
      ['MED-001', 'SAL-001'],
      tete: 43,
      liste: 60,
      couleur: 72,
      dominante: 72,
      scoreJuste: 80,
      scoreFaux: 61,
    );
    verifier(
      'aucune spécialité, N = 4',
      ['MED-001', 'SAL-001', 'OBJ-003'],
      tete: 62,
      liste: 75,
      couleur: 82,
      dominante: 77,
      scoreJuste: 86,
      scoreFaux: 62,
    );
    verifier(
      'spécialité concordante, N = 1',
      ['MED-002', 'SAL-001'],
      tete: 46,
      liste: 64,
      couleur: 88,
      dominante: 91,
      scoreJuste: 85,
      scoreFaux: 68,
    );
    verifier(
      'spécialité concordante, N = 4',
      ['MED-002', 'SAL-001', 'OBJ-003'],
      tete: 65,
      liste: 78,
      couleur: 92,
      dominante: 94,
      scoreJuste: 90,
      scoreFaux: 68,
    );
    verifier(
      'spécialité discordante (psy sur chirurgie), N = 1',
      ['MED-004', 'SAL-001'],
      tete: 44,
      liste: 62,
      couleur: 79,
      dominante: 80,
      scoreJuste: 79,
      scoreFaux: 60,
    );
  });

  test('bruit seul : pourcentages moyens des 5 lignes autour de 40 à 57 %', () {
    final jeu = _jeuDiagnostic(
      maladies: _catalogueCible,
      autre: (brut) {
        final p = (brut['parametres'] as Map)['diagnostic'] as Map;
        p['verite'] = 0;
        p['par_niveau'] = 0;
        p['affinite_type'] = 0;
      },
    );
    final d = Diagnostiqueur(jeu, Alea(3));
    final comb = Combinaison(jeu, ['MED-001', 'SAL-001']);
    final sommes = List.filled(5, 0);
    const tirages = 5000;
    for (var i = 0; i < tirages; i++) {
      final r = d.diagnostiquer(jeu.maladies.first, comb);
      for (var k = 0; k < 5; k++) {
        sommes[k] += r.maladies[k].pourcentage;
      }
    }
    final moyennes = [for (final s in sommes) s / tirages];
    for (final (k, attendu) in [57, 50, 46, 43, 41].indexed) {
      expect(moyennes[k], closeTo(attendu, 1.5));
    }
  });
}
