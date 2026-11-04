import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/modeles/jeu.dart';
import 'package:moteur_cardhospital/validation/validateur.dart';
import 'package:test/test.dart';

void main() {
  final fichier = File('../../docs/exemples/jeu.exemple.json');
  final brut = jsonDecode(fichier.readAsStringSync()) as Map<String, dynamic>;

  test('l\'exemple du dépôt se charge en modèles typés', () {
    final jeu = Jeu.fromJson(brut);
    expect(jeu.format, 'cardhospital');
    expect(jeu.schemaVersion, 1);
    expect(jeu.cartes.length, 14);
    expect(jeu.maladies.length, 6);
    expect(jeu.motifs.keys, containsAll(['admission', 'standard']));
    expect(
      jeu.actions.map((a) => a.id),
      containsAll(['admettre', 'diagnostiquer', 'traiter']),
    );
    expect(jeu.cartes['MED-001']!.type, TypeCarte.medecin);
    expect(
      jeu.maladies.first.traitement.adapte.toJson(),
      isA<Map<String, dynamic>>(),
    );
  });

  test('l\'exemple du dépôt passe la validation', () {
    final rapport = Validateur().validerJson(brut, jeu: Jeu.fromJson(brut));
    expect(rapport.erreurs, isEmpty, reason: rapport.erreurs.join('\n'));
    expect(rapport.valide, isTrue);
  });

  test('un poids nul est refusé avec un message explicite', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[0]['poids'] = 0;
    final rapport = Validateur().validerJson(copie);
    expect(rapport.valide, isFalse);
    expect(rapport.erreurs, contains(contains('poids d\'au moins 1')));
  });

  test('une spécialité non déclarée est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[0]['type'] = 'cardiologie';
    final rapport = Validateur().validerJson(copie);
    expect(rapport.erreurs, contains(contains('cardiologie')));
  });

  test('une référence de carte inconnue est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    ((copie['maladies'] as List)[2]['traitement'] as Map)['adapte'] = {
      'carte': 'OBJ-999',
    };
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('OBJ-999')));
  });

  test('une variable de phrase incompatible avec le motif est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['actions'] as List)[0]['phrase'] =
        'Admission de {patient} dans {salle}.';
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('{salle}')));
  });

  test('une spécialité sans maladie est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['specialites'] as List).add({
      'id': 'dermatologie',
      'nom': 'Dermatologie',
      'couleur': '#F9A825',
      'icone': '🧴',
    });
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('dermatologie')));
  });

  test('combinaisons standard énumérées sans doublon de carte', () {
    final combinaisons = Validateur.combinaisonsPossibles(Jeu.fromJson(brut));
    // 1 médecin : 4 × 3 salles × (1 + 5 accessoires) ; 2 médecins : 6 × 3.
    expect(combinaisons, hasLength(4 * 3 * 6 + 6 * 3));
    for (final c in combinaisons) {
      expect(c.ids.toSet(), hasLength(c.ids.length));
    }
  });

  test('un traitement adapté irréalisable est refusé', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    // Deux accessoires à la fois : impossible dans une combinaison standard.
    ((copie['maladies'] as List)[2]['traitement'] as Map)['adapte'] = {
      'tous': [
        {'carte': 'OBJ-010'},
        {'carte': 'OBJ-011'},
      ],
    };
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(
      rapport.erreurs,
      contains(
        allOf(
          contains('maladies[2].traitement.adapte'),
          contains('Angine bactérienne'),
        ),
      ),
    );
  });

  test('un traitement exigeant trop de médecins est refusé', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    ((copie['maladies'] as List)[0]['traitement'] as Map)['adapte'] = {
      'compte': {'type': 'medecin', 'specialite': 'chirurgie'},
      'min': 3,
    };
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('Appendicite')));
  });

  test('le modèle complet fait l\'aller-retour JSON sans perte', () {
    final une = jsonEncode(Jeu.fromJson(brut));
    final deux = jsonEncode(
      Jeu.fromJson(jsonDecode(une) as Map<String, dynamic>),
    );
    expect(deux, une);
    final relu = jsonDecode(une) as Map<String, dynamic>;
    expect(relu['maladies'][0]['traitement']['adapte'], {
      'tous': [
        {
          'compte': {
            'type': ['medecin'],
            'specialite': ['chirurgie'],
          },
          'min': 2,
        },
        {
          'compte': {
            'type': ['salle'],
            'specialite': ['chirurgie'],
          },
          'min': 1,
        },
      ],
    });
    expect(relu['actions'][2]['effets'][1]['condition'], 'traitement_adapte');
  });

  test('un identifiant en double est refusé', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[1]['id'] = 'appendicite';
    (copie['actions'] as List)[2]['id'] = 'diagnostiquer';
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(
      rapport.erreurs,
      containsAll([
        'maladies[1].id : l\'identifiant « appendicite » est déjà utilisé',
        'actions[2].id : l\'identifiant « diagnostiquer » est déjà utilisé',
      ]),
    );
  });

  test(
    'couleur et icône d\'une spécialité : absentes ou mal formées, erreur',
    () {
      final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
      final specialites = copie['specialites'] as List;
      (specialites[0] as Map).remove('couleur');
      (specialites[1] as Map)['couleur'] = 'rouge';
      (specialites[2] as Map)['icone'] = '';
      final rapport = Validateur().validerJson(copie);
      expect(rapport.valide, isFalse);
      expect(rapport.erreurs, contains(startsWith('specialites[0].couleur')));
      expect(rapport.erreurs, contains(startsWith('specialites[1].couleur')));
      expect(rapport.erreurs, contains(startsWith('specialites[2].icone')));
    },
  );

  test('couleur ou icône partagées par deux spécialités : avertissement', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    final specialites = copie['specialites'] as List;
    (specialites[1] as Map)['couleur'] = (specialites[0] as Map)['couleur']
        .toString()
        .toLowerCase();
    (specialites[2] as Map)['icone'] = (specialites[0] as Map)['icone'];
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.valide, isTrue);
    expect(
      rapport.avertissements,
      containsAll([
        startsWith('specialites[1].couleur : même couleur que « psychologie »'),
        startsWith('specialites[2].icone : même icone que « psychologie »'),
      ]),
    );
  });

  test('l\'exemple porte une couleur et une icône par spécialité', () {
    final jeu = Jeu.fromJson(brut);
    expect(
      {for (final s in jeu.specialites) s.id: (s.couleur, s.icone)},
      {
        'psychologie': ('#7B4FBF', '🧠'),
        'chirurgie': ('#C62828', '✂️'),
        'pharmacie': ('#2E7D32', '💊'),
      },
    );
    expect(jeu.parametres.diagnostic.tailleListe, 5);
    expect(jeu.parametres.diagnostic.scoreBruit, 50);
  });
}
