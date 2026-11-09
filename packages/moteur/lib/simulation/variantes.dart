import 'dart:convert';
import 'dart:math' as math;

import '../modeles/jeu.dart';
import '../moteur/alea.dart';
import '../moteur/combinaison.dart';
import '../moteur/etat.dart';
import '../moteur/partie.dart';
import '../moteur/resultat.dart';
import 'strategies.dart';

/// Qui peut agir sur un patient, et comment il change de mains.
enum Circulation {
  /// Règles actuelles : tout joueur agit sur tout patient.
  libre,

  /// Chaque joueur n'agit que sur les patients posés devant lui ; à la fin
  /// de chaque manche, tous les patients passent au voisin de gauche.
  releve,

  /// Après chaque acte, le patient passe au voisin de gauche.
  passe,

  /// Après son acte, le joueur peut envoyer le patient au joueur de son
  /// choix : celui qui peut le soigner, ou celui de la bonne spécialité.
  adressage,
}

/// Ce qu'un joueur qui partage transmet de ses diagnostics.
enum Transmission {
  /// Toute la liste.
  complete,

  /// Une seule chose : la maladie en tête, ou sa spécialité s'il n'en a pas
  /// vu le nom.
  unMot,
}

/// À qui va la réputation d'une guérison.
enum Recompense {
  /// Tout à celui qui soigne.
  acteur,

  /// Un point au joueur qui a transmis le patient (voisin de droite, ou
  /// celui qui l'a adressé).
  passeur,

  /// Un point au dernier autre joueur dont le diagnostic partagé a servi.
  informateur,
}

/// Ce que l'appli montre d'un diagnostic.
enum Masque {
  /// Tous les noms, à tout le monde (règles actuelles).
  aucun,

  /// Le nom d'une maladie seulement si le médecin du joueur (ou son
  /// diplôme) est de sa spécialité ; sinon sa couleur.
  medecin,

  /// Le nom d'une maladie seulement si une carte de la combinaison
  /// (médecin, salle, objet, diplôme) est de sa spécialité ; sinon sa
  /// couleur. Un premier examen trie, un second, ciblé, nomme.
  combinaison,
}

/// Qui partage ses diagnostics dans une partie simulée.
enum Population {
  /// Tous les joueurs partagent.
  partage('tous partagent'),

  /// Personne ne partage.
  prive('personne ne partage'),

  /// Le premier joueur se tait, les autres partagent.
  defecteur('un seul se tait');

  const Population(this.libelle);
  final String libelle;
}

/// Une variante de règles à simuler.
class Variante {
  const Variante(
    this.nom,
    this.description, {
    this.circulation = Circulation.libre,
    this.transmission = Transmission.complete,
    this.recompense = Recompense.acteur,
    this.masque = Masque.aucun,
    this.services = false,
    this.recettesPrivees = false,
  });

  final String nom;
  final String description;
  final Circulation circulation;
  final Transmission transmission;
  final Recompense recompense;

  /// Noms des maladies affichés ou masqués par l'appli.
  final Masque masque;

  /// Les salles sont réparties entre les joueurs : chacun ne joue que dans
  /// les siennes.
  final bool services;

  /// Partage gradué : les diagnostics se partagent, pas les recettes.
  final bool recettesPrivees;

  /// Variantes du catalogue, dans l'ordre du rapport.
  static const catalogue = [
    Variante('actuel', 'Règles actuelles : tout joueur agit sur tout patient'),
    Variante(
      'actuel+informateur',
      'Règles actuelles, 1 point de la guérison au dernier joueur dont le '
          'diagnostic partagé a servi',
      recompense: Recompense.informateur,
    ),
    Variante(
      'actuel+masque',
      'Règles actuelles, noms des maladies visibles du seul spécialiste',
      masque: Masque.medecin,
    ),
    Variante(
      'actuel+examen-cible',
      'Règles actuelles, noms visibles seulement avec une carte de la '
          'spécialité (médecin, salle ou objet)',
      masque: Masque.combinaison,
    ),
    Variante(
      'actuel+examen-cible+informateur',
      'Règles actuelles, examen ciblé, et 1 point de la guérison au dernier '
          'joueur dont le diagnostic partagé a servi',
      masque: Masque.combinaison,
      recompense: Recompense.informateur,
    ),
    Variante(
      'releve',
      'Relève : on n\'agit que sur ses patients, qui passent tous à gauche '
          'en fin de manche',
      circulation: Circulation.releve,
    ),
    Variante(
      'releve+passeur',
      'Relève, 1 point de la guérison au voisin qui a transmis le patient',
      circulation: Circulation.releve,
      recompense: Recompense.passeur,
    ),
    Variante(
      'releve+informateur',
      'Relève, 1 point de la guérison au dernier joueur dont le diagnostic '
          'partagé a servi',
      circulation: Circulation.releve,
      recompense: Recompense.informateur,
    ),
    Variante(
      'releve+passeur+un-mot',
      'Relève et prime du passeur ; on ne transmet qu\'une chose : une '
          'maladie ou une spécialité',
      circulation: Circulation.releve,
      recompense: Recompense.passeur,
      transmission: Transmission.unMot,
    ),
    Variante(
      'releve+passeur+masque',
      'Relève et prime du passeur ; noms visibles du seul spécialiste',
      circulation: Circulation.releve,
      recompense: Recompense.passeur,
      masque: Masque.medecin,
    ),
    Variante(
      'releve+examen-cible',
      'Relève, sans prime ; noms visibles seulement avec une carte de la '
          'spécialité',
      circulation: Circulation.releve,
      masque: Masque.combinaison,
    ),
    Variante(
      'releve+passeur+examen-cible',
      'Relève et prime du passeur ; noms visibles seulement avec une carte '
          'de la spécialité',
      circulation: Circulation.releve,
      recompense: Recompense.passeur,
      masque: Masque.combinaison,
    ),
    Variante(
      'releve+passeur+gradue',
      'Relève et prime du passeur ; on partage les diagnostics, pas les '
          'recettes',
      circulation: Circulation.releve,
      recompense: Recompense.passeur,
      recettesPrivees: true,
    ),
    Variante(
      'passe+passeur',
      'Un acte, puis le patient passe à gauche ; prime du passeur',
      circulation: Circulation.passe,
      recompense: Recompense.passeur,
    ),
    Variante(
      'adressage+passeur',
      'Après son acte, on adresse le patient au joueur de son choix ; prime '
          'à celui qui adresse',
      circulation: Circulation.adressage,
      recompense: Recompense.passeur,
    ),
    Variante(
      'adressage+passeur+examen-cible',
      'Adressage et prime ; noms visibles seulement avec une carte de la '
          'spécialité',
      circulation: Circulation.adressage,
      recompense: Recompense.passeur,
      masque: Masque.combinaison,
    ),
    Variante(
      'services+releve+passeur',
      'Salles réparties entre les joueurs, relève et prime du passeur',
      circulation: Circulation.releve,
      recompense: Recompense.passeur,
      services: true,
    ),
    Variante(
      'services+adressage+passeur',
      'Salles réparties entre les joueurs, adressage et prime',
      circulation: Circulation.adressage,
      recompense: Recompense.passeur,
      services: true,
    ),
  ];

