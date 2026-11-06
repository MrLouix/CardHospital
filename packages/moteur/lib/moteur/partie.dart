import 'dart:math' as math;

import '../modeles/jeu.dart';
import 'alea.dart';
import 'combinaison.dart';
import 'diagnostic.dart';
import 'etat.dart';
import 'recette.dart';
import 'reconnaissance.dart';
import 'resultat.dart';

/// Capacité qui compte pour des passages de laboratoire supplémentaires
/// (MODELE_DE_JEU.md §12.6).
const capaciteRecherche = 'recherche';

/// Action proposée dans un aperçu, avec sa phrase.
class ActionProposee {
  const ActionProposee({
    required this.id,
    required this.libelle,
    required this.phrase,
    this.maladies,
  });

  final String id;
  final String libelle;
  final String phrase;

  /// Pour une action qui demande de choisir une maladie (analyse au
  /// laboratoire) : les maladies suspectées du patient, parmi lesquelles le
  /// joueur choisit avant de confirmer.
  final List<MaladieAnalysee>? maladies;

  Map<String, dynamic> toJson() => {
    'id': id,
    'libelle': libelle,
    'phrase': phrase,
    if (maladies != null) 'maladies': maladies!.map((m) => m.toJson()).toList(),
  };
}

/// Réponse à « Valider la sélection » (SPECIFICATION.md §5.2).
sealed class ReponseSelection {
  const ReponseSelection();
}

/// Combinaison reconnue : les actions dont la précondition est vérifiée.
final class SelectionAcceptee extends ReponseSelection {
  const SelectionAcceptee({
    required this.cartes,
    required this.motifs,
    required this.actions,
  });

  /// Cartes reconnues, dans l'ordre de sélection, sans doublon.
  final List<String> cartes;

  /// Motifs reconnus, dans l'ordre de déclaration.
  final List<String> motifs;
  final List<ActionProposee> actions;
}

/// Sélection refusée, avec un message affichable.
final class SelectionRefusee extends ReponseSelection {
  const SelectionRefusee(this.message);

  final String message;
}

/// Réponse à la confirmation d'une action (SPECIFICATION.md §5.5).
sealed class ReponseConfirmation {
  const ReponseConfirmation();
}

/// L'action a été appliquée.
final class ActionAppliquee extends ReponseConfirmation {
  const ActionAppliquee(this.resultat);

  final ResultatAction resultat;
}

/// L'action n'a pas été appliquée (précondition non vérifiée…).
final class ActionRefusee extends ReponseConfirmation {
  const ActionRefusee(this.message);

  final String message;
}

/// Une action annulable : l'instantané pris avant elle et son résultat.
class EntreeHistorique {
  const EntreeHistorique({required this.avant, required this.resultat});

  factory EntreeHistorique.fromJson(Map<String, dynamic> json) =>
      EntreeHistorique(
        avant: EtatPartie.fromJson(json['avant'] as Map<String, dynamic>),
        resultat: ResultatAction.fromJson(
          json['resultat'] as Map<String, dynamic>,
        ),
      );

  final EtatPartie avant;
  final ResultatAction resultat;

  Map<String, dynamic> toJson() => {
    'avant': avant.toJson(),
    'resultat': resultat.toJson(),
  };
}

/// Moteur d'une partie : reconnaissance, préconditions, effets, invariants,
/// instantanés (MOTEUR_EFFETS.md §6, MODELE_DE_JEU.md §4 à §10).
///
/// Ne dépend ni de Flutter ni du réseau ; le hasard est injecté.
class Partie {
  Partie({
    required this.jeu,
    required EtatPartie etat,
    required this.alea,
    List<EntreeHistorique>? historique,
  }) : _etat = etat,
       _historique = [...?historique],
       _reconnaissance = ReconnaissanceCombinaisons(jeu),
       _diagnostiqueur = Diagnostiqueur(jeu, alea),
       _redacteur = RedacteurRecette(jeu) {
    _modificateurs = _difficulte(etat.difficulte).modificateurs;
  }

