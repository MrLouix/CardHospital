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
    for (final s in ['hasard', 'seuil:60', 'specialite']) Strategie.depuis(s),
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
      [Strategie.depuis('hasard'), Strategie.depuis('specialite')],
      difficultes: ['interne'],
    );
    expect(avec.resultats.first.toJson(), seule.resultats.first.toJson());
  });

  test('comptes cohérents pour chaque stratégie et chaque niveau', () {
    final rapport = Simulateur(jeu, parametres: petit).simuler(strategies());
    expect(rapport.resultats, hasLength(3 * 3));
    for (final r in rapport.resultats) {
      expect(r.patients, 40 * 5);
      expect(r.soignes + r.morts + r.abandons, r.patients);
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
    expect(taux['specialite'], greaterThan(hasard + 0.3));
  });

  test('abandon au-delà du nombre maximal d\'actions', () {
    // Aucune aggravation et un traitement inadapté sans perte : le hasard
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
    expect(Strategie.depuis('specialite').nom, 'specialite');
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

    test('combinaisons hors patient et traitements adaptés', () {
      expect(catalogue.length, 90);
      for (final cartes in catalogue.cartes) {
        expect(cartes.any((id) => id.startsWith('PAT')), isFalse);
      }
      final appendicite = catalogue.adaptees('appendicite');
      expect(appendicite, isNotEmpty);
      for (final i in appendicite) {
        expect(
          catalogue.cartes[i],
          containsAll(['MED-002', 'MED-003', 'SAL-002']),
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
          4,
          reason: 'Dr Moreau + salle + traité',
        );
      }
      for (final i in catalogue.meilleursDiagnostics({'psychologie'})) {
        final c = Combinaison(jeu, catalogue.cartes[i]);
        expect(c.specialites, {'psychologie'});
      }
      expect(
        catalogue.meilleursDiagnostics({'astrologie'}),
        hasLength(catalogue.length),
        reason: 'aucune combinaison : toutes proposées',
      );
    });
  });
}
