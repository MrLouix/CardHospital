import 'dart:convert';
import 'dart:math' as math;

import '../modeles/jeu.dart';
import '../moteur/alea.dart';
import '../moteur/etat.dart';
import '../moteur/partie.dart';
import '../moteur/resultat.dart';
import 'strategies.dart';

/// Paramètres d'une simulation.
class ParametresSimulation {
  const ParametresSimulation({
    this.graine = 1,
    this.parties = 1000,
    this.patientsParPartie = 10,
    this.patientsEnJeu = 3,
    this.joueurs = 1,
    this.partages = const [true],
    this.actionsMax = 60,
  });

  /// Graine du hasard : même graine, même rapport.
  final int graine;

  /// Nombre de parties simulées par stratégie et par difficulté.
  final int parties;

  /// Patients admis au cours d'une partie.
  final int patientsParPartie;

  /// Nombre de patients en jeu à la fois (N des règles de table), au plus le
  /// nombre de cartes patient du paquet.
  final int patientsEnJeu;

  /// Nombre de joueurs, qui jouent à tour de rôle (une action par tour).
  final int joueurs;

  /// Modes simulés quand il y a plusieurs joueurs : `true`, les résultats
  /// des diagnostics sont mis en commun ; `false`, chacun ne voit que les
  /// siens.
  final List<bool> partages;

  /// Au-delà, le patient est abandonné (compté à part).
  final int actionsMax;

  Map<String, dynamic> toJson() => {
    'graine': graine,
    'parties': parties,
    'patients_par_partie': patientsParPartie,
    'patients_en_jeu': patientsEnJeu,
    'joueurs': joueurs,
    'partages': partages,
    'actions_max': actionsMax,
  };
}

/// Mesures par maladie.
class StatsMaladie {
  int patients = 0;
  int gueris = 0;
  int morts = 0;
  int actions = 0;

  Map<String, dynamic> toJson() => {
    'patients': patients,
    'gueris': gueris,
    'morts': morts,
    'actions': actions,
  };
}

/// Mesures d'une stratégie à un niveau de difficulté.
class StatsStrategie {
  StatsStrategie(this.strategie, this.difficulte, {this.partage});

  final String strategie;
  final String difficulte;

  /// Mode d'information, quand il y a plusieurs joueurs (sinon nul).
  final bool? partage;

  /// Guérisons faites par un joueur qui n'avait pas diagnostiqué ce patient,
  /// alors qu'un autre l'avait fait : il profite du diagnostic d'autrui.
  int guerisonsParAutrui = 0;

  /// Écart de pièces entre le joueur le plus riche et le plus pauvre, à la
  /// fin de chaque partie.
  final ecartsPieces = <int>[];

  double get partGuerisonsParAutrui =>
      gueris == 0 ? 0 : guerisonsParAutrui / gueris;
  double get ecartPiecesMoyen => ecartsPieces.isEmpty
      ? 0
      : ecartsPieces.fold(0, (a, b) => a + b) / ecartsPieces.length;

  int patients = 0;
  int gueris = 0;
  int morts = 0;
  int abandons = 0;

  /// Actions hors admission.
  int actions = 0;
  int diagnostics = 0;
  int pieces = 0;
  int reputation = 0;

  /// Réputation cumulée en fin de partie, et minimum atteint en cours de
  /// partie (par rapport à 0), pour chaque partie simulée.
  final reputationFinale = <int>[];
  final reputationMin = <int>[];

  final parMaladie = <String, StatsMaladie>{};

  double get tauxGuerison => patients == 0 ? 0 : gueris / patients;
  double get tauxMort => patients == 0 ? 0 : morts / patients;
  double get actionsParPatient => patients == 0 ? 0 : actions / patients;
  double get piecesParAction => actions == 0 ? 0 : pieces / actions;
  double get reputationParAction => actions == 0 ? 0 : reputation / actions;
  double get reputationParPatient => patients == 0 ? 0 : reputation / patients;

