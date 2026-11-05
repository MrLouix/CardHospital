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
    required this.indice,
    required this.specialite,
  });

  factory LigneDiagnostic.fromJson(Map<String, dynamic> json) =>
      LigneDiagnostic(
        id: json['id'] as String,
        nom: json['nom'] as String,
        indice: json['indice'] as int,
        specialite: SpecialiteAffichee.fromJson(
          json['specialite'] as Map<String, dynamic>,
        ),
      );

  final String id;
  final String nom;

  /// Indice de suspicion, de 0 à [indiceMax]. Ce n'est pas une probabilité :
  /// les indices des lignes sont indépendants et ne somment pas à 100.
  final int indice;
  final SpecialiteAffichee specialite;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'indice': indice,
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

  /// Les maladies les plus suspectes, par indice décroissant.
  final List<LigneDiagnostic> maladies;

  /// Couleur dominante : la spécialité qui a le plus de lignes dans la liste
  /// (« 3 bleus sur 5 »). En cas d'égalité, celle qui apparaît la première,
  /// donc la mieux classée. C'est la piste que la liste suggère de confirmer
  /// par un diagnostic avec cette spécialité.
  String get specialiteDominante {
    final lignes = <String, int>{};
    for (final l in maladies) {
      lignes[l.specialite.id] = (lignes[l.specialite.id] ?? 0) + 1;
    }
    return lignes.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  }

  Map<String, dynamic> toJson() => {
    'niveau': niveau,
    'maladies': maladies.map((l) => l.toJson()).toList(),
  };
}

/// Indice de suspicion maximal affiché : un diagnostic n'affiche jamais de
/// certitude.
const indiceMax = 99;

/// Calcul du diagnostic probabiliste (MODELE_DE_JEU.md §8.3).
class Diagnostiqueur {
  factory Diagnostiqueur(Jeu jeu, SourceAleatoire alea) {
    final specialites = {for (final s in jeu.specialites) s.id: s};
    final parSpecialite = <String, int>{};
    for (final m in jeu.maladies) {
      parSpecialite[m.specialite] = (parSpecialite[m.specialite] ?? 0) + 1;
    }
    final moyenne = jeu.maladies.length / parSpecialite.length;
    final p = jeu.parametres.diagnostic;
    return Diagnostiqueur._(
      jeu,
      alea,
      {
        for (final m in jeu.maladies)
          m.id: SpecialiteAffichee.depuis(specialites[m.specialite]!),
      },
      {for (final e in parSpecialite.entries) e.key: e.value / moyenne},
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

  /// `n_s / n̄` par spécialité : exposant de la correction du bruit.
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
      // 1. Bruit corrigé : le maximum de chaque spécialité suit la même loi
      //    que celui de n̄ tirages exponentiels, quel que soit son nombre de
      //    maladies.
      var w = -math.log(
        1 - math.pow(alea.flottant(), _exposants[m.specialite]!).toDouble(),
      );
      final vraieSpecialite = m.specialite == vraie.specialite;
      // 2. Affinité de la vraie spécialité.
      if (vraieSpecialite) w *= 1 + _p.affiniteSpecialite;
      // 3. Vraie maladie.
      if (m.id == vraie.id) w *= 1 + _p.verite + _p.parNiveau * n;
      // 4. Spécialités de la combinaison : concordance ou exclusion.
      if (sc.contains(m.specialite)) {
        w *= vraieSpecialite ? 1 + _p.bonusSpecialite : _p.exclusion;
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
            indice: indice(poids[i].$2),
            specialite: _specialites[poids[i].$1.id]!,
          ),
      ],
    );
  }

  /// 6. Indice de suspicion affiché pour un poids : `100 × (1 − e^(−k·w/H))`,
  /// arrondi, plafonné à [indiceMax].
  int indice(double poids) => math.min(
    indiceMax,
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
