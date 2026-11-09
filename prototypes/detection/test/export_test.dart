import 'dart:io';

import 'package:detection/logique/configuration.dart';
import 'package:detection/logique/essai.dart';
import 'package:detection/logique/export_csv.dart';
import 'package:detection/logique/statistiques.dart';
import 'package:detection/logique/stockage.dart';
import 'package:flutter_test/flutter_test.dart';

ResultatEssai essai(
  int numero,
  int dureeMs, {
  IssueEssai issue = IssueEssai.reussi,
  Set<String> faux = const {},
  Set<String> fauxSelection = const {},
  int cartes = 4,
  String telephone = 'Galaxy A10',
}) => ResultatEssai(
  numero: numero,
  date: DateTime(2026, 11, 5, 14, 30),
  config: ConfigEssai(
    telephone: telephone,
    cartesAttendues: contenusPlanche.take(cartes).toSet(),
    distanceCm: 30,
  ),
  issue: issue,
  duree: Duration(milliseconds: dureeMs),
  detections: [
    Detection(const Duration(milliseconds: 120), ['MED-001', 'PAT-001']),
    Detection(Duration(milliseconds: dureeMs), ['MED-001']),
  ],
  faussesLectures: faux,
  faussesDansSelection: fauxSelection,
  selectionFinale: const ['MED-001', 'PAT-001'],
);

void main() {
  group('export CSV', () {
    test('un essai par ligne, séparateur ;, décimales avec virgule', () {
      final csv = ExportCsv.essais([
        essai(1, 1834),
        essai(2, 10000, issue: IssueEssai.echec),
      ]);
      final lignes = csv.trim().split('\n');
      expect(lignes, hasLength(3));
      expect(lignes.first.split(';'), ExportCsv.enTetesEssais);
      final l1 = lignes[1].split(';');
      expect(l1, hasLength(ExportCsv.enTetesEssais.length));
      String champ(List<String> l, String nom) =>
          l[ExportCsv.enTetesEssais.indexOf(nom)];
      expect(champ(l1, 'telephone'), 'Galaxy A10');
      expect(champ(l1, 'taille_cm'), '2,0');
      expect(champ(l1, 'cartes_attendues'), 'MED-001+PAT-001+SAL-001+OBJ-001');
      expect(champ(l1, 'nb_cartes'), '4');
      expect(champ(l1, 'issue'), 'reussi');
      expect(champ(l1, 'temps_s'), '1,834');
      expect(champ(l1, 'moins_de_3s'), '1');
      expect(champ(l1, 'images'), '2');
      expect(champ(l1, 'distance_cm'), '30');
      expect(champ(lignes[2].split(';'), 'moins_de_3s'), '0');
    });

    test('texte libre protégé', () {
      final csv = ExportCsv.essais([essai(1, 1000, telephone: 'Pixel; "7a"')]);
      expect(csv, contains('"Pixel; ""7a"""'));
    });

    test('une détection par ligne', () {
      final csv = ExportCsv.detections([essai(1, 900), essai(2, 700)]);
      expect(csv.trim().split('\n'), [
        'numero_essai;t_ms;contenus',
        '1;120;MED-001+PAT-001',
        '1;900;MED-001',
        '2;120;MED-001+PAT-001',
        '2;700;MED-001',
      ]);
    });
  });

  group('statistiques', () {
    test('taux sous 3 s, médiane, fausses lectures', () {
      final s = Statistiques([
        essai(1, 1000),
        essai(2, 2000, faux: {'DIP-002'}, fauxSelection: {'DIP-002'}),
        essai(3, 4000),
        essai(4, 10000, issue: IssueEssai.echec),
      ]);
      expect(s.essais, 4);
      expect(s.reussis, 3);
      expect(s.moinsDe3s, 2);
      expect(s.tauxMoinsDe3s, 0.5);
      expect(s.mediane, const Duration(seconds: 2));
      expect(s.faussesLectures, 1);
      expect(s.essaisAvecFausseSelection, 1);
      expect(s.critereTemps, isFalse);
      expect(s.critereFaussesLectures, isFalse);
    });

    test('critères de sortie atteints', () {
      final s = Statistiques([for (var i = 0; i < 200; i++) essai(i, 1500)]);
      expect(s.critereTemps, isTrue);
      expect(s.critereFaussesLectures, isTrue);
      expect(Statistiques(const []).mediane, isNull);
      expect(Statistiques(const []).critereTemps, isFalse);
    });
  });

  group('stockage', () {
    late Directory dossier;
    setUp(() => dossier = Directory.systemTemp.createTempSync('detection'));
    tearDown(() => dossier.deleteSync(recursive: true));

    test('aller-retour, fichier absent', () async {
      final stockage = StockageFichier(File('${dossier.path}/essais.json'));
      expect(await stockage.charger(), isEmpty);
      await stockage.enregistrer([essai(1, 1000), essai(2, 2000)]);
      final relus = await stockage.charger();
      expect(relus.map((e) => e.numero), [1, 2]);
      expect(relus.first.toJson(), essai(1, 1000).toJson());
    });

    test('fichier illisible : mis de côté, liste vide', () async {
      final fichier = File('${dossier.path}/essais.json')
        ..writeAsStringSync('{pas du json');
      expect(await StockageFichier(fichier).charger(), isEmpty);
      expect(File('${fichier.path}.illisible').existsSync(), isTrue);
    });
  });
}
