import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

/// Paquet d'exemple dont les maladies sont remplacées par [maladies] :
/// nombre de maladies par spécialité (catalogue synthétique).
Jeu _jeuDiagnostic({
  Map<String, int>? maladies,
  void Function(Map<String, dynamic>)? autre,
}) => jeuExemple((brut) {
  if (maladies != null) {
    brut['maladies'] = [
      for (final e in maladies.entries)
        for (var i = 0; i < e.value; i++)
          {
            'id': '${e.key}_$i',
            'nom': '${e.key} $i',
            'specialite': e.key,
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

/// Catalogue synthétique : 100 maladies sur 3 spécialités.
final _catalogue100 = {'orthopedie': 34, 'psychiatrie': 33, 'generale': 33};

/// Combinaison sans spécialité : Dr Moreau en radiologie (N = 4).
const _neutre = ['MED-001', 'SAL-003'];

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
      expect(d.niveau(Combinaison(jeu, ['MED-005', 'SAL-008'])), 0);
      expect(d.niveau(Combinaison(jeu, ['MED-001', 'SAL-001'])), 2);
      expect(d.niveau(Combinaison(jeu, _neutre)), 4);
      expect(
        d.niveau(Combinaison(jeu, [..._neutre, 'OBJ-002'])),
        4,
        reason: '1 + 3 + 2 = 6, plafonné à precision_max = 4',
      );
    });
  });

  group('liste', () {
    final jeu = _jeuDiagnostic();
    final fracture = jeu.maladies.firstWhere((m) => m.id == 'fracture_ouverte');

    test('taille_liste maladies distinctes, indices décroissants entre 0 et '
        '99, couleur et icône de leur spécialité', () {
      final d = Diagnostiqueur(jeu, Alea(9));
      final specialites = {for (final s in jeu.specialites) s.id: s};
      final specialiteDe = {for (final m in jeu.maladies) m.id: m.specialite};
      for (var i = 0; i < 300; i++) {
        final r = d.diagnostiquer(fracture, Combinaison(jeu, _neutre));
        expect(r.maladies, hasLength(5));
        expect(r.maladies.map((l) => l.id).toSet(), hasLength(5));
        for (var k = 0; k < r.maladies.length; k++) {
          final l = r.maladies[k];
          expect(l.indice, inInclusiveRange(0, indiceMax));
          if (k > 0) {
            expect(l.indice, lessThanOrEqualTo(r.maladies[k - 1].indice));
          }
          final s = specialites[specialiteDe[l.id]]!;
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
      ).diagnostiquer(fracture, Combinaison(j, _neutre));
      expect(r.maladies, hasLength(6));
    });

    test('indice : score_bruit au maximum attendu du bruit, plafond 99', () {
      final cible = _jeuDiagnostic(maladies: _catalogue100);
      final d = Diagnostiqueur(cible, Alea(1));
      final h = maximumAttenduBruit(100 / 3);
      expect(d.indice(h), 50, reason: 'score_bruit = 50');
      expect(d.indice(0), 0);
      expect(d.indice(1e6), indiceMax);
      expect(d.indice(2 * h), 75, reason: '1 − (1 − 0,5)²');
    });

    test('sérialisation aller-retour', () {
      final r = Diagnostiqueur(
        jeu,
        Alea(5),
      ).diagnostiquer(fracture, Combinaison(jeu, ['MED-007', 'SAL-006']));
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
      final comb = Combinaison(jeu, ['MED-007', 'SAL-006']);
      final a = Diagnostiqueur(jeu, Alea(77)).diagnostiquer(fracture, comb);
      final b = Diagnostiqueur(jeu, Alea(77)).diagnostiquer(fracture, comb);
      expect(a.toJson(), b.toJson());
    });
  });

  test('correction : sans indice, chaque spécialité a la même chance d\'être '
      'en tête, quel que soit son nombre de maladies', () {
    final j = _jeuDiagnostic(
      maladies: {'orthopedie': 60, 'psychiatrie': 25, 'generale': 15},
      autre: (brut) {
        final p = (brut['parametres'] as Map)['diagnostic'] as Map;
        p['verite'] = 0;
        p['par_niveau'] = 0;
        p['affinite_specialite'] = 0;
      },
    );
    final d = Diagnostiqueur(j, Alea(4));
    final vraie = j.maladies.first;
    final comb = Combinaison(j, _neutre);
    final enTete = <String, int>{};
    const tirages = 30000;
    for (var i = 0; i < tirages; i++) {
      final t = d.diagnostiquer(vraie, comb).maladies.first.specialite.id;
      enTete[t] = (enTete[t] ?? 0) + 1;
    }
    for (final t in ['orthopedie', 'psychiatrie', 'generale']) {
      expect(
        enTete[t]! / tirages * 100,
        closeTo(100 / 3, 1.5),
        reason: 'sans correction : 60 / 25 / 15 %',
      );
    }
  });

  group('couleur dominante', () {
    LigneDiagnostic ligne(String specialite, int indice) => LigneDiagnostic(
      id: '$specialite$indice',
      nom: '$specialite $indice',
      indice: indice,
      specialite: SpecialiteAffichee(
        id: specialite,
        nom: specialite,
        couleur: '#000000',
        icone: '?',
      ),
    );

    test('la couleur qui a le plus de lignes, pas le plus gros total', () {
      final r = ResultatDiagnostic(
        niveau: 1,
        maladies: [
          ligne('generale', 95),
          ligne('generale', 90),
          ligne('orthopedie', 50),
          ligne('orthopedie', 45),
          ligne('orthopedie', 40),
        ],
      );
      expect(r.specialiteDominante, 'orthopedie', reason: '3 lignes sur 5');
    });

    test('égalité : la couleur la mieux classée', () {
      final r = ResultatDiagnostic(
        niveau: 1,
        maladies: [
          ligne('psychiatrie', 80),
          ligne('orthopedie', 70),
          ligne('orthopedie', 60),
          ligne('psychiatrie', 50),
          ligne('generale', 40),
        ],
      );
      expect(r.specialiteDominante, 'psychiatrie');
    });
  });

  // MODELE_DE_JEU.md §8.4 : comportement attendu sur le paquet de base
  // (103 maladies sur 5 spécialités), 20 000 tirages sur graine fixe. La
  // maladie est de cardiologie, tirée au hasard parmi les 20.
  group('comportement attendu §8.4 (paquet de base, 20 000 tirages)', () {
    final jeu = jeuBase();
    final cardiologie = jeu.maladies
        .where((m) => m.specialite == 'cardiologie')
        .toList();
    const tirages = 20000;

    void verifier(
      String nom,
      List<String> ids, {
      required int niveau,
      required double tete,
      required double liste,
      required double couleur,
      required double dominante,
      required double indiceJuste,
      required double indiceFaux,
    }) {
      test(nom, () {
        final alea = Alea(2026);
        final d = Diagnostiqueur(jeu, alea);
        final comb = Combinaison(jeu, ids);
        expect(d.niveau(comb), niveau);
        var nTete = 0, nListe = 0, nCouleur = 0, nDominante = 0;
        var sJuste = 0, sFaux = 0;
        for (var i = 0; i < tirages; i++) {
          final vraie =
              cardiologie[(alea.flottant() * cardiologie.length).floor()];
          final r = d.diagnostiquer(vraie, comb);
          final premiere = r.maladies.first;
          if (premiere.id == vraie.id) {
            nTete++;
            sJuste += premiere.indice;
          } else {
            sFaux += premiere.indice;
          }
          if (r.maladies.any((l) => l.id == vraie.id)) nListe++;
          if (premiere.specialite.id == 'cardiologie') nCouleur++;
          if (r.specialiteDominante == 'cardiologie') nDominante++;
        }
        double pct(int x) => x / tirages * 100;
        expect(pct(nTete), closeTo(tete, 2), reason: 'vraie maladie en tête');
        expect(pct(nListe), closeTo(liste, 2), reason: 'dans la liste');
        expect(pct(nCouleur), closeTo(couleur, 2), reason: '1re couleur');
        expect(pct(nDominante), closeTo(dominante, 2), reason: 'dominante');
        expect(sJuste / nTete, closeTo(indiceJuste, 2), reason: 'tête juste');
        expect(
          sFaux / (tirages - nTete),
          closeTo(indiceFaux, 2),
          reason: 'tête fausse',
        );
      });
    }

    verifier(
      'aucune spécialité, N = 1 (Dr Moreau à la pharmacie)',
      ['MED-001', 'SAL-007'],
      niveau: 1,
      tete: 41,
      liste: 58,
      couleur: 61,
      dominante: 56,
      indiceJuste: 82,
      indiceFaux: 65,
    );
    verifier(
      'aucune spécialité, N = 4 (Dr Moreau en radiologie)',
      _neutre,
      niveau: 4,
      tete: 55,
      liste: 70,
      couleur: 70,
      dominante: 61,
      indiceJuste: 86,
      indiceFaux: 65,
    );
    verifier(
      'spécialité concordante, N = 1 (Dr Benali en salle de cardiologie)',
      ['MED-003', 'SAL-004'],
      niveau: 1,
      tete: 46,
      liste: 64,
      couleur: 79,
      dominante: 80,
      indiceJuste: 86,
      indiceFaux: 69,
    );
    verifier(
      'spécialité concordante, N = 4 (Dr Benali en radiologie, stéthoscope)',
      ['MED-003', 'SAL-003', 'OBJ-001'],
      niveau: 4,
      tete: 60,
      liste: 75,
      couleur: 84,
      dominante: 83,
      indiceJuste: 89,
      indiceFaux: 70,
    );
    verifier(
      'spécialité discordante, N = 1 (Dr Sauvage en salle de psychiatrie)',
      ['MED-005', 'SAL-002'],
      niveau: 1,
      tete: 42,
      liste: 60,
      couleur: 64,
      dominante: 60,
      indiceJuste: 81,
      indiceFaux: 64,
    );
  });

  test('bruit seul : indices moyens des 5 lignes autour de 40 à 57', () {
    final jeu = _jeuDiagnostic(
      maladies: _catalogue100,
      autre: (brut) {
        final p = (brut['parametres'] as Map)['diagnostic'] as Map;
        p['verite'] = 0;
        p['par_niveau'] = 0;
        p['affinite_specialite'] = 0;
      },
    );
    final d = Diagnostiqueur(jeu, Alea(3));
    final comb = Combinaison(jeu, _neutre);
    final sommes = List.filled(5, 0);
    const tirages = 5000;
    for (var i = 0; i < tirages; i++) {
      final r = d.diagnostiquer(jeu.maladies.first, comb);
      for (var k = 0; k < 5; k++) {
        sommes[k] += r.maladies[k].indice;
      }
    }
    final moyennes = [for (final s in sommes) s / tirages];
    for (final (k, attendu) in [57, 50, 46, 43, 41].indexed) {
      expect(moyennes[k], closeTo(attendu, 1.5));
    }
  });
}