  /// Nouvelle partie, sans patient admis.
  factory Partie.nouvelle({
    required Jeu jeu,
    required IdentitePaquet paquet,
    required String difficulte,
    required SourceAleatoire alea,
  }) => Partie(
    jeu: jeu,
    etat: EtatPartie(paquet: paquet, difficulte: difficulte),
    alea: alea,
  );

  /// Reprend une partie depuis une sauvegarde ([sauvegarde]). Vérifier
  /// d'abord sa compatibilité avec [CompatibiliteEtat.verifier].
  factory Partie.restaurer({
    required Jeu jeu,
    required Map<String, dynamic> sauvegarde,
    required SourceAleatoire alea,
  }) {
    final version = sauvegarde['format_sauvegarde'];
    if (version != formatSauvegarde) {
      throw FormatException('format_sauvegarde non supporté : $version');
    }
    return Partie(
      jeu: jeu,
      etat: EtatPartie.fromJson(sauvegarde['etat'] as Map<String, dynamic>),
      alea: alea,
      historique: [
        for (final e in sauvegarde['historique'] as List)
          EntreeHistorique.fromJson(e as Map<String, dynamic>),
      ],
    );
  }

  /// Version du format de sauvegarde.
  static const formatSauvegarde = 1;

  /// Nombre d'actions annulables (SPECIFICATION.md §7.3).
  static const tailleHistorique = 5;

  final Jeu jeu;
  final SourceAleatoire alea;
  final ReconnaissanceCombinaisons _reconnaissance;
  final Diagnostiqueur _diagnostiqueur;
  final RedacteurRecette _redacteur;
  late final Modificateurs _modificateurs;
  final _choixMaladie = <String, bool>{};
  EtatPartie _etat;
  final List<EntreeHistorique> _historique;

  /// État courant (à ne pas modifier directement).
  EtatPartie get etat => _etat;

  /// Dernières actions annulables, de la plus ancienne à la plus récente.
  List<EntreeHistorique> get historique => List.unmodifiable(_historique);

  Difficulte _difficulte(String id) => jeu.difficultes.firstWhere(
    (d) => d.id == id,
    orElse: () => throw ArgumentError.value(id, 'difficulte', 'inconnue'),
  );

  /// Maladies suspectées du patient [patient] (MODELE_DE_JEU.md §12.2),
  /// dans l'ordre de première apparition ; vide s'il n'est pas en jeu ou
  /// n'a pas encore été diagnostiqué.
  List<MaladieAnalysee> maladiesSuspectees(String patient) {
    final p = _etat.patients[patient];
    if (p == null || !p.enJeu) return const [];
    return [
      for (final id in p.suspectees)
        if (_maladie(id) case final m?) _maladieAnalysee(m),
    ];
  }

  Maladie? _maladie(String id) =>
      jeu.maladies.where((m) => m.id == id).firstOrNull;

  MaladieAnalysee _maladieAnalysee(Maladie m) => MaladieAnalysee(
    id: m.id,
    nom: m.nom,
    specialite: SpecialiteAffichee.depuis(
      jeu.specialites.firstWhere((s) => s.id == m.specialite),
    ),
  );

  /// L'action [a] demande-t-elle de choisir une maladie (effet
  /// `rechercher`) ?
  bool demandeMaladie(ActionJeu a) =>
      _choixMaladie.putIfAbsent(a.id, () => a.effets.any(_recherche));

  static bool _recherche(Effet e) =>
      e.effet == 'rechercher' || [...?e.alors, ...?e.sinon].any(_recherche);

