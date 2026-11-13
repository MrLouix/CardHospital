import '../modeles/jeu.dart';

/// Résultat de la reconnaissance d'une sélection de cartes.
sealed class Reconnaissance {
  const Reconnaissance();
}

/// La sélection correspond à au moins un motif : actions de tous les motifs
/// reconnus, dans l'ordre de déclaration des actions. Les préconditions ne
/// sont pas encore évaluées.
class Apercu extends Reconnaissance {
  const Apercu({required this.motifs, required this.actions});

  /// Motifs reconnus, dans l'ordre de déclaration.
  final List<String> motifs;
  final List<ActionJeu> actions;
}

/// La sélection ne correspond à aucun motif : message du premier écart.
class Refus extends Reconnaissance {
  const Refus(this.message);

  final String message;
}

/// Ordre des groupes de types utilisé pour le choix du « motif le plus
/// proche » (point P3 du plan de codage).
const _ordreGroupes = ['patient', 'medecin', 'salle', 'objet|diplome', 'total'];

const _nomsGroupes = {
  'patient': 'patient',
  'medecin': 'médecin',
  'salle': 'salle',
  'objet|diplome': 'accessoire (objet ou diplôme)',
};

/// Reconnaissance des combinaisons : à partir d'une sélection d'identifiants
/// de cartes, détermine les motifs reconnus et les actions proposées, ou le
/// message du premier écart par rapport au motif le plus proche (P3 :
/// moins d'écarts de cardinalité, puis premier écart dans l'ordre
/// patient, médecin, salle, accessoire, total).
///
/// Quand plusieurs motifs correspondent, leurs actions sont réunies : ce
/// sont les préconditions qui départagent (par exemple le laboratoire ne
/// permet que d'analyser, MOTEUR_EFFETS.md §3).
class ReconnaissanceCombinaisons {
  ReconnaissanceCombinaisons(this.jeu);

  final Jeu jeu;

  /// Reconnaît la sélection. Les identifiants inconnus sont ignorés.
  Reconnaissance reconnaitre(List<String> selection) {
    final ids = selection.toSet();
    final cartes = [
      for (final id in ids)
        if (jeu.cartes.containsKey(id)) id,
    ];
    if (cartes.isEmpty) {
      return const Refus('Aucune carte reconnue.');
    }

    final motifs = [
      for (final entry in jeu.motifs.entries)
        if (_correspond(entry.value, cartes)) entry.key,
    ];
    if (motifs.isEmpty) return Refus(_premierEcart(cartes));
    return Apercu(
      motifs: motifs,
      actions: [
        for (final a in jeu.actions)
          if (motifs.contains(a.motif)) a,
      ],
    );
  }

  bool _correspond(Motif motif, List<String> cartes) {
    final comptes = _comptesParGroupe(cartes);
    for (final entry in motif.intervalles.entries) {
      final groupe = entry.key;
      final intervalle = entry.value;
      final compte = comptes[groupe] ?? 0;
      if (compte < intervalle.min || compte > intervalle.max) return false;
    }
    for (final groupe in comptes.keys) {
      if (!motif.intervalles.containsKey(groupe)) return false;
    }
    return true;
  }

  Map<String, int> _comptesParGroupe(List<String> cartes) {
    final comptes = <String, int>{};
    for (final id in cartes) {
      final type = jeu.cartes[id]!.type;
      final groupe = switch (type) {
        TypeCarte.medecin => 'medecin',
        TypeCarte.patient => 'patient',
        TypeCarte.salle => 'salle',
        TypeCarte.objet || TypeCarte.diplome => 'objet|diplome',
      };
      comptes[groupe] = (comptes[groupe] ?? 0) + 1;
    }
    comptes['total'] = cartes.length;
    return comptes;
  }

  String _premierEcart(List<String> cartes) {
    final comptes = _comptesParGroupe(cartes);
    final candidats = jeu.motifs.entries
        .map((e) => (motif: e.value, score: _scoreEcart(e.value, comptes)))
        .toList();
    candidats.sort((a, b) {
      if (a.score != b.score) return a.score.compareTo(b.score);
      final satisfaitA = _groupesSatisfaits(a.motif, comptes);
      final satisfaitB = _groupesSatisfaits(b.motif, comptes);
      return satisfaitB.compareTo(satisfaitA);
    });
    final motif = candidats.first.motif;
    for (final groupe in _ordreGroupes) {
      final intervalle = motif.intervalles[groupe];
      if (intervalle == null) continue;
      final compte = comptes[groupe] ?? 0;
      if (groupe == 'total') {
        if (compte < intervalle.min) {
          return intervalle.min == 1
              ? 'Il faut au moins une carte.'
              : 'Il faut au moins ${intervalle.min} cartes.';
        }
        if (compte > intervalle.max) {
          return '${intervalle.max} cartes au maximum.';
        }
        continue;
      }
      final nom = _nomsGroupes[groupe]!;
      if (compte < intervalle.min) {
        if (intervalle.min == 1) return 'Il faut une carte $nom.';
        return 'Il faut au moins ${intervalle.min} cartes $nom.';
      }
      if (compte > intervalle.max) {
        if (intervalle.max == 1) return 'Une seule carte $nom par action.';
        return '${intervalle.max} cartes $nom au maximum.';
      }
    }
    for (final groupe in comptes.keys) {
      if (!motif.intervalles.containsKey(groupe) && groupe != 'total') {
        final nom = _nomsGroupes[groupe] ?? groupe;
        return 'Aucune carte $nom attendue ici.';
      }
    }
    return 'Sélection non conforme.';
  }

  int _scoreEcart(Motif motif, Map<String, int> comptes) {
    var score = 0;
    for (final groupe in _ordreGroupes) {
      final intervalle = motif.intervalles[groupe];
      if (intervalle == null) continue;
      final compte = comptes[groupe] ?? 0;
      if (compte < intervalle.min) {
        score += intervalle.min - compte;
      } else if (compte > intervalle.max) {
        score += compte - intervalle.max;
      }
    }
    for (final groupe in comptes.keys) {
      if (!motif.intervalles.containsKey(groupe)) {
        score += comptes[groupe]!;
      }
    }
    return score;
  }

  int _groupesSatisfaits(Motif motif, Map<String, int> comptes) {
    var satisfaits = 0;
    for (final entry in motif.intervalles.entries) {
      final compte = comptes[entry.key] ?? 0;
      if (compte >= entry.value.min && compte <= entry.value.max) satisfaits++;
    }
    return satisfaits;
  }
}
