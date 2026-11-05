import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/moteur.dart';

/// Valide un jeu.json et affiche le rapport. Usage :
/// `dart run tool/valider_paquet.dart <jeu.json>`.
void main(List<String> args) {
  final brut =
      jsonDecode(File(args.single).readAsStringSync()) as Map<String, dynamic>;
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
