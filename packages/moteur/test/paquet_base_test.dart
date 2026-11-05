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

  test('catalogue : 10 médecins, 12 patients, 11 salles, 21 accessoires, '
      '103 maladies sur 5 spécialités', () {
    int nombre(TypeCarte type) =>
        jeu.cartes.values.where((c) => c.type == type).length;
    expect(nombre(TypeCarte.medecin), 10);
    expect(nombre(TypeCarte.patient), 12);
    expect(nombre(TypeCarte.salle), 11);
    expect(nombre(TypeCarte.objet) + nombre(TypeCarte.diplome), 21);
    expect(jeu.maladies, hasLength(103));
    expect(jeu.specialites, hasLength(5));
  });

  test('aucune maladie n\'est soignée par plus de 10 % des combinaisons, et '
      'chacune peut échouer', () {
    expect(combinaisons, hasLength(2650));
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
    expect(soigne('rhume_carabine', ['MED-001', 'SAL-007', 'OBJ-011']), isTrue);
    expect(
      soigne('rhume_carabine', ['MED-001', 'SAL-003', 'OBJ-011']),
      isFalse,
      reason: 'il faut la pharmacie',
    );
    expect(soigne('burn_out', ['MED-005', 'SAL-002']), isTrue);
    expect(
      soigne('burn_out', ['MED-005', 'SAL-010']),
      isFalse,
      reason: 'il faut la salle de psychiatrie',
    );
  });

  test('le laboratoire n\'entre dans aucune combinaison de traitement et ne '
      'permet ni de diagnostiquer ni de traiter', () {
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
    final r = partie.valider(['MED-001', 'PAT-001', 'SAL-011']);
    expect(
      (r as SelectionRefusee).message,
      'Aucune action possible avec ces cartes.',
    );
    expect(
      partie.valider(['MED-001', 'PAT-001', 'SAL-001']),
      isA<SelectionAcceptee>(),
      reason: 'les autres salles restent utilisables à 3 cartes',
    );
  });

  test('aucune carte n\'utilise l\'ancien nom « generaliste »', () {
    expect(
      jeu.cartes.values.where((c) => c.specialite == ancienNomPolyvalent),
      isEmpty,
    );
  });

  test('diagnostic : précision plafonnée à 4, bonus par niveau de 0,8', () {
    expect(jeu.parametres.diagnostic.precisionMax, 4);
    expect(jeu.parametres.diagnostic.parNiveau, 0.8);
  });
}
