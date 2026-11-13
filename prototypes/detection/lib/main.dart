import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'ecrans/ecran_accueil.dart';
import 'logique/stockage.dart';

/// Prototype de détection multi-QR (phase 0 de la feuille de route).
///
/// Appli jetable : elle mesure la lecture des cartes de test par
/// `mobile_scanner`, sans rien du jeu.
void main() => runApp(const AppliDetection());

class AppliDetection extends StatelessWidget {
  const AppliDetection({super.key, this.stockage = _stockageParDefaut});

  /// Fournit le stockage des essais (remplaçable dans les tests).
  final Future<Stockage> Function() stockage;

  static Future<Stockage> _stockageParDefaut() async {
    final dossier = await getApplicationDocumentsDirectory();
    return StockageFichier(File('${dossier.path}/essais_detection.json'));
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Détection CardHospital',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00796B)),
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00796B),
        brightness: Brightness.dark,
      ),
    ),
    home: EcranAccueil(stockage: stockage),
  );
}
