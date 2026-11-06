import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

/// Rédaction des recettes révélées par le laboratoire (MODELE_DE_JEU.md
/// §12.3).
void main() {
  final base = RedacteurRecette(jeuBase());
  final exemple = RedacteurRecette(jeuExemple());
  String recette(RedacteurRecette r, Map<String, dynamic> json) =>
      r.decrire(Predicat.fromJson(json));
  Maladie maladie(String id) =>
      jeuBase().maladies.firstWhere((m) => m.id == id);

  group('familles du paquet de base', () {
    String de(String id) => base.decrire(maladie(id).traitement.adapte);

    test('objet dans une salle, ou dans l\'une de deux salles', () {
      expect(
        de('rhume_carabine'),
        'Le sirop antitussif, dans la salle de consultation ou à la '
        'pharmacie.',
      );
      expect(
        de('burn_out'),
        'Un médecin de spécialité Psychiatrie (ou muni du diplôme de cette '
        'spécialité), dans la salle de psychiatrie.',
      );
    });

    test('deux médecins, dont un spécialiste', () {
      final id = jeuBase().maladies
          .firstWhere(
            (m) =>
                m.specialite == 'cardiologie' &&
                m.traitement.adapte.toJson().toString().contains('SAL-006'),
          )
          .id;
      expect(
        de(id),
        '2 médecins, dont un de spécialité Cardiologie (ou muni du diplôme '
        'de cette spécialité), au bloc opératoire.',
      );
    });

    test('deux spécialistes, dont un peut être un médecin diplômé', () {
      expect(
        de('fracture_ouverte'),
        '2 médecins de spécialité Orthopédie (l\'un d\'eux peut être '
        'remplacé par un médecin muni du diplôme de cette spécialité), au '
        'bloc opératoire.',
      );
    });

    test('exclusion d\'un type de carte', () {
      final id = jeuBase().maladies
          .firstWhere(
            (m) =>
                m.specialite == 'generale' &&
                m.traitement.adapte.toJson().toString().contains('non'),
          )
          .id;
      expect(
        de(id),
        'Un médecin de spécialité Médecine générale (ou muni du diplôme de '
        'cette spécialité), dans la salle de consultation, sans aucun '
        'objet.',
      );
    });
  });

  group('prédicats quelconques', () {
    test('carte seule, y compris une salle', () {
      expect(recette(exemple, {'carte': 'OBJ-010'}), 'L\'antibiotique.');
      expect(recette(exemple, {'carte': 'SAL-003'}), 'En radiologie.');
    });

    test('comptes : sans spécialité, plusieurs, bornes', () {
      expect(
        recette(exemple, {
          'compte': {'type': 'medecin'},
          'min': 2,
        }),
        '2 médecins.',
      );
      expect(
        recette(exemple, {
          'compte': {'type': 'salle'},
        }),
        'Une salle.',
      );
      expect(
        recette(exemple, {
          'compte': {
            'type': ['objet', 'diplome'],
          },
          'min': 1,
          'max': 1,
        }),
        'Exactement un accessoire.',
      );
      expect(
        recette(exemple, {
          'compte': {'type': 'medecin'},
          'max': 1,
        }),
        'Au plus un médecin.',
      );
      expect(
        recette(exemple, {
          'compte': {'type': 'medecin'},
          'min': 1,
          'max': 2,
        }),
        'De 1 à 2 médecins.',
      );
      expect(
        recette(exemple, {
          'compte': {
            'type': ['medecin', 'salle'],
          },
          'min': 3,
        }),
        '3 cartes.',
      );
      expect(recette(exemple, {'compte': <String, dynamic>{}}), 'Une carte.');
    });

    test('comptes : spécialités et identifiants', () {
      expect(
        recette(exemple, {
          'compte': {
            'type': 'salle',
            'specialite': ['generale', 'psychiatrie'],
          },
        }),
        'Une salle de spécialité Médecine générale ou Psychiatrie.',
      );
      expect(
        recette(exemple, {
          'compte': {'type': 'medecin', 'specialite': 'orthopedie'},
          'min': 2,
        }),
        '2 médecins de spécialité Orthopédie (l\'un d\'eux peut être '
        'remplacé par un médecin muni du diplôme de cette spécialité).',
      );
      expect(
        recette(exemple, {
          'compte': {
            'id': ['OBJ-001', 'OBJ-002'],
          },
        }),
        'Le stéthoscope ou le traité de médecine.',
      );
      expect(
        recette(exemple, {
          'compte': {
            'id': ['OBJ-001', 'OBJ-002', 'OBJ-005'],
          },
          'min': 2,
        }),
        '2 cartes parmi le stéthoscope, le traité de médecine et le plâtre.',
      );
      expect(
        recette(exemple, {
          'compte': {
            'type': 'objet',
            'id': ['OBJ-001', 'OBJ-002'],
          },
        }),
        'Un objet parmi le stéthoscope et le traité de médecine.',
      );
      expect(
        recette(exemple, {
          'compte': {
            'type': 'salle',
            'id': ['SAL-007', 'SAL-008'],
          },
        }),
        'À la pharmacie ou à la plâtrerie.',
      );
    });

    test('exclusions : non, au plus 0', () {
      expect(
        recette(exemple, {
          'tous': [
            {'carte': 'OBJ-005'},
            {
              'non': {'carte': 'MED-001'},
            },
            {
              'compte': {'type': 'salle'},
              'max': 0,
            },
            {
              'non': {
                'compte': {
                  'id': ['OBJ-001', 'OBJ-002'],
                },
              },
            },
          ],
        }),
        'Le plâtre, sans le Dr Moreau, sans aucune salle, sans le '
        'stéthoscope ni le traité de médecine.',
      );
      expect(
        recette(exemple, {
          'compte': {'type': 'objet'},
          'max': 0,
        }),
        'Sans aucun objet.',
      );
      expect(
        recette(exemple, {
          'non': {
            'compte': {'type': 'medecin'},
            'min': 2,
          },
        }),
        'Sans 2 médecins.',
      );
    });

    test('alternatives imbriquées', () {
      expect(
        recette(exemple, {
          'un_de': [
            {'carte': 'OBJ-010'},
            {
              'tous': [
                {'carte': 'OBJ-011'},
                {'carte': 'SAL-001'},
              ],
            },
          ],
        }),
        'L\'antibiotique ou (l\'antalgique, dans la salle de consultation).',
      );
      expect(
        recette(exemple, {
          'tous': [
            {
              'tous': [
                {'carte': 'OBJ-010'},
                {'carte': 'OBJ-011'},
              ],
            },
            {
              'un_de': [
                {'carte': 'MED-001'},
                {
                  'compte': {'type': 'objet'},
                  'max': 0,
                },
              ],
            },
          ],
        }),
        '(L\'antibiotique et l\'antalgique) et le Dr Moreau ou aucun objet.',
      );
    });

    test('plusieurs médecins sans spécialité fusionnée : listés à part', () {
      expect(
        recette(exemple, {
          'tous': [
            {
              'compte': {'type': 'medecin'},
              'min': 2,
            },
            {
              'compte': {'type': 'medecin', 'specialite': 'generale'},
            },
            {
              'compte': {'type': 'medecin', 'specialite': 'psychiatrie'},
            },
          ],
        }),
        '2 médecins, un médecin de spécialité Médecine générale (ou muni du '
        'diplôme de cette spécialité) et un médecin de spécialité '
        'Psychiatrie (ou muni du diplôme de cette spécialité).',
      );
    });
  });
}
