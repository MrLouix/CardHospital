import 'dart:math' as math;

import '../modeles/jeu.dart';
import '../moteur/alea.dart';
import '../moteur/combinaison.dart';
import '../moteur/diagnostic.dart';
import '../moteur/etat.dart';
import '../moteur/partie.dart';
import '../moteur/reconnaissance.dart';
import '../moteur/resultat.dart';
import '../validation/validateur.dart';

/// Identifiants des actions du paquet de base utilisées par le simulateur.
const actionAdmettre = 'admettre';
const actionDiagnostiquer = 'diagnostiquer';
const actionTraiter = 'traiter';
const actionAnalyser = 'analyser';

/// Choix d'une stratégie : une action, les cartes hors patient et, pour une
/// analyse, la maladie choisie.
typedef Choix = ({String action, List<String> cartes, String? maladie});

/// Combinaisons standard du paquet (hors patient), indexées pour les
/// stratégies.
class CatalogueCombinaisons {
  factory CatalogueCombinaisons(Jeu jeu) {
    final combinaisons = Validateur.combinaisonsPossibles(jeu);
    final sansPatient = [
      for (final c in combinaisons)
        [
          for (final id in c.ids)
            if (jeu.cartes[id]!.type != TypeCarte.patient) id,
        ],
    ];
    final precisionMax = jeu.parametres.diagnostic.precisionMax;
    final precisions = [
      for (final c in combinaisons)
        c.capacite('precision').clamp(0, precisionMax),
    ];
    final adaptes = {
      for (final m in jeu.maladies)
        m.id: [
          for (var i = 0; i < combinaisons.length; i++)
            if (combinaisons[i].satisfait(m.traitement.adapte)) i,
        ],
    };
    return CatalogueCombinaisons._(
      jeu,
      sansPatient,
      {for (var i = 0; i < sansPatient.length; i++) _cle(sansPatient[i]): i},
      [for (final c in combinaisons) c.specialites],
      precisions,
      adaptes,
      _recherches(jeu),
    );
  }

  CatalogueCombinaisons._(
    this.jeu,
    this.cartes,
    this._indices,
    this._specialites,
    this._precisions,
    this._adaptes,
    this.recherches,
  );

  /// Combinaisons (hors patient) avec lesquelles l'action `analyser` est
  /// proposée, de la plus grande capacité `recherche` à la plus petite.
  /// Vide si le paquet n'a pas cette action.
  final List<List<String>> recherches;

  static List<List<String>> _recherches(Jeu jeu) {
    final analyser = jeu.actions
        .where((a) => a.id == actionAnalyser)
        .firstOrNull;
    final patient = jeu.cartes.entries
        .where((e) => e.value.type == TypeCarte.patient)
        .firstOrNull
        ?.key;
    if (analyser == null || patient == null) return const [];
    List<String> deType(bool Function(TypeCarte) t) => [
      for (final e in jeu.cartes.entries)
        if (t(e.value.type)) e.key,
    ];
    final reconnaissance = ReconnaissanceCombinaisons(jeu);
    final trouvees = <(List<String>, int)>[];
    for (final m in deType((t) => t == TypeCarte.medecin)) {
      for (final s in deType((t) => t == TypeCarte.salle)) {
        for (final a in [
          null,
          ...deType((t) => t == TypeCarte.objet || t == TypeCarte.diplome),
        ]) {
          final cartes = [m, s, ?a];
          final r = reconnaissance.reconnaitre([patient, ...cartes]);
          final c = Combinaison(jeu, [patient, ...cartes]);
          if (r is Apercu &&
              r.motifs.contains(analyser.motif) &&
              (analyser.precondition == null ||
                  c.permet(analyser.precondition!))) {
            trouvees.add((cartes, c.capacite(capaciteRecherche)));
          }
        }
      }
    }
    trouvees.sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final (cartes, _) in trouvees) cartes];
  }

  /// Combinaisons d'analyse de meilleure capacité `recherche`.
  List<List<String>> meilleuresRecherches() {
    if (recherches.isEmpty) return const [];
    final c = Combinaison(jeu, recherches.first);
    final max = c.capacite(capaciteRecherche);
    return [
      for (final r in recherches)
        if (Combinaison(jeu, r).capacite(capaciteRecherche) == max) r,
    ];
  }

  final Jeu jeu;

  /// Cartes hors patient de chaque combinaison.
  final List<List<String>> cartes;
  final Map<String, int> _indices;
  final List<Set<String>> _specialites;
  final _thematiques = <String, List<(int, int)>>{};

  static String _cle(Iterable<String> cartes) =>
      ([...cartes]..sort()).join(',');

  /// Indice de la combinaison formée de [cartes] (hors patient), s'il y en
  /// a une.
  int? indice(Iterable<String> cartes) => _indices[_cle(cartes)];

  /// Combinaisons qui portent la couleur de [specialite], avec leur score :
  /// le nombre de leurs cartes (médecins, salle, accessoire) de cette
  /// spécialité. Ce qu'un joueur qui ne connaît pas les traitements
  /// essaierait d'abord.
  List<(int, int)> thematiques(String specialite) =>
      _thematiques.putIfAbsent(specialite, () {
        return [
          for (var i = 0; i < length; i++)
            if (_score(i, specialite) case final s when s > 0) (i, s),
        ];
      });

  int _score(int i, String specialite) =>
      cartes[i].where((id) => jeu.cartes[id]!.specialite == specialite).length;
  final List<int> _precisions;
  final Map<String, List<int>> _adaptes;

  int get length => cartes.length;

  /// Combinaisons qui soignent la maladie [maladie].
  List<int> adaptees(String maladie) => _adaptes[maladie] ?? const [];

  /// Combinaisons de meilleure précision dont les spécialités sont
  /// exactement [specialites] (vide : aucune spécialité, donc aucune
  /// exclusion). Toutes les combinaisons si aucune ne convient.
  List<int> meilleursDiagnostics(Set<String> specialites) {
    final candidates = [
      for (var i = 0; i < length; i++)
        if (_specialites[i].length == specialites.length &&
            _specialites[i].containsAll(specialites))
          i,
    ];
    if (candidates.isEmpty) return List.generate(length, (i) => i);
    final max = candidates
        .map((i) => _precisions[i])
        .reduce((a, b) => a > b ? a : b);
    return [
      for (final i in candidates)
        if (_precisions[i] == max) i,
    ];
  }

  List<String> tirer(List<int> indices, SourceAleatoire alea) =>
      cartes[indices[(alea.flottant() * indices.length).floor()]];
}

