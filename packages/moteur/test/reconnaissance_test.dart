import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/modeles/jeu.dart';
import 'package:moteur_cardhospital/moteur/reconnaissance.dart';
import 'package:test/test.dart';

void main() {
  final brut = jsonDecode(
    File('../../docs/exemples/jeu.exemple.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final jeu = Jeu.fromJson(brut);
  final reco = ReconnaissanceCombinaisons(jeu);

  test('admission : un patient seul propose admettre', () {
    final resultat = reco.reconnaitre(['PAT-001']);
    expect(resultat, isA<Apercu>());
    final apercu = resultat as Apercu;
    expect(apercu.motif, 'admission');
    expect(apercu.actions.map((a) => a.id), ['admettre']);
  });

  test(
    'standard : médecin + patient + salle propose diagnostiquer et traiter',
    () {
      final resultat = reco.reconnaitre(['MED-001', 'PAT-001', 'SAL-001']);
      expect(resultat, isA<Apercu>());
      final apercu = resultat as Apercu;
      expect(apercu.motif, 'standard');
      expect(
        apercu.actions.map((a) => a.id),
        containsAll(['diagnostiquer', 'traiter']),
      );
    },
  );

  test('standard avec accessoire (objet)', () {
    final resultat = reco.reconnaitre([
      'MED-001',
      'PAT-001',
      'SAL-001',
      'OBJ-001',
    ]);
    expect(resultat, isA<Apercu>());
    expect((resultat as Apercu).motif, 'standard');
  });

  test('standard avec second médecin à la place de l’accessoire', () {
    final resultat = reco.reconnaitre([
      'MED-001',
      'MED-002',
      'PAT-001',
      'SAL-001',
    ]);
    expect(resultat, isA<Apercu>());
    expect((resultat as Apercu).motif, 'standard');
  });

  test('un même QR scanné deux fois ne compte qu’une fois', () {
    final resultat = reco.reconnaitre(['PAT-001', 'PAT-001']);
    expect(resultat, isA<Apercu>());
    expect((resultat as Apercu).motif, 'admission');
  });

  test('refus : il manque une salle', () {
    final resultat = reco.reconnaitre(['MED-001', 'PAT-001']);
    expect(resultat, isA<Refus>());
    expect((resultat as Refus).message, 'Il faut une carte salle.');
  });

  test('refus : une seule carte patient par action', () {
    final resultat = reco.reconnaitre([
      'MED-001',
      'PAT-001',
      'PAT-002',
      'SAL-001',
    ]);
    expect(resultat, isA<Refus>());
    expect((resultat as Refus).message, 'Une seule carte patient par action.');
  });

  test('refus : 4 cartes maximum (second médecin + accessoire)', () {
    final resultat = reco.reconnaitre([
      'MED-001',
      'MED-002',
      'PAT-001',
      'SAL-001',
      'OBJ-001',
    ]);
    expect(resultat, isA<Refus>());
    expect((resultat as Refus).message, contains('maximum'));
  });

  test('refus : aucune carte reconnue', () {
    final resultat = reco.reconnaitre(['XXX-999']);
    expect(resultat, isA<Refus>());
    expect((resultat as Refus).message, 'Aucune carte reconnue.');
  });

  test('refus : deux salles signalé comme « une seule carte salle »', () {
    final resultat = reco.reconnaitre([
      'MED-001',
      'PAT-001',
      'SAL-001',
      'SAL-002',
    ]);
    expect(resultat, isA<Refus>());
    expect((resultat as Refus).message, 'Une seule carte salle par action.');
  });
}