  /// Variante du catalogue nommée [nom].
  static Variante depuis(String nom) => catalogue.firstWhere(
    (v) => v.nom == nom,
    orElse: () => throw FormatException(
      'variante inconnue : $nom (connues : '
      '${catalogue.map((v) => v.nom).join(', ')})',
    ),
  );
}

/// Paramètres d'une simulation de variantes.
class ParametresVariantes {
  const ParametresVariantes({
    this.graine = 1,
    this.parties = 500,
    this.patientsParPartie = 10,
    this.joueurs = 3,
    this.seuil = 70,
    this.novices = false,
    this.actionsMax = 60,
    this.difficulte,
  });

  final int graine;
  final int parties;
  final int patientsParPartie;

  /// Nombre de joueurs ; il y a autant de patients en jeu.
  final int joueurs;

  /// Indice de suspicion à partir duquel un joueur agit sur un diagnostic.
  final int seuil;

  /// Joueurs novices : ils ne connaissent pas les traitements et les
  /// découvrent au laboratoire ou en voyant une guérison. Sinon, vétérans.
  final bool novices;

  /// Au-delà, le patient est abandonné.
  final int actionsMax;

  /// Niveau de difficulté (le premier du paquet par défaut).
  final String? difficulte;

  Map<String, dynamic> toJson() => {
    'graine': graine,
    'parties': parties,
    'patients_par_partie': patientsParPartie,
    'joueurs': joueurs,
    'seuil': seuil,
    'novices': novices,
    'actions_max': actionsMax,
    if (difficulte != null) 'difficulte': difficulte,
  };
}

/// Mesures d'une variante pour une population.
class StatsVariante {
  StatsVariante(this.variante, this.population, this.joueurs)
    : scores = List.filled(joueurs, 0);

  final Variante variante;
  final Population population;
  final int joueurs;

  int parties = 0;
  int patients = 0;
  int gueris = 0;
  int morts = 0;
  int abandons = 0;
  int actions = 0;

  /// Patients dont la spécialité n'est celle d'aucun joueur à la table.
  int orphelins = 0;

  /// Tours de joueur, et tours sans patient sur lequel agir (tant qu'il
  /// reste des patients à admettre).
  int tours = 0;
  int toursVides = 0;

  /// Diagnostics faits alors que le joueur voyait déjà un diagnostic sûr :
  /// il n'avait rien de mieux à faire.
  int diagnosticsRedondants = 0;
  int stabilisations = 0;

  /// Guérisons par un joueur qui n'a jamais diagnostiqué ce patient.
  int guerisonsSurParole = 0;

  /// Morts pendant le premier acte d'un joueur sur un patient que d'autres
  /// avaient déjà pris en charge : il hérite de la faute.
  int mortsHeritees = 0;

  /// Points de réputation versés au passeur ou à l'informateur.
  int primes = 0;

  /// Plus grand nombre de patients tenus par un même joueur, par partie.
  int cumulEngorgement = 0;

  /// Points de victoire cumulés par place (réputation attribuée, plus un
  /// point par lot de 3 pièces).
  final List<int> scores;
  int cumulEcartScores = 0;

  /// Parties où la réputation cumulée est passée sous −10 et −15.
  int fermees10 = 0;
  int fermees15 = 0;

  double _part(int n, int total) => total == 0 ? 0 : n / total;