  /// Reconnaît la sélection [qrs] et propose les actions dont la
  /// précondition est vérifiée sur l'état courant.
  ReponseSelection valider(List<String> qrs) {
    final reconnaissance = _reconnaissance.reconnaitre(qrs);
    switch (reconnaissance) {
      case Refus(:final message):
        return SelectionRefusee(message);
      case Apercu(:final motifs, :final actions):
        final combinaison = Combinaison(jeu, qrs);
        final possibles = [
          for (final a in actions)
            if (_precondition(a, combinaison))
              ActionProposee(
                id: a.id,
                libelle: a.libelle,
                phrase: combinaison.phrase(a.phrase),
                maladies: demandeMaladie(a)
                    ? maladiesSuspectees(combinaison.patient!)
                    : null,
              ),
        ];
        if (possibles.isEmpty) {
          // Une action que les cartes permettent a échoué sur l'état du
          // patient : l'état est en cause. Sinon, si l'état permettait une
          // action, ce sont les cartes ; si rien ne va, l'état d'abord.
          final parEtat = [
            for (final a in actions)
              if (_cartesPermettent(a, combinaison)) a,
          ];
          final causeCartes =
              parEtat.isEmpty &&
              actions.any((a) => _preconditionEtat(a, combinaison));
          return SelectionRefusee(
            causeCartes
                ? 'Aucune action possible avec ces cartes.'
                : _messageEtat(
                    combinaison,
                    parEtat.isEmpty ? actions : parEtat,
                    confirmation: false,
                  ),
          );
        }
        return SelectionAcceptee(
          cartes: combinaison.ids.toList(),
          motifs: motifs,
          actions: possibles,
        );
    }
  }

  /// Confirme l'action [actionId] sur la sélection [qrs] : revalide le motif
  /// et la précondition, prend un instantané, applique les effets.
  ///
  /// [maladie] : pour une action qui le demande (analyse au laboratoire),
  /// la maladie choisie parmi les maladies suspectées du patient.
  ReponseConfirmation confirmer(
    List<String> qrs,
    String actionId, {
    String? maladie,
  }) {
    final reconnaissance = _reconnaissance.reconnaitre(qrs);
    if (reconnaissance is Refus) return ActionRefusee(reconnaissance.message);
    final apercu = reconnaissance as Apercu;
    final action = apercu.actions.where((a) => a.id == actionId).firstOrNull;
    if (action == null) {
      return const ActionRefusee('Action impossible avec cette sélection.');
    }
    final combinaison = Combinaison(jeu, qrs);
    if (!_precondition(action, combinaison)) {
      return ActionRefusee(
        !_cartesPermettent(action, combinaison) &&
                _preconditionEtat(action, combinaison)
            ? 'Cette action n\'est pas possible avec ces cartes — action non '
                  'appliquée.'
            : _messageEtat(combinaison, [action], confirmation: true),
      );
    }
    final choisie = demandeMaladie(action) ? maladie : null;
    if (demandeMaladie(action) &&
        !maladiesSuspectees(combinaison.patient!).any((m) => m.id == maladie)) {
      return const ActionRefusee(
        'Choisissez la maladie à analyser parmi les maladies suspectées — '
        'action non appliquée.',
      );
    }

    final avant = _etat.copie();
    final resultat = _Execution(
      this,
      action,
      combinaison,
      maladieChoisie: choisie,
    ).executer();
    _historique.add(EntreeHistorique(avant: avant, resultat: resultat));
    if (_historique.length > tailleHistorique) _historique.removeAt(0);
    return ActionAppliquee(resultat);
  }

  /// Annule la dernière action (LIFO) en restaurant l'instantané pris avant
  /// elle. Retourne son résultat, dont les pièces et la réputation sont à
  /// reporter en sens inverse, ou `null` s'il n'y a rien à annuler.
  ResultatAction? annulerDerniereAction() {
    if (_historique.isEmpty) return null;
    final entree = _historique.removeLast();
    _etat = entree.avant.copie();
    return entree.resultat;
  }

  /// Sauvegarde complète : état et historique d'annulation.
  Map<String, dynamic> sauvegarde() => {
    'format_sauvegarde': formatSauvegarde,
    'etat': _etat.toJson(),
    'historique': _historique.map((e) => e.toJson()).toList(),
  };

  bool _precondition(ActionJeu action, Combinaison combinaison) {
    final condition = action.precondition;
    if (condition == null) return true;
    return _Execution(this, action, combinaison).evaluer(condition);
  }

  /// Les cartes permettent-elles l'action, l'état du patient étant tenu pour
  /// favorable ? Si oui alors que la précondition est fausse, c'est l'état du
  /// patient qui est en cause, pas les cartes.
  bool _cartesPermettent(ActionJeu action, Combinaison combinaison) =>
      action.precondition == null || combinaison.permet(action.precondition!);

