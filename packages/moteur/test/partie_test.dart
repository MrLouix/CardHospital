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

/// Diagnostic neutre : Dr Moreau (polyvalent) en radiologie (polyvalente).
const _diag = ['MED-001', 'PAT-001', 'SAL-003'];

/// Un seul orthopédiste au bloc : échec pour la fracture ouverte.
const _orthoSeul = ['MED-007', 'PAT-001', 'SAL-006'];

/// Un orthopédiste à la plâtrerie : traitement partiel de la fracture
/// ouverte ; le Dr Vasseur ajoute 1 de stabilisation.
const _platre = ['MED-007', 'PAT-001', 'SAL-008'];
const _platreStabilise = ['MED-008', 'PAT-001', 'SAL-008'];

/// Deux orthopédistes au bloc : soigne la fracture ouverte.
const _orthoDeux = ['MED-007', 'MED-008', 'PAT-001', 'SAL-006'];

/// Un psychiatre en salle de consultation.
const _psy = ['MED-005', 'PAT-001', 'SAL-001'];

/// Laboratoire de recherche.
const _labo = ['MED-001', 'PAT-001', 'SAL-011'];

void main() {
  group('moduler (bonus de difficulté)', () {
    test('le bonus s\'ajoute à la valeur absolue d\'un montant non nul', () {
      expect(moduler(3, 0), 3);
      expect(moduler(3, 1), 4);
      expect(moduler(1, 2), 3);
      expect(moduler(-1, 1), -2);
      expect(moduler(-3, 2), -5);
      expect(moduler(0, 2), 0, reason: 'un montant nul reste nul');
    });

    test('avec un bonus négatif, une base non nulle reste au moins égale à '
        '1 en valeur absolue', () {
      expect(moduler(2, -5), 1);
      expect(moduler(-1, -1), -1);
    });
  });

  group('admission', () {
    test('un patient seul hors jeu propose « Admettre » avec sa phrase', () {
      final r = _partie().valider(['PAT-001']) as SelectionAcceptee;
      expect(r.motifs, ['admission']);
      expect(r.cartes, ['PAT-001']);
      expect(r.actions.single.id, 'admettre');
      expect(r.actions.single.phrase, 'Admission de Mme Garnier.');
      expect(r.actions.single.toJson()['libelle'], 'Admettre');
    });

    test('tirage pondéré de la maladie, PV initiaux, présence 0', () {
      final partie = _partie(tirages: [tirageFractureOuverte]);
      final r = _appliquer(partie, ['PAT-001'], 'admettre');
      expect(r.numero, 1);
      expect(r.pvAvant, isNull);
      expect(r.pvApres, 15);
      expect(r.deltaPv, isNull);
      expect(r.presence, 0);
      expect(partie.etat.ticks, 0, reason: 'l\'admission n\'est pas un tick');
      expect(r.issue, IssuePatient.enJeu);
      expect(r.maladieRevelee, isNull, reason: 'la maladie reste cachée');
      expect(r.pieces, 0);
      expect(r.reputation, 0);
      final p = partie.etat.patients['PAT-001']!;
      expect(p.maladie, 'fracture_ouverte');
      expect(p.enJeu, isTrue);
    });

    test('chaque tirage mène à la maladie attendue', () {
      final attendus = {
        tirageFractureOuverte: 'fracture_ouverte',
        tirageFractureFermee: 'fracture_fermee',
        tirageAngine: 'angine_bacterienne',
        tirageMauxDeTete: 'maux_de_tete',
        tiragePhobie: 'phobie_des_blouses_blanches',
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
    test('tick + 1, pièces, patient stable, liste, patient en jeu', () {
      final partie = _partie(tirages: [tirageFractureOuverte, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final apercu = partie.valider([..._diag, 'OBJ-001']) as SelectionAcceptee;
      expect(apercu.actions.map((a) => a.id), ['diagnostiquer', 'traiter']);
      expect(
        apercu.actions.first.phrase,
        'Examen de Mme Garnier par le Dr Moreau en radiologie avec le '
        'stéthoscope.',
      );

      final r = _appliquer(partie, [..._diag, 'OBJ-001'], 'diagnostiquer');
      expect(r.numero, 2);
      expect(r.presence, 1);
      expect(partie.etat.ticks, 1);
      expect(r.pvAvant, 15);
      expect(r.pvApres, 15, reason: 'stable pendant les 4 premiers ticks');
      expect(r.deltaPv, 0);
      expect(r.pieces, 1);
      expect(r.reputation, 0);
      expect(r.issue, IssuePatient.enJeu);
      expect(r.diagnostic, isNotNull);
      expect(
        r.diagnostic!.niveau,
        4,
        reason: '1 + 3 + 1 = 5, plafonné à precision_max = 4',
      );
      expect(r.diagnostic!.maladies, hasLength(5));
      expect(
        r.diagnostic!.maladies.map((l) => l.specialite.icone).toSet(),
        everyElement(isIn(['🩺', '🧠', '🦴'])),
      );
    });

    test('aggravation par palier de présence, dernière valeur répétée', () {
      // Fracture fermée : PV 12, aggravation [1, 2, 2, 3], paliers 5, 11…
      final partie = _partie(tirages: [tirageFractureFermee, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final pertes = [
        for (var i = 0; i < 9; i++)
          -_appliquer(partie, _diag, 'diagnostiquer').deltaPv!,
      ];
      expect(pertes, [0, 0, 0, 0, 1, 1, 1, 1, 1]);
      expect(partie.etat.patients['PAT-001']!.pv, 12 - 5);
    });

    test('paliers : stable, puis perte du palier atteint', () {
      final p = jeuExemple().parametres;
      expect(p.paliersAggravation, [5, 11, 17, 23]);
      expect(
        [
          for (final presence in [0, 4, 5, 10, 11, 16, 17, 23, 99])
            palierAggravation(presence, p.paliersAggravation),
        ],
        [0, 0, 1, 1, 2, 2, 3, 4, 4],
      );
      final fracture = jeuExemple().maladies.first; // [2, 2, 3, 3]
      expect(
        [
          for (final presence in [4, 5, 11, 17, 23, 40])
            perteAggravation(fracture, presence, p),
        ],
        [0, 2, 2, 3, 3, 3],
      );
    });

    test('horloge commune : un patient délaissé ne perd rien, puis subit '
        'la perte de son palier une seule fois, sans rattrapage', () {
      // Hypocondrie (PV 10, aggravation [1, 1, 2]) pour Mme Garnier, maux de
      // tête (PV 7, aggravation [0, 1]) pour M. Dupont.
      final partie = _partie(tirages: [tirageHypocondrie, tirageMauxDeTete]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, ['PAT-002'], 'admettre');
      for (var i = 0; i < 10; i++) {
        _appliquer(partie, ['MED-001', 'PAT-002', 'SAL-003'], 'diagnostiquer');
      }
      expect(partie.etat.ticks, 10);
      expect(partie.etat.patients['PAT-001']!.pv, 10, reason: 'délaissée');
      final r = _appliquer(partie, _diag, 'diagnostiquer');
      expect(r.presence, 11);
      expect(r.deltaPv, -1, reason: 'une seule perte, celle du palier 2');
    });

    test('mort par aggravation : PV bornés à 0, pénalités d\'attente et de '
        'mort cumulées, aucune pièce', () {
      // Fracture ouverte : PV 15, aggravation [2, 2, 3, 3], attente 9.
      final partie = _partie(tirages: [tirageFractureOuverte, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      for (var i = 0; i < 11; i++) {
        _appliquer(partie, _diag, 'diagnostiquer'); // 15 → … → 1
      }
      final r = _appliquer(partie, _diag, 'diagnostiquer');
      expect(r.deltaPv, -1);
      expect(r.pvApres, 0);
      expect(r.issue, IssuePatient.mort);
      expect(r.attenteDepassee, isTrue, reason: 'présence 12 > attente 9');
      expect(r.reputation, -1 - 3);
      expect(r.pieces, 0, reason: 'pas de pièce si le patient meurt');
      expect(r.maladieRevelee!.id, 'fracture_ouverte');
    });

    test('attente dépassée : réputation à chaque action au-delà du seuil', () {
      // Fracture fermée, attente 12 ; un orthopédiste au bloc donne un
      // traitement partiel, qui n'aggrave pas.
      final partie = _partie(tirages: [tirageFractureFermee, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final reputations = <int>[];
      final attentes = <bool>[];
      for (var i = 0; i < 14; i++) {
        final r = _appliquer(partie, _orthoSeul, 'traiter');
        reputations.add(r.reputation);
        attentes.add(r.attenteDepassee);
      }
      expect(attentes, [for (var t = 1; t <= 14; t++) t > 12]);
      expect(reputations, [for (var t = 1; t <= 14; t++) t > 12 ? -1 : 0]);
    });
  });

  group('traitement', () {
    Partie admise(String difficulte, double tirage) {
      final partie = _partie(difficulte: difficulte, tirages: [tirage, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      return partie;
    }

    test('adapté : guéri, récompenses de la maladie, sans aggravation, '
        'maladie révélée, patient sorti', () {
      final partie = admise('interne', tirageFractureOuverte);
      final r = _appliquer(partie, _orthoDeux, 'traiter');
      expect(r.issue, IssuePatient.gueri);
      expect(r.pvApres, 15, reason: 'pas d\'aggravation');
      expect(r.pieces, 5, reason: 'pieces_traitement propre à la maladie');
      expect(r.reputation, 2);
      expect(r.maladieRevelee!.id, 'fracture_ouverte');
      expect(r.maladieRevelee!.nom, 'Fracture ouverte');
      final p = partie.etat.patients['PAT-001']!;
      expect(p.statut, StatutPatient.sorti);
      expect(p.issue, IssuePatient.gueri);
      expect(partie.etat.enJeu('PAT-001'), isFalse);
    });

    test('« 2 orthopédistes » : deux vrais médecins, dont un peut tenir le '
        'diplôme', () {
      // Un orthopédiste et le diplôme d'orthopédie, sans second médecin.
      final seul = admise('interne', tirageFractureOuverte);
      final r1 = _appliquer(seul, [
        'MED-007',
        'PAT-001',
        'SAL-006',
        'DIP-004',
      ], 'traiter');
      expect(r1.issue, IssuePatient.enJeu);
      // Un orthopédiste et le Dr Moreau, diplômé d'orthopédie.
      final deux = admise('interne', tirageFractureOuverte);
      final r2 = _appliquer(deux, [
        'MED-007',
        'MED-001',
        'PAT-001',
        'SAL-006',
        'DIP-004',
      ], 'traiter');
      expect(r2.issue, IssuePatient.gueri);
    });

    test('partiel : gain de pv_partiel + capacité stabilisation, plafonné, '
        'sans aggravation', () {
      final partie = admise('interne', tirageFractureOuverte);
      for (var i = 0; i < 6; i++) {
        _appliquer(partie, _diag, 'diagnostiquer'); // ticks 5 et 6 : −2
      }
      final r = _appliquer(partie, _platreStabilise, 'traiter');
      // Tick 7 : 11 + 2 + 1 (stabilisation) = 14, sans l'aggravation de 2.
      expect(r.pvAvant, 11);
      expect(r.pvApres, 14);
      expect(r.pieces, 1);
      expect(r.reputation, 0);
      expect(r.issue, IssuePatient.enJeu);

      final r2 = _appliquer(partie, _platre, 'traiter');
      expect(r2.pvApres, 15, reason: 'tick 8 : plafonné, sans aggravation');
      final r3 = _appliquer(partie, _diag, 'diagnostiquer');
      expect(r3.pvApres, 13, reason: 'le diagnostic, lui, aggrave');
    });

    test('partiel en Réanimation : le gain n\'est pas modifié, et rien ne '
        'le reprend', () {
      final partie = admise('reanimation', tirageFractureOuverte);
      for (var i = 0; i < 5; i++) {
        _appliquer(partie, _diag, 'diagnostiquer'); // tick 5 : −(2 + 2)
      }
      final r = _appliquer(partie, _platre, 'traiter');
      expect(r.pvAvant, 11);
      expect(r.pvApres, 13, reason: '11 + 2, sans aggravation');
    });

    test('échec : perte de PV, réputation, aggravation', () {
      // Fracture fermée : PV 12, aggravation [1, 2, 2, 3].
      final partie = admise('interne', tirageFractureFermee);
      final r = _appliquer(partie, _psy, 'traiter');
      expect(r.pvApres, 12 - 2, reason: 'échec, patient encore stable');
      expect(r.pieces, 0);
      expect(r.reputation, -1);
      for (var i = 0; i < 3; i++) {
        _appliquer(partie, _diag, 'diagnostiquer');
      }
      final r2 = _appliquer(partie, _psy, 'traiter');
      expect(r2.pvApres, 10 - 2 - 1, reason: 'tick 5 : échec + palier 1');
    });

    test('récompense surchargée par la maladie (fracture ouverte : échec '
        '−2)', () {
      final partie = admise('interne', tirageFractureOuverte);
      final r = _appliquer(partie, _psy, 'traiter');
      expect(r.reputation, -2);
    });

    test(
      'traitement adapté avec condition « non » (hypocondrie sans objet)',
      () {
        final partie = admise('interne', tirageHypocondrie);
        final avecObjet = _appliquer(partie, [
          'MED-005',
          'PAT-001',
          'SAL-001',
          'OBJ-001',
        ], 'traiter');
        expect(avecObjet.issue, IssuePatient.enJeu, reason: 'objet interdit');
        final sansObjet = _appliquer(partie, [
          'MED-005',
          'PAT-001',
          'SAL-001',
        ], 'traiter');
        expect(sansObjet.issue, IssuePatient.gueri);
      },
    );

    test('médicament : l\'antibiotique soigne l\'angine en consultation ou à '
        'la pharmacie, pas en radiologie', () {
      final partie = admise('interne', tirageAngine);
      final partiel = _appliquer(partie, [
        'MED-002',
        'PAT-001',
        'SAL-003',
        'OBJ-010',
      ], 'traiter');
      expect(partiel.issue, IssuePatient.enJeu, reason: 'pas en radiologie');
      expect(partiel.pieces, 1, reason: 'médecin de médecine générale');
      final adapte = _appliquer(partie, [
        'MED-001',
        'PAT-001',
        'SAL-007',
        'OBJ-010',
      ], 'traiter');
      expect(adapte.issue, IssuePatient.gueri);
    });

    test('mort : PV à 0, pénalité de mort, maladie révélée (Réanimation)', () {
      // Hypocondrie, PV 10. Échec : −(2 + 2) PV et −(1 + 2) de réputation.
      final partie = admise('reanimation', tirageHypocondrie);
      final r1 = _appliquer(partie, _orthoSeul, 'traiter');
      expect(r1.pvApres, 6);
      expect(r1.reputation, -3);
      _appliquer(partie, _orthoSeul, 'traiter');
      final r3 = _appliquer(partie, _orthoSeul, 'traiter');
      expect(r3.pvApres, 0, reason: 'les PV ne descendent pas sous 0');
      expect(r3.issue, IssuePatient.mort);
      expect(r3.reputation, -3 - 5, reason: 'échec −3, mort −(3 + 2)');
      expect(r3.maladieRevelee!.id, 'hypocondrie_aigue');
      expect(partie.etat.patients['PAT-001']!.issue, IssuePatient.mort);
    });

    test('difficulté Chirurgien : +1 pièce, gains de réputation inchangés', () {
      final partie = admise('chirurgien', tirageFractureOuverte);
      final r = _appliquer(partie, _orthoDeux, 'traiter');
      expect(r.pieces, 6, reason: '5 + 1');
      expect(r.reputation, 2, reason: 'seules les pertes sont modifiées');
    });

    test('un patient sorti peut être réadmis avec une nouvelle maladie', () {
      final partie = _partie(tirages: [tirageFractureOuverte, tirageAngine]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, _orthoDeux, 'traiter');
      expect(_refus(partie.valider(_diag)), 'Mme Garnier n\'est pas en jeu.');
      final r = _appliquer(partie, ['PAT-001'], 'admettre');
      expect(r.pvAvant, isNull);
      expect(r.pvApres, 12);
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
      final partie = _partie(tirages: [tirageFractureOuverte]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, _orthoDeux, 'traiter');
      final r = partie.confirmer(_diag, 'diagnostiquer') as ActionRefusee;
      expect(
        r.message,
        'Mme Garnier n\'est plus en jeu — action non appliquée.',
      );
      expect(partie.etat.actions, 2, reason: 'rien n\'est appliqué');
    });

    test(
      'chaque scan compte : deux confirmations font avancer l\'horloge de 2',
      () {
        final partie = _partie(tirages: [tirageFractureOuverte, 0.5]);
        _appliquer(partie, ['PAT-001'], 'admettre');
        _appliquer(partie, _diag, 'diagnostiquer');
        _appliquer(partie, _diag, 'diagnostiquer');
        expect(partie.etat.ticks, 2);
        expect(partie.etat.patients['PAT-001']!.presence(2), 2);
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
      final partie = _partie(tirages: [tirageFractureOuverte, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final avant = jsonEncode(partie.etat.toJson());
      final r = _appliquer(partie, _orthoDeux, 'traiter');
      final annule = partie.annulerDerniereAction();
      expect(annule!.numero, r.numero);
      expect(annule.pieces, 5);
      expect(jsonEncode(partie.etat.toJson()), avant);
      expect(partie.etat.enJeu('PAT-001'), isTrue);
    });

    test('au plus 5 actions annulables, puis plus rien', () {
      final partie = _partie(tirages: [tirageAngine, 0.5]);
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
      expect(partie.etat.ticks, 1);
    });
  });

  group('sauvegarde et restauration', () {
    Partie jouee() {
      final partie = _partie(tirages: [tirageFractureOuverte, 0.3, 0.6, 0.9]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, ['PAT-002'], 'admettre');
      _appliquer(partie, [..._diag, 'OBJ-002'], 'diagnostiquer');
      _appliquer(partie, _orthoDeux, 'traiter');
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
        version: '9.9.9',
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
      expect(c.erreurs, contains(contains('fracture_ouverte')));
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
        'presence',
        'attente_depassee',
        'issue',
        'diagnostic',
        'analyse',
        'maladie_revelee',
        'pieces',
        'reputation',
      ]);
      expect(r['issue'], 'gueri');
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
                  'compte': {'type': 'salle', 'specialite': 'psychiatrie'},
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
      expect(actions(['MED-005', 'PAT-001', 'SAL-002']), [
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
                    'combinaison': {'carte': 'SAL-003'},
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
        expect(partie.valider(_orthoSeul), isA<SelectionAcceptee>());
      },
    );
  });

  group('laboratoire de recherche', () {
    /// Patient admis avec la fracture ouverte (3 passages), puis
    /// diagnostiqué une fois.
    Partie diagnostiquee() {
      final partie = _partie(tirages: [tirageFractureOuverte, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, _diag, 'diagnostiquer');
      return partie;
    }

    ResultatAction analyser(Partie partie, List<String> qrs, String maladie) {
      final reponse = partie.confirmer(qrs, 'analyser', maladie: maladie);
      if (reponse is ActionRefusee) {
        fail('analyse refusée : ${reponse.message}');
      }
      return (reponse as ActionAppliquee).resultat;
    }

    test('le laboratoire ne sert ni à diagnostiquer ni à traiter ; sans '
        'diagnostic, aucune piste', () {
      final partie = _partie();
      _appliquer(partie, ['PAT-001'], 'admettre');
      for (final qrs in [
        _labo,
        [..._labo, 'OBJ-017'],
      ]) {
        expect(
          _refus(partie.valider(qrs)),
          'Aucune piste pour Mme Garnier : faire d\'abord un diagnostic.',
        );
      }
      expect(
        _refus(partie.valider(['MED-001', 'MED-002', 'PAT-001', 'SAL-011'])),
        'Aucune action possible avec ces cartes.',
        reason: 'deux médecins : seul le motif standard correspond',
      );
      expect(
        (partie.confirmer(_labo, 'diagnostiquer') as ActionRefusee).message,
        'Cette action n\'est pas possible avec ces cartes — action non '
        'appliquée.',
      );
      expect(
        (partie.confirmer(
          _labo,
          'analyser',
          maladie: 'fracture_ouverte',
        ) as ActionRefusee).message,
        'Aucune piste pour Mme Garnier : faire d\'abord un diagnostic — '
        'action non appliquée.',
      );
      expect(partie.etat.ticks, 0, reason: 'refus sans coût');
    });

    test('après un diagnostic, le laboratoire ne propose qu\'« analyser », '
        'avec les maladies suspectées ; les autres salles ne le proposent '
        'pas', () {
      final partie = diagnostiquee();
      final liste = [
        for (final l in partie.historique.last.resultat.diagnostic!.maladies)
          l.id,
      ];
      for (final qrs in [
        _labo,
        [..._labo, 'OBJ-017'],
      ]) {
        final r = partie.valider(qrs) as SelectionAcceptee;
        expect(r.actions.map((a) => a.id), ['analyser']);
        expect(r.actions.single.maladies!.map((m) => m.id), liste);
        expect(r.actions.single.toJson()['maladies'], hasLength(5));
      }
      final ailleurs = partie.valider(_diag) as SelectionAcceptee;
      expect(ailleurs.actions.map((a) => a.id), ['diagnostiquer', 'traiter']);
      expect(ailleurs.actions.first.maladies, isNull);
      expect(ailleurs.actions.first.toJson().containsKey('maladies'), isFalse);
    });

    test('la maladie analysée doit être choisie parmi les suspectées', () {
      final partie = diagnostiquee();
      final suspectees = partie.maladiesSuspectees('PAT-001').map((m) => m.id);
      final absente = _jeu.maladies
          .map((m) => m.id)
          .firstWhere((id) => !suspectees.contains(id));
      for (final maladie in [null, absente, 'inconnue']) {
        expect(
          (partie.confirmer(
            _labo,
            'analyser',
            maladie: maladie,
          ) as ActionRefusee).message,
          'Choisissez la maladie à analyser parmi les maladies suspectées — '
          'action non appliquée.',
          reason: '$maladie',
        );
      }
      expect(partie.etat.ticks, 1, reason: 'seul le diagnostic a compté');
    });

    test('maladies suspectées : cumulées d\'un diagnostic à l\'autre, sans '
        'doublon, remises à zéro à l\'admission', () {
      final partie = _partie(tirages: [tirageMauxDeTete, 0.5]);
      _appliquer(partie, ['PAT-001'], 'admettre');
      final d1 = _appliquer(partie, _diag, 'diagnostiquer').diagnostic!;
      final d2 = _appliquer(partie, _psy, 'diagnostiquer').diagnostic!;
      final attendues = {
        for (final l in [...d1.maladies, ...d2.maladies]) l.id,
      };
      final suspectees = partie.etat.patients['PAT-001']!.suspectees;
      expect(suspectees.toSet(), attendues);
      expect(suspectees, hasLength(attendues.length));
      expect(suspectees.take(5), d1.maladies.map((l) => l.id));

      partie.etat.patients['PAT-001']!.statut = StatutPatient.sorti;
      _appliquer(partie, ['PAT-001'], 'admettre');
      expect(partie.etat.patients['PAT-001']!.suspectees, isEmpty);
      expect(partie.maladiesSuspectees('PAT-001'), isEmpty);
      expect(partie.maladiesSuspectees('PAT-002'), isEmpty);
    });

    test('passages : compteur commun par maladie, capacité « recherche », '
        'recette révélée puis affichée de nouveau', () {
      final partie = diagnostiquee();
      partie.etat.patients['PAT-001']!.suspecter(['fracture_ouverte']);
      final pv = partie.etat.patients['PAT-001']!.pv;

      final r1 = analyser(partie, _labo, 'fracture_ouverte');
      expect(r1.action, 'analyser');
      expect(
        r1.phrase,
        'Analyse du cas de Mme Garnier par le Dr Moreau au laboratoire de '
        'recherche.',
      );
      expect(r1.analyse!.maladie.id, 'fracture_ouverte');
      expect(r1.analyse!.maladie.nom, 'Fracture ouverte');
      expect(r1.analyse!.maladie.specialite.id, 'orthopedie');
      expect(
        r1.analyse!.passagesRestants,
        3,
        reason: '4 passages ; le Dr Moreau, polyvalent, compte pour 1',
      );
      expect(r1.analyse!.recetteRevelee, isFalse);
      expect(r1.analyse!.recette, isNull);
      expect(r1.pieces, 0, reason: 'une analyse ne rapporte rien');
      expect(r1.presence, 2, reason: 'l\'analyse fait avancer l\'horloge');
      expect(r1.pvApres, pv, reason: 'patient encore stable');
      expect(r1.maladieRevelee, isNull, reason: 'le patient reste en jeu');
      expect(partie.etat.recherche, {'fracture_ouverte': 1});

      // Le microscope (recherche 1) compte pour un passage de plus.
      final r2 = analyser(partie, [..._labo, 'OBJ-017'], 'fracture_ouverte');
      expect(r2.analyse!.passagesRestants, 1);
      expect(r2.analyse!.recette, isNull);
      expect(partie.etat.recherche, {'fracture_ouverte': 3});

      // Un psychiatre n'a pas la spécialité de la fracture : 1 passage.
      final r3 = analyser(partie, [
        'MED-005',
        'PAT-001',
        'SAL-011',
      ], 'fracture_ouverte');
      expect(r3.analyse!.passagesRestants, 0);
      expect(r3.analyse!.recetteRevelee, isTrue);
      expect(
        r3.analyse!.recette,
        '2 médecins de spécialité Orthopédie (l\'un d\'eux peut être '
        'remplacé par un médecin muni du diplôme de cette spécialité), au '
        'bloc opératoire.',
      );
      expect(partie.etat.recherche, {'fracture_ouverte': 4});

      // Le compteur est commun : un autre patient en profite.
      _appliquer(partie, ['PAT-002'], 'admettre');
      partie.etat.patients['PAT-002']!.suspecter(['fracture_ouverte']);
      final r4 = analyser(partie, [
        'MED-002',
        'PAT-002',
        'SAL-011',
      ], 'fracture_ouverte');
      expect(r4.analyse!.passagesRestants, 0);
      expect(r4.analyse!.recette, r3.analyse!.recette);
      expect(partie.etat.recherche, {'fracture_ouverte': 4});
    });

    test('un médecin de la spécialité de la maladie, ou muni du diplôme, '
        'compte pour un passage de plus', () {
      int restants(List<String> cartes) {
        final partie = diagnostiquee();
        partie.etat.patients['PAT-001']!.suspecter(['fracture_ouverte']);
        return analyser(
          partie,
          cartes,
          'fracture_ouverte',
        ).analyse!.passagesRestants;
      }

      expect(restants(_labo), 3, reason: 'polyvalent : 1');
      expect(restants(['MED-007', 'PAT-001', 'SAL-011']), 2, reason: '1 + 1');
      expect(
        restants(['MED-001', 'PAT-001', 'SAL-011', 'DIP-004']),
        2,
        reason: 'diplôme d\'orthopédie : 1 + 1',
      );
      expect(
        restants(['MED-007', 'PAT-001', 'SAL-011', 'OBJ-017']),
        1,
        reason: 'orthopédiste et microscope : 1 + 1 + 1',
      );
      expect(
        restants(['MED-002', 'PAT-001', 'SAL-011', 'DIP-001']),
        3,
        reason: 'médecine générale : pas la spécialité de la fracture',
      );
    });

    test('sans champ « recherche », une maladie se révèle en un passage ; '
        'sans paramètre, pas de bonus de spécialité', () {
      final jeu = jeuExemple((brut) {
        for (final m in brut['maladies'] as List) {
          (m as Map).remove('recherche');
        }
        (brut['parametres'] as Map).remove('recherche');
      });
      expect(jeu.parametres.recherche, isNull);
      final partie = Partie.nouvelle(
        jeu: jeu,
        paquet: _paquet,
        difficulte: 'interne',
        alea: SequenceFixe([tirageFractureOuverte, 0.5]),
      );
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, _diag, 'diagnostiquer');
      partie.etat.patients['PAT-001']!.suspecter(['maux_de_tete']);
      final r = partie.confirmer(
        ['MED-007', 'PAT-001', 'SAL-011'],
        'analyser',
        maladie: 'maux_de_tete',
      );
      final analyse = (r as ActionAppliquee).resultat.analyse!;
      expect(analyse.passagesRestants, 0);
      expect(analyse.recette, isNotEmpty);
      expect(partie.etat.recherche, {'maux_de_tete': 1});
      expect(
        avanceeRecherche(
          jeu,
          Combinaison(jeu, ['MED-007', 'PAT-001', 'SAL-011']),
          'orthopedie',
        ),
        1,
      );
    });

    test('une analyse aggrave le patient et coûte la pénalité d\'attente', () {
      final partie = diagnostiquee();
      final p = partie.etat.patients['PAT-001']!..admission = -30;
      p.suspecter(['fracture_ouverte']);
      final pv = p.pv;
      final r = analyser(partie, _labo, 'fracture_ouverte');
      expect(r.pvApres, pv - 3, reason: 'palier 4 de la fracture ouverte');
      expect(r.attenteDepassee, isTrue);
      expect(r.reputation, -1);
    });

    test('annulation, sauvegarde et résultat sérialisé', () {
      final partie = diagnostiquee();
      partie.etat.patients['PAT-001']!.suspecter(['fracture_ouverte']);
      analyser(partie, _labo, 'fracture_ouverte');
      final r = analyser(partie, _labo, 'fracture_ouverte');

      final json = r.toJson();
      expect(json['analyse'], {
        'maladie': {
          'id': 'fracture_ouverte',
          'nom': 'Fracture ouverte',
          'specialite': {
            'id': 'orthopedie',
            'nom': 'Orthopédie',
            'couleur': '#E66E17',
            'icone': '🦴',
          },
        },
        'passages_restants': 2,
        'recette': null,
      });
      expect(ResultatAction.fromJson(json).toJson(), json);

      final sauvegarde =
          jsonDecode(jsonEncode(partie.sauvegarde())) as Map<String, dynamic>;
      expect(sauvegarde['etat']['format_etat'], 3);
      expect(sauvegarde['etat']['recherche'], {'fracture_ouverte': 2});
      expect(
        sauvegarde['etat']['patients']['PAT-001']['suspectees'],
        contains('fracture_ouverte'),
      );
      final reprise = Partie.restaurer(
        jeu: _jeu,
        sauvegarde: sauvegarde,
        alea: Alea(2),
      );
      expect(reprise.etat.recherche, {'fracture_ouverte': 2});
      expect(
        reprise.maladiesSuspectees('PAT-001').map((m) => m.id),
        partie.maladiesSuspectees('PAT-001').map((m) => m.id),
      );

      partie.annulerDerniereAction();
      expect(partie.etat.recherche, {'fracture_ouverte': 1});
      partie.annulerDerniereAction();
      expect(partie.etat.recherche, isEmpty);
    });

    test('format_etat 2 (sans laboratoire) encore relu', () {
      final partie = diagnostiquee();
      final etat = partie.etat.toJson()
        ..['format_etat'] = 2
        ..remove('recherche');
      (etat['patients']['PAT-001'] as Map).remove('suspectees');
      final relu = EtatPartie.fromJson(
        jsonDecode(jsonEncode(etat)) as Map<String, dynamic>,
      );
      expect(relu.recherche, isEmpty);
      expect(relu.patients['PAT-001']!.suspectees, isEmpty);
      expect(
        () => EtatPartie.fromJson({...etat, 'format_etat': 1}),
        throwsFormatException,
      );
    });

    test('une maladie analysée absente du paquet : avertissement à la '
        'reprise', () {
      final partie = diagnostiquee();
      partie.etat.recherche['maladie_retiree'] = 1;
      partie.etat.patients['PAT-001']!.suspecter(['autre_retiree']);
      final c = CompatibiliteEtat.verifier(partie.etat, _jeu, _paquet);
      expect(c.compatible, isTrue);
      expect(
        c.avertissements.single,
        contains('autre_retiree, maladie_retiree'),
      );
      expect(
        partie.maladiesSuspectees('PAT-001').map((m) => m.id),
        isNot(contains('autre_retiree')),
      );
    });

    test('avec un motif « recherche » déclaré en tête, les combinaisons à '
        '3 cartes hors laboratoire restent standard', () {
      final jeu = jeuExemple((brut) {
        final motifs = brut['motifs'] as Map<String, dynamic>;
        brut['motifs'] = {'recherche': motifs.remove('recherche'), ...motifs};
      });
      expect(jeu.motifs.keys.first, 'recherche');
      final partie = Partie.nouvelle(
        jeu: jeu,
        paquet: _paquet,
        difficulte: 'interne',
        alea: Alea(1),
      );
      _appliquer(partie, ['PAT-001'], 'admettre');
      _appliquer(partie, _diag, 'diagnostiquer');
      List<String> actions(List<String> qrs) => [
        for (final a in (partie.valider(qrs) as SelectionAcceptee).actions)
          a.id,
      ];
      expect(actions(_diag), ['diagnostiquer', 'traiter']);
      expect(actions([..._diag, 'OBJ-001']), ['diagnostiquer', 'traiter']);
      expect(actions(_orthoDeux), ['diagnostiquer', 'traiter']);
      expect(actions(_labo), ['analyser']);
      expect(actions([..._labo, 'OBJ-001']), ['analyser']);
    });
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