  double get guerison => _part(gueris, patients);
  double get mort => _part(morts, patients);
  double get fermeture10 => _part(fermees10, parties);
  double get fermeture15 => _part(fermees15, parties);
  double get partToursVides => _part(toursVides, tours);
  double get partOrphelins => _part(orphelins, patients);
  double get partRedondants => _part(diagnosticsRedondants, actions);
  double get partSurParole => _part(guerisonsSurParole, gueris);
  double get partMortsHeritees => _part(mortsHeritees, morts);
  double get toursParPartie => parties == 0 ? 0 : tours / parties;
  double get engorgement => parties == 0 ? 0 : cumulEngorgement / parties;
  double get ecartScores => parties == 0 ? 0 : cumulEcartScores / parties;
  double score(int place) => parties == 0 ? 0 : scores[place] / parties;
  double get scoreMoyen =>
      parties == 0 ? 0 : scores.fold(0, (a, b) => a + b) / parties / joueurs;

  Map<String, dynamic> toJson() => {
    'variante': variante.nom,
    'population': population.name,
    'parties': parties,
    'patients': patients,
    'guerison': _arrondi(guerison),
    'mort': _arrondi(mort),
    'abandons': abandons,
    'fermeture_10': _arrondi(fermeture10),
    'fermeture_15': _arrondi(fermeture15),
    'tours_par_partie': _arrondi(toursParPartie),
    'tours_vides': _arrondi(partToursVides),
    'patients_orphelins': _arrondi(partOrphelins),
    'diagnostics_redondants': _arrondi(partRedondants),
    'stabilisations': stabilisations,
    'guerisons_sur_parole': _arrondi(partSurParole),
    'morts_heritees': _arrondi(partMortsHeritees),
    'primes': primes,
    'engorgement': _arrondi(engorgement),
    'ecart_scores': _arrondi(ecartScores),
    'scores': [for (var j = 0; j < joueurs; j++) _arrondi(score(j))],
  };
}

/// Rapport d'une simulation de variantes.
class RapportVariantes {
  RapportVariantes(this.jeu, this.parametres, this.difficulte, this.resultats);

  final Jeu jeu;
  final ParametresVariantes parametres;
  final String difficulte;
  final List<StatsVariante> resultats;

  StatsVariante de(Variante v, Population p) =>
      resultats.firstWhere((r) => r.variante == v && r.population == p);

  Iterable<Variante> get variantes => {for (final r in resultats) r.variante};

  /// Valeur collective du partage : fermetures évitées (écart de 10) quand
  /// tous partagent plutôt que personne.
  double valeurCollective(Variante v) =>
      de(v, Population.prive).fermeture10 -
      de(v, Population.partage).fermeture10;

  /// Tentation de se taire : points gagnés par le joueur qui se tait seul,
  /// par rapport à ce qu'il gagne quand tous partagent.
  double tentation(Variante v) =>
      de(v, Population.defecteur).score(0) - de(v, Population.partage).score(0);

  /// Coût pour les autres : points perdus en moyenne par chacun des autres
  /// joueurs quand le premier se tait.
  double coutPourLesAutres(Variante v) {
    double autres(StatsVariante s) {
      var total = 0.0;
      for (var j = 1; j < s.joueurs; j++) {
        total += s.score(j);
      }
      return s.joueurs < 2 ? 0 : total / (s.joueurs - 1);
    }

    return autres(de(v, Population.partage)) -
        autres(de(v, Population.defecteur));
  }

  Map<String, dynamic> toJson() => {
    'paquet': {'id': jeu.id, 'version': jeu.version},
    'difficulte': difficulte,
    'parametres': parametres.toJson(),
    'resultats': resultats.map((r) => r.toJson()).toList(),
  };

  String enJson() => const JsonEncoder.withIndent('  ').convert(toJson());

