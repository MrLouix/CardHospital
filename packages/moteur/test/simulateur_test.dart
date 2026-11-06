import 'package:moteur_cardhospital/moteur.dart';
import 'package:moteur_cardhospital/simulateur.dart';
import 'package:test/test.dart';

import 'aide.dart';

void main() {
  final jeu = jeuExemple();
  const petit = ParametresSimulation(
    graine: 7,
    parties: 40,
    patientsParPartie: 5,
  );
  List<Strategie> strategies() => [
    for (final s in ['hasard', 'seuil:60', 'couleur:60']) Strategie.depuis(s),
  ];

  test('rapport reproductible : même graine, même rapport', () {
    final a = Simulateur(jeu, parametres: petit).simuler(strategies());
    final b = Simulateur(jeu, parametres: petit).simuler(strategies());
    expect(b.enJson(), a.enJson());
    expect(b.enMarkdown(), a.enMarkdown());
  });

  test('une autre graine donne un autre rapport', () {
    final a = Simulateur(jeu, parametres: petit).simuler(strategies());
    final b = Simulateur(
      jeu,
      parametres: const ParametresSimulation(
        graine: 8,
        parties: 40,
        patientsParPartie: 5,
      ),
    ).simuler(strategies());
    expect(b.enJson(), isNot(a.enJson()));
  });

  test('ajouter une stratégie ne change pas les résultats des autres', () {
    final seule = Simulateur(
      jeu,
      parametres: petit,
    ).simuler([Strategie.depuis('hasard')], difficultes: ['interne']);
    final avec = Simulateur(jeu, parametres: petit).simuler(
      [Strategie.depuis('hasard'), Strategie.depuis('couleur:60')],
      difficultes: ['interne'],
    );
    expect(avec.resultats.first.toJson(), seule.resultats.first.toJson());
  });

  test('comptes cohérents pour chaque stratégie et chaque niveau', () {
    final rapport = Simulateur(jeu, parametres: petit).simuler(strategies());
    expect(rapport.resultats, hasLength(3 * 3));
    for (final r in rapport.resultats) {
      expect(r.patients, 40 * 5);
      expect(r.gueris + r.morts + r.abandons, r.patients);
      expect(r.reputationFinale, hasLength(40));
      expect(r.reputationMin, hasLength(40));
      for (var i = 0; i < 40; i++) {
        expect(r.reputationMin[i], lessThanOrEqualTo(0));
        expect(r.reputationMin[i], lessThanOrEqualTo(r.reputationFinale[i]));
      }
      final parMaladie = r.parMaladie.values;
      expect(parMaladie.fold<int>(0, (s, m) => s + m.patients), r.patients);
      expect(parMaladie.fold<int>(0, (s, m) => s + m.actions), r.actions);
    }
  });

  test('les stratégies informées soignent mieux que le hasard', () {
    final rapport = Simulateur(
      jeu,
      parametres: const ParametresSimulation(graine: 3, parties: 100),
    ).simuler(strategies(), difficultes: ['interne']);
    final taux = {
      for (final r in rapport.resultats) r.strategie: r.tauxGuerison,
    };
    final hasard = taux['hasard']!;
    expect(taux['seuil:60'], greaterThan(hasard + 0.3));
    expect(taux['couleur:60'], greaterThan(hasard + 0.3));
  });

  test('plus de patients en jeu, horloge plus rapide : plus de morts', () {
    double morts(int enJeu) {
      final r = Simulateur(
        jeu,
        parametres: ParametresSimulation(
          graine: 3,
          parties: 200,
          patientsEnJeu: enJeu,
        ),
      ).simuler([Strategie.depuis('hasard')], difficultes: ['reanimation']);
      return r.resultats.single.tauxMort;
    }

    expect(morts(2), greaterThan(morts(1)));
  });

  group('plusieurs joueurs', () {
    final rapport = Simulateur(
      jeu,
      parametres: const ParametresSimulation(
        graine: 5,
        parties: 60,
        joueurs: 3,
        partages: [true, false],
      ),
    ).simuler([Strategie.depuis('seuil:60')], difficultes: ['interne']);

    test('un résultat par mode, comptes cohérents', () {
      expect(rapport.resultats.map((r) => r.strategie), [
        'seuil:60 · partage',
        'seuil:60 · privé',
      ]);
      for (final r in rapport.resultats) {
        expect(r.gueris + r.morts + r.abandons, r.patients);
        expect(r.ecartsPieces, hasLength(60));
        expect(r.toJson()['partage'], r.partage);
      }
    });

    test('partager permet à un autre joueur de soigner ; en privé, seul '
        'celui qui a diagnostiqué soigne', () {
      final partage = rapport.resultats.first;
      final prive = rapport.resultats.last;
      expect(partage.guerisonsParAutrui, greaterThan(0));
      expect(prive.guerisonsParAutrui, 0);
    });

    test('rapport Markdown : section « Joueurs »', () {
      final md = rapport.enMarkdown();
      expect(md, contains('## Joueurs'));
      expect(md, contains('3 joueurs à tour de rôle'));
      expect(md, contains('| privées |'));
    });
  });

  group('stratégie novice', () {
    final catalogue = CatalogueCombinaisons(jeu);
    ResultatAction diagnostic(String id, String specialite, int indice) =>
        ResultatAction(
          numero: 2,
          action: actionDiagnostiquer,
          libelle: 'Diagnostiquer',
          phrase: '',
          cartes: const [],
          patient: 'PAT-001',
          patientNom: 'Mme Garnier',
          pvAvant: 15,
          pvApres: 15,
          presence: 1,
          attenteDepassee: false,
          issue: IssuePatient.enJeu,
          pieces: 1,
          reputation: 0,
          diagnostic: ResultatDiagnostic(
            niveau: 4,
            maladies: [
              LigneDiagnostic(
                id: id,
                nom: id,
                indice: indice,
                specialite: SpecialiteAffichee.depuis(
                  jeu.specialites.firstWhere((s) => s.id == specialite),
                ),
              ),
              LigneDiagnostic(
                id: 'angine_bacterienne',
                nom: 'Angine bactérienne',
                indice: 40,
                specialite: SpecialiteAffichee.depuis(
                  jeu.specialites.firstWhere((s) => s.id == 'generale'),
                ),
              ),
            ],
          ),
        );
    ResultatAction guerison(List<String> cartes, String maladie) =>
        ResultatAction(
          numero: 3,
          action: actionTraiter,
          libelle: 'Traiter',
          phrase: '',
          cartes: ['PAT-001', ...cartes],
          patient: 'PAT-001',
          patientNom: 'Mme Garnier',
          pvAvant: 15,
          pvApres: 15,
          presence: 2,
          attenteDepassee: false,
          issue: IssuePatient.gueri,
          pieces: 5,
          reputation: 2,
          maladieRevelee: MaladieRevelee(id: maladie, nom: maladie),
        );
    final net = diagnostic('fracture_ouverte', 'orthopedie', 95);

    test('description et nom', () {
      expect(Strategie.depuis('novice:70').nom, 'novice:70');
      expect(() => Strategie.depuis('novice'), throwsFormatException);
    });

    test('carnet : une guérison révèle la recette, par maladie et par '
        'spécialité ; le reste est ignoré', () {
      final carnet = Carnet(catalogue);
      final recette = ['MED-007', 'MED-008', 'SAL-006'];
      carnet.noter(net);
      expect(carnet.recettes, 0);
      carnet.noter(guerison(recette, 'fracture_ouverte'));
      final i = catalogue.indice(recette)!;
      expect(carnet.recette('fracture_ouverte'), i);
      expect(carnet.recettesDe('orthopedie'), [i]);
      expect(carnet.recettesDe('psychiatrie'), isEmpty);
    });

    test('sans recette connue, il essaie la combinaison la plus assortie à '
        'la couleur, deux fois, puis passe à autre chose', () {
      final s = StrategieNovice(80, carnet: Carnet(catalogue))..debutPatient();
      expect(s.pret([net], catalogue), isTrue);
      final meilleur = catalogue
          .thematiques('orthopedie')
          .map((p) => p.$2)
          .reduce((a, b) => a > b ? a : b);
      final essais = <List<String>>[];
      for (var k = 0; k < 2; k++) {
        final choix = s.choisir([net], catalogue, Alea(k));
        expect(choix.action, actionTraiter);
        final orthopedie = choix.cartes
            .where((id) => jeu.cartes[id]!.specialite == 'orthopedie')
            .length;
        expect(orthopedie, meilleur);
        essais.add(choix.cartes);
      }
      expect(essais[0], isNot(essais[1]), reason: 'pas deux fois la même');
      expect(s.pret([net], catalogue), isFalse);
      expect(
        s.choisir([net], catalogue, Alea(3)).action,
        actionDiagnostiquer,
        reason: 'fracture écartée, l\'angine est sous le seuil',
      );
    });

    test('il essaie d\'abord la recette notée dans son carnet', () {
      final carnet = Carnet(
        catalogue,
      )..noter(guerison(['MED-007', 'MED-008', 'SAL-006'], 'fracture_ouverte'));
      final s = StrategieNovice(80).nouvelle(carnet: carnet)..debutPatient();
      expect(
        s.choisir([net], catalogue, Alea(1)).cartes,
        containsAll(['MED-007', 'MED-008', 'SAL-006']),
      );
    });

    test('le novice soigne moins que le vétéran', () {
      final rapport =
          Simulateur(
            jeu,
            parametres: const ParametresSimulation(graine: 3, parties: 100),
          ).simuler(
            [Strategie.depuis('seuil:70'), Strategie.depuis('novice:70')],
            difficultes: ['interne'],
          );
      final taux = [for (final r in rapport.resultats) r.tauxGuerison];
      expect(taux[1], lessThan(taux[0]));
    });
  });

  test('stratégies : une instance neuve par patient', () {
    for (final s in ['hasard', 'seuil:60', 'couleur:70', 'novice:70']) {
      final strategie = Strategie.depuis(s);
      final copie = strategie.nouvelle();
      expect(copie.nom, strategie.nom);
      expect(identical(copie, strategie), isFalse);
    }
  });

  test('abandon au-delà du nombre maximal d\'actions', () {
    // Aucune aggravation et un échec de traitement sans perte : le hasard
    // ne tue jamais, il finit par abandonner ou par soigner.
    final immortel = jeuExemple((brut) {
      for (final m in brut['maladies'] as List) {
        (m as Map)['aggravation'] = [0];
      }
      (brut['parametres'] as Map)['recompenses']['pv_echec'] = 0;
    });
    final rapport = Simulateur(
      immortel,
      parametres: const ParametresSimulation(
        graine: 1,
        parties: 20,
        patientsParPartie: 3,
        actionsMax: 2,
      ),
    ).simuler([Strategie.depuis('seuil:100')], difficultes: ['interne']);
    final r = rapport.resultats.single;
    expect(r.morts, 0);
    expect(r.abandons, greaterThan(0));
    expect(r.actions, lessThanOrEqualTo(r.patients * 2));
  });

  test('rapport Markdown : sections et une ligne par maladie', () {
    final md = Simulateur(
      jeu,
      parametres: petit,
    ).simuler(strategies()).enMarkdown();
    expect(md, contains('# Rapport de simulation'));
    expect(md, contains('## Synthèse'));
    expect(md, contains('## Réputation sur une partie'));
    expect(md, contains('## Par maladie'));
    for (final m in jeu.maladies) {
      expect(md, contains('| ${m.nom} |'));
    }
  });

  test('stratégies : description analysée, erreurs explicites', () {
    expect(Strategie.depuis('hasard').nom, 'hasard');
    expect(Strategie.depuis('seuil:65').nom, 'seuil:65');
    expect(Strategie.depuis('couleur:80').nom, 'couleur:80');
    expect(() => Strategie.depuis('couleur'), throwsFormatException);
    expect(() => Strategie.depuis('specialite'), throwsFormatException);
    expect(() => Strategie.depuis('seuil'), throwsFormatException);
    expect(() => Strategie.depuis('seuil:120'), throwsFormatException);
    expect(() => Strategie.depuis('magie'), throwsFormatException);
  });

  test('paquet sans action « traiter » refusé', () {
    final sansTraiter = jeuExemple(
      (brut) => (brut['actions'] as List).removeAt(2),
    );
    expect(() => Simulateur(sansTraiter), throwsArgumentError);
  });

  test('paquet sans carte patient refusé', () {
    final sansPatient = jeuExemple(
      (brut) => (brut['cartes'] as Map).removeWhere(
        (id, _) => (id as String).startsWith('PAT'),
      ),
    );
    expect(() => Simulateur(sansPatient), throwsArgumentError);
  });

  group('catalogue de combinaisons', () {
    final catalogue = CatalogueCombinaisons(jeu);

    test('combinaisons hors patient, hors laboratoire, et traitements '
        'adaptés', () {
      expect(catalogue.length, 720);
      for (final cartes in catalogue.cartes) {
        expect(cartes.any((id) => id.startsWith('PAT')), isFalse);
        expect(cartes, isNot(contains('SAL-011')));
      }
      final fracture = catalogue.adaptees('fracture_ouverte');
      expect(fracture, isNotEmpty);
      for (final i in fracture) {
        final c = Combinaison(jeu, catalogue.cartes[i]);
        expect(c.ids, contains('SAL-006'));
        expect(c.medecins, hasLength(2), reason: 'deux vrais médecins');
      }
      expect(catalogue.adaptees('inconnue'), isEmpty);
    });

    test('meilleurs diagnostics : précision maximale, spécialités exactes', () {
      for (final i in catalogue.meilleursDiagnostics(const {})) {
        final c = Combinaison(jeu, catalogue.cartes[i]);
        expect(c.specialites, isEmpty);
        expect(
          c.capacite('precision'),
          greaterThanOrEqualTo(4),
          reason: 'Dr Moreau + radiologie, au plafond precision_max = 4',
        );
      }
      for (final i in catalogue.meilleursDiagnostics({'psychiatrie'})) {
        final c = Combinaison(jeu, catalogue.cartes[i]);
        expect(c.specialites, {'psychiatrie'});
      }
      expect(
        catalogue.meilleursDiagnostics({'astrologie'}),
        hasLength(catalogue.length),
        reason: 'aucune combinaison : toutes proposées',
      );
    });
  });

  group('stratégies informées', () {
    final catalogue = CatalogueCombinaisons(jeu);
    ResultatAction diagnostic(List<(String, String, int)> lignes) =>
        ResultatAction(
          numero: 2,
          action: actionDiagnostiquer,
          libelle: 'Diagnostiquer',
          phrase: '',
          cartes: const [],
          patient: 'PAT-001',
          patientNom: 'Mme Garnier',
          pvAvant: 10,
          pvApres: 9,
          presence: 1,
          attenteDepassee: false,
          issue: IssuePatient.enJeu,
          pieces: 1,
          reputation: 0,
          diagnostic: ResultatDiagnostic(
            niveau: 1,
            maladies: [
              for (final (id, specialite, indice) in lignes)
                LigneDiagnostic(
                  id: id,
                  nom: id,
                  indice: indice,
                  specialite: SpecialiteAffichee.depuis(
                    jeu.specialites.firstWhere((s) => s.id == specialite),
                  ),
                ),
            ],
          ),
        );

    final flou = diagnostic([
      ('angine_bacterienne', 'generale', 60),
      ('fracture_ouverte', 'orthopedie', 55),
      ('fracture_fermee', 'orthopedie', 52),
      ('phobie_des_blouses_blanches', 'psychiatrie', 50),
      ('entorse_de_la_cheville', 'orthopedie', 30),
    ]);
    final net = diagnostic([
      ('fracture_ouverte', 'orthopedie', 95),
      ('angine_bacterienne', 'generale', 50),
      ('fracture_fermee', 'orthopedie', 45),
      ('phobie_des_blouses_blanches', 'psychiatrie', 40),
      ('maux_de_tete', 'generale', 30),
    ]);

    test('seuil : traite la tête si elle atteint le seuil, sinon diagnostique '
        'sans spécialité', () {
      final s = StrategieSeuil(80)..debutPatient();
      final premier = s.choisir([], catalogue, Alea(1));
      expect(premier.action, actionDiagnostiquer);
      expect(Combinaison(jeu, premier.cartes).specialites, isEmpty);
      expect(s.choisir([flou], catalogue, Alea(1)).action, actionDiagnostiquer);
      final traiter = s.choisir([net], catalogue, Alea(1));
      expect(traiter.action, actionTraiter);
      expect(
        Combinaison(
          jeu,
          traiter.cartes,
        ).satisfait(jeu.maladies.first.traitement.adapte),
        isTrue,
        reason: 'combinaison adaptée à la fracture ouverte',
      );
      expect(
        s.choisir([net], catalogue, Alea(1)).action,
        actionDiagnostiquer,
        reason: 'fracture déjà essayée, la suivante est sous le seuil',
      );
    });

    test('couleur : diagnostique avec la spécialité dominante', () {
      expect(
        flou.diagnostic!.specialiteDominante,
        'orthopedie',
        reason: '3 lignes sur 5',
      );
      final s = StrategieCouleur(80)..debutPatient();
      final premier = s.choisir([], catalogue, Alea(1));
      expect(Combinaison(jeu, premier.cartes).specialites, isEmpty);
      final suivant = s.choisir([flou], catalogue, Alea(1));
      expect(suivant.action, actionDiagnostiquer);
      expect(Combinaison(jeu, suivant.cartes).specialites, {'orthopedie'});
    });
  });
}