  /// Précondition évaluée sur l'état seul, les conditions `combinaison`
  /// étant tenues pour favorables.
  bool _preconditionEtat(ActionJeu action, Combinaison combinaison) {
    final condition = action.precondition;
    if (condition == null) return true;
    return _Execution(
      this,
      action,
      combinaison,
    ).evaluer(condition, combinaisonNeutre: true);
  }

  /// Message d'une précondition non vérifiée à cause de l'état du patient,
  /// pour les [actions] que les cartes permettaient.
  String _messageEtat(
    Combinaison combinaison,
    List<ActionJeu> actions, {
    required bool confirmation,
  }) {
    final id = combinaison.patient;
    if (id == null) return 'Aucune action possible avec cette sélection.';
    final nom = jeu.cartes[id]!.nom;
    final suite = confirmation ? ' — action non appliquée.' : '.';
    if (_etat.enJeu(id)) {
      final sansPiste =
          _etat.patients[id]!.suspectees.isEmpty &&
          actions.any(
            (a) =>
                a.precondition != null &&
                _mentionne(a.precondition!, 'patient_diagnostique'),
          );
      if (sansPiste) {
        return 'Aucune piste pour $nom : faire d\'abord un diagnostic$suite';
      }
      return '$nom est déjà en jeu$suite';
    }
    return confirmation
        ? '$nom n\'est plus en jeu$suite'
        : '$nom n\'est pas en jeu$suite';
  }

  static bool _mentionne(Condition c, String constante) =>
      c.constante == constante ||
      [...?c.et, ...?c.ou, ?c.non].any((x) => _mentionne(x, constante));
}

/// Exécution d'une action : contexte mutable des effets.
class _Execution {
  _Execution(this.partie, this.action, this.combinaison, {this.maladieChoisie})
    : patientId = combinaison.patient {
    final p = patientId == null ? null : partie._etat.patients[patientId];
    pvAvant = (p?.enJeu ?? false) ? p!.pv : null;
  }

  final Partie partie;
  final ActionJeu action;
  final Combinaison combinaison;
  final String? patientId;

  /// Maladie choisie par le joueur (analyse au laboratoire).
  final String? maladieChoisie;
  late final int? pvAvant;

  int pieces = 0;
  int reputation = 0;
  bool gueri = false;
  ResultatDiagnostic? diagnostic;
  ResultatAnalyse? analyse;

  Jeu get jeu => partie.jeu;
  Modificateurs get mod => partie._modificateurs;

  /// État du patient, s'il est en jeu.
  EtatPatient? get patient {
    final p = patientId == null ? null : partie._etat.patients[patientId];
    return (p?.enJeu ?? false) ? p : null;
  }

  Maladie? get maladie {
    final p = patient;
    if (p == null) return null;
    return jeu.maladies.where((m) => m.id == p.maladie).firstOrNull;
  }

  ResultatAction executer() {
    _effets(action.effets);
    final etat = partie._etat;
    etat.actions++;

    // Invariants (MOTEUR_EFFETS.md §6) : mort, puis sortie et révélation.
    final p = patient;
    final m = maladie;
    IssuePatient? issue;
    MaladieRevelee? revelee;
    var attenteDepassee = false;
    if (p != null && m != null) {
      attenteDepassee = _attenteDepassee(p, m);
      issue = IssuePatient.enJeu;
      if (gueri) {
        issue = IssuePatient.gueri;
      } else if (p.pv <= 0) {
        p.pv = 0;
        issue = IssuePatient.mort;
        reputation += _reputation(_recompense('reputation_mort'));
      }
      // Pas de pièce quand le patient meurt pendant l'action.
      if (issue == IssuePatient.mort) pieces = 0;
      if (issue != IssuePatient.enJeu) {
        p.statut = StatutPatient.sorti;
        p.issue = issue;
        revelee = MaladieRevelee(id: m.id, nom: m.nom);
      }
    }

    final etatPatient = patientId == null ? null : etat.patients[patientId];
    return ResultatAction(
      numero: etat.actions,
      action: action.id,
      libelle: action.libelle,
      phrase: combinaison.phrase(action.phrase),
      cartes: combinaison.ids.toList(),
      patient: patientId,
      patientNom: patientId == null ? null : jeu.cartes[patientId]!.nom,
      pvAvant: pvAvant,
      pvApres: etatPatient?.pv,
      presence: etatPatient?.presence(etat.ticks),
      attenteDepassee: attenteDepassee,
      issue: issue,
      diagnostic: diagnostic,
      analyse: analyse,
      maladieRevelee: revelee,
      pieces: pieces,
      reputation: reputation,
    );
  }

