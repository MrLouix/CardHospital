import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/moteur.dart';

/// JSON brut de l'exemple du dépôt.
final String exempleBrut = File('../../docs/exemples/jeu.exemple.json')
    .readAsStringSync();

/// Copie modifiable du JSON de l'exemple.
Map<String, dynamic> copieExemple() =>
    jsonDecode(exempleBrut) as Map<String, dynamic>;

/// Paquet d'exemple, éventuellement modifié par [modifier].
Jeu jeuExemple([void Function(Map<String, dynamic> brut)? modifier]) {
  final brut = copieExemple();
  modifier?.call(brut);
  return Jeu.fromJson(brut);
}

/// Source de hasard scriptée : renvoie les valeurs dans l'ordre, en boucle.
class SequenceFixe implements SourceAleatoire {
  SequenceFixe(this.valeurs);

  final List<double> valeurs;
  var _i = 0;

  @override
  double flottant() => valeurs[_i++ % valeurs.length];
}

/// Paquet de base du dépôt (`contenu/paquet_base.json`).
Jeu jeuBase() => Jeu.fromJson(
  jsonDecode(File('../../contenu/paquet_base.json').readAsStringSync())
      as Map<String, dynamic>,
);

/// Valeurs de tirage d'admission menant à chaque maladie de l'exemple
/// (poids 1, 2, 1, 2, 3, 2 : total 11).
const tirageFractureOuverte = 0.0;
const tirageFractureFermee = 0.2;
const tirageAngine = 0.3;
const tirageMauxDeTete = 0.45;
const tiragePhobie = 0.7;
const tirageHypocondrie = 0.9;
