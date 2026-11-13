import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:moteur_cardhospital/moteur.dart';
import 'package:moteur_cardhospital/simulateur.dart';

/// Simule les variantes de partage d'information (relève, adressage…).
///
/// Exemple, depuis `packages/moteur` :
///
/// ```
/// dart run bin/simuler_variantes.dart --joueurs 3 --parties 500
/// ```
void main(List<String> args) {
  final options = ArgParser()
    ..addOption(
      'paquet',
      abbr: 'p',
      help: 'Chemin du jeu.json à simuler.',
      defaultsTo: '../../contenu/paquet_base.json',
    )
    ..addOption('graine', abbr: 'g', help: 'Graine du hasard.', defaultsTo: '1')
    ..addOption(
      'parties',
      abbr: 'n',
      help: 'Parties par variante et par population.',
      defaultsTo: '500',
    )
    ..addOption('patients', help: 'Patients par partie.', defaultsTo: '10')
    ..addOption(
      'joueurs',
      help: 'Joueurs (2 à 6) ; autant de patients en jeu.',
      defaultsTo: '3',
    )
    ..addOption(
      'seuil',
      help: 'Indice de suspicion à partir duquel un joueur agit.',
      defaultsTo: '70',
    )
    ..addFlag(
      'novices',
      negatable: false,
      help:
          'Joueurs novices, qui découvrent les traitements au laboratoire '
          '(sinon vétérans).',
    )
    ..addOption(
      'difficulte',
      abbr: 'd',
      help: 'Identifiant du niveau (défaut : le premier du paquet).',
    )
    ..addOption(
      'paliers',
      help:
          'Paliers d\'aggravation à la place de ceux du paquet, en ticks, '
          'séparés par des virgules (ex. 3,6,9,12) : pour mesurer l\'effet '
          'd\'un temps plus pressant.',
    )
    ..addOption(
      'variantes',
      abbr: 'v',
      help:
          'Variantes, séparées par des virgules (défaut : toutes) : '
          '${Variante.catalogue.map((v) => v.nom).join(', ')}.',
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
    ..addFlag('aide', abbr: 'h', aliases: ['help'], negatable: false);

  final ArgResults o;
  try {
    o = options.parse(args);
  } on FormatException catch (e) {
    _quitter('${e.message}\n\n${options.usage}');
  }
  if (o.flag('aide')) {
    stdout.writeln('Variantes de partage CardHospital\n\n${options.usage}');
    return;
  }

  int entier(String nom, {required int min, int? max}) {
    final valeur =
        int.tryParse(o.option(nom)!) ??
        _quitter('--$nom : entier attendu (« ${o.option(nom)} »)');
    if (valeur < min || (max != null && valeur > max)) {
      _quitter(
        '--$nom : ${max == null ? 'au moins $min' : 'de $min à $max'} '
        'attendu ($valeur)',
      );
    }
    return valeur;
  }

  final fichier = File(o.option('paquet')!);
  if (!fichier.existsSync()) _quitter('Paquet introuvable : ${fichier.path}');
  final Object? brut;
  try {
    brut = jsonDecode(fichier.readAsStringSync());
  } on FormatException catch (e) {
    _quitter('Paquet illisible (JSON mal formé) : ${e.message}');
  }
  if (brut is! Map<String, dynamic>) {
    _quitter('Paquet invalide : un objet JSON est attendu à la racine.');
  }
  if (o.option('paliers') case final paliers?) {
    (brut['parametres'] as Map<String, dynamic>)['paliers_aggravation'] = [
      for (final t in paliers.split(',')) int.tryParse(t.trim()),
    ];
  }
  final validation = Validateur().validerJson(brut);
  if (!validation.valide) {
    _quitter(
      'Paquet invalide :\n${validation.erreurs.map((e) => '- $e').join('\n')}',
    );
  }

  final RapportVariantes rapport;
  try {
    final variantes = o.option('variantes') == null
        ? Variante.catalogue
        : [
            for (final nom in o.option('variantes')!.split(','))
              Variante.depuis(nom.trim()),
          ];
    rapport = SimulateurVariantes(
      Jeu.fromJson(brut),
      parametres: ParametresVariantes(
        graine: entier('graine', min: 0),
        parties: entier('parties', min: 1),
        patientsParPartie: entier('patients', min: 1),
        joueurs: entier('joueurs', min: 2, max: 6),
        seuil: entier('seuil', min: 0, max: 100),
        novices: o.flag('novices'),
        difficulte: o.option('difficulte'),
      ),
    ).simuler(variantes);
  } on FormatException catch (e) {
    _quitter(e.message);
  } on ArgumentError catch (e) {
    _quitter('${e.message}');
  }
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
