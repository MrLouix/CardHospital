import 'dart:math' as math;

import '../modeles/jeu.dart';
import 'alea.dart';
import 'combinaison.dart';

/// Spécialité d'une maladie listée, avec de quoi l'afficher sans le paquet
/// (un client ne connaît pas forcément le paquet actif de l'hôte).
class SpecialiteAffichee {
  const SpecialiteAffichee({
    required this.id,
    required this.nom,
    required this.couleur,
    required this.icone,
  });

  factory SpecialiteAffichee.depuis(Specialite s) => SpecialiteAffichee(
    id: s.id,
    nom: s.nom,
    couleur: s.couleur,
    icone: s.icone,
  );

  factory SpecialiteAffichee.fromJson(Map<String, dynamic> json) =>
      SpecialiteAffichee(
        id: json['id'] as String,
        nom: json['nom'] as String,
        couleur: json['couleur'] as String,
        icone: json['icone'] as String,
      );

  final String id;
  final String nom;
  final String couleur;
  final String icone;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'couleur': couleur,
    'icone': icone,
  };
}

/// Une maladie de la liste d'un diagnostic.
class LigneDiagnostic {
  const LigneDiagnostic({
    required this.id,
    required this.nom,
    required this.pourcentage,
    required this.specialite,
  });

  factory LigneDiagnostic.fromJson(Map<String, dynamic> json) =>
      LigneDiagnostic(
        id: json['id'] as String,
        nom: json['nom'] as String,
        pourcentage: json['pourcentage'] as int,
        specialite: SpecialiteAffichee.fromJson(
          json['specialite'] as Map<String, dynamic>,
        ),
      );

  final String id;
  final String nom;

  /// Confiance que cette maladie est la bonne, de 0 à 99 %. Les pourcentages
  /// des lignes sont indépendants : ils ne somment pas à 100.
  final int pourcentage;
  final SpecialiteAffichee specialite;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'pourcentage': pourcentage,
    'specialite': specialite.toJson(),
  };
}

/// Résultat d'un diagnostic (MODELE_DE_JEU.md §8).
class ResultatDiagnostic {
  const ResultatDiagnostic({required this.niveau, required this.maladies});

  factory ResultatDiagnostic.fromJson(Map<String, dynamic> json) =>
      ResultatDiagnostic(
        niveau: json['niveau'] as int,
        maladies: [
          for (final l in json['maladies'] as List)
            LigneDiagnostic.fromJson(l as Map<String, dynamic>),
        ],
      );

  /// Niveau de précision `N` utilisé.
  final int niveau;

  /// Les maladies les plus probables, par pourcentage décroissant.
  final List<LigneDiagnostic> maladies;

  /// Spécialité dont les maladies totalisent le plus de pourcentage dans la
  /// liste (la première rencontrée en cas d'égalité) : la piste que la liste
  /// suggère de confirmer par un diagnostic avec cette spécialité.
  String get specialiteDominante {
    final totaux = <String, int>{};
    for (final l in maladies) {
      totaux[l.specialite.id] = (totaux[l.specialite.id] ?? 0) + l.pourcentage;
    }
    return totaux.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  }

  Map<String, dynamic> toJson() => {
    'niveau': niveau,
    'maladies': maladies.map((l) => l.toJson()).toList(),
  };
}

/// Pourcentage maximal affiché : un diagnostic n'affiche jamais de certitude.
const pourcentageMax = 99;

/// Calcul du diagnostic probabiliste (MODELE_DE_JEU.md §8.3).
class Diagnostiqueur {
  factory Diagnostiqueur(Jeu jeu, SourceAleatoire alea) {
    final specialites = {for (final s in jeu.specialites) s.id: s};
    final parType = <String, int>{};
    for (final m in jeu.maladies) {
      parType[m.type] = (parType[m.type] ?? 0) + 1;
    }
    final moyenne = jeu.maladies.length / parType.length;
    final p = jeu.parametres.diagnostic;
    return Diagnostiqueur._(
      jeu,
      alea,
      {
        for (final m in jeu.maladies)
          m.id: SpecialiteAffichee.depuis(specialites[m.type]!),
      },
      {for (final e in parType.entries) e.key: e.value / moyenne},
      maximumAttenduBruit(moyenne),
      -math.log(1 - p.scoreBruit / 100),
    );
  }

