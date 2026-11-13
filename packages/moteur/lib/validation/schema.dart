import 'dart:convert';

import 'package:json_schema/json_schema.dart';

/// Validation d'un `jeu.json` contre le JSON Schema de référence
/// (`docs/schema/jeu.schema.json`, chargé tel quel), avec des messages en
/// français précédés du chemin dans le JSON (ex. `maladies[2].pv_initial`).
///
/// Règle 1 de MOTEUR_EFFETS.md §7. La bibliothèque `json_schema` produit des
/// messages en anglais, qui recopient parfois tout le paquet : ils sont
/// traduits ici selon la règle du schéma qui a échoué.
class ValidateurSchema {
  /// [schemaJson] : contenu du fichier de schéma.
  ValidateurSchema(String schemaJson)
    : _schema = JsonSchema.create(jsonDecode(schemaJson) as Object);

  final JsonSchema _schema;

  /// Erreurs de [instance], sans doublon, dans l'ordre du validateur. Vide
  /// si l'instance est conforme.
  List<String> valider(Object? instance) {
    final precises = <String>{};
    final generiques = <String>{};
    for (final (message, generique) in _erreurs(_schema, instance, '')) {
      (generique ? generiques : precises).add(message);
    }
    // Un message générique double en général une erreur plus précise : on
    // ne le garde que s'il est seul.
    return [...precises, if (precises.isEmpty) ...generiques];
  }

  /// Erreurs de [instance] contre [schema], [base] étant le pointeur de
  /// l'instance dans le paquet.
  ///
  /// Un `oneOf` en échec ne dit pas quelle variante était visée : on la
  /// déduit de sa clé discriminante (`effet`, `carte`, `compte`, `et`…), on
  /// revalide l'élément contre elle seule et on remonte ses erreurs. Un
  /// `allOf` est revalidé branche par branche.
  List<(String, bool)> _erreurs(
    JsonSchema schema,
    Object? instance,
    String base,
  ) {
    final resultat = <(String, bool)>[];
    for (final e in schema.validate(instance).errors) {
      final pointeur = '$base${e.instancePath}';
      final valeur = _valeurA(instance, e.instancePath);
      final sousSchemas = _sousSchemas(e.schemaPath, valeur);
      if (sousSchemas != null) {
        final details = [
          for (final sous in sousSchemas) ..._erreurs(sous, valeur, pointeur),
        ];
        if (details.any((d) => !d.$2)) {
          resultat.addAll(details);
          continue;
        }
      }
      resultat.add(_traduire(e, pointeur, valeur));
    }
    return resultat;
  }

  /// Variante(s) à revalider pour une erreur `oneOf` ou `allOf`, ou `null`.
  List<JsonSchema>? _sousSchemas(String schemaPath, Object? valeur) {
    final oneOf = schemaPath.endsWith('/oneOf');
    if (!oneOf && !schemaPath.endsWith('/allOf')) return null;
    final JsonSchema parent;
    try {
      parent = _schema.resolvePath(
        Uri.parse('#${schemaPath.substring(0, schemaPath.lastIndexOf('/'))}'),
      );
    } on Object {
      return null;
    }
    if (!oneOf) return parent.allOf;
    final branche = _branche(schemaPath, valeur);
    if (branche == null || branche >= parent.oneOf.length) return null;
    return [parent.oneOf[branche]];
  }

  /// Indice de la variante visée d'après la clé discriminante.
  int? _branche(String schemaPath, Object? valeur) {
    int? cle(List<String> cles) {
      if (valeur is! Map) return null;
      final i = cles.indexWhere(valeur.containsKey);
      return i < 0 ? null : i;
    }

    if (schemaPath.endsWith('/effet/oneOf')) {
      final nom = valeur is Map ? valeur['effet'] : null;
      if (nom == 'si') return 2;
      if (const [
        'gagner_pv',
        'perdre_pv',
        'payer',
        'reputation',
      ].contains(nom)) {
        return 1;
      }
      return _effets.contains(nom) ? 0 : null;
    }
    if (schemaPath.endsWith('/predicat/oneOf')) {
      return cle(const ['carte', 'compte', 'tous', 'un_de', 'non']);
    }
    if (schemaPath.endsWith('/condition/oneOf')) {
      if (valeur is String) return null;
      final i = cle(const ['et', 'ou', 'non', 'combinaison']);
      return i == null ? null : i + 1;
    }
    if (schemaPath.endsWith('/valeur/oneOf')) {
      if (valeur is Map) return 2;
      return null;
    }
    return null;
  }