  String enMarkdown() {
    final niveau = jeu.difficultes.firstWhere((d) => d.id == difficulte).nom;
    final b = StringBuffer()
      ..writeln('# Variantes de partage — ${jeu.nom} ${jeu.version}')
      ..writeln()
      ..writeln(
        'Graine ${parametres.graine} · ${parametres.parties} parties de '
        '${parametres.patientsParPartie} patients par variante et par '
        'population · ${parametres.joueurs} joueurs '
        '${parametres.novices ? 'novices, avec laboratoire' : 'vétérans'}, '
        'un médecin chacun · niveau $niveau · seuil ${parametres.seuil} · '
        'paliers d\'aggravation '
        '${jeu.parametres.paliersAggravation.join(', ')}.',
      )
      ..writeln()
      ..writeln('## Variantes')
      ..writeln()
      ..writeln('| Variante | Règle |')
      ..writeln('|---|---|');
    for (final v in variantes) {
      b.writeln('| `${v.nom}` | ${v.description} |');
    }
    b
      ..writeln()
      ..writeln('## Le partage compte-t-il ?')
      ..writeln()
      ..writeln(
        '« Valeur collective » : parties fermées en moins (écart de 10 entre '
        'départ et seuil) quand tous partagent plutôt que personne. '
        '« Tentation » : points de victoire gagnés par un joueur qui se tait '
        'seul, par rapport à ce qu\'il gagne quand tous partagent. « Coût '
        'pour les autres » : points perdus par chacun des autres. Un vrai '
        'dilemme demande une valeur collective forte **et** une tentation '
        'positive.',
      )
      ..writeln()
      ..writeln(
        '| Variante | Guérison (partage / privé) | Fermeture (partage / '
        'privé) | Valeur collective | Tentation | Coût pour les autres |',
      )
      ..writeln('|---|---:|---:|---:|---:|---:|');
    for (final v in variantes) {
      final p = de(v, Population.partage);
      final s = de(v, Population.prive);
      b.writeln(
        '| `${v.nom}` | ${_pct(p.guerison)} / ${_pct(s.guerison)} '
        '| ${_pct(p.fermeture10)} / ${_pct(s.fermeture10)} '
        '| ${_signe(valeurCollective(v) * 100, 0)} pts '
        '| ${_signe(tentation(v))} | ${_signe(coutPourLesAutres(v))} |',
      );
    }
    b
      ..writeln()
      ..writeln('## Qui gagne quoi')
      ..writeln()
      ..writeln(
        'Points de victoire moyens par partie. Quand un seul se tait, il est '
        'à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à '
        'la place 2. « Écart » : écart moyen entre le premier et le dernier '
        'quand tous partagent. « Primes » : points versés au passeur ou à '
        'l\'informateur, par partie.',
      )
      ..writeln()
      ..writeln(
        '| Variante | Tous partagent | Écart | Primes | Un seul se tait : '
        'lui | Son voisin de gauche | Les autres |',
      )
      ..writeln('|---|---:|---:|---:|---:|---:|---:|');
    for (final v in variantes) {
      final p = de(v, Population.partage);
      final d = de(v, Population.defecteur);
      var autres = 0.0;
      for (var j = 2; j < d.joueurs; j++) {
        autres += d.score(j);
      }
      b.writeln(
        '| `${v.nom}` | ${_dec(p.scoreMoyen)} | ${_dec(p.ecartScores)} '
        '| ${_dec(p.parties == 0 ? 0 : p.primes / p.parties)} '
        '| ${_dec(d.score(0))} | ${d.joueurs > 1 ? _dec(d.score(1)) : '—'} '
        '| ${d.joueurs > 2 ? _dec(autres / (d.joueurs - 2)) : '—'} |',
      );
    }
    b
      ..writeln()
      ..writeln('## Signaux de problème en jeu')
      ..writeln()
      ..writeln(
        'Quand tous partagent. « Tours vides » : tours où le joueur n\'a '
        'aucun patient. « Actes sans intérêt » : diagnostics refaits faute '
        'de mieux, alors que le joueur voyait déjà un diagnostic sûr. '
        '« Sur parole » : guérisons par un joueur qui n\'a jamais '
        'diagnostiqué le patient. « Morts héritées » : morts au premier acte '
        'd\'un joueur sur un patient reçu d\'un autre. « Engorgement » : plus '
        'grand nombre de patients tenus par un même joueur. « Patients '
        'orphelins » : patients dont la spécialité n\'est celle d\'aucun '
        'joueur de la table.',
      )
      ..writeln()
      ..writeln(
        '| Variante | Tours / partie | Tours vides | Actes sans intérêt | '
        'Sur parole | Mort | Morts héritées | Abandons | Engorgement | '
        'Patients orphelins |',
      )
      ..writeln('|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|');
    for (final v in variantes) {
      final p = de(v, Population.partage);
      b.writeln(
        '| `${v.nom}` | ${_dec(p.toursParPartie, 0)} '
        '| ${_pct(p.partToursVides)} | ${_pct(p.partRedondants)} '
        '| ${_pct(p.partSurParole)} | ${_pct(p.mort)} '
        '| ${_pct(p.partMortsHeritees)} | ${p.abandons} '
        '| ${_dec(p.engorgement, 1)} | ${_pct(p.partOrphelins)} |',
      );
    }
    return b.toString();
  }
}

/// Simulateur des variantes de partage : des joueurs qui n'ont que leur
/// médecin, des patients qui circulent ou non, et une information que
/// chacun transmet ou garde.
///
/// Les joueurs simulés ne négocient pas et ne mentent pas. Un traitement
/// est joué cartes sur table : son échec est connu de tous, et un joueur
/// qui connaît les recettes en déduit les maladies écartées. Salles et
/// objets sont tous disponibles dès le départ.
class SimulateurVariantes {
  SimulateurVariantes(this.jeu, {this.parametres = const ParametresVariantes()})
    : _catalogue = CatalogueCombinaisons(jeu) {
    if (parametres.joueurs < 2) {
      throw ArgumentError('il faut au moins 2 joueurs');
    }
    final cartes = <TypeCarte, List<String>>{};
    for (final e in jeu.cartes.entries) {
      cartes.putIfAbsent(e.value.type, () => []).add(e.key);
    }
    _patients = cartes[TypeCarte.patient] ?? const [];
    _medecins = cartes[TypeCarte.medecin] ?? const [];
    _diplomes = cartes[TypeCarte.diplome] ?? const [];
    _salles = cartes[TypeCarte.salle] ?? const [];
    if (_patients.isEmpty || _medecins.length < parametres.joueurs) {
      throw ArgumentError(
        'le paquet n\'a pas assez de cartes patient ou médecin',
      );
    }
    _combinaisons = [for (final c in _catalogue.cartes) Combinaison(jeu, c)];
    _specialites = [for (final c in _combinaisons) c.specialites];
    _precisions = [for (final c in _combinaisons) c.capacite('precision')];
  }

  final Jeu jeu;
  final ParametresVariantes parametres;
  final CatalogueCombinaisons _catalogue;
  late final List<String> _patients;
  late final List<String> _medecins;
  late final List<String> _diplomes;
  late final List<String> _salles;
  late final List<Combinaison> _combinaisons;
  late final List<Set<String>> _specialites;
  late final List<int> _precisions;
  late final Map<String, Maladie> _maladies = {
    for (final m in jeu.maladies) m.id: m,
  };
  final _soignees = <int, Set<String>>{};

  /// Vues du catalogue déjà calculées, par main : la vue, les combinaisons
  /// jouées seul et les spécialités du joueur.
  final _vues = <String, (CatalogueCombinaisons, Set<int>, Set<String>)>{};
  final _partiels = <String, List<int>>{};

