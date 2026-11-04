import 'dart:math' as math;

import '../modeles/jeu.dart';
import 'alea.dart';
import 'combinaison.dart';

/// Une ligne d'une distribution affichée : un type, un nom de maladie, ou le
/// regroupement « Autres » ([id] nul).
class LigneDistribution {
  const LigneDistribution({
    required this.id,
    required this.nom,
    required this.pourcentage,
  });

  factory LigneDistribution.fromJson(Map<String, dynamic> json) =>
      LigneDistribution(
        id: json['id'] as String?,
        nom: json['nom'] as String,
        pourcentage: json['pourcentage'] as int,
      );

  /// Libellé du regroupement des lignes non détaillées.
  static const libelleAutres = 'Autres';

  final String? id;
  final String nom;
  final int pourcentage;

  bool get estAutres => id == null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'pourcentage': pourcentage,
  };
}

/// Résultat d'un diagnostic (MODELE_DE_JEU.md §8).
class ResultatDiagnostic {
  const ResultatDiagnostic({
    required this.niveau,
    required this.types,
    this.noms,
  });

  factory ResultatDiagnostic.fromJson(Map<String, dynamic> json) =>
      ResultatDiagnostic(
        niveau: json['niveau'] as int,
        types: _lignes(json['types'])!,
        noms: _lignes(json['noms']),
      );

  /// Niveau de précision `N` utilisé.
  final int niveau;

  /// Distribution sur le type, en pourcentages entiers de somme 100, triée
  /// par pourcentage décroissant, « Autres » en dernier.
  final List<LigneDistribution> types;

  /// Distribution sur les noms des maladies du vrai type, présente seulement
  /// si le vrai type est une spécialité de la combinaison.
  final List<LigneDistribution>? noms;

  Map<String, dynamic> toJson() => {
    'niveau': niveau,
    'types': types.map((l) => l.toJson()).toList(),
    'noms': noms?.map((l) => l.toJson()).toList(),
  };

  static List<LigneDistribution>? _lignes(dynamic json) => (json as List?)
      ?.map((e) => LigneDistribution.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Calcul du diagnostic probabiliste (MODELE_DE_JEU.md §8).
class Diagnostiqueur {
  Diagnostiqueur(this.jeu, this.alea);

  final Jeu jeu;
  final SourceAleatoire alea;

  Diagnostic get _p => jeu.parametres.diagnostic;

  /// Niveau de précision : `min(precision_max, capacité « precision »)`.
  int niveau(Combinaison combinaison) =>
      math.max(0, math.min(_p.precisionMax, combinaison.capacite('precision')));

  /// Tire un diagnostic de la maladie [vraie] avec la [combinaison].
  ResultatDiagnostic diagnostiquer(Maladie vraie, Combinaison combinaison) {
    final n = niveau(combinaison);
    final sc = combinaison.specialites;

    // §8.3 : distribution sur le type.
    final typesMaladies = jeu.maladies.map((m) => m.type).toSet();
    final types = jeu.specialites
        .where((s) => typesMaladies.contains(s.id))
        .toList();
    final poidsTypes = <double>[];
    for (final t in types) {
      var w = alea.exponentielle();
      final estVrai = t.id == vraie.type;
      if (estVrai) w *= 1 + _p.verite + _p.parNiveau * n;
      if (sc.contains(t.id)) {
        w *= estVrai ? 1 + _p.bonusSpecialite : _p.exclusion;
      }
      poidsTypes.add(w);
    }
    final lignesTypes = _lignesTriees([
      for (var i = 0; i < types.length; i++)
        (id: types[i].id, nom: types[i].nom),
    ], pourcentagesPlusFortReste(poidsTypes));
    final affichees = <LigneDistribution>[];
    var autres = 0;
    var regroupees = 0;
    for (final l in lignesTypes) {
      if (l.pourcentage < _p.seuilAffichage) {
        autres += l.pourcentage;
        regroupees++;
      } else {
        affichees.add(l);
      }
    }
    if (regroupees > 0 && autres > 0) affichees.add(_autres(autres));

    // §8.4 : distribution sur le nom, si le vrai type est dans S(C).
    List<LigneDistribution>? noms;
    if (sc.contains(vraie.type)) {
      final maladies = jeu.maladies.where((m) => m.type == vraie.type).toList();
      final poids = [
        for (final m in maladies)
          alea.exponentielle() *
              (m.id == vraie.id ? 1 + _p.veriteNom + _p.parNiveauNom * n : 1),
      ];
      final lignes = _lignesTriees([
        for (final m in maladies) (id: m.id, nom: m.nom),
      ], pourcentagesPlusFortReste(poids));
      noms = lignes.take(_p.nbNoms).toList();
      final reste = lignes
          .skip(_p.nbNoms)
          .fold<int>(0, (s, l) => s + l.pourcentage);
      if (reste > 0) noms.add(_autres(reste));
    }

    return ResultatDiagnostic(niveau: n, types: affichees, noms: noms);
  }

  static LigneDistribution _autres(int pourcentage) => LigneDistribution(
    id: null,
    nom: LigneDistribution.libelleAutres,
    pourcentage: pourcentage,
  );

  /// Lignes triées par pourcentage décroissant (ordre de déclaration en cas
  /// d'égalité).
  static List<LigneDistribution> _lignesTriees(
    List<({String id, String nom})> entrees,
    List<int> pourcentages,
  ) {
    final lignes = [
      for (var i = 0; i < entrees.length; i++)
        (
          i,
          LigneDistribution(
            id: entrees[i].id,
            nom: entrees[i].nom,
            pourcentage: pourcentages[i],
          ),
        ),
    ];
    lignes.sort((a, b) {
      final c = b.$2.pourcentage.compareTo(a.$2.pourcentage);
      return c != 0 ? c : a.$1.compareTo(b.$1);
    });
    return [for (final l in lignes) l.$2];
  }
}

/// Pourcentages entiers de somme 100 proportionnels à [poids], par la
/// méthode du plus fort reste (égalités départagées par l'ordre).
List<int> pourcentagesPlusFortReste(List<double> poids) {
  if (poids.isEmpty) return const [];
  final total = poids.fold<double>(0, (a, b) => a + b);
  if (total <= 0) {
    // Cas dégénéré : répartition uniforme.
    return pourcentagesPlusFortReste(List.filled(poids.length, 1));
  }
  final exacts = [for (final w in poids) w / total * 100];
  final parts = [for (final e in exacts) e.floor()];
  var manquant = 100 - parts.fold<int>(0, (a, b) => a + b);
  final ordre = List.generate(poids.length, (i) => i)
    ..sort((a, b) {
      final c = (exacts[b] - parts[b]).compareTo(exacts[a] - parts[a]);
      return c != 0 ? c : a.compareTo(b);
    });
  for (var k = 0; manquant > 0; k = (k + 1) % ordre.length, manquant--) {
    parts[ordre[k]]++;
  }
  return parts;
}
