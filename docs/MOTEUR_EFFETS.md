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
| Ajouter des spécialités et des capacités (portées par aucune carte imprimée en v1) | Modifier ce qui est **imprimé** sur une carte : type, nom, spécialité, capacités |
| Modifier les paramètres, les récompenses, les difficultés, les phrases (`nom_phrase`, `lieu_phrase`), les actions | Remplacer les images des cartes |

**Ce qui est imprimé** sur une carte : son image, son QR code, son type, son nom, sa spécialité (couleur et icône) et ses capacités. Les joueurs s'en servent pour composer leurs combinaisons à la table : une extension ne peut donc pas les modifier en v1. Chaque carte d'un paquet doit exister dans le **catalogue embarqué**, avec les mêmes attributs imprimés (règle 3 du §7). Les images sont toujours celles embarquées, retrouvées par identifiant (`assets/cartes/<ID>.png`).

### 1.3 Dossier `images/`

Réservé à la future possibilité d'ajouter des cartes. En v1, son contenu est **ignoré** et l'import affiche un avertissement s'il n'est pas vide.

## 2. Structure de `jeu.json`

| Clé | Contenu |
|---|---|
| `format` | Toujours `"cardhospital"` |
| `schema_version` | Version entière du format (actuellement `1`) |
| `id`, `nom`, `version`, `description` | Identité du paquet (`version` au format `MAJEUR.MINEUR.CORRECTIF`) |
| `parametres` | Paramètres du diagnostic, récompenses par défaut, attente maximale par défaut (en ticks), paliers d'aggravation |
| `difficultes` | Exactement 3 niveaux et leurs bonus de difficulté (entiers) |
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
- `lieu_phrase` (salles) : le lieu **avec sa préposition**, tel qu'il s'insère dans une phrase (« en réanimation », « à la pharmacie », « au bloc opératoire »). Par défaut : « dans » suivi de `nom_phrase`.
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
  "pv_initial": 15,
  "aggravation": [2, 2, 3, 3],
  "attente_max": 9,
  "poids": 1,
  "traitement": {
    "adapte":  { "tous": [ { "compte": { "type": "medecin" }, "min": 2 },
                           { "compte": { "type": "medecin", "specialite": "orthopedie" }, "min": 2 },
                           { "carte": "SAL-006" } ] },
    "partiel": { "tous": [ { "compte": { "type": "medecin", "specialite": "orthopedie" }, "min": 1 },
                           { "carte": "SAL-008" } ] }
  },
  "recompenses": { "pieces_traitement": 5, "reputation_echec": -2 },
  "recherche": { "passages": 3 }
}
```

`specialite` est la spécialité de la maladie : une spécialité déclarée, jamais une valeur réservée (`polyvalent`, `recherche`). `aggravation` donne la perte de PV par palier de présence, la dernière valeur se répétant ; `attente_max` se compte en ticks de présence (défaut : `parametres.attente_max_defaut`), `poids` (entier ≥ 1, défaut 1), `traitement.partiel`, `recompenses` et `recherche` sont facultatifs. `recherche.passages` (entier ≥ 1, défaut 1) est le nombre de passages en laboratoire nécessaires pour révéler la recette de la maladie (§9). Un poids nul est interdit : une maladie qui ne peut jamais être tirée n'a pas sa place dans le paquet, il suffit de la retirer. Toute clé de `recompenses` absente reprend la valeur de `parametres.recompenses`.

### 2.3 Spécialités

```json
"specialites": [
  { "id": "generale",    "nom": "Médecine générale", "couleur": "#4150D9", "icone": "🩺" },
  { "id": "cardiologie", "nom": "Cardiologie",       "couleur": "#D90041", "icone": "❤️" },
  { "id": "psychiatrie", "nom": "Psychiatrie",       "couleur": "#A659B2", "icone": "🧠" },
  { "id": "orthopedie",  "nom": "Orthopédie",        "couleur": "#E66E17", "icone": "🦴" },
  { "id": "paranormal",  "nom": "Paranormal",        "couleur": "#11A68B", "icone": "👻" }
]
```

`polyvalent`, `generaliste` (son ancien nom) et `recherche` sont réservés : ils ne se déclarent pas ici.

- `couleur` : couleur d'affichage des maladies de la spécialité dans un diagnostic, au format `#RRGGBB`.
- `icone` : emoji ou symbole court (1 à 8 caractères) affiché à côté de la couleur. Il double la couleur pour les joueurs daltoniens, et distingue les spécialités sur un écran mal calibré.
- Les deux champs sont obligatoires. Deux spécialités de même couleur ou de même icône déclenchent un avertissement à l'import.
- **Accessibilité** ([SPECIFICATION.md §9](SPECIFICATION.md#9-exigences-non-fonctionnelles)) : chaque couleur doit avoir un contraste d'au moins 3:1 sur fond clair (`#FFFFFF`) et sur fond sombre (`#121212`), et deux couleurs doivent rester distinctes (écart ΔE d'au moins 20) en vision normale, en protanopie, en deutéranopie et en tritanopie. Le validateur le vérifie et avertit sinon.
- Une extension qui ajoute une spécialité lui choisit sa couleur et son icône. L'emoji évite d'avoir à embarquer une image, ce qui reste interdit aux extensions en v1.

### 2.4 Horloge et paliers

`parametres.paliers_aggravation` (obligatoire) liste les durées de présence, en ticks et strictement croissantes, où commence chaque palier d'aggravation : `[5, 11, 17, 23]` dans le paquet de base. Avant la première, le patient est stable. Ces paliers sont **communs à toutes les maladies** ; la perte propre à chaque maladie est sa liste `aggravation`. `parametres.attente_max_defaut` est en ticks de présence (15 dans le paquet de base). Voir le [modèle de jeu §5](MODELE_DE_JEU.md#5-horloge-et-aggravation).

### 2.5 Paramètres du diagnostic

`parametres.diagnostic` contient `precision_max`, `verite`, `par_niveau`, `affinite_specialite`, `bonus_specialite`, `exclusion`, `taille_liste`, `score_bruit` et `ponderation_poids`. Leur rôle et leurs valeurs par défaut sont décrits dans le [modèle de jeu §8.3](MODELE_DE_JEU.md#83-calcul-de-la-liste).

### 2.6 Paramètres du laboratoire

`parametres.recherche` (facultatif) contient `bonus_specialite` (entier ≥ 0, défaut 0) : les passages de plus que compte une analyse quand un médecin de la spécialité de la maladie analysée, ou un diplôme de cette spécialité, y participe (§9.4). Le paquet de base le met à 1.

## 3. Motifs

Un motif décrit une forme de sélection par des **intervalles `[min, max]`** de nombre de cartes, par type de carte ou groupe de types de carte (séparés par `|`), plus un intervalle sur le total.

```json
"motifs": {
  "admission": { "patient": [1, 1], "total": [1, 1] },
  "standard":  { "patient": [1, 1], "medecin": [1, 2], "salle": [1, 1], "objet|diplome": [0, 1], "total": [3, 5] },
  "recherche": { "patient": [1, 1], "medecin": [1, 1], "salle": [1, 1], "objet|diplome": [0, 1], "total": [3, 4] }
}
```

Un type de carte absent d'un motif est interdit (`[0, 0]`). Le motif standard encode « 1 médecin + 1 patient + 1 salle, plus au choix un second médecin et un accessoire (objet ou diplôme) » : de 3 à 5 cartes, avec **un seul accessoire**. Le motif `recherche` est celui de l'analyse au laboratoire (§9).

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

Le bonus de difficulté est appliqué **par l'effet** qui consomme la valeur (voir §6), jamais dans l'expression.

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
| `admettre` | — | Tire une maladie (pondérée par `poids`), `PV ← pv_initial`, note le tick d'admission, patient « en jeu ». L'horloge n'avance pas |
| `avancer_temps` | — | L'horloge de l'hôpital avance d'un tick (tous patients confondus) |
| `diagnostiquer` | — | Calcule et ajoute au résultat la liste des maladies les plus probables du [modèle de jeu §8](MODELE_DE_JEU.md#8-diagnostic-probabiliste) ; les maladies de la liste rejoignent les maladies suspectées du patient |
| `rechercher` | — | Un passage en laboratoire sur la maladie choisie par le joueur à la confirmation (§9.4) |
| `aggraver` | — | Perte de PV du palier de présence atteint ([modèle de jeu §5.2](MODELE_DE_JEU.md#52-paliers-daggravation)) : 0 tant que le patient est stable, puis la valeur de `aggravation` pour ce palier (dernière valeur répétée), bonus `pv_perdus` |
| `soigner` | — | Marque le patient guéri |
| `gagner_pv` | `valeur` | Ajoute des PV, plafonnés à `pv_initial` (pas de bonus de difficulté) |
| `perdre_pv` | `valeur` | Retire des PV, bonus `pv_perdus` |
| `payer` | `valeur` | Pièces gagnées par l'acteur, bonus `pieces` |
| `reputation` | `valeur` | Impact sur la réputation (signé) ; bonus `reputation` sur les pertes seulement |
| `si` | `condition`, `alors`, `sinon` (facultatif) | Exécute une des deux listes d'effets |

**Conditions** : `"traitement_adapte"`, `"traitement_partiel"`, `"attente_depassee"`, `"gueri"`, `"patient_en_jeu"`, `"patient_hors_jeu"`, `"patient_diagnostique"` (le patient a des maladies suspectées, §9.3), ou les formes composées `{ "et": [...] }`, `{ "ou": [...] }`, `{ "non": c }` et `{ "combinaison": prédicat }`.

**Invariants du moteur** (non paramétrables, appliqués à toute action) :

1. le bonus de difficulté s'ajoute à la valeur absolue des pertes de PV, des gains de pièces et des pertes de réputation ; un montant nul reste nul, et un montant non nul reste au moins égal à 1 en valeur absolue ;
2. les PV ne descendent pas sous 0 ;
3. en fin d'action, si `PV = 0` et que le patient n'est pas guéri : il meurt, `$recompenses.reputation_mort` est appliqué, et l'acteur ne gagne **aucune pièce** pour cette action ;
4. un patient guéri ou mort passe à l'état « sorti » et sa maladie est révélée dans le résultat ;
5. la précondition de l'action est **réévaluée à la confirmation** (voir [SPECIFICATION.md §5.5](SPECIFICATION.md#55-confirmation-et-revalidation)).

### 6.1 Actions du paquet de base

`diagnostiquer` et `traiter` ont la même précondition : patient en jeu, **hors laboratoire** (le laboratoire ne sert qu'à analyser, §9). Dans `traiter`, le traitement partiel stabilise le patient : il ne subit pas d'aggravation. `analyser` est décrite au §9.3.

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
    "phrase": "Examen de {patient} par {medecin}[ et {medecin2}] {lieu}[ avec {accessoire}].",
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
    "phrase": "Tentative de soin de {patient} par {medecin}[ et {medecin2}] {lieu}[ avec {accessoire}].",
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
  },
  {
    "id": "analyser", "libelle": "Analyser", "motif": "recherche",
    "precondition": { "et": [ "patient_en_jeu", "patient_diagnostique",
                              { "combinaison": { "compte": { "type": "salle", "specialite": "recherche" }, "min": 1 } } ] },
    "phrase": "Analyse du cas de {patient} par {medecin} {lieu}[ avec {accessoire}].",
    "effets": [
      { "effet": "avancer_temps" },
      { "effet": "rechercher" },
      { "effet": "aggraver" },
      { "effet": "si", "condition": "attente_depassee",
        "alors": [ { "effet": "reputation", "valeur": "$recompenses.reputation_attente" } ] }
    ]
  }
]
```

### 6.2 Phrases

- Variables disponibles : `{patient}`, `{medecin}`, `{medecin2}`, `{salle}`, `{accessoire}`, remplacées par le `nom_phrase` de la carte correspondante, et `{lieu}`, remplacée par le `lieu_phrase` de la salle, préposition comprise (« en radiologie » ; par défaut « dans » + `nom_phrase`).
- Un segment entre crochets `[…]` n'est affiché que si **toutes** ses variables sont présentes dans la combinaison.
- La première lettre de la phrase est mise en majuscule automatiquement.
- Le genre et le nombre des personnes étant inconnus, les phrases privilégient le **style nominal**, qui évite tout accord (« Examen de… par… » plutôt que « Le Dr X examine… », qui deviendrait fautif avec deux médecins).
- Exemples : *« Examen de Mme Garnier par le Dr Moreau en radiologie avec le stéthoscope. »*, *« Tentative de soin de M. Dupont par le Dr Cassagne et le Dr Vasseur au bloc opératoire. »*, *« Analyse du cas de Mme Garnier par le Dr Moreau au laboratoire de recherche avec le microscope. »*

## 7. Validation à l'import

Un paquet est **refusé** s'il comporte au moins une erreur ; les avertissements n'empêchent pas l'import. Chaque message indique le chemin dans le JSON et une explication en français (ex. `maladies[12].specialite : la spécialité « cardiologie » n'est pas déclarée`).

**Erreurs**

1. non-conformité au JSON Schema (types, champs obligatoires, valeurs hors bornes) ;
2. `schema_version` non supportée (voir §8) ;
3. carte absente du catalogue embarqué, ou dont un attribut imprimé (type, nom, spécialité, capacités) diffère de la carte imprimée (v1 ; le validateur le vérifie quand on lui fournit le catalogue) ;
4. référence inconnue : spécialité, capacité, carte, motif, référence `$…` ;
5. variable de phrase incompatible avec le motif de l'action (ex. `{salle}` dans une action d'admission) ;
6. spécialité déclarée qui n'est la spécialité d'aucune maladie ;
7. maladie dont le traitement adapté n'est **réalisable par aucune combinaison de traitement** des cartes du catalogue : une combinaison reconnue par le motif d'une action qui teste `traitement_adapte`, et permise par la partie `combinaison` de sa précondition (le laboratoire en est donc exclu). Vérification exhaustive : 13 750 combinaisons pour le paquet de base ;
8. identifiants en double ;
9. `poids` d'une maladie inférieur à 1 (déjà refusé par le JSON Schema, et revérifié par le validateur sémantique, qui donne un message explicite : `maladies[12].poids : une maladie doit avoir un poids d'au moins 1 ; pour l'écarter, retirez-la du paquet`) ;
10. valeur réservée mal employée : `polyvalent`, `generaliste` ou `recherche` déclarés dans `specialites`, spécialité de maladie réservée, `recherche` portée par une carte qui n'est pas une salle ;
11. `recherche.passages` d'une maladie qui n'est pas un entier d'au moins 1, ou `parametres.recherche.bonus_specialite` qui n'est pas un entier positif ou nul ;
12. action avec l'effet `rechercher` dont la précondition n'exige pas `patient_diagnostique` (hors de toute alternative et de toute négation) : le joueur doit pouvoir choisir la maladie parmi les maladies suspectées.

Précisions sur la mise en œuvre (`packages/moteur/lib/validation`) :

- **Règle 1** : le paquet est validé contre le fichier `docs/schema/jeu.schema.json` complet (bibliothèque `json_schema`, draft 2020-12). Les messages sont traduits en français. Quand une forme à variantes est en échec (effet, prédicat, condition, valeur), le validateur repère la variante visée grâce à sa clé (`effet`, `carte`, `compte`, `et`…) et donne l'erreur précise : `actions[1].effets[2].valeur : champ obligatoire absent` plutôt que « effet non reconnu ».
- **Règle 2** : elle est vérifiée avant le schéma, qui ne connaît que la version courante. Le message reste donc explicite pour un paquet trop récent.
- **Règle 3** : l'appli fournit le catalogue embarqué, c'est-à-dire les cartes imprimées du paquet de base (`Validateur.catalogueDe`). Sans catalogue (validation du paquet de base lui-même, outils), la règle n'est pas vérifiée.
- **Ordre** : la validation s'arrête à la première famille d'erreurs. Un paquet non conforme au schéma ne reçoit que les erreurs de schéma ; les contrôles sémantiques ne tournent que sur un paquet conforme.
- **En ligne de commande** : `dart run tool/valider_paquet.dart <jeu.json>` affiche le rapport ; code de sortie 0 (valide), 1 (invalide) ou 64 (fichier absent ou illisible).

**Avertissements** : dossier `images/` non vide, maladie sans traitement partiel, spécialité portée par aucune carte, deux spécialités de même couleur ou de même icône, couleur de spécialité trop peu contrastée sur fond clair ou sombre, deux couleurs trop proches pour un daltonien (protanopie, deutéranopie, tritanopie), carte qui utilise encore `generaliste` (ancien nom de `polyvalent`), laboratoire (salle de spécialité `recherche`) alors qu'aucune action n'a l'effet `rechercher`, traitement adapté satisfait par toutes les combinaisons (prédicat sans doute toujours vrai), maladie qu'aucune combinaison ne traite en échec (traitement partiel sans doute toujours vrai).

## 8. Versionnement

- `schema_version` (entier) est incrémenté à chaque changement incompatible du format.
- L'application déclare la plage de versions qu'elle sait lire. Un paquet plus ancien est **migré** en mémoire ; un paquet plus récent est refusé (« Ce paquet nécessite une version plus récente de l'application »).
- Tant qu'aucun paquet n'a été publié (avant la première version de l'application), le format `schema_version` 1 peut encore évoluer sans incrément. Le passage au diagnostic par liste (couleur et icône des spécialités, nouveaux paramètres du diagnostic) a été fait ainsi, puis les renommages de la [revue de cohérence](REVUE_COHERENCE.md) : `maladies[].type` → `specialite`, `affinite_type` → `affinite_specialite`, `generaliste` → `polyvalent`, capacité `soin` → `stabilisation`, `soin_partiel` → `pv_partiel`, `reputation_soin` → `reputation_guerison`, issue et condition `soigne` → `gueri`, `pourcentage` → `indice` dans le résultat ; puis l'horloge commune (`paliers_aggravation`, `admission`, `presence`), les modificateurs de difficulté devenus des bonus entiers, `ponderation_poids`, `lieu_phrase` et la variable `{lieu}`, le motif standard à 2 médecins et 1 accessoire, et enfin la salle recherche (motif `recherche`, action `analyser`, effet `rechercher`, condition `patient_diagnostique`, champ `recherche` des maladies), d'abord prévue pour `schema_version` 2.
- `version` (texte, au format `MAJEUR.MINEUR.CORRECTIF`) est la version éditoriale du paquet. Elle est enregistrée dans les sauvegardes : au chargement d'une sauvegarde faite avec un autre paquet (identifiant, version ou empreinte différents), l'appli avertit l'utilisateur et refuse si des maladies référencées n'existent plus.

## 9. Salle recherche

Règles du jeu : [MODELE_DE_JEU.md §12](MODELE_DE_JEU.md#12-recherche-en-laboratoire). Code : `packages/moteur/lib/moteur/partie.dart` (effet et condition), `recette.dart` (rédaction des recettes), `etat.dart` (maladies suspectées et compteur commun).

### 9.1 Spécialité réservée

`recherche` est une spécialité de **salle uniquement** : jamais spécialité d'une maladie, jamais portée par un médecin, un objet ou un diplôme, jamais déclarée dans `specialites`. Elle ne compte pas dans les spécialités de la combinaison `S(C)`. Le validateur refuse tout autre emploi (§7, règle 10).

### 9.2 Motif et exclusivité du laboratoire

Le motif `recherche` (§3) accepte 1 médecin, 1 patient, 1 salle et un accessoire facultatif (objet ou diplôme), pour les cartes qui aident à la recherche (§9.6). Une sélection médecin + patient + salle (+ accessoire) correspond à la fois à `standard` et à `recherche` : l'hôte réunit leurs actions (§3), et les préconditions font le tri :

| Salle | `diagnostiquer`, `traiter` | `analyser` |
|---|---|---|
| Laboratoire (spécialité `recherche`) | non : précondition « hors laboratoire » | oui, si le patient a été diagnostiqué |
| Toute autre salle | oui | non : précondition « au laboratoire » |

Le laboratoire ne permet donc **ni de diagnostiquer ni de traiter**, et aucune autre salle ne permet d'**analyser**. Un laboratoire avec deux médecins ne correspond qu'au motif standard : aucune action n'est proposée (« Aucune action possible avec ces cartes. »).

### 9.3 Action `analyser`

- `motif` : `recherche` ; précondition : `patient_en_jeu`, **et** `patient_diagnostique` (le patient a des maladies suspectées), **et** `{ "combinaison": { "compte": { "type": "salle", "specialite": "recherche" }, "min": 1 } }`. JSON complet : §6.1.
- Un patient jamais diagnostiqué est refusé sans coût : « Aucune piste pour Mme Garnier : faire d'abord un diagnostic. ». L'hôte donne ce message quand les cartes permettent l'action mais que seule l'état du patient l'empêche, et que la précondition mentionne `patient_diagnostique`.
- **Maladie choisie par le joueur.** L'aperçu (`SelectionAcceptee`) joint à l'action la liste des maladies suspectées du patient (`maladies` : `{id, nom, specialite}`, dans l'ordre de première apparition). Le joueur en choisit une ; la confirmation la transmet (`maladie_id` dans le message `confirmer`, [SPECIFICATION.md §3.3](SPECIFICATION.md#33-protocole)). Une maladie absente ou non suspectée est refusée sans coût : « Choisissez la maladie à analyser parmi les maladies suspectées — action non appliquée. ». Toute action qui contient l'effet `rechercher` demande ce choix.
- Effets : `avancer_temps`, `rechercher`, `aggraver`, puis pénalité d'attente si dépassée. Aucune pièce gagnée.

### 9.4 Effet `rechercher`

`{ "effet": "rechercher" }`, sans paramètre dans le JSON : la maladie est celle choisie à la confirmation.

1. Le compteur de la maladie choisie avance de 1, plus la capacité `recherche` de la combinaison, plus `parametres.recherche.bonus_specialite` si la combinaison satisfait `{ "compte": { "type": "medecin", "specialite": <spécialité de la maladie> }, "min": 1 }` (un diplôme de cette spécialité compte, §5), sans dépasser `recherche.passages`. Code : `avanceeRecherche` dans `partie.dart`. Ce compteur est **commun à toute la partie**, mémorisé par maladie (`recherche` dans l'état sauvegardé) : les passages de tous les joueurs et sur tous les patients s'additionnent.
2. Le résultat porte `analyse` : la maladie choisie, `passages_restants` et, quand il n'en reste plus, la **recette** de `traitement.adapte` ([modèle de jeu §11.1](MODELE_DE_JEU.md#111-format-du-résultat)). Une maladie déjà révélée peut être analysée de nouveau : la recette s'affiche une nouvelle fois, au coût normal d'un passage.

**Rédaction de la recette** (`RedacteurRecette`) :

- une conjonction (`tous`) s'écrit « cartes requises, lieu, exclusions » ;
- `carte` donne le `nom_phrase` de la carte ; une salle, une alternative entre salles ou un `compte` de salles par identifiant donnent le lieu (`lieu_phrase`), relié par « ou » ;
- `compte` donne « un médecin », « une salle », « 2 médecins », « au plus un… », « exactement… », « de 1 à 2… », avec « de spécialité X » si le filtre porte une spécialité ; pour des médecins d'une spécialité, la recette précise ce que permet un diplôme : « (ou muni du diplôme de cette spécialité) », ou, s'il en faut deux, « (l'un d'eux peut être remplacé par un médecin muni du diplôme de cette spécialité) » ;
- « 2 médecins » et « un médecin de spécialité X » dans une même conjonction se lisent ensemble : « 2 médecins, dont un de spécialité X » ;
- `non` et `compte` avec `max: 0` donnent « sans … » (« sans aucun objet ») ;
- `un_de` relie ses éléments par « ou », une conjonction imbriquée étant mise entre parenthèses.

### 9.5 Champ `recherche` d'une maladie

```json
{ "id": "maladie_xx", "nom": "…", "recherche": { "passages": 3 } }
```

`passages` : entier ≥ 1, défaut 1. Le validateur le contrôle (§7, règle 11). Le paquet de base demande 2 passages aux paliers de gravité A et B, 3 au palier C et 4 au palier D, pour qu'un objet d'aide ou un spécialiste soit toujours utile ([modèle de jeu §12.4](MODELE_DE_JEU.md#124-nombre-de-passages)).

### 9.6 Capacité `recherche`

Déclarée comme toute capacité dans `capacites`, portée par des médecins ou des accessoires : chaque point fait avancer d'un passage de plus le compteur commun de la maladie analysée (§9.4). Une analyse compte toujours pour au moins un passage. Le paquet de base la donne à trois objets d'aide à la recherche, joués comme accessoire du motif `recherche` : le microscope (`OBJ-017`) et la centrifugeuse (`OBJ-018`), 1 point chacun, et le séquenceur d'ADN (`OBJ-019`), 2 points.

### 9.7 État et sauvegarde

L'état (`format_etat` 3) mémorise :

- pour chaque patient, `suspectees` : les identifiants des maladies apparues dans ses diagnostics depuis l'admission ;
- pour la partie, `recherche` : les passages comptés par maladie.

Les instantanés d'annulation les contiennent, si bien qu'annuler une analyse rétablit le compteur. Une sauvegarde au format 2 (sans laboratoire) est encore relue, sans maladie suspectée ni analyse. À la reprise avec un autre paquet, une maladie analysée ou suspectée qui n'existe plus est ignorée, avec un avertissement.