  void _effets(List<Effet> effets) {
    for (final e in effets) {
      _effet(e);
    }
  }

  /// Les effets portant sur le patient sont sans effet s'il n'est pas en
  /// jeu : le validateur et les préconditions doivent l'empêcher, et un
  /// paquet mal conçu ne doit pas bloquer la partie.
  void _effet(Effet e) {
    switch (e.effet) {
      case 'admettre':
        _admettre();
      case 'avancer_temps':
        partie._etat.ticks++;
      case 'diagnostiquer':
        final m = maladie;
        if (m != null) {
          final d = partie._diagnostiqueur.diagnostiquer(m, combinaison);
          diagnostic = d;
          patient!.suspecter(d.maladies.map((l) => l.id));
        }
      case 'rechercher':
        _rechercher();
      case 'aggraver':
        final p = patient;
        final m = maladie;
        if (p != null && m != null) {
          _perdrePv(p, perteAggravation(m, _presence(p), jeu.parametres));
        }
      case 'soigner':
        if (patient != null) gueri = true;
      case 'gagner_pv':
        final p = patient;
        final m = maladie;
        if (p != null && m != null) {
          p.pv = (p.pv + _valeur(e.valeur!)).clamp(0, m.pvInitial);
        }
      case 'perdre_pv':
        final p = patient;
        if (p != null) _perdrePv(p, _valeur(e.valeur!));
      case 'payer':
        pieces += moduler(_valeur(e.valeur!), mod.pieces);
      case 'reputation':
        reputation += _reputation(_valeur(e.valeur!));
      case 'si':
        if (evaluer(e.condition!)) {
          _effets(e.alors ?? const []);
        } else {
          _effets(e.sinon ?? const []);
        }
      default:
        throw StateError('effet inconnu « ${e.effet} »');
    }
  }

  void _admettre() {
    final id = patientId;
    if (id == null) return;
    final maladies = jeu.maladies;
    final i = partie.alea.indicePondere([
      for (final m in maladies) m.poids ?? 1,
    ]);
    final m = maladies[i];
    partie._etat.patients[id] = EtatPatient(
      statut: StatutPatient.enJeu,
      maladie: m.id,
      pv: m.pvInitial,
      admission: partie._etat.ticks,
    );
  }

  /// Un passage en laboratoire sur la maladie choisie (MODELE_DE_JEU.md
  /// §12.3) : le compteur commun avance de 1, plus la capacité `recherche`
  /// de la combinaison ; la recette se révèle quand il atteint le nombre de
  /// passages de la maladie.
  void _rechercher() {
    final id = maladieChoisie;
    final m = id == null ? null : partie._maladie(id);
    if (patient == null || m == null) return;
    final etat = partie._etat;
    final bonus = math.max(0, combinaison.capacite(capaciteRecherche));
    final fait = math.min(m.passages, (etat.recherche[m.id] ?? 0) + 1 + bonus);
    etat.recherche[m.id] = fait;
    final restants = m.passages - fait;
    analyse = ResultatAnalyse(
      maladie: partie._maladieAnalysee(m),
      passagesRestants: restants,
      recette: restants == 0
          ? partie._redacteur.decrire(m.traitement.adapte)
          : null,
    );
  }

  void _perdrePv(EtatPatient p, int base) {
    p.pv = math.max(0, p.pv - moduler(base, mod.pvPerdus));
  }

  int _presence(EtatPatient p) => p.presence(partie._etat.ticks);

  /// Impact sur la réputation : la difficulté ne modifie que les pertes.
  int _reputation(int valeur) =>
      valeur < 0 ? moduler(valeur, mod.reputation) : valeur;

