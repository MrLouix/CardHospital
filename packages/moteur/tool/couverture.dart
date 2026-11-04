import 'dart:io';

/// Vérifie la couverture de tests à partir de `coverage/lcov.info`
/// (produit par `dart run coverage:test_with_coverage`), hors code généré.
///
/// Usage : `dart run tool/couverture.dart [seuil]` (défaut : 90).
void main(List<String> args) {
  final seuil = args.isEmpty ? 90.0 : double.parse(args.first);
  final lcov = File('coverage/lcov.info');
  if (!lcov.existsSync()) {
    stderr.writeln(
      'coverage/lcov.info absent : lancez d\'abord '
      '`dart run coverage:test_with_coverage`.',
    );
    exit(2);
  }
  final lignes = <String, (int, int)>{};
  String? fichier;
  for (final ligne in lcov.readAsLinesSync()) {
    if (ligne.startsWith('SF:')) {
      fichier = ligne.substring(3).split('/lib/').last;
    } else if (ligne.startsWith('DA:') && !fichier!.endsWith('.g.dart')) {
      final execute = int.parse(ligne.substring(3).split(',')[1]) > 0;
      final (total, couvert) = lignes[fichier] ?? (0, 0);
      lignes[fichier] = (total + 1, couvert + (execute ? 1 : 0));
    }
  }
  var total = 0;
  var couvert = 0;
  for (final MapEntry(key: f, value: (t, c)) in lignes.entries) {
    total += t;
    couvert += c;
    stdout.writeln('${f.padRight(32)} ${(100 * c / t).toStringAsFixed(1)} %');
  }
  final taux = 100 * couvert / total;
  stdout.writeln('Total : ${taux.toStringAsFixed(1)} % ($couvert/$total)');
  if (taux < seuil) {
    stderr.writeln('Couverture inférieure au seuil de $seuil %.');
    exit(1);
  }
}
