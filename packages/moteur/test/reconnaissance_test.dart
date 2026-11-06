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

  List<String> ids(Reconnaissance r) => [
    for (final a in (r as Apercu).actions) a.id,
  ];

  test('admission : un patient seul propose admettre', () {
    final resultat = reco.reconnaitre(['PAT-001']);
    expect(resultat, isA<Apercu>());
    final apercu = resultat as Apercu;
    expect(apercu.motifs, ['admission']);
    expect(ids(apercu), ['admettre']);
  });

  test(
    'standard : médecin + patient + salle propose diagnostiquer et traiter',
    () {
      final resultat = reco.reconnaitre(['MED-001', 'PAT-001', 'SAL-001']);
      expect(resultat, isA<Apercu>());
      expect((resultat as Apercu).motifs, ['standard']);
      expect(ids(resultat), containsAll(['diagnostiquer', 'traiter']));
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
    expect((resultat as Apercu).motifs, ['standard']);
  });

  test('standard avec second médecin à la place de l’accessoire', () {
    final resultat = reco.reconnaitre([
      'MED-001',
      'MED-002',
      'PAT-001',
      'SAL-001',
    ]);
    expect(resultat, isA<Apercu>());
    expect((resultat as Apercu).motifs, ['standard']);
  });

  test('un même QR scanné deux fois ne compte qu’une fois', () {
    final resultat = reco.reconnaitre(['PAT-001', 'PAT-001']);
    expect(resultat, isA<Apercu>());
    expect((resultat as Apercu).motifs, ['admission']);
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

  test('standard : second médecin et accessoire (5 cartes)', () {
    final resultat = reco.reconnaitre([
      'MED-001',
      'MED-002',
      'PAT-001',
      'SAL-001',
      'DIP-004',
    ]);
    expect((resultat as Apercu).motifs, ['standard']);
  });

  test('refus : 2 médecins et 1 accessoire au plus', () {
    final troisMedecins = reco.reconnaitre([
      'MED-001',
      'MED-002',
      'MED-005',
      'PAT-001',
      'SAL-001',
    ]);
    expect((troisMedecins as Refus).message, '2 cartes médecin au maximum.');
    final deuxAccessoires = reco.reconnaitre([
      'MED-001',
      'PAT-001',
      'SAL-001',
      'OBJ-001',
      'DIP-004',
    ]);
    expect(
      (deuxAccessoires as Refus).message,
      'Une seule carte accessoire (objet ou diplôme) par action.',
    );
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

  test('plusieurs motifs correspondent : leurs actions sont réunies, dans '
      'l\'ordre de déclaration des actions', () {
    final copie = jsonDecode(jsonEncode(brut)) as Map<String, dynamic>;
    final motifs = copie['motifs'] as Map<String, dynamic>;
    copie['motifs'] = {
      'recherche': {
        'patient': [1, 1],
        'medecin': [1, 1],
        'salle': [1, 1],
        'objet|diplome': [0, 1],
        'total': [3, 4],
      },
      ...motifs,
    };
    (copie['actions'] as List).add({
      'id': 'analyser',
      'libelle': 'Analyser',
      'motif': 'recherche',
      'phrase': 'Analyse pour {patient}.',
      'effets': [
        {'effet': 'avancer_temps'},
      ],
    });
    final r = ReconnaissanceCombinaisons(Jeu.fromJson(copie));
    final trois = r.reconnaitre(['MED-001', 'PAT-001', 'SAL-001']);
    expect((trois as Apercu).motifs, ['recherche', 'standard']);
    expect(ids(trois), ['diagnostiquer', 'traiter', 'analyser']);
    final quatre = r.reconnaitre(['MED-001', 'PAT-001', 'SAL-001', 'OBJ-001']);
    expect((quatre as Apercu).motifs, ['recherche', 'standard']);
    final deuxMedecins = r.reconnaitre([
      'MED-001',
      'MED-002',
      'PAT-001',
      'SAL-001',
    ]);
    expect((deuxMedecins as Apercu).motifs, ['standard']);
    expect(ids(deuxMedecins), ['diagnostiquer', 'traiter']);
  });
}
