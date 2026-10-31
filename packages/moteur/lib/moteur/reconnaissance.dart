import '../modeles/jeu.dart';

/// Résultat de la reconnaissance d'une sélection de cartes.
sealed class Reconnaissance {
  const Reconnaissance();
}

/// La sélection correspond à un motif : liste des actions proposées.
class Apercu extends Reconnaissance {
  const Apercu({required this.motif, required this.actions});

  final String motif;
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
  'total': 'total',
};

/// Reconnaissance des combinaisons : à partir d'une sélection d'identifiants
/// de cartes, détermine le motif reconnu et les actions proposées, ou le
/// message du premier écart par rapport au motif le plus proche (P3 :
/// moins d'écarts de cardinalité, puis premier écart dans l'ordre
/// patient, médecin, salle, accessoire, total).
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

    for (final entry in jeu.motifs.entries) {
      if (_correspond(entry.value, cartes)) {
        final actions = jeu.actions.where((a) => a.motif == entry.key).toList();
        return Apercu(motif: entry.key, actions: actions);
      }
    }
    return Refus(_premierEcart(cartes));
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
      final nom = _nomsGroupes[groupe]!;
      if (compte < intervalle.min) {
        if (intervalle.min == 1) return 'Il faut une carte $nom.';
        return 'Il faut au moins ${intervalle.min} cartes $nom.';
      }
      if (compte > intervalle.max) {
        if (intervalle.max == 1) return 'Une seule carte $nom par action.';
        return '${intervalle.max} cartes $nom maximum.';
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
