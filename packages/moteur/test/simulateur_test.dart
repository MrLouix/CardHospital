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

  test('plus de patients en jeu, horloge plus rapide : moins de guérisons', () {
    double taux(int enJeu) =>
        Simulateur(
              jeu,
              parametres: ParametresSimulation(
                graine: 3,
                parties: 100,
                patientsEnJeu: enJeu,
              ),
            )
            .simuler([Strategie.depuis('seuil:60')], difficultes: ['interne'])
            .resultats
            .single
            .tauxGuerison;
    expect(taux(2), lessThan(taux(1)));
  });

  test('stratégies : une instance neuve par patient', () {
    for (final s in ['hasard', 'seuil:60', 'couleur:70']) {
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
      expect(catalogue.length, 200);
      for (final cartes in catalogue.cartes) {
        expect(cartes.any((id) => id.startsWith('PAT')), isFalse);
        expect(cartes, isNot(contains('SAL-011')));
      }
      final fracture = catalogue.adaptees('fracture_ouverte');
      expect(fracture, isNotEmpty);
      for (final i in fracture) {
        expect(
          catalogue.cartes[i],
          containsAll(['MED-007', 'MED-008', 'SAL-006']),
        );
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