  Map<String, dynamic> toJson() => {
    'strategie': strategie,
    'difficulte': difficulte,
    if (partage != null) 'partage': partage,
    if (partage != null) 'guerisons_par_autrui': guerisonsParAutrui,
    if (partage != null) 'ecart_pieces_moyen': _arrondi(ecartPiecesMoyen, 2),
    'patients': patients,
    'gueris': gueris,
    'morts': morts,
    'abandons': abandons,
    'actions': actions,
    'diagnostics': diagnostics,
    'pieces': pieces,
    'reputation': reputation,
    'taux_guerison': _arrondi(tauxGuerison, 4),
    'actions_par_patient': _arrondi(actionsParPatient, 3),
    'pieces_par_action': _arrondi(piecesParAction, 3),
    'reputation_par_action': _arrondi(reputationParAction, 3),
    'reputation_finale': _centiles(reputationFinale),
    'reputation_min': _centiles(reputationMin),
    'par_maladie': parMaladie.map((id, s) => MapEntry(id, s.toJson())),
  };
}

/// Rapport complet d'une simulation.
class RapportSimulation {
  RapportSimulation(this.jeu, this.parametres, this.resultats);

  final Jeu jeu;
  final ParametresSimulation parametres;
  final List<StatsStrategie> resultats;

  Map<String, dynamic> toJson() => {
    'paquet': {'id': jeu.id, 'version': jeu.version},
    'parametres': parametres.toJson(),
    'resultats': resultats.map((r) => r.toJson()).toList(),
  };