  Diagnostiqueur._(
    this.jeu,
    this.alea,
    this._specialites,
    this._exposants,
    this._reference,
    this._pente,
  );

  final Jeu jeu;
  final SourceAleatoire alea;
  final Map<String, SpecialiteAffichee> _specialites;

  /// `n_t / n̄` par type : exposant de la correction du bruit.
  final Map<String, double> _exposants;

  /// Maximum attendu du bruit seul, `H(n̄)`.
  final double _reference;

  /// `k = −ln(1 − score_bruit / 100)`.
  final double _pente;

  Diagnostic get _p => jeu.parametres.diagnostic;

  /// Niveau de précision : `min(precision_max, capacité « precision »)`.
  int niveau(Combinaison combinaison) =>
      math.max(0, math.min(_p.precisionMax, combinaison.capacite('precision')));

  /// Tire un diagnostic de la maladie [vraie] avec la [combinaison].
  ResultatDiagnostic diagnostiquer(Maladie vraie, Combinaison combinaison) {
    final n = niveau(combinaison);
    final sc = combinaison.specialites;
    final poids = <(Maladie, double)>[];
    for (final m in jeu.maladies) {
      // 1. Bruit corrigé : le maximum de chaque type suit la même loi que
      //    celui de n̄ tirages exponentiels, quel que soit son nombre de
      //    maladies.
      var w = -math.log(
        1 - math.pow(alea.flottant(), _exposants[m.type]!).toDouble(),
      );
      final vraiType = m.type == vraie.type;
      // 2. Affinité du vrai type.
      if (vraiType) w *= 1 + _p.affiniteType;
      // 3. Vraie maladie.
      if (m.id == vraie.id) w *= 1 + _p.verite + _p.parNiveau * n;
      // 4. Spécialités de la combinaison : concordance ou exclusion.
      if (sc.contains(m.type)) {
        w *= vraiType ? 1 + _p.bonusSpecialite : _p.exclusion;
      }
      poids.add((m, w));
    }
    // 5. Tri par poids décroissant (ordre de déclaration en cas d'égalité).
    final indices = List.generate(poids.length, (i) => i)
      ..sort((a, b) {
        final c = poids[b].$2.compareTo(poids[a].$2);
        return c != 0 ? c : a.compareTo(b);
      });
    return ResultatDiagnostic(
      niveau: n,
      maladies: [
        for (final i in indices.take(_p.tailleListe))
          LigneDiagnostic(
            id: poids[i].$1.id,
            nom: poids[i].$1.nom,
            pourcentage: pourcentage(poids[i].$2),
            specialite: _specialites[poids[i].$1.id]!,
          ),
      ],
    );
  }

  /// 6. Pourcentage affiché pour un poids : `100 × (1 − e^(−k·w/H))`,
  /// arrondi, plafonné à [pourcentageMax].
  int pourcentage(double poids) => math.min(
    pourcentageMax,
    (100 * (1 - math.exp(-_pente * poids / _reference))).round(),
  );
}

/// Maximum attendu de [n] tirages exponentiels de paramètre 1, généralisé aux
/// réels : `H(n) = ψ(n + 1) + γ` (nombre harmonique pour n entier).
double maximumAttenduBruit(double n) => _digamma(n + 1) + _euler;

const _euler = 0.5772156649015329;

double _digamma(double x) {
  var resultat = 0.0;
  var y = x;
  while (y < 10) {
    resultat -= 1 / y;
    y += 1;
  }
  final y2 = 1 / (y * y);
  return resultat +
      math.log(y) -
      1 / (2 * y) -
      y2 * (1 / 12 - y2 * (1 / 120 - y2 / 252));
}