  static const _paquet = IdentitePaquet(
    id: 'variantes',
    version: '0.0.0',
    empreinte: 'sha256:',
  );

  /// Maladies que soigne la combinaison [i].
  Set<String> _maladiesSoignees(int i) => _soignees.putIfAbsent(
    i,
    () => {
      for (final m in jeu.maladies)
        if (_combinaisons[i].satisfait(m.traitement.adapte)) m.id,
    },
  );

  /// Combinaisons qui stabilisent [maladie] sans la guérir.
  List<int> _stabilisantes(String maladie) =>
      _partiels.putIfAbsent(maladie, () {
        final t = _maladies[maladie]!.traitement;
        final partiel = t.partiel;
        if (partiel == null) return const [];
        return [
          for (var i = 0; i < _combinaisons.length; i++)
            if (_combinaisons[i].satisfait(partiel) &&
                !_combinaisons[i].satisfait(t.adapte))
              i,
        ];
      });

  /// Simule chaque variante pour chaque population.
  RapportVariantes simuler(List<Variante> variantes) {
    final difficulte = parametres.difficulte ?? jeu.difficultes.first.id;
    if (!jeu.difficultes.any((d) => d.id == difficulte)) {
      throw ArgumentError('difficulté inconnue : $difficulte');
    }
    final resultats = <StatsVariante>[];
    for (final v in variantes) {
      final rang = Variante.catalogue.indexOf(v);
      for (final p in Population.values) {
        // Même graine pour les trois populations d'une variante : mêmes
        // médecins tirés, à la divergence des parties près.
        final stats = StatsVariante(v, p, parametres.joueurs);
        final alea = Alea(parametres.graine * 1000003 + rang * 7919);
        for (var n = 0; n < parametres.parties; n++) {
          _PartieSimulee(this, v, p, difficulte, alea, stats).jouer();
        }
        resultats.add(stats);
      }
    }
    return RapportVariantes(jeu, parametres, difficulte, resultats);
  }
}

/// Ligne d'un diagnostic telle qu'un joueur la connaît : avec le nom de la
/// maladie, ou seulement sa couleur.
class _Ligne {
  const _Ligne(this.maladie, this.specialite, this.indice, this.nommee);

  final String maladie;
  final String specialite;
  final int indice;
  final bool nommee;
}

/// Ce qu'un joueur sait d'un patient.
class _Savoir {
  List<_Ligne> liste = const [];
  final ecartees = <String>{};

  /// Le joueur a-t-il lui-même diagnostiqué ce patient ?
  bool aDiagnostique = false;

  /// Dernier autre joueur dont le diagnostic partagé a renseigné la liste.
  int? informateur;
  int actes = 0;
  bool stabilise = false;

  /// Spécialités déjà visées par un examen ciblé de ce joueur.
  final cibles = <String>{};

  _Ligne? get candidate =>
      liste.where((l) => !ecartees.contains(l.maladie)).firstOrNull;
}

class _PatientEnJeu {
  _PatientEnJeu(this.carte, int joueurs)
    : savoirs = [for (var j = 0; j < joueurs; j++) _Savoir()];

  final String carte;
  final List<_Savoir> savoirs;
  int? tenuPar;
  int? passeur;
  int actes = 0;
}

enum _Geste { traiter, analyser, diagnostiquer, cibler, stabiliser, redondant }

class _PartieSimulee {
  _PartieSimulee(
    this.sim,
    this.variante,
    this.population,
    String difficulte,
    this.alea,
    this.stats,
  ) : partie = Partie.nouvelle(
        jeu: sim.jeu,
        paquet: SimulateurVariantes._paquet,
        difficulte: difficulte,
        alea: alea,
      ) {
    _distribuer();
  }

  final SimulateurVariantes sim;
  final Variante variante;
  final Population population;
  final SourceAleatoire alea;
  final StatsVariante stats;
  final Partie partie;

  int get joueurs => sim.parametres.joueurs;
  late final List<CatalogueCombinaisons> vues;
  late final List<Set<int>> seuls;
  late final List<Set<String>> specialites;
  late final List<Carnet> carnets;
  final proprietaire = <String, int>{};
  final enJeu = <_PatientEnJeu>[];
  late final scores = List.filled(joueurs, 0);
  late final pieces = List.filled(joueurs, 0);

  bool partage(int joueur) => switch (population) {
    Population.partage => true,
    Population.prive => false,
    Population.defecteur => joueur != 0,
  };

  bool get tenus => variante.circulation != Circulation.libre;

  List<String> _melanger(List<String> cartes) {
    final copie = [...cartes];
    for (var i = copie.length - 1; i > 0; i--) {
      final j = (alea.flottant() * (i + 1)).floor();
      final t = copie[i];
      copie[i] = copie[j];
      copie[j] = t;
    }
    return copie;
  }

