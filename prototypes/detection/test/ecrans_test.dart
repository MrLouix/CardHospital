import 'package:detection/ecrans/ecran_accueil.dart';
import 'package:detection/logique/stockage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Caméra factice : expose le rappel pour simuler des images.
void Function(List<String>)? _image;

Widget _cameraFactice(
  BuildContext context,
  Object config,
  void Function(List<String>) surImage,
) {
  _image = surImage;
  return const ColoredBox(color: Colors.black, child: SizedBox.expand());
}

void main() {
  late StockageMemoire stockage;
  setUp(() => stockage = StockageMemoire());

  Future<void> ouvrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: EcranAccueil(
          stockage: () async => stockage,
          camera: _cameraFactice,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('démarrage impossible sans carte posée', (tester) async {
    await ouvrir(tester);
    final bouton = find.byKey(const Key('demarrer'));
    expect(tester.widget<FilledButton>(bouton).onPressed, isNull);
    await tester.tap(find.text('MED-001'));
    await tester.pump();
    expect(tester.widget<FilledButton>(bouton).onPressed, isNotNull);
  });

  testWidgets('au plus 4 cartes posées', (tester) async {
    await ouvrir(tester);
    for (final c in ['MED-001', 'PAT-001', 'SAL-001', 'OBJ-001', 'DIP-001']) {
      await tester.tap(find.text(c));
      await tester.pump();
    }
    expect(find.text('Cartes posées (4/4)'), findsOneWidget);
  });

  testWidgets('essai complet : top départ, lecture, résultat gardé et '
      'enregistré', (tester) async {
    await ouvrir(tester);
    await tester.tap(find.text('MED-001'));
    await tester.tap(find.text('PAT-001'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('demarrer')));
    await tester.pumpAndSettle();

    // Avant le top départ, les images sont ignorées.
    _image!(['MED-001', 'PAT-001']);
    await tester.tap(find.byKey(const Key('top')));
    await tester.pump();
    expect(find.byKey(const Key('chrono')), findsOneWidget);

    // Mode cumulatif : deux détections successives.
    _image!(['MED-001', 'PAT-001']);
    await tester.pump(const Duration(milliseconds: 50));
    _image!(['MED-001', 'PAT-001']);
    await tester.pump();
    expect(find.textContaining('Réussi : 2 carte(s)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('terminer')));
    await tester.pumpAndSettle();
    expect(find.textContaining('N° 1 — 2 carte(s) — Réussi'), findsOneWidget);
    expect(stockage.essais.single.reussi, isTrue);
    expect(find.byKey(const Key('demarrer')), findsOneWidget);
    expect(find.text('Démarrer l\'essai n° 2'), findsOneWidget);
  });

  testWidgets('échec déclaré, essai non gardé', (tester) async {
    await ouvrir(tester);
    await tester.tap(find.text('MED-001'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('demarrer')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('top')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('echec')));
    await tester.pump();
    expect(find.textContaining('Échec après'), findsOneWidget);
    await tester.tap(find.byKey(const Key('jeter')));
    await tester.pump();
    expect(find.byKey(const Key('top')), findsOneWidget);
    expect(stockage.essais, isEmpty);
  });

  testWidgets('les essais enregistrés sont rechargés au démarrage', (
    tester,
  ) async {
    await ouvrir(tester);
    await tester.tap(find.text('SAL-002'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('demarrer')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('top')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('echec')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('suivant')));
    await tester.pump();
    expect(find.text('Essai n° 2 — Cumulative'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Nouvelle ouverture de l'appli sur le même stockage.
    await tester.pumpWidget(const SizedBox());
    await ouvrir(tester);
    expect(find.textContaining('N° 1 — 1 carte(s) — Échec'), findsOneWidget);
    expect(find.text('Démarrer l\'essai n° 2'), findsOneWidget);
  });
}
