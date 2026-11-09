import 'dart:convert';

import 'package:moteur_cardhospital/simulateur.dart';
import 'package:test/test.dart';

import 'aide.dart';

void main() {
  final jeu = jeuBase();

  RapportVariantes simuler({
    List<Variante> variantes = Variante.catalogue,
    int joueurs = 3,
    bool novices = false,
    int parties = 4,
    int graine = 1,
    String? difficulte,
  }) => SimulateurVariantes(
    jeu,
    parametres: ParametresVariantes(
      graine: graine,
      parties: parties,
      joueurs: joueurs,
      novices: novices,
      difficulte: difficulte,
    ),
  ).simuler(variantes);

  void verifier(RapportVariantes rapport, {required int parties}) {
    for (final r in rapport.resultats) {
      final nom = '${r.variante.nom}, ${r.population.libelle}';
      expect(r.parties, parties, reason: nom);
      expect(r.patients, parties * 10, reason: nom);
      expect(r.gueris + r.morts + r.abandons, r.patients, reason: nom);
      expect(r.actions, greaterThanOrEqualTo(r.patients), reason: nom);
      expect(r.tours, greaterThanOrEqualTo(r.actions), reason: nom);
      expect(r.toursVides, lessThan(r.tours), reason: nom);
      expect(r.guerisonsSurParole, lessThanOrEqualTo(r.gueris), reason: nom);
      expect(r.mortsHeritees, lessThanOrEqualTo(r.morts), reason: nom);
      expect(r.fermees15, lessThanOrEqualTo(r.fermees10), reason: nom);
      expect(r.orphelins, lessThanOrEqualTo(r.patients), reason: nom);
      if (r.variante.recompense == Recompense.acteur) {
        expect(r.primes, 0, reason: nom);
      } else {
        expect(r.primes, lessThanOrEqualTo(r.gueris), reason: nom);
      }
      if (r.variante.circulation != Circulation.libre) {
        expect(r.engorgement, greaterThanOrEqualTo(1), reason: nom);
      }
    }
  }

  test('toutes les variantes, vétérans à 3 joueurs : comptes cohérents', () {
    final rapport = simuler();
    expect(
      rapport.resultats,
      hasLength(Variante.catalogue.length * Population.values.length),
    );
    verifier(rapport, parties: 4);
  });

  test('novices avec laboratoire, à 2 et à 4 joueurs', () {
    verifier(simuler(novices: true, parties: 3), parties: 3);
    verifier(simuler(joueurs: 2, parties: 3), parties: 3);
    verifier(simuler(joueurs: 4, novices: true, parties: 3), parties: 3);
  });

  test('même graine, même rapport ; autre graine, autre rapport', () {
    final variantes = [
      Variante.depuis('actuel'),
      Variante.depuis('releve+passeur'),
    ];
    final a = simuler(variantes: variantes).enJson();
    expect(simuler(variantes: variantes).enJson(), a);
    expect(simuler(variantes: variantes, graine: 2).enJson(), isNot(a));
  });

  test('la prime du passeur est versée, et la relève tient un patient par '
      'joueur', () {
    final rapport = simuler(
      variantes: [
        Variante.depuis('releve'),
        Variante.depuis('releve+passeur'),
        Variante.depuis('adressage+passeur'),
      ],
      parties: 20,
    );
    final releve = rapport.de(Variante.depuis('releve'), Population.partage);
    expect(releve.primes, 0);
    expect(releve.engorgement, 1);
    final prime = rapport.de(
      Variante.depuis('releve+passeur'),
      Population.partage,
    );
    expect(prime.primes, greaterThan(0));
    // Sans partage, personne ne soigne sur la parole d'un autre.
    final prive = rapport.de(
      Variante.depuis('releve+passeur'),
      Population.prive,
    );
    expect(prive.guerisonsSurParole, 0);
    expect(prime.guerisonsSurParole, greaterThan(0));
    // L'adressage concentre les patients chez certains joueurs.
    final adressage = rapport.de(
      Variante.depuis('adressage+passeur'),
      Population.partage,
    );
    expect(adressage.engorgement, greaterThan(1));
  });

  test('noms masqués au non-spécialiste : le jeu devient bien plus dur', () {
    final rapport = simuler(
      variantes: [Variante.depuis('actuel'), Variante.depuis('actuel+masque')],
      parties: 40,
    );
    final actuel = rapport.de(Variante.depuis('actuel'), Population.partage);
    final masque = rapport.de(
      Variante.depuis('actuel+masque'),
      Population.partage,
    );
    expect(masque.guerison, lessThan(actuel.guerison));
    expect(masque.partRedondants, greaterThan(actuel.partRedondants));
    expect(actuel.orphelins, greaterThan(0));
  });

  test('examen ciblé : le partage compte nettement plus', () {
    final rapport = simuler(
      variantes: [
        Variante.depuis('actuel'),
        Variante.depuis('actuel+examen-cible'),
      ],
      parties: 60,
    );
    expect(
      rapport.valeurCollective(Variante.depuis('actuel+examen-cible')),
      greaterThan(rapport.valeurCollective(Variante.depuis('actuel'))),
    );
  });

  test('rapport Markdown et JSON', () {
    final rapport = simuler(
      variantes: [Variante.depuis('actuel'), Variante.depuis('passe+passeur')],
      difficulte: 'reanimation',
    );
    final md = rapport.enMarkdown();
    expect(md, contains('# Variantes de partage'));
    expect(md, contains('niveau Réanimation'));
    for (final section in [
      '## Variantes',
      '## Le partage compte-t-il ?',
      '## Qui gagne quoi',
      '## Signaux de problème en jeu',
      '| `passe+passeur` |',
    ]) {
      expect(md, contains(section));
    }
    final json = jsonDecode(rapport.enJson()) as Map<String, dynamic>;
    expect(json['difficulte'], 'reanimation');
    expect(json['resultats'], hasLength(6));
    expect(
      (json['resultats'] as List).first,
      containsPair('population', 'partage'),
    );
    expect(json['parametres'], containsPair('joueurs', 3));
    expect(rapport.tentation(Variante.depuis('actuel')), isA<double>());
    expect(rapport.coutPourLesAutres(Variante.depuis('actuel')), isA<double>());
  });

  test('erreurs : variante, joueurs, difficulté, paquet', () {
    expect(() => Variante.depuis('inconnue'), throwsFormatException);
    expect(
      () => SimulateurVariantes(
        jeu,
        parametres: const ParametresVariantes(joueurs: 1),
      ),
      throwsArgumentError,
    );
    expect(
      () => SimulateurVariantes(
        jeu,
        parametres: const ParametresVariantes(joueurs: 11),
      ),
      throwsArgumentError,
    );
    expect(() => simuler(difficulte: 'inconnue'), throwsArgumentError);
    expect(
      const ParametresVariantes(difficulte: 'interne').toJson(),
      containsPair('difficulte', 'interne'),
    );
  });

  test('l\'exemple réduit se simule aussi', () {
    final rapport = SimulateurVariantes(
      jeuExemple(),
      parametres: const ParametresVariantes(parties: 5, novices: true),
    ).simuler(Variante.catalogue);
    for (final r in rapport.resultats) {
      expect(r.gueris + r.morts + r.abandons, r.patients);
    }
  });
}