  /// Un médecin par joueur, un diplôme à 2 ou 3 joueurs, et les salles si
  /// elles sont réparties.
  void _distribuer() {
    final jeu = sim.jeu;
    final medecins = _melanger(sim._medecins).sublist(0, joueurs);
    final diplomes = _melanger(sim._diplomes);
    final salles = _melanger(sim._salles);
    for (var j = 0; j < joueurs; j++) {
      proprietaire[medecins[j]] = j;
    }
    vues = [];
    seuls = [];
    specialites = [];
    for (var j = 0; j < joueurs; j++) {
      final diplome = joueurs <= 3 && j < diplomes.length ? diplomes[j] : null;
      final mesSalles = {
        for (var s = 0; s < salles.length; s++)
          if (!variante.services || s % joueurs == j) salles[s],
      };
      final cle = variante.services
          ? null
          : '${medecins[j]}|$diplome|${([...medecins]..sort()).join(',')}';
      final enCache = cle == null ? null : sim._vues[cle];
      if (enCache != null) {
        vues.add(enCache.$1);
        seuls.add(enCache.$2);
        specialites.add(enCache.$3);
        continue;
      }
      final vue = sim._catalogue.restreint(
        (cartes) {
          var lesMiens = 0;
          for (final id in cartes) {
            switch (jeu.cartes[id]!.type) {
              case TypeCarte.medecin:
                if (id == medecins[j]) {
                  lesMiens++;
                } else if (!proprietaire.containsKey(id)) {
                  return false;
                }
              case TypeCarte.diplome:
                if (id != diplome) return false;
              case TypeCarte.salle:
                if (!mesSalles.contains(id)) return false;
              case TypeCarte.objet || TypeCarte.patient:
            }
          }
          return lesMiens > 0;
        },
        seul: (cartes) => cartes.every(
          (id) => proprietaire[id] == null || proprietaire[id] == j,
        ),
      );
      final entree = (
        vue,
        vue.indicesSeul.toSet(),
        {
          for (final id in [medecins[j], ?diplome])
            if (jeu.cartes[id]!.specialite case final s?
                when !specialitesReservees.contains(s))
              s,
        },
      );
      if (cle != null) sim._vues[cle] = entree;
      vues.add(entree.$1);
      seuls.add(entree.$2);
      specialites.add(entree.$3);
    }
    carnets = [for (var j = 0; j < joueurs; j++) Carnet(sim._catalogue)];
  }

  bool _connait(int joueur, String maladie) =>
      !sim.parametres.novices ||
      carnets[joueur].revelee(maladie) ||
      carnets[joueur].recette(maladie) != null;

  /// Le joueur peut-il soigner [maladie] sans le médecin d'un autre ?
  bool _soigneSeul(int joueur, String maladie) =>
      vues[joueur].adaptees(maladie).any(seuls[joueur].contains);

  ({_Geste geste, _PatientEnJeu patient})? _choisir(
    int joueur,
    List<_PatientEnJeu> accessibles,
  ) {
    final seuil = sim.parametres.seuil;
    final vue = vues[joueur];
    _PatientEnJeu? analyse;
    _PatientEnJeu? diagnostic;
    _PatientEnJeu? stabilisation;
    _PatientEnJeu? cible;
    for (final p in accessibles) {
      final s = p.savoirs[joueur];
      final c = s.candidate;
      if (c == null || c.indice < seuil) {
        diagnostic ??= p;
        continue;
      }
      if (!c.nommee) {
        // Une couleur sans nom : examen ciblé, si la variante le permet et
        // si le joueur n'en a pas déjà fait un pour rien.
        if (variante.masque == Masque.combinaison &&
            !s.cibles.contains(c.specialite) &&
            _ciblees(joueur, c.specialite).isNotEmpty) {
          cible ??= p;
        }
        continue;
      }
      if (_connait(joueur, c.maladie)) {
        if (vue.adaptees(c.maladie).isNotEmpty) {
          return (geste: _Geste.traiter, patient: p);
        }
        if (!s.stabilise &&
            sim._stabilisantes(c.maladie).any(seuls[joueur].contains)) {
          stabilisation ??= p;
        }
      } else if (vue.meilleuresRecherches(c.specialite).isNotEmpty) {
        analyse ??= p;
      }
    }
    if (analyse != null) return (geste: _Geste.analyser, patient: analyse);
    if (cible != null) return (geste: _Geste.cibler, patient: cible);
    if (diagnostic != null) {
      return (geste: _Geste.diagnostiquer, patient: diagnostic);
    }
    if (stabilisation != null) {
      return (geste: _Geste.stabiliser, patient: stabilisation);
    }
    return (geste: _Geste.redondant, patient: accessibles.first);
  }

  final _examensCibles = <String, List<int>>{};

  /// Combinaisons de diagnostic que le joueur joue seul et qui portent
  /// [specialite], à la meilleure précision.
  List<int> _ciblees(int joueur, String specialite) =>
      _examensCibles.putIfAbsent('$joueur|$specialite', () {
        final avec = [
          for (final i in seuls[joueur])
            if (sim._specialites[i].contains(specialite)) i,
        ]..sort();
        if (avec.isEmpty) return avec;
        final max = avec.map((i) => sim._precisions[i]).reduce(math.max);
        return [
          for (final i in avec)
            if (sim._precisions[i] == max) i,
        ];
      });

  List<String> _tirer(List<int> indices) =>
      sim._catalogue.cartes[indices[(alea.flottant() * indices.length)
          .floor()]];

