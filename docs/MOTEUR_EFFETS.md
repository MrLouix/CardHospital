# CardHospital — Paquets de jeu et moteur d'effets

Ce document définit le **format des paquets de jeu** (contenu et règles) et le **mini-langage d'effets** interprété par l'hôte. Les règles qu'il encode sont décrites dans le [modèle de jeu](MODELE_DE_JEU.md). Le schéma formel est [`schema/jeu.schema.json`](schema/jeu.schema.json) ; un exemple complet et valide se trouve dans [`exemples/jeu.exemple.json`](exemples/jeu.exemple.json).

## 1. Paquet de jeu

### 1.1 Format

Un paquet est une archive `.zip` :

```
mon-extension.zip
├── jeu.json          # obligatoire : contenu et règles, conforme au schéma
└── images/           # facultatif, réservé (voir 1.3)
```

- Le **paquet de base** est embarqué dans l'application (assets).
- Une **extension** est importée depuis le système de fichiers ou via le partage Android, puis sélectionnée dans la page admin avant le lancement de la partie.
- Un paquet est **autonome** : il remplace intégralement le paquet actif. En pratique, une extension part d'une copie du `jeu.json` de base. Les paquets différentiels (qui ne contiendraient que des ajouts) sont envisagés plus tard.

### 1.2 Ce qu'une extension peut faire en v1

| Autorisé | Interdit en v1 |
|---|---|
| Ajouter, retirer ou modifier des **maladies** (qui sont virtuelles) | Ajouter une carte (nouvel identifiant QR) |
| Modifier les attributs d'une carte existante (spécialité, capacités, nom affiché) | Changer le type d'une carte existante |
| Ajouter des spécialités et des capacités | Remplacer les images des cartes |
| Modifier les paramètres, les récompenses, les difficultés, les phrases, les actions | |

Chaque identifiant de carte d'un paquet doit exister dans le **catalogue embarqué**, avec le même type. Les images sont toujours celles embarquées, retrouvées par identifiant (`assets/cartes/<ID>.png`).

### 1.3 Dossier `images/`

Réservé à la future possibilité d'ajouter des cartes. En v1, son contenu est **ignoré** et l'import affiche un avertissement s'il n'est pas vide.

## 2. Structure de `jeu.json`

| Clé | Contenu |
|---|---|
| `format` | Toujours `"cardhospital"` |
| `schema_version` | Version entière du format (actuellement `1`) |
| `id`, `nom`, `version`, `description` | Identité du paquet (`version` au format `MAJEUR.MINEUR.CORRECTIF`) |
| `parametres` | Paramètres du diagnostic, récompenses par défaut, attente par défaut |
| `difficultes` | Exactement 3 niveaux et leurs modificateurs |
| `specialites` | Spécialités des maladies et des cartes, avec leur couleur et leur icône (`polyvalent` et `recherche` sont réservés et implicites) |
| `capacites` | Capacités déclarées (ex. `precision`, `stabilisation`) |
| `cartes` | Dictionnaire `identifiant QR → carte` |
| `maladies` | Liste des maladies |
| `motifs` | Formes de combinaison reconnues |
| `actions` | Actions possibles, avec leur motif, leur précondition, leur phrase et leur liste d'effets |

Toutes les clés sont en **français**, en `snake_case`. Les identifiants sont en minuscules (`[a-z0-9_]`), sauf les identifiants de cartes, qui reprennent le contenu du QR (`MED-001`, `PAT-012`…).

### 2.1 Cartes

```json
"MED-006": {
  "type": "medecin",
  "nom": "Dr Reyer",
  "nom_phrase": "la Dr Reyer",
  "specialite": "psychiatrie",
  "capacites": { "precision": 1 }
}
```

- `type` : `medecin`, `patient`, `salle`, `objet` ou `diplome`.
- `nom` : nom affiché (titres, listes).
- `nom_phrase` : nom **avec son article**, tel qu'il s'insère dans une phrase (« le stéthoscope », « la salle d'opération », « l'IRM »). On évite ainsi tout calcul grammatical. S'il est absent, `nom` est utilisé.
- `specialite` : une spécialité déclarée, ou une valeur réservée : `polyvalent` (sans spécialité) ou `recherche` (salles seulement : le laboratoire de recherche). Un champ absent vaut `polyvalent`. `generaliste`, ancien nom de `polyvalent`, est encore accepté avec un avertissement. Interdit pour un patient. Attention : `generale` (médecine générale) est une spécialité comme les autres, pas une valeur neutre.
- `capacites` : entiers par capacité déclarée (interdit pour un patient).