/// Carnet de recettes d'un joueur pendant une partie : les combinaisons
/// qu'il a vu guérir un patient, par maladie et par spécialité. Le
/// simulateur le tient à jour ; il est commun à tous les joueurs quand ils
/// partagent leurs informations.
class Carnet {
  Carnet(this.catalogue)
    : _specialiteDe = {
        for (final m in catalogue.jeu.maladies) m.id: m.specialite,
      };

  final CatalogueCombinaisons catalogue;
  final Map<String, String> _specialiteDe;
  final _parMaladie = <String, int>{};
  final _parSpecialite = <String, List<int>>{};

  /// Nombre de maladies dont la recette est connue.
  int get recettes => _parMaladie.length;

  /// Combinaison qui a guéri [maladie], si on l'a vue.
  int? recette(String maladie) => _parMaladie[maladie];

  /// Combinaisons qui ont guéri une maladie de [specialite], de la plus
  /// récente à la plus ancienne.
  List<int> recettesDe(String specialite) =>
      _parSpecialite[specialite] ?? const [];

  /// Note le résultat [r] : une guérison révèle la maladie et la recette ;
  /// une analyse terminée au laboratoire révèle la recette, et le joueur
  /// retient l'une des combinaisons qui la satisfont.
  void noter(ResultatAction r) {
    final analyse = r.analyse;
    if (analyse != null && analyse.recetteRevelee) {
      final id = analyse.maladie.id;
      final adaptees = catalogue.adaptees(id);
      final specialite = _specialiteDe[id];
      if (adaptees.isNotEmpty && specialite != null) {
        _retenir(id, specialite, _parMaladie[id] ?? adaptees.first);
      }
      return;
    }
    final m = r.maladieRevelee;
    if (r.issue != IssuePatient.gueri || m == null) return;
    final i = catalogue.indice([
      for (final id in r.cartes)
        if (id != r.patient) id,
    ]);
    final specialite = _specialiteDe[m.id];
    if (i == null || specialite == null) return;
    _retenir(m.id, specialite, i);
  }

  void _retenir(String maladie, String specialite, int i) {
    _parMaladie[maladie] = i;
    _parSpecialite.putIfAbsent(specialite, () => [])
      ..remove(i)
      ..insert(0, i);
  }
}

/// Stratégie de jeu automatique. Elle voit les résultats des actions sur le
/// patient courant et les spécialités des cartes.
///
/// Les stratégies `seuil` et `couleur` connaissent aussi les traitements des
/// maladies, alors que le livret de règles ne les donne pas
/// (REGLES_DE_TABLE.md §9) : elles jouent comme des joueurs vétérans. La
/// stratégie `novice` ne les connaît pas et les apprend pendant la partie.
abstract class Strategie {
  /// Nom affiché dans le rapport.
  String get nom;

  /// Appelé à chaque nouveau patient admis.
  void debutPatient() {}

  /// Nouvelle instance de la même stratégie, sans mémoire : le simulateur
  /// en crée une par patient et par joueur. [carnet] : les recettes que ce
  /// joueur a vu réussir pendant la partie (stratégie novice).
  Strategie nouvelle({Carnet? carnet});