  String enJson() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// Rapport lisible en Markdown.
  String enMarkdown() {
    final b = StringBuffer()
      ..writeln('# Rapport de simulation — ${jeu.nom} ${jeu.version}')
      ..writeln()
      ..writeln(
        'Graine ${parametres.graine} · ${parametres.parties} parties de '
        '${parametres.patientsParPartie} patients par stratégie et par '
        'difficulté, ${parametres.patientsEnJeu} patients en jeu à la fois, '
        '${parametres.joueurs == 1 ? '1 joueur' : '${parametres.joueurs} joueurs à tour de rôle'} '
        '· abandon au-delà de ${parametres.actionsMax} actions sur un '
        'patient.',
      )
      ..writeln()
      ..writeln('## Synthèse')
      ..writeln()
      ..writeln(
        '| Stratégie | Difficulté | Guérison | Mort | Abandon | '
        'Actions / patient | Diagnostics / patient | Pièces / action | '
        'Réputation / action | Réputation / patient |',
      )
      ..writeln('|---|---|---:|---:|---:|---:|---:|---:|---:|---:|');
    for (final r in resultats) {
      b.writeln(
        '| ${r.strategie} | ${_nomDifficulte(r.difficulte)} '
        '| ${_pct(r.tauxGuerison)} | ${_pct(r.tauxMort)} '
        '| ${r.abandons} | ${_dec(r.actionsParPatient)} '
        '| ${_dec(r.patients == 0 ? 0 : r.diagnostics / r.patients)} '
        '| ${_dec(r.piecesParAction)} | ${_dec(r.reputationParAction)} '
        '| ${_dec(r.reputationParPatient)} |',
      );
    }
    b
      ..writeln()
      ..writeln('## Réputation sur une partie')
      ..writeln()
      ..writeln(
        'Cumul des impacts sur une partie (départ à 0). « Minimum » est le '
        'point le plus bas atteint en cours de partie : pour qu\'au plus 5 % '
        'des parties ferment, l\'écart entre la valeur de départ et le seuil '
        'de fermeture doit dépasser l\'opposé du 5ᵉ centile du minimum.',
      )
      ..writeln()
      ..writeln(
        '| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | '
        'Minimum C5 | Minimum C50 |',
      )
      ..writeln('|---|---|---:|---:|---:|---:|---:|');
    for (final r in resultats) {
      final f = _centiles(r.reputationFinale);
      final m = _centiles(r.reputationMin);
      b.writeln(
        '| ${r.strategie} | ${_nomDifficulte(r.difficulte)} '
        '| ${f['c5']} | ${f['c50']} | ${f['c95']} | ${m['c5']} | ${m['c50']} |',
      );
    }
    if (resultats.any((r) => r.partage != null)) {
      b
        ..writeln()
        ..writeln('## Joueurs')
        ..writeln()
        ..writeln(
          '« Par un autre » : part des guérisons faites par un joueur qui '
          'n\'avait pas diagnostiqué le patient, alors qu\'un autre l\'avait '
          'fait. « Écart de pièces » : écart moyen, en fin de partie, entre le '
          'joueur le plus riche et le plus pauvre.',
        )
        ..writeln()
        ..writeln(
          '| Stratégie | Difficulté | Informations | Guérison | '
          'Réputation / patient | Par un autre | Écart de pièces |',
        )
        ..writeln('|---|---|---|---:|---:|---:|---:|');
      for (final r in resultats) {
        b.writeln(
          '| ${r.strategie} | ${_nomDifficulte(r.difficulte)} '
          '| ${r.partage! ? 'partagées' : 'privées'} '
          '| ${_pct(r.tauxGuerison)} | ${_dec(r.reputationParPatient)} '
          '| ${_pct(r.partGuerisonsParAutrui)} | ${_dec(r.ecartPiecesMoyen, 1)} |',
        );
      }
    }
    b
      ..writeln()
      ..writeln('## Par maladie')
      ..writeln()
      ..writeln(
        'Taux de guérison et actions par patient, par stratégie, au niveau '
        '${_nomDifficulte(resultats.first.difficulte)}.',
      )
      ..writeln();
    final premier = resultats.first.difficulte;
    final duNiveau = resultats.where((r) => r.difficulte == premier).toList();
    b
      ..writeln(
        '| Maladie | Spécialité | Poids | ${duNiveau.map((r) => r.strategie).join(' | ')} |',
      )
      ..writeln('|---|---|---:|${duNiveau.map((_) => '---:').join('|')}|');
    for (final m in jeu.maladies) {
      final cellules = [
        for (final r in duNiveau)
          _cellule(r.parMaladie[m.id] ?? StatsMaladie()),
      ];
      b.writeln(
        '| ${m.nom} | ${m.specialite} | ${m.poids ?? 1} | ${cellules.join(' | ')} |',
      );
    }
    return b.toString();
  }

  String _nomDifficulte(String id) =>
      jeu.difficultes.firstWhere((d) => d.id == id).nom;

  static String _cellule(StatsMaladie s) => s.patients == 0
      ? '—'
      : '${_pct(s.gueris / s.patients)} en ${_dec(s.actions / s.patients)}';
}

/// Simulateur de parties automatiques (phase 1 de la feuille de route).
///
/// Une partie partage une seule horloge : jusqu'à
/// [ParametresSimulation.patientsEnJeu] patients sont en jeu à la fois et
/// pris en charge à tour de rôle, dans l'ordre d'admission. Chaque patient
/// a sa propre instance de la stratégie. Dès qu'un patient sort, un autre
/// est admis, jusqu'à [ParametresSimulation.patientsParPartie] admissions.
/// Les cartes des patients sortis, même morts, sont réutilisées : la
/// défausse des règles de table n'est pas simulée.
class Simulateur {
  Simulateur(this.jeu, {this.parametres = const ParametresSimulation()})
    : _catalogue = CatalogueCombinaisons(jeu) {
    _cartesPatient = [
      for (final e in jeu.cartes.entries)
        if (e.value.type == TypeCarte.patient) e.key,
    ];
    if (_cartesPatient.isEmpty) {
      throw ArgumentError('le paquet ne contient aucune carte patient');
    }
    for (final id in [actionAdmettre, actionDiagnostiquer, actionTraiter]) {
      if (!jeu.actions.any((a) => a.id == id)) {
        throw ArgumentError('le paquet ne définit pas l\'action « $id »');
      }
    }
  }