  static const _types = {
    'integer': 'entier',
    'number': 'nombre',
    'string': 'texte',
    'object': 'objet',
    'array': 'liste',
    'boolean': 'booléen',
    'null': 'null',
  };

  static const _effets = {
    'admettre',
    'avancer_temps',
    'diagnostiquer',
    'aggraver',
    'soigner',
    'gagner_pv',
    'perdre_pv',
    'payer',
    'reputation',
    'si',
  };

  (String, bool) _traduire(ValidationError e, String chemin, Object? valeur) {
    final m = e.message;
    final schema = e.schemaPath;
    var pointeur = chemin;
    String texte;
    var generique = false;
    RegExpMatch? r;

    if ((r = RegExp(r'^required prop missing: (\S+) from').firstMatch(m)) !=
        null) {
      final champ = r!.group(1)!;
      if (!pointeur.endsWith('/$champ')) pointeur = '$pointeur/$champ';
      texte = 'champ obligatoire absent';
    } else if ((r = RegExp(r'^type: wanted \[(.*?)\]').firstMatch(m)) != null) {
      final attendus = r!
          .group(1)!
          .split(',')
          .map((t) => _types[t.trim()] ?? t.trim())
          .join(' ou ');
      texte = 'type attendu : $attendus';
    } else if ((r = RegExp(r'^minimum violated \((.*) < (.*)\)$')
            .firstMatch(m)) !=
        null) {
      texte = RegExp(r'^/maladies/\d+/poids$').hasMatch(pointeur)
          ? 'une maladie doit avoir un poids d\'au moins 1 ; pour l\'écarter, '
                'retirez-la du paquet'
          : 'valeur trop petite (${r!.group(1)}, minimum ${r.group(2)})';
    } else if ((r = RegExp(r'^maximum exceeded \((.*) > (.*)\)$')
            .firstMatch(m)) !=
        null) {
      texte = 'valeur trop grande (${r!.group(1)}, maximum ${r.group(2)})';
    } else if ((r = RegExp(r'^exclusiveMinimum violated \((.*) <= (.*)\)$')
            .firstMatch(m)) !=
        null) {
      texte =
          'doit être strictement supérieur à ${r!.group(2)} '
          '(${r.group(1)})';
    } else if ((r = RegExp(r'^exclusiveMaximum exceeded \((.*) >= (.*)\)$')
            .firstMatch(m)) !=
        null) {
      texte =
          'doit être strictement inférieur à ${r!.group(2)} (${r.group(1)})';
    } else if ((r = RegExp(r'^const violated (.*)$').firstMatch(m)) != null) {
      texte = pointeur == '/format'
          ? 'doit valoir « cardhospital »'
          : 'valeur « ${r!.group(1)} » non autorisée';
    } else if ((r = RegExp(r'^enum violated (.*)$').firstMatch(m)) != null) {
      texte = schema.endsWith('/type_carte')
          ? 'type de carte « ${r!.group(1)} » inconnu (medecin, patient, '
                'salle, objet ou diplome)'
          : 'valeur « ${r!.group(1)} » non autorisée';
    } else if ((r = RegExp(r'^maxLength exceeded \(.* vs (\d+)\)$')
            .firstMatch(m)) !=
        null) {
      texte = 'texte trop long (${r!.group(1)} caractères au plus)';
    } else if ((r = RegExp(r'^minLength violated \(.* vs (\d+)\)$')
            .firstMatch(m)) !=
        null) {
      texte = r!.group(1) == '1'
          ? 'texte vide'
          : 'texte trop court (${r.group(1)} caractères au moins)';
    } else if ((r = RegExp(r'^pattern violated \((.*) vs RegExp:')
            .firstMatch(m)) !=
        null) {
      texte = _motif(schema, pointeur, r!.group(1)!);
    } else if ((r = RegExp(r'^unallowed additional property (.*)$')
            .firstMatch(m)) !=
        null) {
      pointeur = '$pointeur/${r!.group(1)}';
      texte = 'champ inconnu';
    } else if ((r = RegExp(r'^(max|min)Items \w+ \((\d+) vs (\d+)\)$')
            .firstMatch(m)) !=
        null) {
      final (sens, trouve, borne) = (r!.group(1), r.group(2), r.group(3));
      texte = pointeur == '/difficultes'
          ? 'exactement 3 niveaux requis ($trouve trouvé(s))'
          : sens == 'max'
          ? '$borne élément(s) au plus ($trouve trouvé(s))'
          : 'au moins $borne élément(s) requis ($trouve trouvé(s))';
    } else if ((r = RegExp(r'^minProperties violated \((\d+) < (\d+)\)$').firstMatch(m)) != null) {
      texte = 'au moins ${r!.group(2)} entrée(s) requise(s)';
    } else if (schema.endsWith('/oneOf')) {
      texte = _formeNonReconnue(schema, valeur);
    } else if (m.contains('then violated') && schema.contains('/carte/')) {
      texte = 'un patient ne peut porter ni spécialité ni capacités';
    } else if (m.contains('not violated') && schema.contains('/specialite/properties/id')) {
      texte =
          '« $valeur » est une valeur réservée, implicite, qui ne se déclare pas';
    } else if (m.contains('not violated') && schema.contains('/maladie/properties/specialite')) {
      texte =
          '« $valeur » est une valeur réservée, qui ne peut pas être la spécialité d\'une maladie';
    } else {
      generique = true;
      final court = m.length > 100 ? '${m.substring(0, 100)}…' : m;
      texte = 'non conforme au schéma ($court)';
    }
    return ('${cheminLisible(pointeur)} : $texte', generique);
  }