  /// Au vu de l'[historique] visible, la stratégie veut-elle traiter ce
  /// patient maintenant ? Sert à choisir le patient pris en charge quand
  /// plusieurs joueurs se partagent les patients.
  bool pret(List<ResultatAction> historique, CatalogueCombinaisons catalogue) =>
      false;

  /// Choisit la prochaine action sur le patient, au vu de l'[historique]
  /// de ses résultats depuis l'admission (exclue).
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  );

  /// Stratégie décrite par [description] : `hasard`, `seuil:<X>`,
  /// `couleur:<X>`, `novice:<X>` ou `novice+labo:<X>`.
  static Strategie depuis(String description) {
    final parties = description.split(':');
    int seuil() {
      final x = parties.length > 1 ? int.tryParse(parties[1]) : null;
      if (x == null || x < 0 || x > 100) {
        throw FormatException('seuil attendu entre 0 et 100 : $description');
      }
      return x;
    }

    switch (parties.first) {
      case 'hasard':
        return StrategieHasard();
      case 'seuil':
        return StrategieSeuil(seuil());
      case 'couleur':
        return StrategieCouleur(seuil());
      case 'novice':
        return StrategieNovice(seuil());
      case 'novice+labo':
        return StrategieNovice(seuil(), labo: true);
    }
    throw FormatException('stratégie inconnue : $description');
  }
}

/// Traiter ou diagnostiquer au hasard, avec une combinaison au hasard.
class StrategieHasard extends Strategie {
  @override
  String get nom => 'hasard';

  @override
  Strategie nouvelle({Carnet? carnet}) => StrategieHasard();

  @override
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  ) {
    final action = alea.flottant() < 0.5 ? actionDiagnostiquer : actionTraiter;
    final i = (alea.flottant() * catalogue.length).floor();
    return (action: action, cartes: catalogue.cartes[i], maladie: null);
  }
}

/// Diagnostiquer sans spécialité, avec la meilleure précision, jusqu'à ce
/// que la maladie en tête de liste (non encore essayée) atteigne l'indice de
/// suspicion [seuil], puis la traiter. Un traitement qui échoue relance le diagnostic.
class StrategieSeuil extends Strategie {
  StrategieSeuil(this.seuil);

  final int seuil;
  final _essayees = <String>{};

  @override
  String get nom => 'seuil:$seuil';

  @override
  void debutPatient() => _essayees.clear();

  @override
  Strategie nouvelle({Carnet? carnet}) => StrategieSeuil(seuil);

  LigneDiagnostic? _candidate(List<ResultatAction> historique) => historique
      .lastOrNull
      ?.diagnostic
      ?.maladies
      .where((l) => !_essayees.contains(l.id))
      .firstOrNull;

  @override
  bool pret(List<ResultatAction> historique, CatalogueCombinaisons catalogue) {
    final c = _candidate(historique);
    return c != null &&
        c.indice >= seuil &&
        catalogue.adaptees(c.id).isNotEmpty;
  }

  /// Spécialités de la combinaison du prochain diagnostic.
  Set<String> specialitesDiagnostic(List<ResultatAction> historique) =>
      const {};

  @override
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  ) {
    final candidate = _candidate(historique);
    if (candidate != null && candidate.indice >= seuil) {
      final combinaisons = catalogue.adaptees(candidate.id);
      if (combinaisons.isNotEmpty) {
        _essayees.add(candidate.id);
        return (
          action: actionTraiter,
          cartes: catalogue.tirer(combinaisons, alea),
          maladie: null,
        );
      }
    }
    return (
      action: actionDiagnostiquer,
      cartes: catalogue.tirer(
        catalogue.meilleursDiagnostics(specialitesDiagnostic(historique)),
        alea,
      ),
      maladie: null,
    );
  }
}

/// Suivre la couleur : comme [StrategieSeuil], mais après un premier
/// diagnostic sans spécialité, chaque diagnostic se fait avec la spécialité
/// dominante de la dernière liste (la couleur qui a le plus de lignes), pour
/// la confirmer ou l'écarter.
class StrategieCouleur extends StrategieSeuil {
  StrategieCouleur(super.seuil);

  @override
  Strategie nouvelle({Carnet? carnet}) => StrategieCouleur(seuil);

  @override
  String get nom => 'couleur:$seuil';

  @override
  Set<String> specialitesDiagnostic(List<ResultatAction> historique) {
    final diagnostic = historique.reversed
        .map((r) => r.diagnostic)
        .whereType<ResultatDiagnostic>()
        .firstOrNull;
    if (diagnostic == null) return const {};
    return {diagnostic.specialiteDominante};
  }
}