  final Jeu jeu;
  final ParametresSimulation parametres;
  final CatalogueCombinaisons _catalogue;
  late final List<String> _cartesPatient;

  static const _paquet = IdentitePaquet(
    id: 'simulation',
    version: '0.0.0',
    empreinte: 'sha256:',
  );

  /// Simule chaque stratégie à chaque niveau de [difficultes] (tous par
  /// défaut).
  RapportSimulation simuler(
    List<Strategie> strategies, {
    List<String>? difficultes,
  }) {
    final niveaux = difficultes ?? jeu.difficultes.map((d) => d.id).toList();
    final modes = parametres.joueurs > 1 ? parametres.partages : [null];
    final resultats = <StatsStrategie>[];
    for (var n = 0; n < niveaux.length; n++) {
      for (var m = 0; m < modes.length; m++) {
        for (var s = 0; s < strategies.length; s++) {
          // Une graine dérivée par (stratégie, niveau, mode) : ajouter une
          // stratégie ou un mode ne change pas les autres résultats.
          final graine =
              parametres.graine * 1000003 + n * 1009 + s * 7919 + m * 104729;
          resultats.add(
            _simulerStrategie(
              strategies[s],
              niveaux[n],
              Alea(graine),
              partage: modes[m],
            ),
          );
        }
      }
    }
    return RapportSimulation(jeu, parametres, resultats);
  }

  StatsStrategie _simulerStrategie(
    Strategie strategie,
    String difficulte,
    SourceAleatoire alea, {
    bool? partage,
  }) {
    final nom = partage == null
        ? strategie.nom
        : '${strategie.nom} · ${partage ? 'partage' : 'privé'}';
    final stats = StatsStrategie(nom, difficulte, partage: partage);
    final joueurs = parametres.joueurs < 1 ? 1 : parametres.joueurs;
    final enJeuMax = parametres.patientsEnJeu.clamp(1, _cartesPatient.length);
    for (var p = 0; p < parametres.parties; p++) {
      final partie = Partie.nouvelle(
        jeu: jeu,
        paquet: _paquet,
        difficulte: difficulte,
        alea: alea,
      );
      final libres = [..._cartesPatient];
      final enJeu = <_PatientSimule>[];
      final piecesJoueurs = List.filled(joueurs, 0);
      // Recettes vues réussir : communes si les joueurs partagent leurs
      // informations, propres à chacun sinon.
      final carnetCommun = Carnet(_catalogue);
      final carnets = [
        for (var j = 0; j < joueurs; j++)
          partage == false ? Carnet(_catalogue) : carnetCommun,
      ];
      var tour = 0;
      var admissions = 0;
      var cumul = 0;
      var minimum = 0;
      while (true) {
        while (enJeu.length < enJeuMax &&
            admissions < parametres.patientsParPartie &&
            libres.isNotEmpty) {
          final carte = libres.removeAt(0);
          _appliquer(partie, [carte], actionAdmettre);
          admissions++;
          final maladie = partie.etat.patients[carte]!.maladie;
          enJeu.add(
            _PatientSimule(carte, [
              for (var j = 0; j < joueurs; j++)
                strategie.nouvelle(carnet: carnets[j])..debutPatient(),
            ], stats.parMaladie.putIfAbsent(maladie, StatsMaladie.new)),
          );
          stats.patients++;
          enJeu.last.stats.patients++;
        }
        if (enJeu.isEmpty) break;

        // Le joueur du tour traite d'abord un patient qu'il est prêt à
        // soigner ; sinon il prend en charge le suivant dans la file.
        final joueur = tour % joueurs;
        tour++;
        List<ResultatAction> visible(_PatientSimule s) =>
            partage == false ? s.parJoueur[joueur] : s.historique;
        final pret = enJeu.indexWhere(
          (s) => s.strategies[joueur].pret(visible(s), _catalogue),
        );
        final suivi = enJeu.removeAt(pret < 0 ? 0 : pret);
        if (suivi.historique.length >= parametres.actionsMax) {
          // Abandonné : il reste en jeu dans le moteur, sa carte n'est pas
          // libérée.
          stats.abandons++;
          continue;
        }
        final choix = suivi.strategies[joueur].choisir(
          visible(suivi),
          _catalogue,
          alea,
        );
        final r = _appliquer(partie, [
          suivi.carte,
          ...choix.cartes,
        ], choix.action);
        suivi.historique.add(r);
        if (partage == false) suivi.parJoueur[joueur].add(r);
        if (r.diagnostic != null) suivi.diagnostiqueurs.add(joueur);
        carnets[joueur].noter(r);
        piecesJoueurs[joueur] += r.pieces;
        stats.actions++;
        suivi.stats.actions++;
        if (r.diagnostic != null) stats.diagnostics++;
        stats.pieces += r.pieces;
        stats.reputation += r.reputation;
        cumul += r.reputation;
        if (cumul < minimum) minimum = cumul;
        switch (r.issue ?? IssuePatient.enJeu) {
          case IssuePatient.enJeu:
            enJeu.add(suivi);
          case IssuePatient.gueri:
            stats.gueris++;
            suivi.stats.gueris++;
            if (suivi.diagnostiqueurs.isNotEmpty &&
                !suivi.diagnostiqueurs.contains(joueur)) {
              stats.guerisonsParAutrui++;
            }
            libres.add(suivi.carte);
          case IssuePatient.mort:
            stats.morts++;
            suivi.stats.morts++;
            libres.add(suivi.carte);
        }
      }
      stats.reputationFinale.add(cumul);
      stats.reputationMin.add(minimum);
      if (partage != null) {
        stats.ecartsPieces.add(
          piecesJoueurs.reduce(math.max) - piecesJoueurs.reduce(math.min),
        );
      }
    }
    return stats;
  }

