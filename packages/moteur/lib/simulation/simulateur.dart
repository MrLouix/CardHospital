import 'dart:convert';

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
    this.actionsMax = 60,
  });

  /// Graine du hasard : même graine, même rapport.
  final int graine;

  /// Nombre de parties simulées par stratégie et par difficulté.
  final int parties;

  /// Patients admis au cours d'une partie.
  final int patientsParPartie;

  /// Au-delà, le patient est abandonné (compté à part).
  final int actionsMax;

  Map<String, dynamic> toJson() => {
    'graine': graine,
    'parties': parties,
    'patients_par_partie': patientsParPartie,
    'actions_max': actionsMax,
  };
}

/// Mesures par maladie.
class StatsMaladie {
  int patients = 0;
  int soignes = 0;
  int morts = 0;
  int actions = 0;

  Map<String, dynamic> toJson() => {
    'patients': patients,
    'soignes': soignes,
    'morts': morts,
    'actions': actions,
  };
}

/// Mesures d'une stratégie à un niveau de difficulté.
class StatsStrategie {
  StatsStrategie(this.strategie, this.difficulte);

  final String strategie;
  final String difficulte;

  int patients = 0;
  int soignes = 0;
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

  double get tauxGuerison => patients == 0 ? 0 : soignes / patients;
  double get tauxMort => patients == 0 ? 0 : morts / patients;
  double get actionsParPatient => patients == 0 ? 0 : actions / patients;
  double get piecesParAction => actions == 0 ? 0 : pieces / actions;
  double get reputationParAction => actions == 0 ? 0 : reputation / actions;
  double get reputationParPatient => patients == 0 ? 0 : reputation / patients;

  Map<String, dynamic> toJson() => {
    'strategie': strategie,
    'difficulte': difficulte,
    'patients': patients,
    'soignes': soignes,
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
        'difficulté · abandon au-delà de ${parametres.actionsMax} actions.',
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
        '| Maladie | Type | Poids | ${duNiveau.map((r) => r.strategie).join(' | ')} |',
      )
      ..writeln('|---|---|---:|${duNiveau.map((_) => '---:').join('|')}|');
    for (final m in jeu.maladies) {
      final cellules = [
        for (final r in duNiveau)
          _cellule(r.parMaladie[m.id] ?? StatsMaladie()),
      ];
      b.writeln(
        '| ${m.nom} | ${m.type} | ${m.poids ?? 1} | ${cellules.join(' | ')} |',
      );
    }
    return b.toString();
  }

  String _nomDifficulte(String id) =>
      jeu.difficultes.firstWhere((d) => d.id == id).nom;

  static String _cellule(StatsMaladie s) => s.patients == 0
      ? '—'
      : '${_pct(s.soignes / s.patients)} en ${_dec(s.actions / s.patients)}';
}

/// Simulateur de parties automatiques (phase 1 de la feuille de route).
///
/// Le temps étant propre à chaque patient, une partie est simulée patient
/// par patient : l'ordre d'entrelacement des patients ne change pas leur
/// évolution.
class Simulateur {
  Simulateur(this.jeu, {this.parametres = const ParametresSimulation()})
    : _catalogue = CatalogueCombinaisons(jeu) {
    _patient = jeu.cartes.entries
        .firstWhere(
          (e) => e.value.type == TypeCarte.patient,
          orElse: () =>
              throw ArgumentError('le paquet ne contient aucune carte patient'),
        )
        .key;
    for (final id in [actionAdmettre, actionDiagnostiquer, actionTraiter]) {
      if (!jeu.actions.any((a) => a.id == id)) {
        throw ArgumentError('le paquet ne définit pas l\'action « $id »');
      }
    }
  }

  final Jeu jeu;
  final ParametresSimulation parametres;
  final CatalogueCombinaisons _catalogue;
  late final String _patient;

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
    final resultats = <StatsStrategie>[];
    for (var n = 0; n < niveaux.length; n++) {
      for (var s = 0; s < strategies.length; s++) {
        // Une graine dérivée par couple (stratégie, niveau) : ajouter une
        // stratégie ne change pas les résultats des autres.
        final graine = parametres.graine * 1000003 + n * 1009 + s * 7919;
        resultats.add(
          _simulerStrategie(strategies[s], niveaux[n], Alea(graine)),
        );
      }
    }
    return RapportSimulation(jeu, parametres, resultats);
  }

  StatsStrategie _simulerStrategie(
    Strategie strategie,
    String difficulte,
    SourceAleatoire alea,
  ) {
    final stats = StatsStrategie(strategie.nom, difficulte);
    for (var p = 0; p < parametres.parties; p++) {
      var cumul = 0;
      var minimum = 0;
      for (var i = 0; i < parametres.patientsParPartie; i++) {
        final partie = Partie.nouvelle(
          jeu: jeu,
          paquet: _paquet,
          difficulte: difficulte,
          alea: alea,
        );
        _appliquer(partie, [_patient], actionAdmettre);
        final maladie = partie.etat.patients[_patient]!.maladie;
        final parMaladie = stats.parMaladie.putIfAbsent(
          maladie,
          StatsMaladie.new,
        );
        stats.patients++;
        parMaladie.patients++;
        strategie.debutPatient();

        final historique = <ResultatAction>[];
        var issue = IssuePatient.enJeu;
        while (issue == IssuePatient.enJeu) {
          if (historique.length >= parametres.actionsMax) {
            stats.abandons++;
            break;
          }
          final choix = strategie.choisir(historique, _catalogue, alea);
          final r = _appliquer(partie, [
            _patient,
            ...choix.cartes,
          ], choix.action);
          historique.add(r);
          stats.actions++;
          parMaladie.actions++;
          if (r.diagnostic != null) stats.diagnostics++;
          stats.pieces += r.pieces;
          stats.reputation += r.reputation;
          cumul += r.reputation;
          if (cumul < minimum) minimum = cumul;
          issue = r.issue ?? IssuePatient.enJeu;
        }
        if (issue == IssuePatient.soigne) {
          stats.soignes++;
          parMaladie.soignes++;
        } else if (issue == IssuePatient.mort) {
          stats.morts++;
          parMaladie.morts++;
        }
      }
      stats.reputationFinale.add(cumul);
      stats.reputationMin.add(minimum);
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
