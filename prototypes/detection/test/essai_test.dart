import 'package:detection/logique/configuration.dart';
import 'package:detection/logique/essai.dart';
import 'package:flutter_test/flutter_test.dart';

Duration ms(int x) => Duration(milliseconds: x);

void main() {
  const quatre = {'MED-001', 'PAT-001', 'SAL-001', 'OBJ-001'};
  const cumulatif = ConfigEssai(cartesAttendues: quatre);
  const simultane = ConfigEssai(
    cartesAttendues: quatre,
    mode: ModeSelection.simultane,
  );

  group('mode cumulatif', () {
    test('une carte entre dans la sélection après deux détections '
        'successives, et y reste hors du champ', () {
      final s = SuiviEssai(cumulatif);
      s.ajouterImage(ms(100), ['MED-001']);
      expect(s.selection, isEmpty, reason: 'une seule image');
      s.ajouterImage(ms(150), ['MED-001', 'PAT-001']);
      expect(s.selection, ['MED-001']);
      s.ajouterImage(ms(200), ['PAT-001', 'SAL-001']);
      expect(s.selection, ['MED-001', 'PAT-001']);
      s.ajouterImage(ms(250), ['SAL-001']);
      expect(s.selection, ['MED-001', 'PAT-001', 'SAL-001']);
      expect(s.termine, isFalse);
    });

    test(
      'deux détections trop espacées ne comptent pas comme consécutives',
      () {
        final s = SuiviEssai(cumulatif);
        s.ajouterImage(ms(100), ['MED-001']);
        s.ajouterImage(ms(500), ['MED-001']);
        expect(s.selection, isEmpty, reason: 'écart de 400 ms > 300 ms');
        s.ajouterImage(ms(700), ['MED-001']);
        expect(s.selection, ['MED-001']);
      },
    );

    test('réussite quand toutes les cartes sont sélectionnées', () {
      final s = SuiviEssai(cumulatif);
      s.ajouterImage(ms(100), ['MED-001', 'PAT-001']);
      s.ajouterImage(ms(150), ['MED-001', 'PAT-001']);
      s.ajouterImage(ms(800), ['SAL-001', 'OBJ-001']);
      expect(s.ajouterImage(ms(850), ['SAL-001', 'OBJ-001']), isTrue);
      expect(s.issue, IssueEssai.reussi);
      expect(s.duree, ms(850));
      expect(
        s.ajouterImage(ms(900), ['DIP-001']),
        isFalse,
        reason: 'essai terminé : plus rien n\'est enregistré',
      );
      expect(s.detections, hasLength(4));
    });

    test('fausses lectures : comptées, et repérées si elles entrent dans la '
        'sélection', () {
      final s = SuiviEssai(cumulatif);
      s.ajouterImage(ms(100), ['MED-001', 'DIP-002', 'xyz']);
      s.ajouterImage(ms(150), ['MED-001', 'DIP-002']);
      expect(s.faussesLectures, {'DIP-002', 'xyz'});
      expect(s.selection, ['MED-001', 'DIP-002']);
      s.abandonner(ms(400));
      final r = s.resultat(numero: 1, date: DateTime(2026));
      expect(r.faussesDansSelection, {'DIP-002'});
    });

    test('retirer une carte, vider la sélection', () {
      final s = SuiviEssai(cumulatif);
      s.ajouterImage(ms(100), ['MED-001', 'PAT-001']);
      s.ajouterImage(ms(150), ['MED-001', 'PAT-001']);
      s.retirer('MED-001');
      expect(s.selection, ['PAT-001']);
      s.vider();
      expect(s.selection, isEmpty);
    });
  });

  group('mode simultané', () {
    test('réussite seulement si une même image contient toutes les cartes', () {
      final s = SuiviEssai(simultane);
      s.ajouterImage(ms(100), ['MED-001', 'PAT-001']);
      s.ajouterImage(ms(150), ['SAL-001', 'OBJ-001']);
      expect(s.termine, isFalse);
      expect(s.selection, ['SAL-001', 'OBJ-001'], reason: 'dernière image');
      expect(
        s.ajouterImage(ms(200), ['OBJ-001', 'MED-001', 'SAL-001', 'PAT-001']),
        isTrue,
      );
      expect(s.duree, ms(200));
    });
  });

  group('délai et abandon', () {
    test('échec au-delà du délai maximal', () {
      final s = SuiviEssai(cumulatif.copyWith(delaiMaxS: 2));
      expect(s.verifierDelai(ms(1999)), isFalse);
      expect(s.verifierDelai(ms(2001)), isTrue);
      expect(s.issue, IssueEssai.echec);
      expect(s.duree, const Duration(seconds: 2));
    });

    test('une image après le délai termine l\'essai en échec', () {
      final s = SuiviEssai(cumulatif.copyWith(delaiMaxS: 1));
      expect(s.ajouterImage(ms(1500), quatre), isFalse);
      expect(s.issue, IssueEssai.echec);
      expect(s.detections, isEmpty);
    });

    test('abandon par le testeur', () {
      final s = SuiviEssai(cumulatif)..abandonner(ms(1234));
      expect(s.issue, IssueEssai.echec);
      expect(s.duree, ms(1234));
      s.abandonner(ms(2000));
      expect(s.duree, ms(1234), reason: 'déjà terminé');
    });

    test('résultat demandé avant la fin : erreur', () {
      expect(
        () => SuiviEssai(cumulatif).resultat(numero: 1, date: DateTime(2026)),
        throwsStateError,
      );
    });

    test('contenus vides ignorés', () {
      final s = SuiviEssai(cumulatif);
      expect(s.ajouterImage(ms(10), ['', '  ']), isFalse);
      expect(s.detections, isEmpty);
    });
  });

  test('critère de 3 s', () {
    ResultatEssai r(int duree, IssueEssai issue) => ResultatEssai(
      numero: 1,
      date: DateTime(2026),
      config: cumulatif,
      issue: issue,
      duree: ms(duree),
      detections: const [],
      faussesLectures: const {},
      faussesDansSelection: const {},
      selectionFinale: const [],
    );
    expect(r(2999, IssueEssai.reussi).moinsDe3s, isTrue);
    expect(r(3000, IssueEssai.reussi).moinsDe3s, isFalse);
    expect(r(1000, IssueEssai.echec).moinsDe3s, isFalse);
  });

  test('configuration et résultat : aller-retour JSON', () {
    final config = cumulatif.copyWith(
      telephone: 'Pixel 7a, Android 15',
      finition: Finition.brillante,
      taille: TailleQr.t15,
      correction: Correction.q,
      eclairage: Eclairage.penombre,
      support: Support.enMain,
      resolution: Resolution.r1080,
      distanceCm: () => 35,
      angle: 45,
    );
    expect(ConfigEssai.fromJson(config.toJson()).toJson(), config.toJson());
    final s = SuiviEssai(config)
      ..ajouterImage(ms(10), ['MED-001'])
      ..abandonner(ms(20));
    final r = s.resultat(numero: 7, date: DateTime(2026, 11, 5, 10));
    expect(ResultatEssai.fromJson(r.toJson()).toJson(), r.toJson());
    expect(
      config.copyWith(distanceCm: () => null).distanceCm,
      isNull,
      reason: 'distance effaçable',
    );
  });
}
