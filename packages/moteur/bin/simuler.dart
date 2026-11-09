import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:moteur_cardhospital/moteur.dart';
import 'package:moteur_cardhospital/simulateur.dart';

/// Simulateur en ligne de commande.
///
/// Exemple, depuis `packages/moteur` :
///
/// ```
/// dart run bin/simuler.dart --parties 2000 --strategies hasard,seuil:70,couleur:70
/// ```
Future<void> main(List<String> args) async {
  final options = ArgParser()
    ..addOption(
      'paquet',
      abbr: 'p',
      help: 'Chemin du jeu.json à simuler.',
      defaultsTo: '../../docs/exemples/jeu.exemple.json',
    )
    ..addOption(
      'schema',
      help: 'Chemin du JSON Schema de référence.',
      defaultsTo: '../../docs/schema/jeu.schema.json',
    )
    ..addOption('graine', abbr: 'g', help: 'Graine du hasard.', defaultsTo: '1')
    ..addOption(
      'parties',
      abbr: 'n',
      help: 'Parties par stratégie et par difficulté.',
      defaultsTo: '1000',
    )
    ..addOption('patients', help: 'Patients par partie.', defaultsTo: '10')
    ..addOption(
      'joueurs',
      help: 'Joueurs, à tour de rôle (2 ou 3 pour simuler le partage).',
      defaultsTo: '1',
    )
    ..addOption(
      'partage',
      help:
          'Avec plusieurs joueurs : résultats des diagnostics mis en commun '
          '(oui), gardés pour soi (non), ou les deux modes (les-deux).',
      allowed: ['oui', 'non', 'les-deux'],
      defaultsTo: 'les-deux',
    )
    ..addOption(
      'cartes',
      help:
          'Cartes des joueurs : toutes à chacun (communes), ou un médecin par '
          'joueur, plus un diplôme à 2 ou 3 joueurs (personnelles).',
      allowed: ['communes', 'personnelles'],
      defaultsTo: 'communes',
    )
    ..addOption(
      'en-jeu',
      help: 'Patients en jeu à la fois (N des règles de table).',
      defaultsTo: '3',
    )
    ..addOption(
      'actions-max',
      help: 'Actions au-delà desquelles un patient est abandonné.',
      defaultsTo: '60',
    )
    ..addOption(
      'strategies',
      abbr: 's',
      help:
          'Stratégies, séparées par des virgules : hasard, seuil:<X>, '
          'couleur:<X>, novice:<X>, novice+labo:<X> (novice qui analyse au '
          'laboratoire).',
      defaultsTo: 'hasard,seuil:60,seuil:80,couleur:60,couleur:80',
    )
    ..addOption(
      'difficultes',
      abbr: 'd',
      help:
          'Identifiants des niveaux, séparés par des virgules (défaut : '
          'tous).',
    )
    ..addOption(
      'format',
      abbr: 'f',
      allowed: ['markdown', 'json'],
      defaultsTo: 'markdown',
    )
    ..addOption(
      'sortie',
      abbr: 'o',
      help: 'Fichier de sortie (défaut : écran).',
    )
    ..addFlag(
      'aide',
      abbr: 'h',
      aliases: ['help'],
      negatable: false,
      help: 'Affiche cette aide (aussi --help).',
    );

  final ArgResults o;
  try {
    o = options.parse(args);
  } on FormatException catch (e) {
    _quitter('${e.message}\n\n${options.usage}');
  }
  if (o.flag('aide')) {
    stdout.writeln('Simulateur CardHospital\n\n${options.usage}');
    return;
  }

  int entier(String nom) =>
      int.tryParse(o.option(nom)!) ??
      _quitter('--$nom : entier attendu (« ${o.option(nom)} »)');

  final fichier = File(o.option('paquet')!);
  if (!fichier.existsSync()) _quitter('Paquet introuvable : ${fichier.path}');
  final brut = jsonDecode(fichier.readAsStringSync()) as Map<String, dynamic>;
  final rapportValidation = Validateur(cheminSchema: o.option('schema'))
      .validerJson(brut);
  if (!rapportValidation.valide) {
    _quitter(
      'Paquet invalide :\n${rapportValidation.erreurs.map((e) => '- $e').join('\n')}',
    );
  }
  final jeu = Jeu.fromJson(brut);

  final List<Strategie> strategies;
  try {
    strategies = [
      for (final s in o.option('strategies')!.split(','))
        Strategie.depuis(s.trim()),
    ];
  } on FormatException catch (e) {
    _quitter(e.message);
  }
  final difficultes = o
      .option('difficultes')
      ?.split(',')
      .map((d) => d.trim())
      .toList();
  for (final d in difficultes ?? const <String>[]) {
    if (!jeu.difficultes.any((n) => n.id == d)) {
      _quitter('Difficulté inconnue : $d');
    }
  }

  final simulateur = Simulateur(
    jeu,
    parametres: ParametresSimulation(
      graine: entier('graine'),
      parties: entier('parties'),
      patientsParPartie: entier('patients'),
      patientsEnJeu: entier('en-jeu'),
      joueurs: entier('joueurs'),
      partages: switch (o.option('partage')) {
        'oui' => const [true],
        'non' => const [false],
        _ => const [true, false],
      },
      actionsMax: entier('actions-max'),
      cartesPersonnelles: o.option('cartes') == 'personnelles',
    ),
  );
  final rapport = simulateur.simuler(strategies, difficultes: difficultes);
  final texte = o.option('format') == 'json'
      ? rapport.enJson()
      : rapport.enMarkdown();
  final sortie = o.option('sortie');
  if (sortie == null) {
    stdout.write(texte);
  } else {
    File(sortie).writeAsStringSync(texte);
    stderr.writeln('Rapport écrit dans $sortie');
  }
}

Never _quitter(String message) {
  stderr.writeln(message);
  exit(64);
}
