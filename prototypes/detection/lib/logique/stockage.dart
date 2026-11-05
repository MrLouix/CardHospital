import 'dart:convert';
import 'dart:io';

import 'essai.dart';

/// Sauvegarde des essais, après chaque essai : une série de 200 essais ne
/// doit pas être perdue si l'appli est fermée.
abstract interface class Stockage {
  Future<List<ResultatEssai>> charger();
  Future<void> enregistrer(List<ResultatEssai> essais);
}

/// Stockage en mémoire (tests d'écran, où les accès fichiers ne se
/// terminent pas dans le temps simulé).
class StockageMemoire implements Stockage {
  final essais = <ResultatEssai>[];

  @override
  Future<List<ResultatEssai>> charger() async => [...essais];

  @override
  Future<void> enregistrer(List<ResultatEssai> essais) async => this.essais
    ..clear()
    ..addAll(essais);
}

/// Stockage dans un fichier JSON.
class StockageFichier implements Stockage {
  StockageFichier(this.fichier);

  final File fichier;

  /// Essais enregistrés ; liste vide si le fichier n'existe pas ou est
  /// illisible (un fichier illisible est conservé sous `.illisible`).
  @override
  Future<List<ResultatEssai>> charger() async {
    if (!await fichier.exists()) return [];
    try {
      final json =
          jsonDecode(await fichier.readAsString()) as Map<String, dynamic>;
      return [
        for (final e in json['essais'] as List)
          ResultatEssai.fromJson(e as Map<String, dynamic>),
      ];
    } on Object {
      await fichier.rename('${fichier.path}.illisible');
      return [];
    }
  }

  /// Écriture atomique : fichier temporaire puis renommage.
  @override
  Future<void> enregistrer(List<ResultatEssai> essais) async {
    final temporaire = File('${fichier.path}.tmp');
    await temporaire.writeAsString(
      jsonEncode({
        'format': 1,
        'essais': essais.map((e) => e.toJson()).toList(),
      }),
      flush: true,
    );
    await temporaire.rename(fichier.path);
  }
}