  void jouer() {
    final p = sim.parametres;
    final libres = [...sim._patients];
    final passe = List.filled(joueurs, false);
    var admissions = 0;
    var cumul = 0;
    var minimum = 0;
    var tour = 0;
    var engorgement = 0;
    stats.parties++;

    void admettre(int joueur) {
      final carte = libres.removeAt(0);
      _appliquer([carte], actionAdmettre);
      admissions++;
      stats.patients++;
      final specialite =
          sim._maladies[partie.etat.patients[carte]!.maladie]!.specialite;
      if (!specialites.any((s) => s.contains(specialite))) stats.orphelins++;
      enJeu.add(_PatientEnJeu(carte, joueurs)..tenuPar = tenus ? joueur : null);
    }

    // Garde-fou : une partie ne peut pas durer plus que ses actes possibles.
    final toursMax = p.patientsParPartie * (p.actionsMax + 2) * joueurs;
    while (tour < toursMax) {
      final joueur = tour % joueurs;
      tour++;
      // Début du tour : un nouveau patient s'il en manque (pour le joueur
      // qui n'en a pas, quand les patients sont tenus).
      final manque =
          enJeu.length < joueurs &&
          admissions < p.patientsParPartie &&
          libres.isNotEmpty;
      if (manque && (!tenus || !enJeu.any((e) => e.tenuPar == joueur))) {
        admettre(joueur);
      }
      if (enJeu.isEmpty &&
          (admissions >= p.patientsParPartie || libres.isEmpty)) {
        break;
      }
      stats.tours++;
      if (passe[joueur]) {
        passe[joueur] = false;
      } else {
        final accessibles = [
          for (final e in enJeu)
            if (!tenus || e.tenuPar == joueur) e,
        ];
        engorgement = math.max(engorgement, accessibles.length);
        final choix = accessibles.isEmpty
            ? null
            : _choisir(joueur, accessibles);
        if (choix == null) {
          if (admissions < p.patientsParPartie) stats.toursVides++;
        } else {
          final (reputation, sorti) = _agir(
            joueur,
            choix.geste,
            choix.patient,
            passe,
          );
          cumul += reputation;
          if (cumul < minimum) minimum = cumul;
          if (sorti) libres.add(choix.patient.carte);
        }
      }
      // Fin de manche : relève.
      if (variante.circulation == Circulation.releve && tour % joueurs == 0) {
        for (final e in enJeu) {
          e
            ..passeur = e.tenuPar
            ..tenuPar = (e.tenuPar! + 1) % joueurs;
        }
      }
    }
    stats.abandons += enJeu.length;
    for (var j = 0; j < joueurs; j++) {
      scores[j] += pieces[j] ~/ 3;
      stats.scores[j] += scores[j];
    }
    stats.cumulEcartScores += scores.reduce(math.max) - scores.reduce(math.min);
    stats.cumulEngorgement += engorgement;
    if (minimum < -10) stats.fermees10++;
    if (minimum < -15) stats.fermees15++;
  }

  /// Joue le [geste] du [joueur] sur [patient]. Renvoie l'impact sur la
  /// réputation de l'hôpital, et si le patient est sorti (guéri ou mort).
  (int, bool) _agir(
    int joueur,
    _Geste geste,
    _PatientEnJeu patient,
    List<bool> passe,
  ) {
    final vue = vues[joueur];
    final savoir = patient.savoirs[joueur];
    final cible = savoir.candidate;
    final (action, cartes) = switch (geste) {
      _Geste.traiter => (actionTraiter, _tirer(vue.adaptees(cible!.maladie))),
      _Geste.stabiliser => (
        actionTraiter,
        _tirer([
          for (final i in sim._stabilisantes(cible!.maladie))
            if (seuls[joueur].contains(i)) i,
        ]),
      ),
      _Geste.analyser => (
        actionAnalyser,
        _tirer0(vue.meilleuresRecherches(cible!.specialite)),
      ),
      _Geste.cibler => (
        actionDiagnostiquer,
        _tirer(_ciblees(joueur, cible!.specialite)),
      ),
      _Geste.diagnostiquer || _Geste.redondant => (
        actionDiagnostiquer,
        _tirer(vue.meilleursDiagnostics(const {})),
      ),
    };
    final r = _appliquer(
      [patient.carte, ...cartes],
      action,
      maladie: geste == _Geste.analyser ? cible!.maladie : null,
    );
    stats.actions++;
    patient.actes++;
    savoir.actes++;
    if (geste == _Geste.redondant) stats.diagnosticsRedondants++;
    if (geste == _Geste.cibler) savoir.cibles.add(cible!.specialite);
    if (geste == _Geste.stabiliser) {
      stats.stabilisations++;
      savoir.stabilise = true;
    }

    // Action à deux : le partenaire voit tout et passe son prochain tour.
    final partenaire = cartes
        .map((id) => proprietaire[id])
        .where((k) => k != null && k != joueur)
        .firstOrNull;
    if (partenaire != null) passe[partenaire] = true;

    _informer(joueur, partenaire, patient, r, geste, cible);
    pieces[joueur] += r.pieces;
    _attribuer(joueur, patient, r);

    final issue = r.issue ?? IssuePatient.enJeu;
    if (issue == IssuePatient.gueri) {
      stats.gueris++;
      if (!savoir.aDiagnostique) stats.guerisonsSurParole++;
    } else if (issue == IssuePatient.mort) {
      stats.morts++;
      if (savoir.actes == 1 && patient.actes > 1) stats.mortsHeritees++;
    }
    if (issue != IssuePatient.enJeu) {
      enJeu.remove(patient);
    } else if (patient.actes >= sim.parametres.actionsMax) {
      // Abandonné : il reste en jeu dans le moteur, sa carte est perdue.
      enJeu.remove(patient);
      stats.abandons++;
    } else {
      _transmettre(joueur, patient);
    }
    return (r.reputation, issue != IssuePatient.enJeu);
  }

  List<String> _tirer0(List<List<String>> combinaisons) =>
      combinaisons[(alea.flottant() * combinaisons.length).floor()];

