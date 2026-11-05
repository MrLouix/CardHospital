import 'essai.dart';

/// Synthèse d'un ensemble d'essais, pour suivre les critères de sortie de la
/// phase 0 (FEUILLE_DE_ROUTE.md).
class Statistiques {
  factory Statistiques(Iterable<ResultatEssai> essais) {
    final liste = essais.toList();
    final durees = [
      for (final e in liste)
        if (e.reussi) e.duree,
    ]..sort();
    return Statistiques._(
      essais: liste.length,
      reussis: durees.length,
      moinsDe3s: liste.where((e) => e.moinsDe3s).length,
      mediane: durees.isEmpty ? null : durees[(durees.length - 1) ~/ 2],
      faussesLectures: liste.fold(0, (s, e) => s + e.faussesLectures.length),
      essaisAvecFausseSelection: liste
          .where((e) => e.faussesDansSelection.isNotEmpty)
          .length,
    );
  }

  const Statistiques._({
    required this.essais,
    required this.reussis,
    required this.moinsDe3s,
    required this.mediane,
    required this.faussesLectures,
    required this.essaisAvecFausseSelection,
  });

  final int essais;
  final int reussis;

  /// Essais réussis en moins de 3 s.
  final int moinsDe3s;

  /// Temps médian des essais réussis (médiane basse).
  final Duration? mediane;

  /// Total des contenus lus qui n'étaient pas des cartes attendues.
  final int faussesLectures;

  /// Essais où une fausse lecture est entrée dans la sélection.
  final int essaisAvecFausseSelection;

  double get tauxMoinsDe3s => essais == 0 ? 0 : moinsDe3s / essais;

  /// Critère de sortie : au moins 95 % des essais en moins de 3 s.
  bool get critereTemps => essais > 0 && tauxMoinsDe3s >= 0.95;

  /// Critère de sortie : aucune fausse lecture (sur au moins 200 essais).
  bool get critereFaussesLectures => essais >= 200 && faussesLectures == 0;
}
