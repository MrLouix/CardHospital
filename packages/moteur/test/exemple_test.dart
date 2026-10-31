import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/modeles/jeu.dart';
import 'package:moteur_cardhospital/validation/validateur.dart';
import 'package:test/test.dart';

void main() {
  final fichier = File('../../docs/exemples/jeu.exemple.json');
  final brut = jsonDecode(fichier.readAsStringSync()) as Map<String, dynamic>;

  test('l\'exemple du dépôt se charge en modèles typés', () {
    final jeu = Jeu.fromJson(brut);
    expect(jeu.format, 'cardhospital');
    expect(jeu.schemaVersion, 1);
    expect(jeu.cartes.length, 14);
    expect(jeu.maladies.length, 6);
    expect(jeu.motifs.keys, containsAll(['admission', 'standard']));
    expect(
      jeu.actions.map((a) => a.id),
      containsAll(['admettre', 'diagnostiquer', 'traiter']),
    );
    expect(jeu.cartes['MED-001']!.type, TypeCarte.medecin);
    expect(
      jeu.maladies.first.traitement.adapte.toJson(),
      isA<Map<String, dynamic>>(),
    );
  });

  test('l\'exemple du dépôt passe la validation', () {
    final rapport = Validateur().validerJson(brut, jeu: Jeu.fromJson(brut));
    expect(rapport.erreurs, isEmpty, reason: rapport.erreurs.join('\n'));
    expect(rapport.valide, isTrue);
  });

  test('un poids nul est refusé avec un message explicite', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[0]['poids'] = 0;
    final rapport = Validateur().validerJson(copie);
    expect(rapport.valide, isFalse);
    expect(rapport.erreurs, contains(contains('poids d\'au moins 1')));
  });

  test('une spécialité non déclarée est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['maladies'] as List)[0]['type'] = 'cardiologie';
    final rapport = Validateur().validerJson(copie);
    expect(rapport.erreurs, contains(contains('cardiologie')));
  });

  test('une référence de carte inconnue est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    ((copie['maladies'] as List)[2]['traitement'] as Map)['adapte'] = {
      'carte': 'OBJ-999',
    };
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('OBJ-999')));
  });

  test('une variable de phrase incompatible avec le motif est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['actions'] as List)[0]['phrase'] =
        'Admission de {patient} dans {salle}.';
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('{salle}')));
  });

  test('une spécialité sans maladie est refusée', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    (copie['specialites'] as List).add({
      'id': 'dermatologie',
      'nom': 'Dermatologie',
    });
    final rapport = Validateur().validerJson(copie, jeu: Jeu.fromJson(copie));
    expect(rapport.erreurs, contains(contains('dermatologie')));
  });
}