  ResultatAction _appliquer(Partie partie, List<String> qrs, String action) {
    final reponse = partie.confirmer(qrs, action);
    return switch (reponse) {
      ActionAppliquee(:final resultat) => resultat,
      ActionRefusee(:final message) => throw StateError(
        'action « $action » refusée pendant la simulation : $message',
      ),
    };
  }
}

/// Centiles 5, 50 et 95 (rang le plus proche).
Map<String, int?> _centiles(List<int> valeurs) {
  if (valeurs.isEmpty) return {'c5': null, 'c50': null, 'c95': null};
  final tri = [...valeurs]..sort();
  int rang(double q) =>
      tri[((q * tri.length).ceil() - 1).clamp(0, tri.length - 1)];
  return {'c5': rang(0.05), 'c50': rang(0.5), 'c95': rang(0.95)};
}

double _arrondi(double x, int decimales) =>
    double.parse(x.toStringAsFixed(decimales));

String _pct(double x) => '${_dec(x * 100, 1)} %';

String _dec(double x, [int decimales = 2]) =>
    x.toStringAsFixed(decimales).replaceAll('.', ',');

/// Un patient en jeu pendant une simulation : sa carte, une stratégie par
/// joueur, et l'historique de ses résultats depuis son admission (commun,
/// et par joueur pour les informations privées).
class _PatientSimule {
  _PatientSimule(this.carte, this.strategies, this.stats)
    : parJoueur = [for (final _ in strategies) <ResultatAction>[]];

  final String carte;
  final List<Strategie> strategies;
  final StatsMaladie stats;
  final historique = <ResultatAction>[];
  final List<List<ResultatAction>> parJoueur;

  /// Joueurs qui ont diagnostiqué ce patient.
  final diagnostiqueurs = <int>{};
}