  bool _attenteDepassee(EtatPatient p, Maladie m) =>
      _presence(p) > (m.attenteMax ?? jeu.parametres.attenteMaxDefaut);

  /// Évalue une condition (MOTEUR_EFFETS.md §6) sur l'état courant.
  ///
  /// Si [combinaisonNeutre] est fourni, les conditions `combinaison` ne sont
  /// pas évaluées : elles valent [combinaisonNeutre] (inversé sous un `non`),
  /// ce qui isole la part de la condition qui dépend de l'état.
  bool evaluer(Condition c, {bool? combinaisonNeutre}) {
    bool sous(Condition x) => evaluer(x, combinaisonNeutre: combinaisonNeutre);
    if (c.constante != null) {
      switch (c.constante) {
        case 'traitement_adapte':
          final m = maladie;
          return m != null && combinaison.satisfait(m.traitement.adapte);
        case 'traitement_partiel':
          final partiel = maladie?.traitement.partiel;
          return partiel != null && combinaison.satisfait(partiel);
        case 'attente_depassee':
          final p = patient;
          final m = maladie;
          return p != null && m != null && _attenteDepassee(p, m);
        case 'gueri':
          return gueri;
        case 'patient_en_jeu':
          return patient != null;
        case 'patient_hors_jeu':
          return patientId != null && patient == null;
        case 'patient_diagnostique':
          return patient?.suspectees.isNotEmpty ?? false;
        default:
          throw StateError('condition inconnue « ${c.constante} »');
      }
    }
    if (c.et != null) return c.et!.every(sous);
    if (c.ou != null) return c.ou!.any(sous);
    if (c.non != null) {
      return !evaluer(
        c.non!,
        combinaisonNeutre: combinaisonNeutre == null
            ? null
            : !combinaisonNeutre,
      );
    }
    return combinaisonNeutre ?? combinaison.satisfait(c.combinaison!);
  }

  int _valeur(Valeur v) {
    if (v.entier != null) return v.entier!;
    if (v.sousValeurs != null) {
      return v.sousValeurs!.fold(0, (s, sv) => s + _valeur(sv));
    }
    final ref = v.reference!;
    final point = ref.indexOf('.');
    final espace = ref.substring(0, point);
    final cle = ref.substring(point + 1);
    return switch (espace) {
      r'$recompenses' => _recompense(cle),
      r'$capacite' => combinaison.capacite(cle),
      _ => throw StateError('référence inconnue « $ref »'),
    };
  }

  /// Récompense de la maladie si elle est définie, sinon valeur globale.
  int _recompense(String cle) {
    final propre = maladie?.recompenses?.toJson()[cle] as int?;
    return propre ??
        jeu.parametres.recompenses.toJson()[cle] as int? ??
        (throw StateError('récompense inconnue « $cle »'));
  }
}

/// Palier d'aggravation atteint après [presence] ticks de présence : nombre
/// de seuils de [paliers] atteints (0 : patient stable).
int palierAggravation(int presence, List<int> paliers) =>
    paliers.where((seuil) => presence >= seuil).length;

/// Perte de PV d'aggravation (avant difficulté) de la maladie [m] après
/// [presence] ticks : 0 tant que le patient est stable, puis la valeur de
/// `aggravation` du palier atteint (le premier élément pour le premier
/// palier, la dernière valeur se répétant).
int perteAggravation(Maladie m, int presence, Parametres parametres) {
  final palier = palierAggravation(presence, parametres.paliersAggravation);
  if (palier == 0) return 0;
  return m.aggravation[(palier - 1).clamp(0, m.aggravation.length - 1)];
}

/// Applique le bonus de difficulté [bonus] à un montant entier [base] : il
/// s'ajoute à sa valeur absolue. Un montant nul reste nul, et un montant non
/// nul reste au moins égal à 1 en valeur absolue, même avec un bonus négatif
/// (MODELE_DE_JEU.md §10).
int moduler(int base, int bonus) {
  if (base == 0) return 0;
  final valeur = base.abs() + bonus;
  return base.sign * (valeur < 1 ? 1 : valeur);
}
