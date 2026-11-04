import 'dart:convert';

import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

final _jeu = jeuExemple();
final _paquet = IdentitePaquet.depuis(_jeu, exempleBrut);

Partie _partie({String difficulte = 'interne', List<double>? tirages}) =>
    Partie.nouvelle(
      jeu: _jeu,
      paquet: _paquet,
      difficulte: difficulte,
      alea: tirages == null ? Alea(1) : SequenceFixe(tirages),
    );

ResultatAction _appliquer(Partie partie, List<String> qrs, String action) {
  final reponse = partie.confirmer(qrs, action);
  if (reponse is ActionRefusee) fail('action refusée : ${reponse.message}');
  return (reponse as ActionAppliquee).resultat;
}

String _refus(ReponseSelection r) => (r as SelectionRefusee).message;

const _diag = ['MED-001', 'PAT-001', 'SAL-001'];
const _chirSeul = ['MED-002', 'PAT-001', 'SAL-002'];
const _chirSoin = ['MED-003', 'PAT-001', 'SAL-002'];
const _chirDeux = ['MED-002', 'MED-003', 'PAT-001', 'SAL-002'];
const _psy = ['MED-004', 'PAT-001', 'SAL-001'];

void main() {
  group('moduler (difficulté et arrondi)', () {
    test('arrondi au plus proche, demi éloigné de zéro', () {
      expect(moduler(3, 1.5), 5);
      expect(moduler(-3, 1.5), -5);
      expect(moduler(1, 1.2), 1);
      expect(moduler(4, 1.2), 5);
      expect(moduler(-1, 1.5), -2);
      expect(moduler(2, 1.0), 2);
    });

    test('une base non nulle reste au moins égale à 1 en valeur absolue', () {
      expect(moduler(1, 0.3), 1);
      expect(moduler(-1, 0.3), -1);
      expect(moduler(0, 2), 0);
    });

    test('pas de piège flottant : 10 × 1,15 = 11,5 → 12', () {
      expect(moduler(10, 1.15), 12);
    });
  });

  group('admission', () {
    test('un patient seul hors jeu propose « Admettre » avec sa phrase', () {
      final r = _partie().valider(['PAT-001']) as SelectionAcceptee;
      expect(r.motif, 'admission');
      expect(r.cartes, ['PAT-001']);
      expect(r.actions.single.id, 'admettre');
      expect(r.actions.single.phrase, 'Admission de Mme Garnier.');
      expect(r.actions.single.toJson()['libelle'], 'Admettre');
    });

    test('tirage pondéré de la maladie, PV initiaux, temps 0', () {
      final partie = _partie(tirages: [tirageAppendicite]);
      final r = _appliquer(partie, ['PAT-001'], 'admettre');
      expect(r.numero, 1);
      expect(r.pvAvant, isNull);
      expect(r.pvApres, 10);
      expect(r.deltaPv, isNull);
      expect(r.temps, 0);
      expect(r.issue, IssuePatient.enJeu);
      expect(r.maladieRevelee, isNull, reason: 'la maladie reste cachée');
      expect(r.pieces, 0);
      expect(r.reputation, 0);
      final p = partie.etat.patients['PAT-001']!;
      expect(p.maladie, 'appendicite');
      expect(p.enJeu, isTrue);
    });

    test('chaque tirage mène à la maladie attendue', () {
      final attendus = {
        tirageAppendicite: 'appendicite',
        tirageFracture: 'fracture_ouverte',
        tirageAngine: 'angine_bacterienne',
        tirageAllergie: 'allergie_saisonniere',
        tiragePhobie: 'phobie_des_blouses',
        tirageHypocondrie: 'hypocondrie_aigue',
      };
      attendus.forEach((tirage, maladie) {
        final partie = _partie(tirages: [tirage]);
        _appliquer(partie, ['PAT-001'], 'admettre');
        expect(partie.etat.patients['PAT-001']!.maladie, maladie);
      });
    });

    test('un patient déjà en jeu, scanné seul, est refusé', () {
      final partie = _partie();
      _appliquer(partie, ['PAT-001'], 'admettre');
      expect(
        _refus(partie.valider(['PAT-001'])),
        'Mme Garnier est déjà en jeu.',
      );
    });

    test('une combinaison standard avec un patient non admis est refusée', () {
      expect(
        _refus(_partie().valider(['MED-001', 'PAT-002', 'SAL-001'])),
        'M. Dupont n\'est pas en jeu.',
      );
    });

    test('une sélection non conforme renvoie le premier écart', () {
      expect(
        _refus(_partie().valider(['MED-001', 'PAT-001'])),
        'Il faut une carte salle.',
      );
    });
  });

  group('diagnostic', () {
    test('temps + 1, pièces, aggravation, distribution, patient en jeu', () {
      final partie = _partie(tirages: [tirageAppendicite, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final apercu = partie.valider([..._diag, 'OBJ-001']) as SelectionAcceptee;
      expect(apercu.actions.map((a) => a.id), ['diagnostiquer', 'traiter']);
      expect(
        apercu.actions.first.phrase,
        'Examen de Mme Garnier par le Dr Moreau dans la salle de consultation '
        'avec le stéthoscope.',
      );

      final r = _appliquer(partie, [..._diag, 'OBJ-001'], 'diagnostiquer');
      expect(r.numero, 2);
      expect(r.temps, 1);
      expect(r.pvAvant, 10);
      expect(r.pvApres, 9, reason: 'aggravation[0] = 1');
      expect(r.deltaPv, -1);
      expect(r.pieces, 1);
      expect(r.reputation, 0);
      expect(r.issue, IssuePatient.enJeu);
      expect(r.diagnostic, isNotNull);
      expect(r.diagnostic!.niveau, 3);
      expect(r.diagnostic!.noms, isNull);
      expect(
        r.diagnostic!.types.fold<int>(0, (s, l) => s + l.pourcentage),
        100,
      );
    });

    test('aggravation selon le temps, dernière valeur répétée', () {
      final partie = _partie(tirages: [tirageFracture, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final pertes = [
        for (var i = 0; i < 4; i++)
          -_appliquer(partie, _diag, 'diagnostiquer').deltaPv!,
      ];
      expect(pertes, [1, 1, 2, 2], reason: 'aggravation [1, 1, 2]');
    });

    test('mort par aggravation : PV bornés à 0, pénalités d\'attente et de '
        'mort cumulées', () {
      final partie = _partie(tirages: [tirageAppendicite, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      for (var i = 0; i < 4; i++) {
        _appliquer(partie, _diag, 'diagnostiquer'); // 10 → 9 → 7 → 5 → 2
      }
      final r = _appliquer(partie, _diag, 'diagnostiquer');
      expect(r.deltaPv, -2);
      expect(r.pvApres, 0);
      expect(r.issue, IssuePatient.mort);
      expect(r.attenteDepassee, isTrue, reason: 'temps 5 > attente_max 4');
      expect(r.reputation, -1 - 3);
      expect(r.maladieRevelee!.id, 'appendicite');
    });

    test('attente dépassée : réputation à chaque action au-delà du seuil', () {
      final partie = _partie(tirages: [tirageHypocondrie, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final reputations = <int>[];
      final attentes = <bool>[];
      for (var i = 0; i < 5; i++) {
        final r = _appliquer(partie, _diag, 'diagnostiquer');
        reputations.add(r.reputation);
        attentes.add(r.attenteDepassee);
      }
      expect(attentes, [
        false,
        false,
        false,
        true,
        true,
      ], reason: 'attente_max 3');
      expect(reputations, [0, 0, 0, -1, -1]);
    });
  });

  group('traitement', () {
    Partie admise(String difficulte, double tirage) {
      final partie = _partie(difficulte: difficulte, tirages: [tirage, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      return partie;
    }

    test('adapté : soigné, récompenses de la maladie, sans aggravation, '
        'maladie révélée, patient sorti', () {
      final partie = admise('interne', tirageAppendicite);
      final r = _appliquer(partie, _chirDeux, 'traiter');
      expect(r.issue, IssuePatient.soigne);
      expect(r.pvApres, 10, reason: 'pas d\'aggravation');
      expect(r.pieces, 4, reason: 'pieces_traitement propre à la maladie');
      expect(r.reputation, 2);
      expect(r.maladieRevelee!.id, 'appendicite');
      expect(r.maladieRevelee!.nom, 'Appendicite');
      final p = partie.etat.patients['PAT-001']!;
      expect(p.statut, StatutPatient.sorti);
      expect(p.issue, IssuePatient.soigne);
      expect(partie.etat.enJeu('PAT-001'), isFalse);
    });

    test('partiel : gain de soin_partiel + capacité soin, plafonné, puis '
        'aggravation', () {
      final partie = admise('interne', tirageAppendicite);
      _appliquer(partie, _diag, 'diagnostiquer'); // 10 → 9
      _appliquer(partie, _diag, 'diagnostiquer'); // 9 → 7
      final r = _appliquer(partie, _chirSoin, 'traiter');
      // temps 3 : 7 + 2 + 1 (soin) = 10, plafonné à 10, puis −2.
      expect(r.pvAvant, 7);
      expect(r.pvApres, 8);
      expect(r.pieces, 1);
      expect(r.reputation, 0);
      expect(r.issue, IssuePatient.enJeu);

      final r2 = _appliquer(partie, _chirSeul, 'traiter');
      // temps 4 : 8 + 2 = 10, puis −3.
      expect(r2.pvApres, 7);
    });

    test('inadapté : perte de PV, réputation, aggravation', () {
      final partie = admise('interne', tirageAppendicite);
      final r = _appliquer(partie, _psy, 'traiter');
      expect(r.pvApres, 10 - 2 - 1);
      expect(r.pieces, 0);
      expect(r.reputation, -1);
    });

    test('récompense surchargée par la maladie (hypocondrie : échec −2)', () {
      final partie = admise('interne', tirageHypocondrie);
      final r = _appliquer(partie, _chirSeul, 'traiter');
      expect(r.reputation, -2);
    });

    test(
      'traitement adapté avec condition « non » (hypocondrie sans objet)',
      () {
        final partie = admise('interne', tirageHypocondrie);
        final avecObjet = _appliquer(partie, [
          'MED-004',
          'PAT-001',
          'SAL-003',
          'OBJ-001',
        ], 'traiter');
        expect(avecObjet.issue, IssuePatient.enJeu, reason: 'objet interdit');
        final sansObjet = _appliquer(partie, [
          'MED-004',
          'PAT-001',
          'SAL-003',
        ], 'traiter');
        expect(sansObjet.issue, IssuePatient.soigne);
      },
    );

    test('traitement par une carte précise (angine : antibiotique)', () {
      final partie = admise('interne', tirageAngine);
      final partiel = _appliquer(partie, [..._diag, 'OBJ-011'], 'traiter');
      expect(partiel.pieces, 1, reason: 'autre médicament : partiel');
      final adapte = _appliquer(partie, [..._diag, 'OBJ-010'], 'traiter');
      expect(adapte.issue, IssuePatient.soigne);
    });

    test('mort : PV à 0, pénalité de mort, maladie révélée (Réanimation)', () {
      final partie = admise('reanimation', tirageHypocondrie);
      // PV 7. Échec : −2 × 2 = −4, aggravation −1 × 2 = −2.
      final r1 = _appliquer(partie, _chirSeul, 'traiter');
      expect(r1.pvApres, 1);
      expect(r1.reputation, -4);
      final r2 = _appliquer(partie, _chirSeul, 'traiter');
      expect(r2.pvApres, 0, reason: 'les PV ne descendent pas sous 0');
      expect(r2.issue, IssuePatient.mort);
      expect(r2.reputation, -4 - 6, reason: 'échec −4, mort −3 × 2');
      expect(r2.maladieRevelee!.id, 'hypocondrie_aigue');
      expect(partie.etat.patients['PAT-001']!.issue, IssuePatient.mort);
    });

    test('difficulté Chirurgien : pièces ×1,2 et réputation ×1,5', () {
      final partie = admise('chirurgien', tirageAppendicite);
      final r = _appliquer(partie, _chirDeux, 'traiter');
      expect(r.pieces, 5, reason: '4 × 1,2 = 4,8 → 5');
      expect(r.reputation, 3, reason: '2 × 1,5 = 3');
    });

    test('un patient sorti peut être réadmis avec une nouvelle maladie', () {
      final partie = _partie(tirages: [tirageAppendicite, tirageAngine]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, _chirDeux, 'traiter');
      expect(_refus(partie.valider(_diag)), 'Mme Garnier n\'est pas en jeu.');
      final r = _appliquer(partie, ['PAT-001'], 'admettre');
      expect(r.pvAvant, isNull);
      expect(r.pvApres, 8);
      expect(partie.etat.patients['PAT-001']!.maladie, 'angine_bacterienne');
      expect(partie.etat.patients['PAT-001']!.issue, isNull);
    });
  });

  group('confirmation et revalidation', () {
    test('la précondition est réévaluée : double admission refusée', () {
      final partie = _partie();
      expect(partie.valider(['PAT-002']), isA<SelectionAcceptee>());
      expect(partie.valider(['PAT-002']), isA<SelectionAcceptee>());
      _appliquer(partie, ['PAT-002'], 'admettre');
      final r = partie.confirmer(['PAT-002'], 'admettre') as ActionRefusee;
      expect(r.message, 'M. Dupont est déjà en jeu — action non appliquée.');
    });

    test('patient sorti entre l\'aperçu et la confirmation', () {
      final partie = _partie(tirages: [tirageAppendicite]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, _chirDeux, 'traiter');
      final r = partie.confirmer(_diag, 'diagnostiquer') as ActionRefusee;
      expect(
        r.message,
        'Mme Garnier n\'est plus en jeu — action non appliquée.',
      );
      expect(partie.etat.actions, 2, reason: 'rien n\'est appliqué');
    });

    test(
      'chaque scan compte : deux confirmations font avancer le temps de 2',
      () {
        final partie = _partie(tirages: [tirageAppendicite, 0.5]);
        _appliquer(partie, ['PAT-001'], 'admettre');
        _appliquer(partie, _diag, 'diagnostiquer');
        _appliquer(partie, _diag, 'diagnostiquer');
        expect(partie.etat.patients['PAT-001']!.temps, 2);
      },
    );

    test('action étrangère au motif ou sélection non conforme refusées', () {
      final partie = _partie();
      expect(
        (partie.confirmer(['PAT-001'], 'traiter') as ActionRefusee).message,
        'Action impossible avec cette sélection.',
      );
      expect(
        (partie.confirmer(['MED-001'], 'admettre') as ActionRefusee).message,
        'Il faut une carte patient.',
      );
    });

    test('difficulté inconnue refusée', () {
      expect(() => _partie(difficulte: 'facile'), throwsArgumentError);
    });
  });

  group('annulation (LIFO, 5 actions)', () {
    test('restaure l\'instantané et renvoie le résultat annulé', () {
      final partie = _partie(tirages: [tirageAppendicite, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final avant = jsonEncode(partie.etat.toJson());
      final r = _appliquer(partie, _chirDeux, 'traiter');
      final annule = partie.annulerDerniereAction();
      expect(annule!.numero, r.numero);
      expect(annule.pieces, 4);
      expect(jsonEncode(partie.etat.toJson()), avant);
      expect(partie.etat.enJeu('PAT-001'), isTrue);
    });

    test('au plus 5 actions annulables, puis plus rien', () {
      final partie = _partie(tirages: [tirageAllergie, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      for (var i = 0; i < 6; i++) {
        _appliquer(partie, _diag, 'diagnostiquer');
      }
      expect(partie.historique, hasLength(5));
      final numeros = <int>[];
      for (var i = 0; i < 5; i++) {
        numeros.add(partie.annulerDerniereAction()!.numero);
      }
      expect(numeros, [7, 6, 5, 4, 3]);
      expect(partie.annulerDerniereAction(), isNull);
      expect(partie.etat.actions, 2);
      expect(partie.etat.patients['PAT-001']!.temps, 1);
    });
  });

  group('sauvegarde et restauration', () {
    Partie jouee() {
      final partie = _partie(tirages: [tirageAppendicite, 0.3, 0.6, 0.9]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, ['PAT-002'], 'admettre');
      _appliquer(partie, [..._diag, 'OBJ-002'], 'diagnostiquer');
      _appliquer(partie, _chirDeux, 'traiter');
      return partie;
    }

    test('aller-retour JSON identique, historique compris', () {
      final partie = jouee();
      final texte = jsonEncode(partie.sauvegarde());
      final reprise = Partie.restaurer(
        jeu: _jeu,
        sauvegarde: jsonDecode(texte) as Map<String, dynamic>,
        alea: Alea(3),
      );
      expect(jsonEncode(reprise.sauvegarde()), texte);
      expect(reprise.historique, hasLength(4));
      expect(reprise.annulerDerniereAction()!.action, 'traiter');
      expect(reprise.etat.enJeu('PAT-001'), isTrue);
    });

    test('formats non supportés refusés', () {
      expect(
        () => Partie.restaurer(
          jeu: _jeu,
          sauvegarde: {'format_sauvegarde': 99},
          alea: Alea(1),
        ),
        throwsFormatException,
      );
      final etat = jouee().etat.toJson()..['format_etat'] = 99;
      expect(() => EtatPartie.fromJson(etat), throwsFormatException);
    });

    test('compatibilité : même paquet, sans remarque', () {
      final c = CompatibiliteEtat.verifier(jouee().etat, _jeu, _paquet);
      expect(c.compatible, isTrue);
      expect(c.avertissements, isEmpty);
    });

    test('compatibilité : autre version du paquet, avertissement', () {
      final autre = IdentitePaquet(
        id: _paquet.id,
        version: '0.2.0',
        empreinte: _paquet.empreinte,
      );
      final c = CompatibiliteEtat.verifier(jouee().etat, _jeu, autre);
      expect(c.compatible, isTrue);
      expect(c.avertissements.single, contains('autre paquet'));
    });

    test('compatibilité : maladie, carte ou difficulté disparues, erreur', () {
      final etat = jouee().etat;
      final reduit = jeuExemple((brut) {
        (brut['maladies'] as List).removeAt(0);
        (brut['cartes'] as Map).remove('PAT-002');
        ((brut['difficultes'] as List)[0] as Map)['id'] = 'debutant';
      });
      final c = CompatibiliteEtat.verifier(etat, reduit, _paquet);
      expect(c.compatible, isFalse);
      expect(c.erreurs, contains(contains('appendicite')));
      expect(c.erreurs, contains(contains('PAT-002')));
      expect(c.erreurs, contains(contains('interne')));
    });

    test('empreinte : SHA-256 du contenu, sensible au moindre changement', () {
      expect(_paquet.empreinte, startsWith('sha256:'));
      expect(_paquet.empreinte, hasLength(7 + 64));
      expect(empreintePaquet('$exempleBrut '), isNot(_paquet.empreinte));
      expect(
        IdentitePaquet.fromJson(_paquet.toJson()).hashCode,
        _paquet.hashCode,
      );
    });

    test('résultat sérialisé : clés du message « resultat »', () {
      final partie = jouee();
      final r = partie.historique.last.resultat.toJson();
      expect(r.keys, [
        'numero',
        'action',
        'libelle',
        'phrase',
        'cartes',
        'patient',
        'patient_nom',
        'pv_avant',
        'pv_apres',
        'temps',
        'attente_depassee',
        'issue',
        'diagnostic',
        'maladie_revelee',
        'pieces',
        'reputation',
      ]);
      expect(r['issue'], 'soigne');
      expect(ResultatAction.fromJson(r).toJson(), r);
    });
  });

  group('précondition de combinaison', () {
    test('l\'aperçu ne propose que les actions dont la précondition de '
        'combinaison est satisfaite', () {
      final jeu = jeuExemple((brut) {
        (brut['actions'] as List).add({
          'id': 'consulter',
          'libelle': 'Consulter',
          'motif': 'standard',
          'precondition': {
            'et': [
              'patient_en_jeu',
              {
                'combinaison': {
                  'compte': {'type': 'salle', 'specialite': 'psychologie'},
                  'min': 1,
                },
              },
            ],
          },
          'phrase': 'Consultation de {patient}.',
          'effets': [
            {'effet': 'avancer_temps'},
          ],
        });
      });
      final partie = Partie.nouvelle(
        jeu: jeu,
        paquet: _paquet,
        difficulte: 'interne',
        alea: Alea(1),
      );
      _appliquer(partie, ['PAT-001'], 'admettre');
      List<String> actions(List<String> qrs) => [
        for (final a in (partie.valider(qrs) as SelectionAcceptee).actions)
          a.id,
      ];
      expect(actions(_diag), ['diagnostiquer', 'traiter']);
      expect(actions(['MED-004', 'PAT-001', 'SAL-003']), [
        'diagnostiquer',
        'traiter',
        'consulter',
      ]);
      final refus = partie.confirmer(_diag, 'consulter') as ActionRefusee;
      expect(
        refus.message,
        'Cette action n\'est pas possible avec ces cartes — action non '
        'appliquée.',
        reason: 'les cartes sont en cause, pas l\'état du patient',
      );
    });

    test(
      'aucune action possible à cause des cartes : message sur les cartes',
      () {
        final jeu = jeuExemple((brut) {
          for (final a in brut['actions'] as List) {
            if ((a as Map)['motif'] != 'standard') continue;
            a['precondition'] = {
              'et': [
                'patient_en_jeu',
                {
                  'non': {
                    'combinaison': {'carte': 'SAL-001'},
                  },
                },
              ],
            };
          }
        });
        final partie = Partie.nouvelle(
          jeu: jeu,
          paquet: _paquet,
          difficulte: 'interne',
          alea: Alea(1),
        );
        expect(
          _refus(partie.valider(_diag)),
          'Mme Garnier n\'est pas en jeu.',
          reason: 'patient hors jeu : l\'état est en cause',
        );
        _appliquer(partie, ['PAT-001'], 'admettre');
        expect(
          _refus(partie.valider(_diag)),
          'Aucune action possible avec ces cartes.',
        );
        expect(partie.valider(_chirSeul), isA<SelectionAcceptee>());
      },
    );
  });

  group('robustesse face à un paquet mal conçu', () {
    test('effets sur un patient hors jeu sans précondition : sans effet', () {
      final jeu = jeuExemple((brut) {
        final traiter = (brut['actions'] as List)[2] as Map;
        traiter.remove('precondition');
      });
      final partie = Partie.nouvelle(
        jeu: jeu,
        paquet: _paquet,
        difficulte: 'interne',
        alea: Alea(1),
      );
      final r = _appliquer(partie, _psy, 'traiter');
      expect(r.issue, isNull);
      expect(r.pvApres, isNull);
      expect(
        r.reputation,
        -1,
        reason: 'les effets hors patient restent appliqués',
      );
    });
  });
}