Les noms de personnages ou de marques existants (personnages de séries, marques de médicaments) sont à proscrire dans le contenu livré.

### 2.2 Maladies

Extrait du paquet de base :

```json
{
  "id": "fracture_ouverte",
  "nom": "Fracture ouverte",
  "specialite": "orthopedie",
  "pv_initial": 10,
  "aggravation": [1, 2, 2, 3],
  "attente_max": 4,
  "poids": 2,
  "traitement": {
    "adapte":  { "tous": [ { "compte": { "type": "medecin", "specialite": "orthopedie" }, "min": 2 },
                           { "carte": "SAL-006" } ] },
    "partiel": { "tous": [ { "compte": { "type": "medecin", "specialite": "orthopedie" }, "min": 1 },
                           { "carte": "SAL-008" } ] }
  },
  "recompenses": { "pieces_traitement": 4 }
}
```

`specialite` est la spécialité de la maladie : une spécialité déclarée, jamais une valeur réservée (`polyvalent`, `recherche`). `attente_max` (défaut : `parametres.attente_max_defaut`), `poids` (entier ≥ 1, défaut 1), `traitement.partiel`, `recompenses` et `recherche` sont facultatifs. `recherche.passages` (entier ≥ 1, défaut 1) est le nombre de passages en laboratoire nécessaires pour révéler la recette de la maladie (§9, prévu pour `schema_version` 2). Un poids nul est interdit : une maladie qui ne peut jamais être tirée n'a pas sa place dans le paquet, il suffit de la retirer. Toute clé de `recompenses` absente reprend la valeur de `parametres.recompenses`.

### 2.3 Spécialités

```json
"specialites": [
  { "id": "generale",    "nom": "Médecine générale", "couleur": "#1565C0", "icone": "🩺" },
  { "id": "cardiologie", "nom": "Cardiologie",       "couleur": "#C62828", "icone": "❤️" },
  { "id": "psychiatrie", "nom": "Psychiatrie",       "couleur": "#7B4FBF", "icone": "🧠" },
  { "id": "orthopedie",  "nom": "Orthopédie",        "couleur": "#EF6C00", "icone": "🦴" },
  { "id": "paranormal",  "nom": "Paranormal",        "couleur": "#37474F", "icone": "👻" }
]
```

`polyvalent`, `generaliste` (son ancien nom) et `recherche` sont réservés : ils ne se déclarent pas ici.

- `couleur` : couleur d'affichage des maladies de la spécialité dans un diagnostic, au format `#RRGGBB`.
- `icone` : emoji ou symbole court (1 à 8 caractères) affiché à côté de la couleur. Il double la couleur pour les joueurs daltoniens, et distingue les spécialités sur un écran mal calibré.
- Les deux champs sont obligatoires. Deux spécialités de même couleur ou de même icône déclenchent un avertissement à l'import.
- Une extension qui ajoute une spécialité lui choisit sa couleur et son icône. L'emoji évite d'avoir à embarquer une image, ce qui reste interdit aux extensions en v1.

### 2.4 Paramètres du diagnostic

`parametres.diagnostic` contient `precision_max`, `verite`, `par_niveau`, `affinite_specialite`, `bonus_specialite`, `exclusion`, `taille_liste` et `score_bruit`. Leur rôle et leurs valeurs par défaut sont décrits dans le [modèle de jeu §8.3](MODELE_DE_JEU.md#83-calcul-de-la-liste).

## 3. Motifs

Un motif décrit une forme de sélection par des **intervalles `[min, max]`** de nombre de cartes, par type de carte ou groupe de types de carte (séparés par `|`), plus un intervalle sur le total.

```json
"motifs": {
  "admission": { "patient": [1, 1], "total": [1, 1] },
  "standard":  { "patient": [1, 1], "medecin": [1, 2], "salle": [1, 1], "objet|diplome": [0, 1], "total": [3, 4] }
}
```

Un type de carte absent d'un motif est interdit (`[0, 0]`). Le motif standard encode « 1 médecin + 1 patient + 1 salle + au plus une carte parmi {objet, diplôme, second médecin} », la limite `total ≤ 4` excluant d'avoir à la fois un second médecin et un accessoire.

Quand plusieurs motifs correspondent à une même sélection, l'hôte **réunit leurs actions** (dans l'ordre de déclaration des actions), puis ne propose que celles dont la précondition est vérifiée. L'ordre des motifs n'a donc pas d'importance : ce sont les préconditions qui départagent, par exemple entre le motif `recherche` et le motif `standard` (§9). Si aucune action ne reste à cause des cartes, l'hôte répond « Aucune action possible avec ces cartes. ».