/// Joueur novice : il ne connaît pas les traitements.
///
/// Il diagnostique comme [StrategieSeuil] jusqu'à ce que la maladie en tête
/// atteigne [seuil]. Pour la soigner, il essaie dans l'ordre : la recette
/// qu'il connaît pour cette maladie (vue guérir, ou révélée par une
/// analyse), puis celles qui ont guéri une maladie de la même spécialité,
/// puis la combinaison la plus « assortie » à la couleur de la maladie (le
/// plus de cartes de sa spécialité ; au hasard parmi les ex æquo). Après
/// [essais] échecs sur une maladie, il l'écarte et passe à la suivante, ou
/// diagnostique de nouveau.
///
/// Avec [labo], il analyse au laboratoire une maladie dont il ne connaît pas
/// la recette avant d'essayer quoi que ce soit, jusqu'à ce que l'analyse la
/// révèle, avec la combinaison de meilleure capacité `recherche`.
class StrategieNovice extends Strategie {
  StrategieNovice(
    this.seuil, {
    this.carnet,
    this.essais = 2,
    this.labo = false,
  });

  final int seuil;
  final int essais;

  /// Analyse au laboratoire les maladies dont la recette est inconnue.
  final bool labo;

  /// Recettes vues réussir pendant la partie (fourni par le simulateur).
  final Carnet? carnet;
  final _ecartees = <String>{};
  final _tentees = <String, Set<int>>{};

  @override
  String get nom => labo ? 'novice+labo:$seuil' : 'novice:$seuil';

  @override
  void debutPatient() {
    _ecartees.clear();
    _tentees.clear();
  }

  @override
  Strategie nouvelle({Carnet? carnet}) =>
      StrategieNovice(seuil, carnet: carnet, essais: essais, labo: labo);

  /// Faut-il analyser [c] au laboratoire avant de la traiter ?
  bool _analyser(LigneDiagnostic c, CatalogueCombinaisons catalogue) =>
      labo &&
      catalogue.recherches.isNotEmpty &&
      carnet?.recette(c.id) == null &&
      !(_tentees[c.id]?.isNotEmpty ?? false);

  LigneDiagnostic? _candidate(List<ResultatAction> historique) => historique
      .reversed
      .map((r) => r.diagnostic)
      .whereType<ResultatDiagnostic>()
      .firstOrNull
      ?.maladies
      .where((l) => !_ecartees.contains(l.id))
      .firstOrNull;

  /// Prochaine combinaison à essayer pour [c], ou `null` s'il n'y en a plus.
  /// Sans [alea], renvoie seulement s'il en reste une.
  int? _essai(
    LigneDiagnostic c,
    CatalogueCombinaisons catalogue,
    SourceAleatoire? alea,
  ) {
    final tentees = _tentees[c.id] ?? const <int>{};
    final connue = carnet?.recette(c.id);
    if (connue != null && !tentees.contains(connue)) return connue;
    for (final i in carnet?.recettesDe(c.specialite.id) ?? const <int>[]) {
      if (!tentees.contains(i)) return i;
    }
    final pistes = [
      for (final (i, score) in catalogue.thematiques(c.specialite.id))
        if (!tentees.contains(i)) (i, score),
    ];
    if (pistes.isEmpty) return null;
    if (alea == null) return pistes.first.$1;
    // La plus « assortie » d'abord : le plus de cartes de la spécialité ;
    // au hasard parmi les ex æquo.
    final meilleur = pistes.map((p) => p.$2).reduce(math.max);
    final ex = [
      for (final (i, score) in pistes)
        if (score == meilleur) i,
    ];
    return ex[(alea.flottant() * ex.length).floor()];
  }

  @override
  bool pret(List<ResultatAction> historique, CatalogueCombinaisons catalogue) {
    final c = _candidate(historique);
    return c != null &&
        c.indice >= seuil &&
        (_analyser(c, catalogue) || _essai(c, catalogue, null) != null);
  }

  @override
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  ) {
    var c = _candidate(historique);
    while (c != null && c.indice >= seuil) {
      if (_analyser(c, catalogue)) {
        final recherches = catalogue.meilleuresRecherches();
        return (
          action: actionAnalyser,
          cartes: recherches[(alea.flottant() * recherches.length).floor()],
          maladie: c.id,
        );
      }
      final i = _essai(c, catalogue, alea);
      if (i != null) {
        final tentees = _tentees.putIfAbsent(c.id, () => {})..add(i);
        if (tentees.length >= essais) _ecartees.add(c.id);
        return (
          action: actionTraiter,
          cartes: catalogue.cartes[i],
          maladie: null,
        );
      }
      _ecartees.add(c.id);
      c = _candidate(historique);
    }
    return (
      action: actionDiagnostiquer,
      cartes: catalogue.tirer(catalogue.meilleursDiagnostics(const {}), alea),
      maladie: null,
    );
  }
}