  String _motif(String schema, String pointeur, String valeur) {
    if (schema.endsWith('/identifiant_carte')) {
      return 'identifiant de carte au format ABC-123 attendu (« $valeur »)';
    }
    if (schema.endsWith('/identifiant')) {
      return 'identifiant en minuscules, chiffres et _ attendu (« $valeur »)';
    }
    if (schema.endsWith('/couleur')) {
      return 'couleur au format #RRGGBB attendue (« $valeur »)';
    }
    if (schema.endsWith('/properties/version')) {
      return 'version au format MAJEUR.MINEUR.CORRECTIF attendue '
          '(« $valeur »)';
    }
    if (pointeur.startsWith('/motifs/')) {
      return 'clé de motif invalide : « total » ou types de cartes séparés '
          'par | (« $valeur »)';
    }
    return 'format invalide (« $valeur »)';
  }

  String _formeNonReconnue(String schema, Object? valeur) {
    if (schema.endsWith('/effet/oneOf')) {
      final nom = valeur is Map ? valeur['effet'] : null;
      if (nom is String && !_effets.contains(nom)) {
        return 'effet « $nom » inconnu';
      }
      if (nom is String) return 'paramètres invalides pour l\'effet « $nom »';
      return 'effet non reconnu : objet avec une clé « effet » attendu';
    }
    if (schema.endsWith('/predicat/oneOf')) {
      return 'prédicat non reconnu : une seule clé parmi carte, compte, '
          'tous, un_de et non, avec ses paramètres';
    }
    if (schema.endsWith('/condition/oneOf')) {
      if (valeur is String) return 'condition « $valeur » inconnue';
      return 'condition non reconnue : une constante, ou une seule clé parmi '
          'et, ou, non et combinaison';
    }
    if (schema.endsWith('/valeur/oneOf')) {
      return 'valeur non reconnue : entier, référence \$recompenses.… ou '
          '\$capacite.…, ou { "somme": […] }';
    }
    final filtre = RegExp(r'/filtre/properties/(\w+)/oneOf$')
        .firstMatch(schema);
    if (filtre != null) {
      return 'valeur ou liste de valeurs invalide pour « ${filtre.group(1)} »';
    }
    return 'forme non reconnue';
  }

  /// Valeur de [instance] au pointeur JSON [pointeur], ou `null`.
  static Object? _valeurA(Object? instance, String pointeur) {
    Object? courant = instance;
    for (final segment in _segments(pointeur)) {
      if (courant is Map) {
        courant = courant[segment];
      } else if (courant is List) {
        final i = int.tryParse(segment);
        courant = i != null && i < courant.length ? courant[i] : null;
      } else {
        return null;
      }
    }
    return courant;
  }

  static Iterable<String> _segments(String pointeur) => pointeur
      .split('/')
      .skip(1)
      .map((s) => s.replaceAll('~1', '/').replaceAll('~0', '~'));
}

/// Pointeur JSON (`/maladies/2/pv_initial`) en chemin lisible
/// (`maladies[2].pv_initial`).
String cheminLisible(String pointeur) {
  if (pointeur.isEmpty || pointeur == '/') return '(racine)';
  final b = StringBuffer();
  for (final s in ValidateurSchema._segments(pointeur)) {
    if (int.tryParse(s) != null) {
      b.write('[$s]');
    } else {
      if (b.isNotEmpty) b.write('.');
      b.write(s);
    }
  }
  return b.toString();
}
