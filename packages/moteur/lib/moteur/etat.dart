import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../modeles/jeu.dart';

/// Statut d'un patient qui a été admis au moins une fois.
///
/// Un patient jamais admis n'a pas d'état : il est « hors jeu », comme un
/// patient sorti.
enum StatutPatient { enJeu, sorti }

/// Issue d'un patient à la fin d'une action.
enum IssuePatient { enJeu, gueri, mort }

const _statuts = {StatutPatient.enJeu: 'en_jeu', StatutPatient.sorti: 'sorti'};
const _issues = {
  IssuePatient.enJeu: 'en_jeu',
  IssuePatient.gueri: 'gueri',
  IssuePatient.mort: 'mort',
};

T _decoder<T>(Map<T, String> table, Object? valeur) =>
    table.entries.firstWhere((e) => e.value == valeur).key;

/// Nom JSON d'une issue (`en_jeu`, `gueri`, `mort`).
String nomIssue(IssuePatient issue) => _issues[issue]!;

/// Issue lue depuis son nom JSON.
IssuePatient issueDepuisNom(String nom) => _decoder(_issues, nom);

/// État d'un patient (point P2 du plan de codage).
class EtatPatient {
  EtatPatient({
    required this.statut,
    required this.maladie,
    required this.pv,
    required this.admission,
    this.issue,
  });

  factory EtatPatient.fromJson(Map<String, dynamic> json) => EtatPatient(
    statut: _decoder(_statuts, json['statut']),
    maladie: json['maladie'] as String,
    pv: json['pv'] as int,
    admission: json['admission'] as int,
    issue: json['issue'] == null
        ? null
        : issueDepuisNom(json['issue'] as String),
  );

  StatutPatient statut;

  /// Identifiant de la maladie (information cachée).
  String maladie;
  int pv;

  /// Tick de l'horloge de l'hôpital auquel le patient a été admis.
  int admission;

  /// Durée de présence du patient à l'hôpital, en ticks, quand l'horloge
  /// marque [ticks].
  int presence(int ticks) => ticks - admission;

  /// Issue de la sortie (`gueri` ou `mort`), quand le patient est sorti.
  IssuePatient? issue;

  bool get enJeu => statut == StatutPatient.enJeu;

  EtatPatient copie() => EtatPatient(
    statut: statut,
    maladie: maladie,
    pv: pv,
    admission: admission,
    issue: issue,
  );

  Map<String, dynamic> toJson() => {
    'statut': _statuts[statut],
    'maladie': maladie,
    'pv': pv,
    'admission': admission,
    if (issue != null) 'issue': nomIssue(issue!),
  };
}

/// Identité du paquet actif, enregistrée dans l'état et les sauvegardes
/// (MOTEUR_EFFETS.md §8).
class IdentitePaquet {
  const IdentitePaquet({
    required this.id,
    required this.version,
    required this.empreinte,
  });

  /// Identité de [jeu], dont le contenu JSON brut est [jsonBrut].
  factory IdentitePaquet.depuis(Jeu jeu, String jsonBrut) => IdentitePaquet(
    id: jeu.id,
    version: jeu.version,
    empreinte: empreintePaquet(jsonBrut),
  );

  factory IdentitePaquet.fromJson(Map<String, dynamic> json) => IdentitePaquet(
    id: json['id'] as String,
    version: json['version'] as String,
    empreinte: json['empreinte'] as String,
  );

  final String id;
  final String version;

  /// Empreinte SHA-256 du `jeu.json`, préfixée par `sha256:`.
  final String empreinte;

  @override
  bool operator ==(Object other) =>
      other is IdentitePaquet &&
      other.id == id &&
      other.version == version &&
      other.empreinte == empreinte;

  @override
  int get hashCode => Object.hash(id, version, empreinte);

  Map<String, dynamic> toJson() => {
    'id': id,
    'version': version,
    'empreinte': empreinte,
  };
}

/// Empreinte d'un `jeu.json` : SHA-256 de son contenu en UTF-8.
String empreintePaquet(String jsonBrut) =>
    'sha256:${sha256.convert(utf8.encode(jsonBrut))}';

