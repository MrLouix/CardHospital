import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

/// Parties aléatoires : sélections quelconques (valides ou non), confirmées,
/// annulées, sauvegardées et reprises. Le moteur ne doit jamais lever
/// d'exception, et ses invariants doivent tenir à chaque action.
void main() {
  final paquets = {
    'exemple': (jeuExemple(), exempleBrut),
    'paquet de base': (
      jeuBase(),
      File('../../contenu/paquet_base.json').readAsStringSync(),
    ),
  };

  for (final MapEntry(key: nom, value: (jeu, brut)) in paquets.entries) {
    for (final difficulte in jeu.difficultes) {
      test('$nom, ${difficulte.nom} : invariants sur des parties '
          'aléatoires', () {
        final ids = jeu.cartes.keys.toList();
        final patients = [
          for (final e in jeu.cartes.entries)
            if (e.value.type == TypeCarte.patient) e.key,
        ];
        final parType = <TypeCarte, List<String>>{};
        for (final e in jeu.cartes.entries) {
          parType.putIfAbsent(e.value.type, () => []).add(e.key);
        }
        final accessoires = [
          ...?parType[TypeCarte.objet],
          ...?parType[TypeCarte.diplome],
        ];
        final pvInitial = {for (final m in jeu.maladies) m.id: m.pvInitial};
        var appliquees = 0;
        var sorties = 0;
        for (var graine = 1; graine <= 40; graine++) {
          final hasard = Alea(graine);
          int tirer(int n) => (hasard.flottant() * n).floor();
          var partie = Partie.nouvelle(
            jeu: jeu,
            paquet: IdentitePaquet.depuis(jeu, brut),
            difficulte: difficulte.id,
            alea: Alea(1000 + graine),
          );
          for (var tour = 0; tour < 150; tour++) {
            // Sélection : le plus souvent bien formée (patient seul, ou
            // patient, médecins, salle, accessoire), sinon des cartes
            // quelconques ; parfois une carte inconnue ou un doublon.
            String une(List<String> cartes) => cartes[tirer(cartes.length)];
            final forme = tirer(10);
            final selection = <String>[
              if (forme < 2)
                une(patients)
              else if (forme < 8) ...[
                une(patients),
                une(parType[TypeCarte.medecin]!),
                if (tirer(4) == 0) une(parType[TypeCarte.medecin]!),
                une(parType[TypeCarte.salle]!),
                if (tirer(2) == 0) une(accessoires),
              ] else ...[
                if (tirer(10) > 0) une(patients),
                for (var i = tirer(6); i > 0; i--) une(ids),
              ],
              if (tirer(20) == 0) 'XXX-999',
            ];
            if (selection.isNotEmpty && tirer(15) == 0) {
              selection.add(selection.first);
            }
            final avant = jsonEncode(partie.etat.toJson());
            final reponse = partie.valider(selection);
            if (reponse is! SelectionAcceptee) {
              expect((reponse as SelectionRefusee).message, isNotEmpty);
              expect(jsonEncode(partie.etat.toJson()), avant);
              continue;
            }
            expect(reponse.actions, isNotEmpty);
            final action = reponse.actions[tirer(reponse.actions.length)];
            expect(action.phrase, isNot(contains('{')));
            final maladies = action.maladies;
            final confirmation = partie.confirmer(
              selection,
              action.id,
              maladie: maladies == null || maladies.isEmpty
                  ? null
                  : maladies[tirer(maladies.length)].id,
            );
            expect(
              confirmation,
              isA<ActionAppliquee>(),
              reason: 'une action proposée doit pouvoir être confirmée',
            );
            final resultat = (confirmation as ActionAppliquee).resultat;
            appliquees++;
            if (resultat.maladieRevelee != null) sorties++;

            // Invariants de l'état.
            final etat = partie.etat;
            expect(resultat.numero, etat.actions);
            expect(resultat.pieces, greaterThanOrEqualTo(0));
            for (final p in etat.patients.values) {
              expect(p.pv, inInclusiveRange(0, pvInitial[p.maladie]!));
              expect(p.admission, lessThanOrEqualTo(etat.ticks));
              if (p.enJeu) {
                expect(p.pv, greaterThan(0), reason: 'un mort sort du jeu');
                expect(p.issue, isNull);
              } else {
                expect(p.issue, isNot(IssuePatient.enJeu));
              }
            }
            if (resultat.issue == IssuePatient.mort) {
              expect(resultat.pieces, 0);
              expect(resultat.pvApres, 0);
              expect(resultat.reputation, lessThan(0));
            }
            if (resultat.issue != null &&
                resultat.issue != IssuePatient.enJeu) {
              expect(resultat.maladieRevelee, isNotNull);
            } else {
              expect(resultat.maladieRevelee, isNull);
            }
            for (final e in etat.recherche.entries) {
              final m = jeu.maladies.firstWhere((m) => m.id == e.key);
              expect(e.value, inInclusiveRange(1, m.passages));
            }

            // Aller-retour JSON du résultat et de la sauvegarde.
            final json = jsonEncode(resultat.toJson());
            expect(
              jsonEncode(
                ResultatAction.fromJson(
                  jsonDecode(json) as Map<String, dynamic>,
                ).toJson(),
              ),
              json,
            );
            final sauvegarde = jsonEncode(partie.sauvegarde());
            final reprise = Partie.restaurer(
              jeu: jeu,
              sauvegarde: jsonDecode(sauvegarde) as Map<String, dynamic>,
              alea: Alea(2000 + graine + tour),
            );
            expect(jsonEncode(reprise.sauvegarde()), sauvegarde);

            // Annulation : retour exact à l'état d'avant.
            final choix = tirer(8);
            if (choix == 0) {
              expect(partie.annulerDerniereAction()!.numero, resultat.numero);
              expect(jsonEncode(partie.etat.toJson()), avant);
            } else if (choix == 1) {
              partie = reprise;
            }
          }
        }
        // Le test n'a de valeur que s'il joue vraiment.
        printOnFailure('$appliquees actions, $sorties sorties');
        expect(appliquees, greaterThan(1000));
        expect(sorties, greaterThan(20));
      });
    }
  }
}
