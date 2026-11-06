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

/// Stratégie de jeu automatique. Elle voit les résultats des actions sur le
/// patient courant et les spécialités des cartes.
///
/// Hypothèse optimiste : elle connaît aussi les traitements des maladies,
/// alors que le livret de règles ne les donne pas (REGLES_DE_TABLE.md §9).
/// Elle joue donc comme un joueur vétéran ; une stratégie qui apprend les
/// traitements reste à écrire.
abstract class Strategie {
  /// Nom affiché dans le rapport.
  String get nom;

  /// Appelé à chaque nouveau patient admis.
  void debutPatient() {}

  /// Nouvelle instance de la même stratégie, sans mémoire : le simulateur
  /// en crée une par patient et par joueur.
  Strategie nouvelle();

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

  /// Stratégie décrite par [description] : `hasard`, `seuil:<X>` ou
  /// `couleur:<X>`.
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
    }
    throw FormatException('stratégie inconnue : $description');
  }
}

/// Traiter ou diagnostiquer au hasard, avec une combinaison au hasard.
class StrategieHasard extends Strategie {
  @override
  String get nom => 'hasard';

  @override
  Strategie nouvelle() => StrategieHasard();

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
  Strategie nouvelle() => StrategieSeuil(seuil);

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
        );
      }
    }
    return (
      action: actionDiagnostiquer,
      cartes: catalogue.tirer(
        catalogue.meilleursDiagnostics(specialitesDiagnostic(historique)),
        alea,
      ),
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
  Strategie nouvelle() => StrategieCouleur(seuil);

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