Quand une sélection ne correspond à aucun motif, l'hôte renvoie le **premier écart** constaté par rapport au motif le plus proche (« Il faut une carte salle »). Le motif le plus proche est celui qui a le moins d'écarts de cardinalité (somme des cartes manquantes ou en trop par groupe, plus les cartes d'un type absent du motif) ; à égalité, celui qui a le plus de groupes satisfaits. Le premier écart est cherché dans l'ordre patient, médecin, salle, accessoire, total.

## 4. Valeurs

Partout où un montant est attendu :

| Forme | Exemple | Sens |
|---|---|---|
| Entier | `2` | Valeur littérale |
| Référence | `"$recompenses.pieces_traitement"` | Valeur de la maladie du patient si elle est définie, sinon celle de `parametres.recompenses` |
| Référence | `"$capacite.stabilisation"` | Total de la capacité `stabilisation` sur les cartes de la combinaison (patient exclu) |
| Somme | `{ "somme": [ "$recompenses.pv_partiel", "$capacite.stabilisation" ] }` | Somme des valeurs |

Le modificateur de difficulté et l'arrondi sont appliqués **par l'effet** qui consomme la valeur (voir §6), jamais dans l'expression.

## 5. Prédicats

Les prédicats testent les **cartes d'une combinaison**. Ils servent aux traitements des maladies et à la condition `{ "combinaison": … }`.

| Prédicat | Exemple | Vrai si |
|---|---|---|
| `carte` | `{ "carte": "OBJ-010" }` | La carte est dans la combinaison |
| `compte` | `{ "compte": { "type": "medecin", "specialite": "orthopedie" }, "min": 2 }` | Au moins `min` et au plus `max` cartes correspondent au filtre. Sans `min` ni `max`, `min` vaut 1 : le prédicat demande au moins une carte. Avec `max` seul, `min` vaut 0 |
| `tous` | `{ "tous": [ p1, p2 ] }` | Tous les sous-prédicats sont vrais |
| `un_de` | `{ "un_de": [ p1, p2 ] }` | Au moins un sous-prédicat est vrai |
| `non` | `{ "non": p }` | Le sous-prédicat est faux |

Le filtre d'un `compte` accepte `type` (type de carte), `specialite` et `id`, chacun sous forme d'une valeur ou d'une liste de valeurs acceptées. Pour exiger une carte précise, préférer `{ "carte": "SAL-007" }` à un `compte` sur son identifiant.

Un **diplôme de spécialité X** présent dans la combinaison compte comme un **médecin de spécialité X** quand le filtre demande `type: medecin` avec `specialite: X`. Les trois cas sont décrits dans l'encadré « Diplôme » du [modèle de jeu §2.2](MODELE_DE_JEU.md#22-cartes) :

1. filtre `type: medecin` avec la spécialité du diplôme : le diplôme compte ;
2. filtre `type: medecin` sans spécialité, ou avec une autre : il ne compte pas ;
3. sous un `non`, il compte aussi : `{ "non": { "compte": { "type": "medecin", "specialite": "X" }, "min": 1 } }` est faux si le diplôme X est présent.

## 6. Effets

Une action est une **liste d'effets exécutés dans l'ordre**. Chaque effet est un objet discriminé par la clé `effet`.

| Effet | Paramètres | Comportement |
|---|---|---|
| `admettre` | — | Tire une maladie (pondérée par `poids`), `PV ← pv_initial`, `temps ← 0`, patient « en jeu » |
| `avancer_temps` | — | `temps ← temps + 1` |
| `diagnostiquer` | — | Calcule et ajoute au résultat la liste des maladies les plus probables du [modèle de jeu §8](MODELE_DE_JEU.md#8-diagnostic-probabiliste) |
| `aggraver` | — | Perte de `aggravation[temps]` PV (dernière valeur répétée), modificateur `pv_perdus` |
| `soigner` | — | Marque le patient guéri |
| `gagner_pv` | `valeur` | Ajoute des PV, plafonnés à `pv_initial` (pas de modificateur) |
| `perdre_pv` | `valeur` | Retire des PV, modificateur `pv_perdus` |
| `payer` | `valeur` | Pièces gagnées par l'acteur, modificateur `pieces` |
| `reputation` | `valeur` | Impact sur la réputation (signé), modificateur `reputation` |
| `si` | `condition`, `alors`, `sinon` (facultatif) | Exécute une des deux listes d'effets |

**Conditions** : `"traitement_adapte"`, `"traitement_partiel"`, `"attente_depassee"`, `"gueri"`, `"patient_en_jeu"`, `"patient_hors_jeu"`, ou les formes composées `{ "et": [...] }`, `{ "ou": [...] }`, `{ "non": c }` et `{ "combinaison": prédicat }`.

**Invariants du moteur** (non paramétrables, appliqués à toute action) :

1. les montants sont modifiés par la difficulté, puis arrondis à l'entier le plus proche (demi éloigné de zéro), et une base non nulle reste au moins égale à 1 en valeur absolue ;
2. les PV ne descendent pas sous 0 ;
3. en fin d'action, si `PV = 0` et que le patient n'est pas guéri : il meurt, et `$recompenses.reputation_mort` est appliqué ;
4. un patient guéri ou mort passe à l'état « sorti » et sa maladie est révélée dans le résultat ;
5. la précondition de l'action est **réévaluée à la confirmation** (voir [SPECIFICATION.md §5.5](SPECIFICATION.md#55-confirmation-et-revalidation)).

### 6.1 Actions du paquet de base

`diagnostiquer` et `traiter` ont la même précondition : patient en jeu, **hors laboratoire** (le laboratoire ne sert qu'à analyser, §9). Dans `traiter`, le traitement partiel stabilise le patient : il ne subit pas d'aggravation.

```json
"actions": [
  {
    "id": "admettre", "libelle": "Admettre", "motif": "admission",
    "precondition": "patient_hors_jeu",
    "phrase": "Admission de {patient}.",
    "effets": [ { "effet": "admettre" } ]
  },
  {
    "id": "diagnostiquer", "libelle": "Diagnostiquer", "motif": "standard",
    "precondition": { "et": [ "patient_en_jeu",
                              { "non": { "combinaison": { "compte": { "type": "salle", "specialite": "recherche" }, "min": 1 } } } ] },
    "phrase": "Examen de {patient} par {medecin}[ et {medecin2}] dans {salle}[ avec {accessoire}].",
    "effets": [
      { "effet": "avancer_temps" },
      { "effet": "diagnostiquer" },
      { "effet": "payer", "valeur": "$recompenses.pieces_diagnostic" },
      { "effet": "aggraver" },
      { "effet": "si", "condition": "attente_depassee",
        "alors": [ { "effet": "reputation", "valeur": "$recompenses.reputation_attente" } ] }
    ]
  },
  {
    "id": "traiter", "libelle": "Traiter", "motif": "standard",
    "precondition": { "et": [ "patient_en_jeu",
                              { "non": { "combinaison": { "compte": { "type": "salle", "specialite": "recherche" }, "min": 1 } } } ] },
    "phrase": "Tentative de soin de {patient} par {medecin}[ et {medecin2}] dans {salle}[ avec {accessoire}].",
    "effets": [
      { "effet": "avancer_temps" },
      { "effet": "si", "condition": "traitement_adapte",
        "alors": [ { "effet": "soigner" },
                   { "effet": "payer", "valeur": "$recompenses.pieces_traitement" },
                   { "effet": "reputation", "valeur": "$recompenses.reputation_guerison" } ],
        "sinon": [ { "effet": "si", "condition": "traitement_partiel",
                     "alors": [ { "effet": "gagner_pv", "valeur": { "somme": [ "$recompenses.pv_partiel", "$capacite.stabilisation" ] } },
                                { "effet": "payer", "valeur": "$recompenses.pieces_partiel" } ],
                     "sinon": [ { "effet": "perdre_pv", "valeur": "$recompenses.pv_echec" },
                                { "effet": "reputation", "valeur": "$recompenses.reputation_echec" } ] } ] },
      { "effet": "si", "condition": { "non": { "ou": [ "gueri", "traitement_partiel" ] } }, "alors": [ { "effet": "aggraver" } ] },
      { "effet": "si", "condition": "attente_depassee",
        "alors": [ { "effet": "reputation", "valeur": "$recompenses.reputation_attente" } ] }
    ]
  }
]
```

### 6.2 Phrases

- Variables disponibles : `{patient}`, `{medecin}`, `{medecin2}`, `{salle}`, `{accessoire}`. Elles sont remplacées par le `nom_phrase` de la carte correspondante.
- Un segment entre crochets `[…]` n'est affiché que si **toutes** ses variables sont présentes dans la combinaison.
- La première lettre de la phrase est mise en majuscule automatiquement.
- Le genre et le nombre des personnes étant inconnus, les phrases privilégient le **style nominal**, qui évite tout accord (« Examen de… par… » plutôt que « Le Dr X examine… », qui deviendrait fautif avec deux médecins).
- Exemple : *« Examen de Mme Garnier par le Dr Moreau dans la salle de consultation avec le stéthoscope. »*

## 7. Validation à l'import

Un paquet est **refusé** s'il comporte au moins une erreur ; les avertissements n'empêchent pas l'import. Chaque message indique le chemin dans le JSON et une explication en français (ex. `maladies[12].specialite : la spécialité « cardiologie » n'est pas déclarée`).

**Erreurs**

1. non-conformité au JSON Schema (types, champs obligatoires, valeurs hors bornes) ;
2. `schema_version` non supportée (voir §8) ;
3. carte absente du catalogue embarqué, ou de type différent (v1) ;
4. référence inconnue : spécialité, capacité, carte, motif, référence `$…` ;
5. variable de phrase incompatible avec le motif de l'action (ex. `{salle}` dans une action d'admission) ;
6. spécialité déclarée qui n'est la spécialité d'aucune maladie ;
7. maladie dont le traitement adapté n'est **réalisable par aucune combinaison de traitement** des cartes du catalogue : une combinaison reconnue par le motif d'une action qui teste `traitement_adapte`, et permise par la partie `combinaison` de sa précondition (le laboratoire en est donc exclu). Vérification exhaustive : 2 650 combinaisons pour le paquet de base ;
8. identifiants en double ;
9. `poids` d'une maladie inférieur à 1 (déjà refusé par le JSON Schema, et revérifié par le validateur sémantique, qui donne un message explicite : `maladies[12].poids : une maladie doit avoir un poids d'au moins 1 ; pour l'écarter, retirez-la du paquet`) ;
10. valeur réservée mal employée : `polyvalent`, `generaliste` ou `recherche` déclarés dans `specialites`, spécialité de maladie réservée, `recherche` portée par une carte qui n'est pas une salle.

**Avertissements** : dossier `images/` non vide, maladie sans traitement partiel, spécialité portée par aucune carte, deux spécialités de même couleur ou de même icône, carte qui utilise encore `generaliste` (ancien nom de `polyvalent`), traitement adapté satisfait par toutes les combinaisons (prédicat sans doute toujours vrai), maladie qu'aucune combinaison ne traite en échec (traitement partiel sans doute toujours vrai).

## 8. Versionnement

- `schema_version` (entier) est incrémenté à chaque changement incompatible du format.
- L'application déclare la plage de versions qu'elle sait lire. Un paquet plus ancien est **migré** en mémoire ; un paquet plus récent est refusé (« Ce paquet nécessite une version plus récente de l'application »).
- Tant qu'aucun paquet n'a été publié (avant la première version de l'application), le format `schema_version` 1 peut encore évoluer sans incrément. Le passage au diagnostic par liste (couleur et icône des spécialités, nouveaux paramètres du diagnostic) a été fait ainsi, puis les renommages de la [revue de cohérence](REVUE_COHERENCE.md) : `maladies[].type` → `specialite`, `affinite_type` → `affinite_specialite`, `generaliste` → `polyvalent`, capacité `soin` → `stabilisation`, `soin_partiel` → `pv_partiel`, `reputation_soin` → `reputation_guerison`, issue et condition `soigne` → `gueri`, `pourcentage` → `indice` dans le résultat.
- `version` (texte, au format `MAJEUR.MINEUR.CORRECTIF`) est la version éditoriale du paquet. Elle est enregistrée dans les sauvegardes : au chargement d'une sauvegarde faite avec un autre paquet (identifiant, version ou empreinte différents), l'appli avertit l'utilisateur et refuse si des maladies référencées n'existent plus.

## 9. Salle recherche (prévu pour `schema_version` 2)

> **État** : conception validée. Sont **déjà en place** en `schema_version` 1 : la valeur réservée `recherche` (validateur), la carte du laboratoire dans le paquet de base (`SAL-011`), la réunion des actions de tous les motifs reconnus, et les préconditions « hors laboratoire » de `diagnostiquer` et `traiter`. Le reste (motif `recherche`, action `analyser`, effet `rechercher`, champ `recherche` des maladies) arrive avec la montée à `schema_version` 2 (voir [PLAN_DE_CODAGE.md](PLAN_DE_CODAGE.md) §5.2, étape 10). Règles du jeu : [MODELE_DE_JEU.md §12](MODELE_DE_JEU.md#12-recherche-en-laboratoire).

### 9.1 Spécialité réservée

`recherche` est une spécialité de **salle uniquement** : jamais spécialité d'une maladie, jamais portée par un médecin, un objet ou un diplôme, jamais déclarée dans `specialites`. Elle ne compte pas dans les spécialités de la combinaison `S(C)`. Le validateur refuse tout autre emploi (§7, règle 10).

### 9.2 Motif et exclusivité du laboratoire

```json
"motifs": {
  "admission": { "patient": [1, 1], "total": [1, 1] },
  "standard":  { "patient": [1, 1], "medecin": [1, 2], "salle": [1, 1], "objet|diplome": [0, 1], "total": [3, 4] },
  "recherche": { "patient": [1, 1], "medecin": [1, 1], "salle": [1, 1], "objet|diplome": [0, 1], "total": [3, 4] }
}
```

Le motif `recherche` accepte un accessoire (objet ou diplôme), pour les cartes qui aident à la recherche (§9.6). Une sélection médecin + patient + salle (+ accessoire) correspond à la fois à `standard` et à `recherche` : l'hôte réunit leurs actions (§3), et les préconditions font le tri :

| Salle | `diagnostiquer`, `traiter` | `analyser` |
|---|---|---|
| Laboratoire (spécialité `recherche`) | non : précondition « hors laboratoire » | oui |
| Toute autre salle | oui | non : précondition « au laboratoire » |

Le laboratoire ne permet donc **ni de diagnostiquer ni de traiter**, et aucune autre salle ne permet d'**analyser**. Un laboratoire avec deux médecins ne correspond qu'au motif standard : aucune action n'est proposée.

### 9.3 Action `analyser`

- `motif` : `recherche` ; précondition : `patient_en_jeu`, **et** `patient_diagnostique` (nouvelle condition : le patient a des maladies suspectées), **et** `{ "combinaison": { "compte": { "type": "salle", "specialite": "recherche" }, "min": 1 } }`. Un patient jamais diagnostiqué est refusé sans coût (« Aucune piste — faire d'abord un diagnostic »).
- **Paramètre choisi par le joueur à la confirmation** : la maladie analysée (`maladie_id`), dans la liste des maladies suspectées du patient.
- Effets : `avancer_temps`, `rechercher` (9.4), `aggraver`, puis pénalité d'attente si dépassée. Aucune pièce gagnée.

### 9.4 Nouvel effet `rechercher`

`{ "effet": "rechercher", "maladie": "<id_maladie>" }` :

1. ajoute au résultat la liste des maladies suspectées du patient (noms mémorisés lors des effets `diagnostiquer` précédents, remis à zéro à chaque admission) ;
2. décrémente de 1 le compteur de passages restants de la maladie choisie — état **global à la partie**, mémorisé par maladie ; la capacité `recherche` de la combinaison réduit le nombre de passages requis (minimum 1) ;
3. si le compteur atteint 0 : ajoute au résultat la **recette** de `traitement.adapte`, générée depuis le prédicat (`carte` → « la carte X », `compte` → « N cartes de type/spécialité … », en écrivant « médecins ou diplômes de X » quand un diplôme peut compter, `tous` → conjonction, `non` → « sans … ») ;
4. sinon : indique le nombre de passages restants (« Analyse en cours — X passage(s) restant(s) »).

### 9.5 Champ `recherche` d'une maladie

```json
{ "id": "maladie_xx", "nom": "…", "recherche": { "passages": 3 } }
```

`passages` : entier ≥ 1, défaut 1. Le validateur contrôle la cohérence (entier ≥ 1).

### 9.6 Capacité `recherche`

Déclarable comme toute capacité dans `capacites`, portée par des médecins ou des accessoires : chaque point réduit de 1 le nombre de passages requis pour l'analyse en cours, sans descendre sous 1. L'accessoire du motif `recherche` permet de jouer des **objets d'aide à la recherche**, à créer (aucun dans le paquet de base).