/// État complet d'une partie, tel que sauvegardé après chaque action
/// (point P2 du plan de codage).
///
/// Il ne contient ni le paquet (seulement son identité), ni l'état du
/// générateur aléatoire : une partie reprise continue avec un hasard neuf.
class EtatPartie {
  EtatPartie({
    required this.paquet,
    required this.difficulte,
    this.actions = 0,
    this.ticks = 0,
    Map<String, EtatPatient>? patients,
  }) : patients = patients ?? {};

  factory EtatPartie.fromJson(Map<String, dynamic> json) {
    final version = json['format_etat'];
    if (version != formatEtat) {
      throw FormatException('format_etat non supporté : $version');
    }
    return EtatPartie(
      paquet: IdentitePaquet.fromJson(json['paquet'] as Map<String, dynamic>),
      difficulte: json['difficulte'] as String,
      actions: json['actions'] as int,
      ticks: json['ticks'] as int,
      patients: (json['patients'] as Map<String, dynamic>).map(
        (id, p) =>
            MapEntry(id, EtatPatient.fromJson(p as Map<String, dynamic>)),
      ),
    );
  }

  /// Version du format de l'état sérialisé.
  static const formatEtat = 2;

  final IdentitePaquet paquet;

  /// Identifiant du niveau de difficulté.
  final String difficulte;

  /// Nombre d'actions confirmées depuis le début de la partie ; sert aussi
  /// de numéro au résultat suivant.
  int actions;

  /// Horloge de l'hôpital : nombre de diagnostics, traitements et analyses
  /// confirmés depuis le début de la partie, tous patients confondus
  /// (MODELE_DE_JEU.md §5).
  int ticks;

  /// État des patients déjà admis au moins une fois, par identifiant de
  /// carte.
  final Map<String, EtatPatient> patients;

  /// Le patient [id] est-il en jeu ?
  bool enJeu(String id) => patients[id]?.enJeu ?? false;

  /// Copie profonde (instantané).
  EtatPartie copie() => EtatPartie(
    paquet: paquet,
    difficulte: difficulte,
    actions: actions,
    ticks: ticks,
    patients: patients.map((id, p) => MapEntry(id, p.copie())),
  );

  Map<String, dynamic> toJson() => {
    'format_etat': formatEtat,
    'paquet': paquet.toJson(),
    'difficulte': difficulte,
    'actions': actions,
    'ticks': ticks,
    'patients': patients.map((id, p) => MapEntry(id, p.toJson())),
  };
}

/// Contrôle d'un état sauvegardé avant de le reprendre avec [jeu].
class CompatibiliteEtat {
  CompatibiliteEtat._(this.erreurs, this.avertissements);

  /// Compare l'état au paquet actif (identité [paquet]) : avertissement si le
  /// paquet diffère, erreur si une maladie, une carte patient ou la
  /// difficulté référencées n'existent plus (MOTEUR_EFFETS.md §8).
  factory CompatibiliteEtat.verifier(
    EtatPartie etat,
    Jeu jeu,
    IdentitePaquet paquet,
  ) {
    final erreurs = <String>[];
    final avertissements = <String>[];
    if (etat.paquet != paquet) {
      avertissements.add(
        'La sauvegarde a été faite avec un autre paquet '
        '(${etat.paquet.id} ${etat.paquet.version}) que le paquet actif '
        '(${paquet.id} ${paquet.version}).',
      );
    }
    if (!jeu.difficultes.any((d) => d.id == etat.difficulte)) {
      erreurs.add(
        'difficulte : le niveau « ${etat.difficulte} » n\'existe plus',
      );
    }
    final maladies = jeu.maladies.map((m) => m.id).toSet();
    for (final e in etat.patients.entries) {
      final carte = jeu.cartes[e.key];
      if (carte == null || carte.type != TypeCarte.patient) {
        erreurs.add('patients.${e.key} : la carte patient n\'existe plus');
      }
      if (!maladies.contains(e.value.maladie)) {
        erreurs.add(
          'patients.${e.key}.maladie : la maladie « ${e.value.maladie} » '
          'n\'existe plus',
        );
      }
    }
    return CompatibiliteEtat._(erreurs, avertissements);
  }

  final List<String> erreurs;
  final List<String> avertissements;

  bool get compatible => erreurs.isEmpty;
}
