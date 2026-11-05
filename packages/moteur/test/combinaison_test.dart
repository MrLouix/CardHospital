import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

void main() {
  final jeu = jeuExemple();
  Combinaison c(List<String> ids) => Combinaison(jeu, ids);
  Predicat p(Map<String, dynamic> json) => Predicat.fromJson(json);

  group('composition', () {
    test('doublons retirés, inconnus ignorés, ordre conservé', () {
      final comb = c(['MED-007', 'PAT-001', 'MED-007', 'XXX-999', 'SAL-006']);
      expect(comb.ids, ['MED-007', 'PAT-001', 'SAL-006']);
      expect(comb.patient, 'PAT-001');
      expect(comb.medecins, ['MED-007']);
      expect(comb.salle, 'SAL-006');
      expect(comb.accessoire, isNull);
    });

    test('un diplôme compte comme accessoire', () {
      expect(c(['DIP-001', 'PAT-001']).accessoire, 'DIP-001');
    });

    test('S(C) : spécialités hors patient et hors valeurs réservées', () {
      final comb = c(['MED-001', 'MED-005', 'PAT-001', 'SAL-006', 'OBJ-010']);
      expect(comb.specialites, {'psychiatrie', 'orthopedie', 'generale'});
      expect(
        c(['MED-001', 'PAT-001', 'SAL-003']).specialites,
        isEmpty,
        reason: 'Dr Moreau et la radiologie sont polyvalents',
      );
      expect(
        c(['MED-001', 'PAT-001', 'SAL-011']).specialites,
        isEmpty,
        reason: '« recherche » est réservée au laboratoire',
      );
      expect(c(['MED-001', 'PAT-001', 'SAL-001']).specialites, {
        'generale',
      }, reason: 'la salle de consultation est de médecine générale');
    });

    test('« generaliste », ancien nom de « polyvalent », reste neutre', () {
      final ancien = jeuExemple(
        (brut) =>
            (brut['cartes'] as Map)['SAL-003']['specialite'] = 'generaliste',
      );
      expect(
        Combinaison(ancien, ['MED-001', 'PAT-001', 'SAL-003']).specialites,
        isEmpty,
      );
    });

    test('capacité totale hors patient', () {
      final comb = c(['MED-001', 'PAT-001', 'SAL-003', 'OBJ-002']);
      expect(comb.capacite('precision'), 6);
      expect(comb.capacite('stabilisation'), 0);
      expect(c(['MED-008', 'PAT-001']).capacite('stabilisation'), 1);
    });
  });

  group('prédicats', () {
    final comb = c(['MED-007', 'MED-008', 'PAT-001', 'SAL-006']);

    test('carte', () {
      expect(comb.satisfait(p({'carte': 'MED-007'})), isTrue);
      expect(comb.satisfait(p({'carte': 'OBJ-010'})), isFalse);
    });

    test('compte avec min et max au niveau du prédicat', () {
      final filtre = {'type': 'medecin', 'specialite': 'orthopedie'};
      expect(comb.satisfait(p({'compte': filtre, 'min': 2})), isTrue);
      expect(comb.satisfait(p({'compte': filtre, 'min': 3})), isFalse);
      expect(comb.satisfait(p({'compte': filtre, 'max': 1})), isFalse);
      expect(comb.satisfait(p({'compte': filtre, 'min': 1, 'max': 2})), isTrue);
    });

    test('compte sans min ni max : au moins une carte, jamais vrai '
        'd\'office', () {
      final platrerie = p({
        'compte': {'type': 'salle', 'id': 'SAL-008'},
      });
      expect(comb.satisfait(platrerie), isFalse, reason: 'salle absente');
      expect(c(['MED-007', 'PAT-001', 'SAL-008']).satisfait(platrerie), isTrue);
      expect(
        comb.satisfait(
          p({
            'compte': {'type': 'objet'},
            'max': 0,
          }),
        ),
        isTrue,
        reason: 'avec max seul, min vaut 0',
      );
    });

    test('un diplôme de spécialité X compte comme un médecin de X', () {
      final avecDiplome = c(['MED-005', 'PAT-001', 'SAL-001', 'DIP-001']);
      expect(
        avecDiplome.satisfait(
          p({
            'compte': {'type': 'medecin', 'specialite': 'generale'},
            'min': 1,
          }),
        ),
        isTrue,
      );
      expect(
        avecDiplome.satisfait(
          p({
            'compte': {'type': 'medecin', 'specialite': 'generale'},
            'min': 2,
          }),
        ),
        isFalse,
      );
      expect(
        avecDiplome.satisfait(
          p({
            'compte': {'type': 'medecin', 'specialite': 'orthopedie'},
            'min': 1,
          }),
        ),
        isFalse,
      );
      expect(
        avecDiplome.satisfait(
          p({
            'compte': {'type': 'medecin'},
            'min': 2,
          }),
        ),
        isFalse,
        reason: 'sans spécialité, le diplôme ne compte pas comme médecin',
      );
    });

    test('compte : min et max relus puis réécrits au bon niveau', () {
      final json = {
        'compte': {'type': 'medecin'},
        'min': 2,
        'max': 3,
      };
      final predicat = p(json);
      expect(predicat.min, 2);
      expect(predicat.max, 3);
      expect(predicat.toJson(), {
        'compte': {
          'type': ['medecin'],
        },
        'min': 2,
        'max': 3,
      });
    });

    test(
      'compte : filtres par liste de types, spécialités et identifiants',
      () {
        expect(
          comb.satisfait(
            p({
              'compte': {
                'type': ['salle', 'objet'],
              },
              'min': 1,
              'max': 1,
            }),
          ),
          isTrue,
        );
        expect(
          comb.satisfait(
            p({
              'compte': {
                'specialite': ['psychiatrie', 'generale'],
              },
              'min': 1,
            }),
          ),
          isFalse,
        );
        expect(
          comb.satisfait(
            p({
              'compte': {
                'id': ['MED-007', 'MED-005'],
              },
              'min': 1,
              'max': 1,
            }),
          ),
          isTrue,
        );
      },
    );

    test('tous, un_de, non', () {
      final vrai = {'carte': 'MED-007'};
      final faux = {'carte': 'OBJ-010'};
      expect(
        comb.satisfait(
          p({
            'tous': [vrai, vrai],
          }),
        ),
        isTrue,
      );
      expect(
        comb.satisfait(
          p({
            'tous': [vrai, faux],
          }),
        ),
        isFalse,
      );
      expect(
        comb.satisfait(
          p({
            'un_de': [faux, vrai],
          }),
        ),
        isTrue,
      );
      expect(
        comb.satisfait(
          p({
            'un_de': [faux, faux],
          }),
        ),
        isFalse,
      );
      expect(comb.satisfait(p({'non': faux})), isTrue);
      expect(comb.satisfait(p({'non': vrai})), isFalse);
    });

    test('traitements de l\'exemple : 2 orthopédistes au bloc pour la '
        'fracture ouverte, pas un seul', () {
      final fracture = jeu.maladies.first;
      expect(fracture.id, 'fracture_ouverte');
      expect(comb.satisfait(fracture.traitement.adapte), isTrue);
      final seul = c(['MED-007', 'PAT-001', 'SAL-006']);
      expect(seul.satisfait(fracture.traitement.adapte), isFalse);
      expect(
        seul.satisfait(fracture.traitement.partiel!),
        isFalse,
        reason: 'le traitement partiel se fait à la plâtrerie',
      );
      expect(
        c(['MED-007', 'PAT-001', 'SAL-008'])
            .satisfait(fracture.traitement.partiel!),
        isTrue,
      );
    });
  });

  group('cartes et préconditions', () {
    final horsLabo = Condition.fromJson({
      'et': [
        'patient_en_jeu',
        {
          'non': {
            'combinaison': {
              'compte': {'type': 'salle', 'specialite': 'recherche'},
              'min': 1,
            },
          },
        },
      ],
    });

    test('les conditions d\'état sont tenues pour favorables', () {
      expect(c(['MED-001', 'PAT-001', 'SAL-006']).permet(horsLabo), isTrue);
      expect(c(['MED-001', 'PAT-001', 'SAL-011']).permet(horsLabo), isFalse);
      final comb = c(['MED-001', 'PAT-001', 'SAL-006']);
      expect(comb.permet(Condition.fromJson('patient_hors_jeu')), isTrue);
      expect(
        comb.permet(Condition.fromJson({'non': 'patient_hors_jeu'})),
        isTrue,
      );
      expect(
        comb.permet(
          Condition.fromJson({
            'ou': [
              'gueri',
              {
                'combinaison': {'carte': 'OBJ-010'},
              },
            ],
          }),
        ),
        isTrue,
      );
    });
  });

  group('phrases', () {
    const modele =
        'Examen de {patient} par {medecin}[ et {medecin2}] dans '
        '{salle}[ avec {accessoire}].';

    test('segments facultatifs absents', () {
      expect(
        c(['MED-001', 'PAT-001', 'SAL-001']).phrase(modele),
        'Examen de Mme Garnier par le Dr Moreau dans la salle de '
        'consultation.',
      );
    });

    test('accessoire présent', () {
      expect(
        c(['MED-001', 'PAT-001', 'SAL-001', 'OBJ-001']).phrase(modele),
        'Examen de Mme Garnier par le Dr Moreau dans la salle de '
        'consultation avec le stéthoscope.',
      );
    });

    test('second médecin, dans l\'ordre de sélection', () {
      expect(
        c(['MED-008', 'PAT-002', 'MED-007', 'SAL-006']).phrase(modele),
        'Examen de M. Dupont par le Dr Vasseur et le Dr Cassagne dans le bloc '
        'opératoire.',
      );
    });

    test('première lettre en majuscule ; phrase vide', () {
      expect(
        c(['SAL-003', 'PAT-001']).phrase('{salle} accueille {patient}.'),
        'La salle de radiologie accueille Mme Garnier.',
      );
      expect(c(['PAT-001']).phrase(''), '');
    });
  });
}
