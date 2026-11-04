import '../modeles/jeu.dart';
import '../moteur/alea.dart';
import '../moteur/diagnostic.dart';
import '../moteur/resultat.dart';
import '../validation/validateur.dart';

/// Identifiants des actions du paquet de base utilisées par le simulateur.
const actionAdmettre = 'admettre';
const actionDiagnostiquer = 'diagnostiquer';
const actionTraiter = 'traiter';

/// Choix d'une stratégie : une action et les cartes hors patient.
typedef Choix = ({String action, List<String> cartes});

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
      [for (final c in combinaisons) c.specialites],
      precisions,
      adaptes,
    );
  }

  CatalogueCombinaisons._(
    this.jeu,
    this.cartes,
    this._specialites,
    this._precisions,
    this._adaptes,
  );

  final Jeu jeu;

  /// Cartes hors patient de chaque combinaison.
  final List<List<String>> cartes;
  final List<Set<String>> _specialites;
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

/// Stratégie de jeu automatique. Elle ne voit que ce que voit un joueur :
/// les résultats des actions sur le patient courant et les règles publiques
/// du paquet (spécialités des cartes, traitements des maladies, supposés
/// connus des joueurs via le livret de règles).
abstract class Strategie {
  /// Nom affiché dans le rapport.
  String get nom;

  /// Appelé à chaque nouveau patient admis.
  void debutPatient() {}

  /// Choisit la prochaine action sur le patient, au vu de l'[historique]
  /// de ses résultats depuis l'admission (exclue).
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  );

  /// Stratégie décrite par [description] : `hasard`, `seuil:<X>` ou
  /// `specialite`.
  static Strategie depuis(String description) {
    final parties = description.split(':');
    switch (parties.first) {
      case 'hasard':
        return StrategieHasard();
      case 'seuil':
        final x = parties.length > 1 ? int.tryParse(parties[1]) : null;
        if (x == null || x < 0 || x > 100) {
          throw FormatException('seuil attendu entre 0 et 100 : $description');
        }
        return StrategieSeuil(x);
      case 'specialite':
        return StrategieSpecialite();
    }
    throw FormatException('stratégie inconnue : $description');
  }
}

/// Traiter ou diagnostiquer au hasard, avec une combinaison au hasard.
class StrategieHasard extends Strategie {
  @override
  String get nom => 'hasard';

  @override
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  ) {
    final action = alea.flottant() < 0.5 ? actionDiagnostiquer : actionTraiter;
    final i = (alea.flottant() * catalogue.length).floor();
    return (action: action, cartes: catalogue.cartes[i]);
  }
}

/// Diagnostiquer sans spécialité, avec la meilleure précision, jusqu'à ce
/// que le type en tête atteigne [seuil] %, puis traiter avec un traitement
/// adapté d'une maladie de ce type (la plus probable si les noms sont
/// connus). Un traitement qui échoue relance le diagnostic.
class StrategieSeuil extends Strategie {
  StrategieSeuil(this.seuil);

  final int seuil;
  final _essayees = <String>{};

  @override
  String get nom => 'seuil:$seuil';

  @override
  void debutPatient() => _essayees.clear();

  @override
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  ) {
    final diagnostic = historique.lastOrNull?.diagnostic;
    final tete = diagnostic?.types.firstOrNull;
    if (diagnostic != null &&
        tete != null &&
        !tete.estAutres &&
        tete.pourcentage >= seuil) {
      final traitement = _traiterProbable(
        catalogue,
        tete.id!,
        diagnostic.noms,
        _essayees,
        alea,
      );
      if (traitement != null) return traitement;
    }
    return (
      action: actionDiagnostiquer,
      cartes: catalogue.tirer(catalogue.meilleursDiagnostics(const {}), alea),
    );
  }
}

/// Se fier à la spécialité : diagnostiquer avec une seule spécialité à la
/// fois. La liste des noms n'apparaît que si le vrai type est une spécialité
/// de la combinaison : son absence exclut la spécialité testée, sa présence
/// confirme le type. On traite alors la maladie la plus probable non encore
/// essayée.
class StrategieSpecialite extends Strategie {
  final _exclues = <String>{};
  final _essayees = <String>{};
  String? _type;
  String? _testee;

  @override
  String get nom => 'specialite';

  @override
  void debutPatient() {
    _exclues.clear();
    _essayees.clear();
    _type = null;
    _testee = null;
  }

  @override
  Choix choisir(
    List<ResultatAction> historique,
    CatalogueCombinaisons catalogue,
    SourceAleatoire alea,
  ) {
    final diagnostic = historique.lastOrNull?.diagnostic;
    if (diagnostic != null && _type == null && _testee != null) {
      if (diagnostic.noms != null) {
        _type = _testee;
      } else {
        _exclues.add(_testee!);
      }
    }

    final type = _type;
    if (type != null) {
      final traitement = _traiterProbable(
        catalogue,
        type,
        _derniersNoms(historique),
        _essayees,
        alea,
      );
      if (traitement != null) return traitement;
    }

    final typesMaladies = catalogue.jeu.maladies.map((m) => m.type).toSet();
    var restants = [
      for (final s in catalogue.jeu.specialites)
        if (typesMaladies.contains(s.id) && !_exclues.contains(s.id)) s.id,
    ];
    if (restants.isEmpty) {
      _exclues.clear();
      restants = [...typesMaladies];
    }
    // Spécialité la plus probable d'après le dernier diagnostic.
    final ordre = [
      for (final l in diagnostic?.types ?? const <LigneDistribution>[])
        if (restants.contains(l.id)) l.id!,
      ...restants,
    ];
    final testee = _testee = ordre.first;
    return (
      action: actionDiagnostiquer,
      cartes: catalogue.tirer(catalogue.meilleursDiagnostics({testee}), alea),
    );
  }

  static List<LigneDistribution>? _derniersNoms(
    List<ResultatAction> historique,
  ) {
    for (final r in historique.reversed) {
      final noms = r.diagnostic?.noms;
      if (noms != null) return noms;
    }
    return null;
  }
}

/// Traite la maladie la plus probable du [type] non encore [essayees] :
/// selon la distribution des [noms] si elle est connue, puis par poids
/// décroissant. Quand toutes ont été essayées, le tour recommence. `null` si
/// aucune maladie du type n'a de traitement réalisable.
Choix? _traiterProbable(
  CatalogueCombinaisons catalogue,
  String type,
  List<LigneDistribution>? noms,
  Set<String> essayees,
  SourceAleatoire alea,
) {
  final duType = catalogue.jeu.maladies.where((m) => m.type == type).toList()
    ..sort((a, b) => (b.poids ?? 1).compareTo(a.poids ?? 1));
  final ids = duType.map((m) => m.id).toSet();
  final ordre = [
    for (final l in noms ?? const <LigneDistribution>[])
      if (ids.contains(l.id)) l.id!,
    ...ids,
  ];
  var restantes = ordre.where((id) => !essayees.contains(id)).toList();
  if (restantes.isEmpty) {
    essayees.removeAll(ids);
    restantes = ordre;
  }
  for (final maladie in restantes) {
    final combinaisons = catalogue.adaptees(maladie);
    if (combinaisons.isEmpty) continue;
    essayees.add(maladie);
    return (action: actionTraiter, cartes: catalogue.tirer(combinaisons, alea));
  }
  return null;
}