  /// Met à jour ce que chaque joueur sait du patient après le résultat [r].
  void _informer(
    int joueur,
    int? partenaire,
    _PatientEnJeu patient,
    ResultatAction r,
    _Geste geste,
    _Ligne? cible,
  ) {
    bool temoin(int k) => k == joueur || k == partenaire;
    final diagnostic = r.diagnostic;
    if (diagnostic != null) {
      // Ce que l'acteur a vu : tous les noms, ou seulement ceux des
      // spécialités de son médecin ou de sa combinaison.
      final nommees = switch (variante.masque) {
        Masque.aucun => null,
        Masque.medecin => specialites[joueur],
        Masque.combinaison => Combinaison(sim.jeu, r.cartes).specialites,
      };
      final vues = [
        for (final l in diagnostic.maladies)
          _Ligne(
            l.id,
            l.specialite.id,
            l.indice,
            nommees == null || nommees.contains(l.specialite.id),
          ),
      ];
      for (var k = 0; k < joueurs; k++) {
        final s = patient.savoirs[k];
        if (temoin(k)) {
          s
            ..liste = vues
            ..aDiagnostique = true;
        } else if (partage(joueur)) {
          s
            ..liste = variante.transmission == Transmission.unMot
                ? vues.sublist(0, 1)
                : vues
            ..informateur = joueur;
        }
      }
    }
    // Recettes : guérison ou analyse, pour l'acteur et, s'il les partage,
    // pour tous.
    final recettesPubliques = partage(joueur) && !variante.recettesPrivees;
    for (var k = 0; k < joueurs; k++) {
      if (temoin(k) || recettesPubliques) carnets[k].noter(r);
    }
    // Un traitement raté se voit : la maladie visée est écartée par
    // l'acteur, et celles que ces cartes soignent par ceux qui le savent.
    if (geste == _Geste.traiter && r.issue != IssuePatient.gueri) {
      patient.savoirs[joueur].ecartees.add(cible!.maladie);
      final i = sim._catalogue.indice([
        for (final id in r.cartes)
          if (id != r.patient) id,
      ]);
      if (i != null) {
        for (var k = 0; k < joueurs; k++) {
          for (final m in sim._maladiesSoignees(i)) {
            if (_connait(k, m)) patient.savoirs[k].ecartees.add(m);
          }
        }
      }
    }
  }

  /// Répartit la réputation de [r] entre les joueurs.
  void _attribuer(int joueur, _PatientEnJeu patient, ResultatAction r) {
    var pourLui = r.reputation;
    if (r.issue == IssuePatient.gueri && r.reputation > 0) {
      final autre = switch (variante.recompense) {
        Recompense.acteur => null,
        Recompense.passeur => patient.passeur,
        Recompense.informateur => patient.savoirs[joueur].informateur,
      };
      if (autre != null && autre != joueur) {
        scores[autre]++;
        pourLui--;
        stats.primes++;
      }
    }
    scores[joueur] += pourLui;
  }

  /// Après un acte, le patient change de mains selon la variante.
  void _transmettre(int joueur, _PatientEnJeu patient) {
    switch (variante.circulation) {
      case Circulation.libre || Circulation.releve:
        return;
      case Circulation.passe:
        patient
          ..passeur = joueur
          ..tenuPar = (joueur + 1) % joueurs;
      case Circulation.adressage:
        final c = patient.savoirs[joueur].candidate;
        if (c == null || c.indice < sim.parametres.seuil) return;
        final dest = _destinataire(joueur, c);
        if (dest != null) {
          patient
            ..passeur = joueur
            ..tenuPar = dest;
        }
    }
  }

  /// À qui adresser un patient dont on connaît la piste [c] : au joueur qui
  /// peut le soigner seul si on connaît la recette, au laboratoire si on
  /// ne peut pas l'analyser, sinon au joueur de la spécialité.
  int? _destinataire(int joueur, _Ligne c) {
    bool Function(int k) convient;
    if (c.nommee && _connait(joueur, c.maladie)) {
      if (_soigneSeul(joueur, c.maladie)) return null;
      convient = (k) => _soigneSeul(k, c.maladie);
    } else if (c.nommee && sim.parametres.novices) {
      if (vues[joueur].meilleuresRecherches(c.specialite).isNotEmpty) {
        return null;
      }
      convient = (k) => vues[k].meilleuresRecherches(c.specialite).isNotEmpty;
    } else {
      if (specialites[joueur].contains(c.specialite)) return null;
      convient = (k) => specialites[k].contains(c.specialite);
    }
    for (var d = 1; d < joueurs; d++) {
      final k = (joueur + d) % joueurs;
      if (convient(k)) return k;
    }
    return null;
  }

  ResultatAction _appliquer(
    List<String> qrs,
    String action, {
    String? maladie,
  }) => switch (partie.confirmer(qrs, action, maladie: maladie)) {
    ActionAppliquee(:final resultat) => resultat,
    ActionRefusee(:final message) => throw StateError(
      'action « $action » refusée pendant la simulation : $message',
    ),
  };
}

double _arrondi(double x) => double.parse(x.toStringAsFixed(4));

String _dec(double x, [int decimales = 1]) =>
    x.toStringAsFixed(decimales).replaceAll('.', ',');

String _pct(double x) => '${_dec(x * 100, 0)} %';

String _signe(double x, [int decimales = 1]) {
  final texte = _dec(x.abs(), decimales);
  if (double.parse(texte.replaceAll(',', '.')) == 0) return texte;
  return '${x < 0 ? '−' : '+'}$texte';
}
