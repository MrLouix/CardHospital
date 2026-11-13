import 'dart:convert';
import 'dart:io';

import 'package:moteur_cardhospital/moteur.dart';
import 'package:test/test.dart';

import 'aide.dart';

/// Le paquet réellement joué (`contenu/paquet_base.json`) : validation,
/// traitements plausibles et règles du laboratoire.
void main() {
  final brut = jsonDecode(
    File('../../contenu/paquet_base.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final jeu = jeuBase();
  final combinaisons = Validateur.combinaisonsPossibles(jeu);

  test('le paquet de base passe la validation, sans avertissement', () {
    final rapport = Validateur().validerJson(brut, jeu: jeu);
    expect(rapport.erreurs, isEmpty, reason: rapport.erreurs.join('\n'));
    expect(
      rapport.avertissements,
      isEmpty,
      reason: rapport.avertissements.join('\n'),
    );
  });

  test('catalogue : 10 médecins, 12 patients, 11 salles, 24 accessoires '
      '(dont 3 d\'aide à la recherche), 103 maladies sur 5 spécialités', () {
    int nombre(TypeCarte type) =>
        jeu.cartes.values.where((c) => c.type == type).length;
    expect(nombre(TypeCarte.medecin), 10);
    expect(nombre(TypeCarte.patient), 12);
    expect(nombre(TypeCarte.salle), 11);
    expect(nombre(TypeCarte.objet) + nombre(TypeCarte.diplome), 24);
    expect(
      {
        for (final e in jeu.cartes.entries)
          if (e.value.capacites?.containsKey('recherche') ?? false)
            e.key: e.value.capacites!['recherche'],
      },
      {'OBJ-017': 1, 'OBJ-018': 1, 'OBJ-019': 2},
    );
    expect(jeu.maladies, hasLength(103));
    expect(jeu.specialites, hasLength(5));
  });

  test('aucune maladie n\'est soignée par plus de 10 % des combinaisons, et '
      'chacune peut échouer', () {
    expect(combinaisons, hasLength(13750));
    for (final m in jeu.maladies) {
      final adaptees = combinaisons
          .where((c) => c.satisfait(m.traitement.adapte))
          .length;
      expect(adaptees, greaterThan(0), reason: m.nom);
      expect(adaptees / combinaisons.length, lessThan(0.10), reason: m.nom);
      final partiel = m.traitement.partiel;
      expect(
        combinaisons.any(
          (c) =>
              !c.satisfait(m.traitement.adapte) &&
              (partiel == null || !c.satisfait(partiel)),
        ),
        isTrue,
        reason: '${m.nom} : aucun échec possible',
      );
    }
  });

  test('les salles exigées par identifiant le sont vraiment', () {
    Maladie maladie(String id) => jeu.maladies.firstWhere((m) => m.id == id);
    bool soigne(String id, List<String> cartes) =>
        Combinaison(jeu, cartes).satisfait(maladie(id).traitement.adapte);
    expect(soigne('rhume_carabine', ['MED-001', 'SAL-007', 'OBJ-016']), isTrue);
    expect(
      soigne('rhume_carabine', ['MED-001', 'SAL-003', 'OBJ-016']),
      isFalse,
      reason: 'il faut la consultation ou la pharmacie',
    );
    expect(soigne('burn_out', ['MED-005', 'SAL-002']), isTrue);
    expect(
      soigne('burn_out', ['MED-005', 'SAL-010']),
      isFalse,
      reason: 'il faut la salle de psychiatrie',
    );
  });

  test('le laboratoire n\'entre dans aucune combinaison de traitement, ne '
      'permet ni de diagnostiquer ni de traiter, et sert à analyser', () {
    for (final c in combinaisons) {
      expect(c.ids, isNot(contains('SAL-011')));
    }
    final partie = Partie.nouvelle(
      jeu: jeu,
      paquet: IdentitePaquet.depuis(jeu, jsonEncode(brut)),
      difficulte: 'interne',
      alea: Alea(1),
    );
    partie.confirmer(['PAT-001'], 'admettre');
    expect(
      (partie.valider([
        'MED-001',
        'PAT-001',
        'SAL-011',
      ]) as SelectionRefusee).message,
      'Aucune piste pour Mme Garnier : faire d\'abord un diagnostic.',
    );
    List<String> actions(List<String> qrs) => [
      for (final a in (partie.valider(qrs) as SelectionAcceptee).actions) a.id,
    ];
    expect(actions(['MED-001', 'PAT-001', 'SAL-001']), [
      'diagnostiquer',
      'traiter',
    ], reason: 'les autres salles restent utilisables à 3 cartes');
    partie.confirmer(['MED-001', 'PAT-001', 'SAL-001'], 'diagnostiquer');
    for (final accessoire in ['OBJ-017', 'OBJ-018', 'OBJ-019', 'DIP-001']) {
      expect(actions(['MED-001', 'PAT-001', 'SAL-011', accessoire]), [
        'analyser',
      ]);
    }
    expect(
      (partie.valider([
        'MED-001',
        'MED-002',
        'PAT-001',
        'SAL-011',
      ]) as SelectionRefusee).message,
      'Aucune action possible avec ces cartes.',
    );
  });

  test('aucune carte n\'utilise l\'ancien nom « generaliste »', () {
    expect(
      jeu.cartes.values.where((c) => c.specialite == ancienNomPolyvalent),
      isEmpty,
    );
  });

  test('familles de traitements : aucune combinaison ne soigne plus de 40 % '
      'des maladies d\'une spécialité', () {
    for (final s in jeu.specialites) {
      final maladies = jeu.maladies.where((m) => m.specialite == s.id);
      var meilleure = 0;
      for (final c in combinaisons) {
        final n = maladies
            .where((m) => c.satisfait(m.traitement.adapte))
            .length;
        if (n > meilleure) meilleure = n;
      }
      expect(
        meilleure / maladies.length,
        lessThanOrEqualTo(0.40),
        reason: s.id,
      );
    }
  });

  test('les PV initiaux ne trahissent pas la spécialité : au plus 30 % du '
      'poids d\'une valeur pour une même spécialité', () {
    final parPv = <int, Map<String, int>>{};
    for (final m in jeu.maladies) {
      final t = parPv.putIfAbsent(m.pvInitial, () => {});
      t[m.specialite] = (t[m.specialite] ?? 0) + (m.poids ?? 1);
    }
    parPv.forEach((pv, t) {
      final total = t.values.fold(0, (a, b) => a + b);
      final max = t.values.reduce((a, b) => a > b ? a : b);
      expect(max / total, lessThanOrEqualTo(0.30), reason: 'PV $pv');
    });
    expect(parPv.keys.length, greaterThanOrEqualTo(8), reason: 'PV variés');
  });

  test('laboratoire : 2 passages aux paliers A et B, 3 au palier C, 4 au '
      'palier D ; un spécialiste compte pour un passage de plus', () {
    for (final m in jeu.maladies) {
      final attendu = m.pvInitial >= 15
          ? 4
          : m.pvInitial >= 12
          ? 3
          : 2;
      expect(m.passages, attendu, reason: m.nom);
      expect(m.passages, greaterThanOrEqualTo(2), reason: m.nom);
    }
    expect(jeu.parametres.recherche!.bonusSpecialite, 1);
  });

  test('chaque maladie a une recette rédigée, sans identifiant de carte', () {
    final redacteur = RedacteurRecette(jeu);
    for (final m in jeu.maladies) {
      final recette = redacteur.decrire(m.traitement.adapte);
      expect(recette, endsWith('.'), reason: m.nom);
      expect(recette, isNot(matches(RegExp(r'[A-Z]{3}-\d{3}'))), reason: m.nom);
      expect(recette[0], recette[0].toUpperCase(), reason: m.nom);
    }
  });

  test('diagnostic : précision plafonnée à 4, bonus par niveau de 0,8', () {
    expect(jeu.parametres.diagnostic.precisionMax, 4);
    expect(jeu.parametres.diagnostic.parNiveau, 0.8);
  });
}
