import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

void main() {
  final jeu = jeuExemple();
  Combinaison c(List<String> ids) => Combinaison(jeu, ids);
  Predicat p(Map<String, dynamic> json) => Predicat.fromJson(json);

  group('composition', () {
    test('doublons retirés, inconnus ignorés, ordre conservé', () {
      final comb = c(['MED-002', 'PAT-001', 'MED-002', 'XXX-999', 'SAL-002']);
      expect(comb.ids, ['MED-002', 'PAT-001', 'SAL-002']);
      expect(comb.patient, 'PAT-001');
      expect(comb.medecins, ['MED-002']);
      expect(comb.salle, 'SAL-002');
      expect(comb.accessoire, isNull);
    });

    test('un diplôme compte comme accessoire', () {
      expect(c(['DIP-001', 'PAT-001']).accessoire, 'DIP-001');
    });

    test('S(C) : spécialités hors patient et hors généraliste', () {
      final comb = c(['MED-001', 'MED-004', 'PAT-001', 'SAL-002', 'OBJ-010']);
      expect(comb.specialites, {'psychologie', 'chirurgie', 'pharmacie'});
      expect(c(['MED-001', 'PAT-001', 'SAL-001']).specialites, isEmpty);
    });

    test('capacité totale hors patient', () {
      final comb = c(['MED-001', 'PAT-001', 'SAL-001', 'OBJ-002']);
      expect(comb.capacite('precision'), 4);
      expect(comb.capacite('soin'), 0);
      expect(c(['MED-003', 'PAT-001']).capacite('soin'), 1);
    });
  });

  group('prédicats', () {
    final comb = c(['MED-002', 'MED-003', 'PAT-001', 'SAL-002']);

    test('carte', () {
      expect(comb.satisfait(p({'carte': 'MED-002'})), isTrue);
      expect(comb.satisfait(p({'carte': 'OBJ-010'})), isFalse);
    });

    test('compte avec min et max au niveau du prédicat', () {
      final filtre = {'type': 'medecin', 'specialite': 'chirurgie'};
      expect(comb.satisfait(p({'compte': filtre, 'min': 2})), isTrue);
      expect(comb.satisfait(p({'compte': filtre, 'min': 3})), isFalse);
      expect(comb.satisfait(p({'compte': filtre, 'max': 1})), isFalse);
      expect(comb.satisfait(p({'compte': filtre, 'min': 1, 'max': 2})), isTrue);
    });

    test('un diplôme de spécialité X compte comme un médecin de X', () {
      final avecDiplome = c(['MED-004', 'PAT-001', 'SAL-001', 'DIP-001']);
      expect(
        avecDiplome.satisfait(
          p({
            'compte': {'type': 'medecin', 'specialite': 'pharmacie'},
            'min': 1,
          }),
        ),
        isTrue,
      );
      expect(
        avecDiplome.satisfait(
          p({
            'compte': {'type': 'medecin', 'specialite': 'pharmacie'},
            'min': 2,
          }),
        ),
        isFalse,
      );
      expect(
        avecDiplome.satisfait(
          p({
            'compte': {'type': 'medecin', 'specialite': 'chirurgie'},
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
      );
    });

    test('compte sans borne : au moins une carte ; max seul : minimum 0', () {
      final salle = {'type': 'salle', 'id': 'SAL-002'};
      expect(comb.satisfait(p({'compte': salle})), isTrue);
      expect(
        c(['MED-002', 'PAT-001', 'SAL-001']).satisfait(p({'compte': salle})),
        isFalse,
        reason: 'sans min ni max, la salle SAL-002 doit être présente',
      );
      final objet = {'type': 'objet'};
      expect(comb.satisfait(p({'compte': objet, 'max': 0})), isTrue);
      expect(comb.satisfait(p({'compte': objet, 'max': 1})), isTrue);
      expect(comb.satisfait(p({'compte': objet, 'min': 0})), isTrue);
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
                'specialite': ['psychologie', 'pharmacie'],
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
                'id': ['MED-002', 'MED-004'],
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
      final vrai = {'carte': 'MED-002'};
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

    test('traitements de l\'exemple : 2 chirurgiens au bloc pour '
        'l\'appendicite, pas un seul', () {
      final appendicite = jeu.maladies.first;
      expect(comb.satisfait(appendicite.traitement.adapte), isTrue);
      final seul = c(['MED-002', 'PAT-001', 'SAL-002']);
      expect(seul.satisfait(appendicite.traitement.adapte), isFalse);
      expect(seul.satisfait(appendicite.traitement.partiel!), isTrue);
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
        c(['MED-003', 'PAT-002', 'MED-002', 'SAL-002']).phrase(modele),
        'Examen de M. Dupont par la Dr Benali et le Dr Lefort dans le bloc '
        'opératoire.',
      );
    });

    test('première lettre en majuscule ; phrase vide', () {
      expect(
        c(['SAL-003', 'PAT-001']).phrase('{salle} accueille {patient}.'),
        'L\'unité de psychiatrie accueille Mme Garnier.',
      );
      expect(c(['PAT-001']).phrase(''), '');
    });
  });
}
