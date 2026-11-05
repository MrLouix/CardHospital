# CardHospital — Plan de codage

Ce document dit **ce qui peut être codé maintenant**, ce qui reste à préciser en cours de route, et **comment démarrer concrètement**. Il complète la [feuille de route](FEUILLE_DE_ROUTE.md), qui décrit les phases et leurs critères de fin.

## 1. État de préparation de la spécification

En résumé : la spec suffit pour démarrer selon la feuille de route, pas pour coder toute l'appli d'un coup. Chaque phase n'a besoin que de sa partie de la spec, et le moteur est la partie la mieux définie.

| Phase | Spec suffisante ? | Pourquoi |
|---|---|---|
| **0 – Prototype de détection** | **Oui** | Il n'a presque pas besoin de la spec : une caméra, une liste des QR lus, des mesures. Les critères de fin sont chiffrés. |
| **1 – Moteur, validateur, simulateur** | **Oui, à ~90 %** | Le [schéma JSON](schema/jeu.schema.json), les [effets](MOTEUR_EFFETS.md), les algorithmes du [modèle de jeu](MODELE_DE_JEU.md) (diagnostic, arrondi, ordre de résolution) et les règles de validation sont précis. Un [exemple valide](exemples/jeu.exemple.json) permet d'écrire les premiers tests. |
| **2 – Appli solo** | **Partiellement** | Les écrans et le parcours sont listés ([SPECIFICATION.md §6](SPECIFICATION.md#6-écrans-et-cas-derreur)), mais il n'y a ni maquettes ni images de cartes. C'est suffisant pour un prototype fonctionnel avec des images provisoires, pas pour une appli finie. |
| **3 – Hôte et clients** | **Partiellement** | Les messages sont définis ([SPECIFICATION.md §3.3](SPECIFICATION.md#33-protocole)) et le contenu du message `resultat` est fixé ([MODELE_DE_JEU.md §11.1](MODELE_DE_JEU.md#111-format-du-résultat)), mais pas encore le détail des champs des autres messages. Le type de service de premier plan exigé par Android 14 reste à choisir. À préciser au début de la phase 3. |
| **4 et 5** | Pas encore | Elles dépendent des retours des phases précédentes. Le contenu du paquet de base existe ([`contenu/paquet_base.json`](../contenu/paquet_base.json)) ; reste à l'équilibrer. |

## 2. Points à trancher pendant la phase 1

Aucun ne bloque le démarrage. Chacun est tranché au moment du codage, puis reporté dans la spec concernée.

| # | Sujet | Document à mettre à jour | Statut |
|---|---|---|---|
| P1 | **Format exact du résultat** renvoyé par le moteur (structure de données), qui servira aussi de contenu au message `resultat` | [MODELE_DE_JEU.md §11.1](MODELE_DE_JEU.md#111-format-du-résultat), [SPECIFICATION.md §3.3](SPECIFICATION.md#33-protocole) | Tranché |
| P2 | **Format de l'état sauvegardé** et des instantanés (patients, difficulté, paquet actif avec son identifiant, sa version et son empreinte) | [SPECIFICATION.md §3.5](SPECIFICATION.md#35-robustesse-de-lhôte) | Tranché |
| P3 | **« Motif le plus proche »** : la règle qui choisit le message d'erreur d'une sélection refusée. Proposition : le motif qui a le moins d'écarts de cardinalité, puis le premier écart dans l'ordre patient, médecin, salle, accessoire, total | [MOTEUR_EFFETS.md §3](MOTEUR_EFFETS.md#3-motifs) | Tranché (proposition retenue) |
| P4 | **Organisation du code** et versions figées de Flutter et Dart (voir §4) | ce document | Tranché pour le moteur : Dart 3.13 (`environment: sdk: ^3.13.0`) ; Flutter à figer en phase 0 |

## 3. Prérequis hors code

| Prérequis | Nécessaire pour | Statut |
|---|---|---|
| **Contenu du jeu** : spécialité et capacités de chaque carte, environ 20 maladies pour la phase 1 et 100 pour la phase 5 | Simulateur (phase 1), contenu complet (phase 5) | Fait : paquet de base de 103 maladies ([`contenu/paquet_base.json`](../contenu/paquet_base.json)) ; l'exemple en est un sous-ensemble de 6 maladies. Restent les objets d'aide à la recherche. |
| **Images des cartes** | Phase 2 et suivantes | Des images provisoires suffisent jusqu'à la phase 4 |
| **Téléphones de test**, dont un d'entrée de gamme sous API 26–28 | Phase 0 | À réunir |
| **Impression de la planche de QR** de test, en finition mate et brillante | Phase 0 | Après génération de la planche |
| **Questions ouvertes** ([SPECIFICATION.md §12](SPECIFICATION.md#12-questions-ouvertes)) | Aucune phase bloquée | Des choix par défaut sont pris, modifiables dans le JSON ou à faible coût |

## 4. Organisation du dépôt

```
CardHospital/
├── docs/                      # spécifications (existant)
├── packages/
│   └── moteur/                # paquet Dart pur : modèles, validateur, moteur, simulateur
│       ├── lib/
│       │   ├── modeles/       # classes générées depuis jeu.json (json_serializable)
│       │   ├── validation/    # JSON Schema + contrôles sémantiques
│       │   ├── moteur/        # motifs, prédicats, effets, diagnostic, état, instantanés
│       │   └── moteur.dart    # API publique
│       ├── bin/simuler.dart   # simulateur en ligne de commande
│       └── test/
├── prototypes/
│   └── detection/             # appli Flutter jetable de la phase 0
├── outils/
│   └── planche_qr/            # générateur de la planche de QR de test (PDF)
└── app/                       # appli Flutter (à partir de la phase 2), dépend de packages/moteur
```

Principes :

- **Le moteur ne dépend ni de Flutter ni du réseau.** L'appli solo (phase 2) l'appelle directement ; l'hôte (phase 3) l'appelle derrière le serveur. Le même code sert aux tests, au simulateur et à l'appli.
- **Le hasard est injecté** (générateur à graine) : tests et simulations sont reproductibles.
- **Le schéma reste unique** : `docs/schema/jeu.schema.json` est la référence ; le validateur Dart le charge tel quel.
- **Versions figées** : la version stable de Flutter et de Dart en vigueur au démarrage, inscrite dans le dépôt (`pubspec.yaml`, contraintes `environment`), et mise à jour volontairement.

### Intégration continue (GitHub Actions)

Dès le premier commit de code :

- `dart format --set-exit-if-changed` et `dart analyze` (zéro warning) ;
- `dart test` sur `packages/moteur`, avec mesure de couverture ;
- validation de `docs/exemples/jeu.exemple.json` contre le schéma ;
- plus tard : `flutter analyze` et construction de l'APK pour `app/`.

## 5. Démarrage : phases 0 et 1 en parallèle

Les deux phases sont indépendantes : la phase 0 lève le risque matériel (caméra), la phase 1 le risque de conception (règles et équilibrage).

### 5.1 Phase 0 — Prototype de détection

Réparti entre le code (Claude) et les essais physiques (l'équipe).

- [x] **Générateur de planche de QR** (`outils/planche_qr`) : PDF A4 avec des QR de 1,5, 2 et 2,5 cm, en correction M et Q, avec une marge de 4 modules et le contenu `MED-001`, `PAT-001`… Chaque QR est étiqueté par sa taille et son niveau de correction.
- [ ] **Appli de test** (`prototypes/detection`) : flux caméra `mobile_scanner`, liste des QR détectés par image avec horodatage, deux modes (détection simultanée / sélection cumulative selon [SPECIFICATION.md §4.1](SPECIFICATION.md#41-sélection-cumulative)), chronomètre « 4 cartes sélectionnées en X s », export des mesures en CSV.
- [ ] **Essais physiques** (équipe) : impression mate et brillante, protocole de la [feuille de route](FEUILLE_DE_ROUTE.md#phase-0--prototype-de-détection), au moins 3 téléphones.
- [ ] **Bilan** : taille de QR, niveau de correction, finition et mode de sélection arrêtés et reportés dans [SPECIFICATION.md §4](SPECIFICATION.md#4-détection-des-cartes).

La caméra ne peut pas être testée depuis l'environnement de développement de Claude : les mesures viennent obligatoirement des essais physiques.

### 5.2 Phase 1 — Moteur, validateur et simulateur

Ordre de réalisation, chaque étape étant livrée avec ses tests :

1. [x] **Squelette** : `packages/moteur`, analyse statique stricte, intégration continue.
2. [x] **Modèles** : classes typées de `jeu.json` (cartes, maladies, prédicats, conditions, valeurs, effets, actions), chargement de l'exemple.
3. [x] **Validateur** : JSON Schema, puis les contrôles sémantiques de [MOTEUR_EFFETS.md §7](MOTEUR_EFFETS.md#7-validation-à-limport) (références, phrases, spécialités sans maladie, réalisabilité des traitements par recherche exhaustive, doublons, poids), avec messages en français et chemin JSON. Un test négatif par règle.
4. [x] **Reconnaissance des combinaisons** : motifs, préconditions, actions proposées, message du premier écart (point P3).
5. [x] **Moteur d'effets** : état des patients, effets, conditions, prédicats, valeurs `$…`, modificateurs de difficulté, arrondi, invariants (mort, sortie, révélation).
6. [x] **Diagnostic probabiliste** : liste des 5 maladies les plus suspectes, indices de suspicion indépendants, couleur et icône de chaque spécialité, bruit corrigé selon le nombre de maladies par spécialité. Tests statistiques sur graine fixe, comparés aux valeurs de [MODELE_DE_JEU.md §8.4](MODELE_DE_JEU.md#84-comportement-attendu). Cette version remplace le premier diagnostic (distribution sur le type, puis liste de noms), dont la liste de noms révélait le type avec certitude (voir §5.4).
7. [x] **Résultat et état** : formats arrêtés (points P1 et P2), sérialisation et restauration des instantanés.
8. [x] **Simulateur** (`bin/simuler.dart`) : stratégies simples (traiter au hasard, diagnostiquer jusqu'à X % puis traiter, se fier à la spécialité). Il mesure le taux de guérison, la durée de vie des patients, les pièces et la réputation par action, et produit un rapport reproductible.
9. [x] **Paquet de base** : [`contenu/paquet_base.json`](../contenu/paquet_base.json), 103 maladies sur 5 spécialités, validé et contrôlé en intégration continue (`test/paquet_base_test.dart` : validation sans avertissement, aucune maladie soignée par plus de 10 % des combinaisons, échec toujours possible, laboratoire exclu). Il remplace le paquet intermédiaire d'environ 20 maladies prévu au départ ; le réglage reste à faire dessus (§5.4).
10. [ ] **Salle recherche** (`schema_version` 2) : motif `recherche` (médecin + patient + salle + accessoire facultatif), action `analyser` avec choix de la maladie par le joueur, nouvelle condition `patient_diagnostique`, nouvel effet `rechercher`, champ `recherche.passages` des maladies, capacité `recherche` et objets d'aide à la recherche, montée du schéma + migration v1 → v2. Conception : [MOTEUR_EFFETS.md §9](MOTEUR_EFFETS.md#9-salle-recherche-prévu-pour-schema_version-2) et [MODELE_DE_JEU.md §12](MODELE_DE_JEU.md#12-recherche-en-laboratoire). Tests positifs et négatifs.
    Déjà en place, avec leurs tests : les actions de tous les motifs reconnus sont réunies, puis filtrées par précondition, y compris de combinaison ; une précondition de combinaison non satisfaite donne un message sur les cartes (« Aucune action possible avec ces cartes. ») et non sur l'état du patient ; la valeur réservée `recherche` (salles seulement) ; la carte du laboratoire `SAL-011` dans le paquet de base ; les préconditions « hors laboratoire » de `diagnostiquer` et `traiter`. Restent à faire : l'état (maladies suspectées par patient, passages restants par maladie, à ajouter au format de sauvegarde P2), la condition `patient_diagnostique`, le paramètre `maladie_id` de la confirmation, l'effet `rechercher` et la génération des recettes, les champs du résultat propres à l'analyse, le schéma v2 et sa migration.

Critères de fin : ceux de la [feuille de route](FEUILLE_DE_ROUTE.md#phase-1--moteur-deffets-validateur-et-simulateur), soit une couverture ≥ 90 %, un test négatif par règle de validation et un rapport de simulation reproductible.

État des critères (fin de l'étape 8) :

- **couverture** : 96 % hors code généré, vérifiée en intégration continue avec un seuil de 90 % (`dart run tool/couverture.dart`) ;
- **rapport reproductible** : atteint ; même graine, même rapport, testé. Rapport de référence : [simulations/rapport_exemple.md](simulations/rapport_exemple.md) ;
- **un test négatif par règle de validation** : partiel. Les règles 4 à 10 sont testées. Restent les règles 1 (conformité complète au JSON Schema : le validateur ne contrôle encore qu'une partie du schéma, sans la bibliothèque `json_schema` prévue), 2 (une seule version de schéma existe) et 3 (le catalogue embarqué n'existe pas encore).

### 5.3 Utiliser le moteur et le simulateur

Depuis `packages/moteur` :

```bash
dart test
dart run bin/simuler.dart --parties 2000 --strategies hasard,seuil:70,couleur:70
dart run bin/simuler.dart --aide   # ou --help, -h
```

Stratégies disponibles :

| Stratégie | Comportement |
|---|---|
| `hasard` | Diagnostiquer ou traiter au hasard, avec une combinaison au hasard |
| `seuil:X` | Diagnostiquer sans spécialité, à la meilleure précision, jusqu'à ce que la maladie en tête de liste, non encore essayée, atteigne l'indice de suspicion X ; puis la traiter |
| `couleur:X` | Comme `seuil:X`, mais après un premier diagnostic sans spécialité, diagnostiquer avec la spécialité de la couleur dominante de la dernière liste (la couleur qui a le plus de lignes), pour la confirmer ou l'écarter |

Les stratégies voient ce que voit un joueur (résultats des actions, spécialités des cartes) et sont supposées connaître les traitements des maladies, comme s'ils figuraient dans le livret de règles.

### 5.4 Premiers constats du simulateur

**Historique du diagnostic.** Le premier diagnostic donnait une distribution sur la spécialité, puis une liste de noms dans certains cas. Le simulateur a montré que l'apparition de cette liste était un signal **certain** : elle ne contenait que des maladies de la vraie spécialité. Avec la première règle (liste si la bonne spécialité est dans la combinaison), comme avec la seconde (liste si la vraie spécialité est en tête), une stratégie qui raisonnait par élimination guérissait 94 à 100 % des patients. Le diagnostic par liste de 5 maladies ([MODELE_DE_JEU.md §8](MODELE_DE_JEU.md#8-diagnostic-probabiliste)) supprime ce signal : la liste a toujours la même forme, et les couleurs comme les indices de suspicion ne font qu'orienter.

**Sur le paquet d'exemple** (6 maladies, 2 par spécialité), le [rapport](simulations/rapport_exemple.md) n'est **pas représentatif** :

- les stratégies informées (`seuil:X`, `couleur:X`) guérissent 99 % des patients en Interne et 90 à 94 % en Réanimation, en 1,1 à 1,3 diagnostic. Les paramètres par défaut sont calés pour une centaine de maladies : avec 6, la vraie maladie ressort presque toujours en tête, et le diagnostic est trop facile ;
- `couleur:X` ne fait pas mieux que `seuil:X`, car un seul diagnostic suffit le plus souvent.

**Sur le paquet de base** (103 maladies sur 5 spécialités, [rapport](simulations/rapport_paquet_base.md)) :

- les stratégies informées guérissent 94 à 97 % des patients en Interne, 80 à 87 % en Chirurgien et 80 à 84 % en Réanimation, avec 1,2 à 2 diagnostics par patient ; le hasard n'en guérit que 3 à 5 % ;
- suivre la couleur est récompensé sans être infaillible : `couleur:80` guérit 97 % des patients en Interne, contre 95 % pour `seuil:80` ;
- Chirurgien et Réanimation donnent des taux de guérison proches.

**À faire** : régler `verite`, `affinite_specialite`, `bonus_specialite` et `exclusion` sur ce paquet. Le comportement du diagnostic y est mesuré dans [MODELE_DE_JEU.md §8.4](MODELE_DE_JEU.md#84-comportement-attendu). La valeur de départ et le seuil de fermeture de la réputation ne sont à fixer qu'après ce réglage.

## 6. Après le démarrage

| Moment | Action |
|---|---|
| Fin de phase 0 | Mettre à jour [SPECIFICATION.md §4](SPECIFICATION.md#4-détection-des-cartes) (QR, sélection) ; si l'échec est confirmé, revoir le principe de lecture avant la phase 2 |
| Fin de phase 1 | Reporter les points P1 à P4 dans la spec ; fixer par simulation les paramètres du diagnostic, les récompenses, la réputation de départ et le seuil de fermeture |
| Début de phase 2 | Maquettes basse fidélité des écrans ([SPECIFICATION.md §6.1](SPECIFICATION.md#61-écrans)) |
| Début de phase 3 | Détail des champs de chaque message du protocole ; type de service de premier plan pour Android 14 |
