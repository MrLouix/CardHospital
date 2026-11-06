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
    expect(jeu.cartes.length, 18);
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

  test('paliers d\'aggravation absents, nuls ou non croissants : erreur', () {
    for (final paliers in [
      null,
      <int>[],
      [5, 0],
      [5, 5, 11],
    ]) {
      final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
      final parametres = copie['parametres'] as Map;
      if (paliers == null) {
        parametres.remove('paliers_aggravation');
      } else {
        parametres['paliers_aggravation'] = paliers;
      }
      final rapport = Validateur().validerJson(copie);
      expect(
        rapport.erreurs,
        contains(startsWith('parametres.paliers_aggravation')),
        reason: '$paliers',
      );
    }
  });

  test('une spécialité non déclarée est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[0]['specialite'] = 'cardiologie';
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

  test('combinaisons de traitement énumérées sans doublon de carte, '
      'laboratoire exclu', () {
    final combinaisons = Validateur.combinaisonsPossibles(Jeu.fromJson(brut));
    // 5 salles hors laboratoire. 1 médecin : 5 × 5 × (1 + 5 accessoires) ;
    // 2 médecins : 10 paires × 5.
    expect(combinaisons, hasLength(5 * 5 * 6 + 10 * 5));
    for (final c in combinaisons) {
      expect(c.ids.toSet(), hasLength(c.ids.length));
      expect(c.ids, isNot(contains('SAL-011')));
    }
  });

  test('un traitement réalisable seulement au laboratoire est refusé', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    ((copie['maladies'] as List)[2]['traitement'] as Map)['adapte'] = {
      'carte': 'SAL-011',
    };
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('Angine bactérienne')));
  });

  test('traitement toujours vrai ou sans échec possible : avertissement', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    final maladies = copie['maladies'] as List;
    (maladies[2]['traitement'] as Map)['adapte'] = {
      'compte': {'type': 'medecin'},
      'max': 5,
    };
    (maladies[3]['traitement'] as Map)['partiel'] = {
      'non': {'carte': 'SAL-011'},
    };
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.valide, isTrue);
    expect(
      rapport.avertissements,
      containsAll([
        startsWith('maladies[2].traitement.adapte : toutes les combinaisons'),
        startsWith(
          'maladies[3].traitement : aucune combinaison ne mène à un '
          'échec',
        ),
      ]),
    );
  });

  test('valeurs réservées : polyvalent, generaliste, recherche', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[0]['specialite'] = 'polyvalent';
    (copie['cartes'] as Map)['OBJ-001']['specialite'] = 'recherche';
    (copie['specialites'] as List).add({
      'id': 'recherche',
      'nom': 'Recherche',
      'couleur': '#000000',
      'icone': '🔬',
    });
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(
      rapport.erreurs,
      contains(startsWith('specialites[3].id : « recherche » est une valeur')),
    );

    final copie2 = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie2['maladies'] as List)[0]['specialite'] = 'polyvalent';
    (copie2['cartes'] as Map)['OBJ-001']['specialite'] = 'recherche';
    final rapport2 = Validateur().validerJson(
      copie2,
      jeu: Jeu.fromJson(copie2),
    );
    expect(
      rapport2.erreurs,
      containsAll([
        startsWith('maladies[0].specialite : « polyvalent » est une valeur'),
        startsWith(
          'cartes.OBJ-001.specialite : « recherche » est réservée '
          'aux salles',
        ),
      ]),
    );
  });

  test('« generaliste » est accepté, avec un avertissement', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['cartes'] as Map)['MED-001']['specialite'] = 'generaliste';
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.valide, isTrue);
    expect(
      rapport.avertissements,
      contains(startsWith('cartes.MED-001.specialite : « generaliste »')),
    );
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
      'compte': {'type': 'medecin', 'specialite': 'orthopedie'},
      'min': 3,
    };
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('Fracture ouverte')));
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
            'specialite': ['orthopedie'],
          },
          'min': 2,
        },
        {'carte': 'SAL-006'},
      ],
    });
    expect(relu['maladies'][0]['specialite'], 'orthopedie');
    expect(relu['actions'][2]['effets'][1]['condition'], 'traitement_adapte');
  });

  test('un identifiant en double est refusé', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[1]['id'] = 'fracture_ouverte';
    (copie['actions'] as List)[2]['id'] = 'diagnostiquer';
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(
      rapport.erreurs,
      containsAll([
        'maladies[1].id : l\'identifiant « fracture_ouverte » est déjà utilisé',
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
        startsWith('specialites[1].couleur : même couleur que « generale »'),
        startsWith('specialites[2].icone : même icone que « generale »'),
      ]),
    );
  });

  test('l\'exemple est un sous-ensemble exact du paquet de base', () {
    final base = jsonDecode(
      File('../../contenu/paquet_base.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    for (final cle in ['parametres', 'difficultes', 'capacites', 'motifs']) {
      expect(jsonEncode(brut[cle]), jsonEncode(base[cle]), reason: cle);
    }
    expect(jsonEncode(brut['actions']), jsonEncode(base['actions']));
    final cartes = base['cartes'] as Map<String, dynamic>;
    (brut['cartes'] as Map<String, dynamic>).forEach((id, carte) {
      expect(jsonEncode(carte), jsonEncode(cartes[id]), reason: id);
    });
    final maladies = {
      for (final m in base['maladies'] as List) (m as Map)['id']: m,
    };
    for (final m in brut['maladies'] as List) {
      expect(jsonEncode(m), jsonEncode(maladies[(m as Map)['id']]));
    }
    final specialites = {
      for (final s in base['specialites'] as List) (s as Map)['id']: s,
    };
    for (final s in brut['specialites'] as List) {
      expect(jsonEncode(s), jsonEncode(specialites[(s as Map)['id']]));
    }
  });

  test('l\'exemple porte une couleur et une icône par spécialité', () {
    final jeu = Jeu.fromJson(brut);
    expect(
      {for (final s in jeu.specialites) s.id: (s.couleur, s.icone)},
      {
        'generale': ('#1565C0', '🩺'),
        'psychiatrie': ('#7B4FBF', '🧠'),
        'orthopedie': ('#EF6C00', '🦴'),
      },
    );
    expect(jeu.parametres.diagnostic.tailleListe, 5);
    expect(jeu.parametres.diagnostic.scoreBruit, 50);
  });
}
