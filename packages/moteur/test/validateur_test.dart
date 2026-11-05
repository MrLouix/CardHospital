import 'package:moteur_cardhospital/moteur.dart';
import 'package:moteur_cardhospital/validation/schema.dart';
import 'package:test/test.dart';

import 'aide.dart';

/// Un test négatif par règle de validation de MOTEUR_EFFETS.md §7.
void main() {
  final validateur = Validateur();

  /// Erreurs de l'exemple modifié par [modifier].
  List<String> erreurs(
    void Function(Map<String, dynamic> brut) modifier, {
    Map<String, TypeCarte>? catalogue,
  }) {
    final brut = copieExemple();
    modifier(brut);
    return validateur.validerJson(brut, catalogue: catalogue).erreurs;
  }

  Map<String, dynamic> maladie(Map<String, dynamic> b, int i) =>
      (b['maladies'] as List)[i] as Map<String, dynamic>;
  Map<String, dynamic> carte(Map<String, dynamic> b, String id) =>
      (b['cartes'] as Map)[id] as Map<String, dynamic>;
  List<dynamic> effets(Map<String, dynamic> b, int action) =>
      ((b['actions'] as List)[action] as Map)['effets'] as List;

  test('l\'exemple du dépôt est valide, catalogue compris', () {
    final brut = copieExemple();
    final rapport = validateur.validerJson(
      brut,
      catalogue: Validateur.catalogueDe(Jeu.fromJson(brut)),
    );
    expect(rapport.erreurs, isEmpty, reason: rapport.erreurs.join('\n'));
  });

  group('règle 1 : conformité au JSON Schema', () {
    test('champ obligatoire absent, sans doublon', () {
      final e = erreurs((b) => b.remove('parametres'));
      expect(e, ['parametres : champ obligatoire absent']);
    });

    test('champ obligatoire absent dans un objet imbriqué', () {
      expect(
        erreurs((b) => maladie(b, 1).remove('aggravation')),
        contains('maladies[1].aggravation : champ obligatoire absent'),
      );
    });

    test('type', () {
      expect(
        erreurs((b) => maladie(b, 0)['pv_initial'] = 'dix'),
        contains('maladies[0].pv_initial : type attendu : entier'),
      );
    });

    test('valeur trop petite ou trop grande', () {
      expect(
        erreurs((b) => maladie(b, 0)['pv_initial'] = 0),
        contains('maladies[0].pv_initial : valeur trop petite (0, minimum 1)'),
      );
      expect(
        erreurs(
          (b) => (b['parametres'] as Map)['diagnostic']['score_bruit'] = 100,
        ),
        contains(
          'parametres.diagnostic.score_bruit : valeur trop grande (100, '
          'maximum 99)',
        ),
      );
    });

    test('strictement positif', () {
      expect(
        erreurs(
          (b) =>
              ((b['difficultes'] as List)[0]
                      as Map)['modificateurs']['pieces'] =
                  0,
        ),
        contains(
          'difficultes[0].modificateurs.pieces : doit être strictement '
          'supérieur à 0 (0)',
        ),
      );
    });

    test('formats : identifiant, identifiant de carte, couleur, version', () {
      expect(
        erreurs((b) => maladie(b, 0)['id'] = 'Appendicite'),
        contains(startsWith('maladies[0].id : identifiant en minuscules')),
      );
      expect(
        erreurs(
          (b) =>
              (b['cartes'] as Map)['med-9'] = {'type': 'medecin', 'nom': 'X'},
        ),
        contains(startsWith('cartes.med-9 : identifiant de carte au format')),
      );
      expect(
        erreurs(
          (b) => ((b['specialites'] as List)[0] as Map)['couleur'] = 'violet',
        ),
        contains(
          'specialites[0].couleur : couleur au format #RRGGBB attendue '
          '(« violet »)',
        ),
      );
      expect(
        erreurs((b) => b['version'] = '1.0'),
        contains(startsWith('version : version au format MAJEUR.MINEUR')),
      );
      expect(
        erreurs((b) => (b['motifs'] as Map)['standard']['infirmier'] = [0, 1]),
        contains(startsWith('motifs.standard.infirmier : clé de motif')),
      );
    });

    test('champ inconnu', () {
      expect(
        erreurs((b) => maladie(b, 0)['couleur'] = '#000000'),
        contains('maladies[0].couleur : champ inconnu'),
      );
    });

    test('valeur hors liste : type de carte, format', () {
      expect(
        erreurs((b) => carte(b, 'MED-001')['type'] = 'infirmier'),
        contains(
          startsWith('cartes.MED-001.type : type de carte « infirmier »'),
        ),
      );
      expect(
        erreurs((b) => b['format'] = 'autre'),
        contains('format : doit valoir « cardhospital »'),
      );
    });

    test('nombre d\'éléments : difficultés, aggravation, cartes', () {
      expect(
        erreurs((b) => (b['difficultes'] as List).removeLast()),
        contains('difficultes : exactement 3 niveaux requis (2 trouvé(s))'),
      );
      expect(
        erreurs((b) => maladie(b, 0)['aggravation'] = <int>[]),
        contains(
          'maladies[0].aggravation : au moins 1 élément(s) requis (0 '
          'trouvé(s))',
        ),
      );
      expect(
        erreurs((b) => b['cartes'] = <String, dynamic>{}),
        contains('cartes : au moins 1 entrée(s) requise(s)'),
      );
    });

    test('texte vide ou trop long', () {
      expect(
        erreurs((b) => maladie(b, 0)['nom'] = ''),
        contains('maladies[0].nom : texte vide'),
      );
      expect(
        erreurs(
          (b) => ((b['specialites'] as List)[0] as Map)['icone'] = 'ABCDEFGHI',
        ),
        contains(
          'specialites[0].icone : texte trop long (8 caractères au plus)',
        ),
      );
    });

    test('effet inconnu ou mal paramétré', () {
      expect(
        erreurs((b) => effets(b, 0)[0] = {'effet': 'voler'}),
        contains('actions[0].effets[0] : effet « voler » inconnu'),
      );
      expect(
        erreurs((b) => effets(b, 1)[2] = {'effet': 'payer'}),
        contains('actions[1].effets[2].valeur : champ obligatoire absent'),
      );
      expect(
        erreurs((b) => effets(b, 0)[0] = 'admettre'),
        contains(startsWith('actions[0].effets[0] : effet non reconnu')),
      );
    });

    test('condition, prédicat et valeur non reconnus', () {
      expect(
        erreurs(
          (b) => ((b['actions'] as List)[0] as Map)['precondition'] = 'malade',
        ),
        contains('actions[0].precondition : condition « malade » inconnue'),
      );
      expect(
        erreurs(
          (b) => ((b['actions'] as List)[0] as Map)['precondition'] = {
            'et': ['soigne'],
            'ou': ['soigne'],
          },
        ),
        contains('actions[0].precondition.ou : champ inconnu'),
      );
      expect(
        erreurs(
          (b) => (maladie(b, 2)['traitement'] as Map)['adapte'] = {
            'carte': 'OBJ-010',
            'min': 1,
          },
        ),
        contains('maladies[2].traitement.adapte.min : champ inconnu'),
      );
      expect(
        erreurs(
          (b) => (maladie(b, 2)['traitement'] as Map)['adapte'] = {
            'remede': 'OBJ-010',
          },
        ),
        contains(
          startsWith('maladies[2].traitement.adapte : prédicat non reconnu'),
        ),
      );
      expect(
        erreurs(
          (b) => effets(b, 1)[2] = {'effet': 'payer', 'valeur': r'$pieces'},
        ),
        contains(
          startsWith('actions[1].effets[2].valeur : valeur non reconnue'),
        ),
      );
    });

    test('filtre d\'un compte : valeur ou liste invalide', () {
      expect(
        erreurs(
          (b) => (maladie(b, 2)['traitement'] as Map)['partiel'] = {
            'compte': {'type': <String>[]},
            'min': 1,
          },
        ),
        contains(
          startsWith(
            'maladies[2].traitement.partiel.compte.type : valeur ou '
            'liste',
          ),
        ),
      );
    });

    test('patient avec spécialité ; spécialité « generaliste » déclarée', () {
      expect(
        erreurs((b) => carte(b, 'PAT-001')['specialite'] = 'chirurgie'),
        contains(
          'cartes.PAT-001 : un patient ne peut porter ni spécialité ni '
          'capacités',
        ),
      );
      expect(
        erreurs(
          (b) => ((b['specialites'] as List)[0] as Map)['id'] = 'generaliste',
        ),
        contains(
          'specialites[0].id : « generaliste » est réservé et ne peut pas '
          'être déclaré',
        ),
      );
    });

    test('chemins lisibles', () {
      expect(cheminLisible(''), '(racine)');
      expect(cheminLisible('/maladies/2/pv_initial'), 'maladies[2].pv_initial');
      expect(cheminLisible('/cartes/MED-001/type'), 'cartes.MED-001.type');
      expect(
        cheminLisible('/motifs/standard/objet|diplome'),
        'motifs.standard.objet|diplome',
      );
      expect(cheminLisible('/a~1b/c~0d'), 'a/b.c~d');
    });
  });

  group('règle 2 : version du format', () {
    test('paquet plus récent que l\'application', () {
      expect(erreurs((b) => b['schema_version'] = 2), [
        'schema_version : ce paquet nécessite une version plus récente de '
            'l\'application (version 2, version 1 au plus)',
      ]);
    });

    test('version antérieure à la première', () {
      expect(erreurs((b) => b['schema_version'] = 0), [
        'schema_version : version 0 non supportée (version 1 au moins)',
      ]);
    });
  });

  group('règle 3 : catalogue embarqué', () {
    final catalogue = Validateur.catalogueDe(jeuExemple());

    test('carte absente du catalogue', () {
      expect(
        erreurs(
          (b) => (b['cartes'] as Map)['MED-099'] = {
            'type': 'medecin',
            'nom': 'Dr Nouveau',
            'specialite': 'chirurgie',
          },
          catalogue: catalogue,
        ),
        [
          'cartes.MED-099 : carte absente du catalogue embarqué ; une '
              'extension ne peut pas ajouter de carte en v1',
        ],
      );
    });

    test('carte de type différent', () {
      expect(
        erreurs((b) {
          final c = carte(b, 'OBJ-001');
          c['type'] = 'diplome';
        }, catalogue: catalogue),
        contains(
          'cartes.OBJ-001.type : la carte est de type « objet » dans le '
          'catalogue embarqué, pas « diplome »',
        ),
      );
    });

    test('sans catalogue, la règle n\'est pas vérifiée', () {
      expect(
        erreurs(
          (b) => (b['cartes'] as Map)['MED-099'] = {
            'type': 'medecin',
            'nom': 'Dr Nouveau',
          },
        ),
        isEmpty,
      );
    });
  });

  group('règle 4 : références inconnues', () {
    test('spécialité d\'une maladie et d\'une carte', () {
      expect(
        erreurs((b) => maladie(b, 0)['type'] = 'cardiologie'),
        contains(contains('« cardiologie » n\'est pas déclarée')),
      );
      expect(
        erreurs((b) => carte(b, 'MED-002')['specialite'] = 'cardiologie'),
        contains(startsWith('cartes.MED-002.specialite : la spécialité')),
      );
    });

    test('capacité d\'une carte', () {
      expect(
        erreurs((b) => carte(b, 'MED-002')['capacites'] = {'charisme': 1}),
        contains(startsWith('cartes.MED-002.capacites.charisme')),
      );
    });

    test('carte d\'un prédicat, carte d\'un filtre', () {
      expect(
        erreurs(
          (b) => (maladie(b, 2)['traitement'] as Map)['adapte'] = {
            'carte': 'OBJ-999',
          },
        ),
        contains(contains('OBJ-999')),
      );
      expect(
        erreurs(
          (b) => (maladie(b, 2)['traitement'] as Map)['partiel'] = {
            'compte': {'id': 'OBJ-998'},
            'min': 1,
          },
        ),
        contains(contains('OBJ-998')),
      );
    });

    test('motif d\'une action', () {
      expect(
        erreurs((b) => ((b['actions'] as List)[0] as Map)['motif'] = 'urgence'),
        contains('actions[0].motif : le motif « urgence » n\'est pas déclaré'),
      );
    });

    test('références \$recompenses et \$capacite', () {
      expect(
        erreurs(
          (b) => effets(b, 1)[2] = {
            'effet': 'payer',
            'valeur': r'$recompenses.pourboire',
          },
        ),
        contains(contains(r'« $recompenses.pourboire »')),
      );
      expect(
        erreurs(
          (b) => effets(b, 1)[2] = {
            'effet': 'payer',
            'valeur': r'$capacite.charisme',
          },
        ),
        contains(contains('« charisme » n\'est pas déclarée')),
      );
    });
  });

  test('règle 5 : variable de phrase incompatible avec le motif', () {
    expect(
      erreurs(
        (b) => ((b['actions'] as List)[0] as Map)['phrase'] =
            'Admission de {patient} dans {salle}.',
      ),
      contains(contains('{salle}')),
    );
    expect(
      erreurs(
        (b) => ((b['actions'] as List)[0] as Map)['phrase'] = '{infirmier}.',
      ),
      contains('actions[0].phrase : variable inconnue « {infirmier} »'),
    );
  });

  test('règle 6 : spécialité-type sans aucune maladie', () {
    expect(
      erreurs(
        (b) => (b['specialites'] as List).add({
          'id': 'dermatologie',
          'nom': 'Dermatologie',
          'couleur': '#F9A825',
          'icone': '🧴',
        }),
      ),
      contains(
        'specialites : « dermatologie » n\'est le type d\'aucune maladie',
      ),
    );
  });

  test('règle 7 : traitement adapté irréalisable', () {
    expect(
      erreurs(
        (b) => (maladie(b, 0)['traitement'] as Map)['adapte'] = {
          'compte': {'type': 'salle'},
          'min': 2,
        },
      ),
      contains(
        startsWith('maladies[0].traitement.adapte : aucune combinaison'),
      ),
    );
  });

  test('règle 8 : identifiants en double', () {
    expect(
      erreurs((b) => maladie(b, 1)['id'] = 'appendicite'),
      contains(
        'maladies[1].id : l\'identifiant « appendicite » est déjà utilisé',
      ),
    );
  });

  test('règle 9 : poids inférieur à 1, message explicite', () {
    expect(erreurs((b) => maladie(b, 0)['poids'] = 0), [
      'maladies[0].poids : une maladie doit avoir un poids d\'au moins 1 ; '
          'pour l\'écarter, retirez-la du paquet',
    ]);
  });

  test('avertissements : sans traitement partiel, spécialité sans carte', () {
    final brut = copieExemple();
    for (final c in (brut['cartes'] as Map).values) {
      if ((c as Map)['specialite'] == 'psychologie') {
        c['specialite'] = 'generaliste';
      }
    }
    // Sans carte psychologie, les traitements psy deviennent irréalisables :
    // on les ramène à une carte précise.
    for (final m in brut['maladies'] as List) {
      if ((m as Map)['type'] == 'psychologie') {
        m['traitement'] = {
          'adapte': {'carte': 'SAL-003'},
        };
      }
    }
    final rapport = validateur.validerJson(brut);
    expect(rapport.valide, isTrue, reason: rapport.erreurs.join('\n'));
    expect(
      rapport.avertissements,
      containsAll([
        'specialites : « psychologie » n\'est portée par aucune carte',
        'maladies : « Fracture ouverte » n\'a pas de traitement partiel',
      ]),
    );
  });

  test('validateur construit depuis le texte du schéma', () {
    final v = Validateur.depuisSchema(validateur.schemaJson);
    expect(v.validerJson(copieExemple()).valide, isTrue);
  });
}
