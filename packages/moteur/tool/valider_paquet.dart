import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/moteur.dart';

/// Valide un jeu.json et affiche le rapport. Usage :
/// `dart run tool/valider_paquet.dart <jeu.json>`.
///
/// Code de sortie : 0 si le paquet est valide, 1 s'il ne l'est pas, 64 si
/// la commande est mal appelée ou le fichier illisible.
void main(List<String> args) {
  if (args.length != 1) {
    _quitter('Usage : dart run tool/valider_paquet.dart <jeu.json>');
  }
  final fichier = File(args.single);
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
  final debut = DateTime.now();
  final rapport = Validateur().validerJson(brut);
  final duree = DateTime.now().difference(debut).inMilliseconds;
  stdout.writeln('Erreurs : ${rapport.erreurs.length} — validé en $duree ms');
  for (final e in rapport.erreurs) {
    stdout.writeln('  ✗ $e');
  }
  stdout.writeln('Avertissements : ${rapport.avertissements.length}');
  for (final a in rapport.avertissements) {
    stdout.writeln('  ! $a');
  }
  exit(rapport.valide ? 0 : 1);
}

Never _quitter(String message) {
  stderr.writeln(message);
  exit(64);
}
