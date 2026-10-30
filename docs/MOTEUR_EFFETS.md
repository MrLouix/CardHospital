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
| `specialites` | Types de maladie / spécialités (`generaliste` est réservé et implicite) |
| `capacites` | Capacités déclarées (ex. `precision`, `soin`) |
| `cartes` | Dictionnaire `identifiant QR → carte` |
| `maladies` | Liste des maladies |
| `motifs` | Formes de combinaison reconnues |
| `actions` | Actions possibles, avec leur motif, leur précondition, leur phrase et leur liste d'effets |

Toutes les clés sont en **français**, en `snake_case`. Les identifiants sont en minuscules (`[a-z0-9_]`), sauf les identifiants de cartes, qui reprennent le contenu du QR (`MED-001`, `PAT-012`…).

### 2.1 Cartes

```json
"MED-003": {
  "type": "medecin",
  "nom": "Dr Lefort",
  "nom_phrase": "le Dr Lefort",
  "specialite": "chirurgie",
  "capacites": { "precision": 1 }
}
```

- `type` : `medecin`, `patient`, `salle`, `objet` ou `diplome`.
- `nom` : nom affiché (titres, listes).
- `nom_phrase` : nom **avec son article**, tel qu'il s'insère dans une phrase (« le stéthoscope », « la salle d'opération », « l'IRM »). On évite ainsi tout calcul grammatical. S'il est absent, `nom` est utilisé.
- `specialite` : une spécialité déclarée ou `generaliste` (interdit pour un patient).
- `capacites` : entiers par capacité déclarée (interdit pour un patient).

Les noms de personnages ou de marques existants (personnages de séries, marques de médicaments) sont à proscrire dans le contenu livré.

### 2.2 Maladies

```json
{
  "id": "appendicite",
  "nom": "Appendicite",
  "type": "chirurgie",
  "pv_initial": 10,
  "aggravation": [1, 2, 2, 3],
  "attente_max": 4,
  "poids": 2,
  "traitement": {
    "adapte":  { "tous": [ { "compte": { "type": "medecin", "specialite": "chirurgie" }, "min": 2 },
                           { "compte": { "type": "salle",   "specialite": "chirurgie" }, "min": 1 } ] },
    "partiel": { "compte": { "type": "medecin", "specialite": "chirurgie" }, "min": 1 }
  },
  "recompenses": { "pieces_traitement": 4 }
}
```

`attente_max`, `poids` (entier ≥ 1, défaut 1), `traitement.partiel` et `recompenses` sont facultatifs. Un poids nul est interdit : une maladie qui ne peut jamais être tirée n'a pas sa place dans le paquet, il suffit de la retirer. Toute clé de `recompenses` absente reprend la valeur de `parametres.recompenses`.

## 3. Motifs

Un motif décrit une forme de sélection par des **intervalles `[min, max]`** de nombre de cartes, par type ou groupe de types (séparés par `|`), plus un intervalle sur le total.

```json
"motifs": {
  "admission": { "patient": [1, 1], "total": [1, 1] },
  "standard":  { "patient": [1, 1], "medecin": [1, 2], "salle": [1, 1], "objet|diplome": [0, 1], "total": [3, 4] }
}
```

Un type absent d'un motif est interdit (`[0, 0]`). Le motif standard encode « 1 médecin + 1 patient + 1 salle + au plus une carte parmi {objet, diplôme, second médecin} », la limite `total ≤ 4` excluant d'avoir à la fois un second médecin et un accessoire.

Quand une sélection ne correspond à aucun motif, l'hôte renvoie le **premier écart** constaté par rapport au motif le plus proche (« Il faut une carte salle »).

## 4. Valeurs

Partout où un montant est attendu :

| Forme | Exemple | Sens |
|---|---|---|
| Entier | `2` | Valeur littérale |
| Référence | `"$recompenses.pieces_traitement"` | Valeur de la maladie du patient si elle est définie, sinon celle de `parametres.recompenses` |
| Référence | `"$capacite.soin"` | Total de la capacité `soin` sur les cartes de la combinaison (patient exclu) |
| Somme | `{ "somme": [ "$recompenses.soin_partiel", "$capacite.soin" ] }` | Somme des valeurs |

Le modificateur de difficulté et l'arrondi sont appliqués **par l'effet** qui consomme la valeur (voir §6), jamais dans l'expression.

## 5. Prédicats

Les prédicats testent les **cartes d'une combinaison**. Ils servent aux traitements des maladies et à la condition `{ "combinaison": … }`.

| Prédicat | Exemple | Vrai si |
|---|---|---|
| `carte` | `{ "carte": "OBJ-012" }` | La carte est dans la combinaison |
| `compte` | `{ "compte": { "type": "medecin", "specialite": "chirurgie" }, "min": 2 }` | Au moins `min` (et au plus `max`, facultatif) cartes correspondent au filtre |
| `tous` | `{ "tous": [ p1, p2 ] }` | Tous les sous-prédicats sont vrais |
| `un_de` | `{ "un_de": [ p1, p2 ] }` | Au moins un sous-prédicat est vrai |
| `non` | `{ "non": p }` | Le sous-prédicat est faux |

Le filtre d'un `compte` accepte `type`, `specialite` et `id`, chacun sous forme d'une valeur ou d'une liste de valeurs acceptées.

## 6. Effets

Une action est une **liste d'effets exécutés dans l'ordre**. Chaque effet est un objet discriminé par la clé `effet`.

| Effet | Paramètres | Comportement |
|---|---|---|
| `admettre` | — | Tire une maladie (pondérée par `poids`), `PV ← pv_initial`, `temps ← 0`, patient « en jeu » |
| `avancer_temps` | — | `temps ← temps + 1` |
| `diagnostiquer` | — | Calcule et ajoute au résultat la distribution du [modèle de jeu §8](MODELE_DE_JEU.md#8-diagnostic-probabiliste) |
| `aggraver` | — | Perte de `aggravation[temps]` PV (dernière valeur répétée), modificateur `pv_perdus` |
| `soigner` | — | Marque le patient soigné |
| `gagner_pv` | `valeur` | Ajoute des PV, plafonnés à `pv_initial` (pas de modificateur) |
| `perdre_pv` | `valeur` | Retire des PV, modificateur `pv_perdus` |
| `payer` | `valeur` | Pièces gagnées par l'acteur, modificateur `pieces` |
| `reputation` | `valeur` | Impact sur la réputation (signé), modificateur `reputation` |
| `si` | `condition`, `alors`, `sinon` (facultatif) | Exécute une des deux listes d'effets |

**Conditions** : `"traitement_adapte"`, `"traitement_partiel"`, `"attente_depassee"`, `"soigne"`, `"patient_en_jeu"`, `"patient_hors_jeu"`, ou les formes composées `{ "et": [...] }`, `{ "ou": [...] }`, `{ "non": c }` et `{ "combinaison": prédicat }`.

**Invariants du moteur** (non paramétrables, appliqués à toute action) :

1. les montants sont modifiés par la difficulté, puis arrondis à l'entier le plus proche (demi éloigné de zéro), et une base non nulle reste au moins égale à 1 en valeur absolue ;
2. les PV ne descendent pas sous 0 ;
3. en fin d'action, si `PV = 0` et que le patient n'est pas soigné : il meurt, et `$recompenses.reputation_mort` est appliqué ;
4. un patient soigné ou mort passe à l'état « sorti » et sa maladie est révélée dans le résultat ;
5. la précondition de l'action est **réévaluée à la confirmation** (voir [SPECIFICATION.md §5.5](SPECIFICATION.md#55-confirmation-et-revalidation)).

### 6.1 Actions du paquet de base

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
    "precondition": "patient_en_jeu",
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
    "precondition": "patient_en_jeu",
    "phrase": "Tentative de soin de {patient} par {medecin}[ et {medecin2}] dans {salle}[ avec {accessoire}].",
    "effets": [
      { "effet": "avancer_temps" },
      { "effet": "si", "condition": "traitement_adapte",
        "alors": [ { "effet": "soigner" },
                   { "effet": "payer", "valeur": "$recompenses.pieces_traitement" },
                   { "effet": "reputation", "valeur": "$recompenses.reputation_soin" } ],
        "sinon": [ { "effet": "si", "condition": "traitement_partiel",
                     "alors": [ { "effet": "gagner_pv", "valeur": { "somme": [ "$recompenses.soin_partiel", "$capacite.soin" ] } },
                                { "effet": "payer", "valeur": "$recompenses.pieces_partiel" } ],
                     "sinon": [ { "effet": "perdre_pv", "valeur": "$recompenses.pv_echec" },
                                { "effet": "reputation", "valeur": "$recompenses.reputation_echec" } ] } ] },
      { "effet": "si", "condition": { "non": "soigne" }, "alors": [ { "effet": "aggraver" } ] },
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

Un paquet est **refusé** s'il comporte au moins une erreur ; les avertissements n'empêchent pas l'import. Chaque message indique le chemin dans le JSON et une explication en français (ex. `maladies[12].type : la spécialité « cardiologie » n'est pas déclarée`).

**Erreurs**

1. non-conformité au JSON Schema (types, champs obligatoires, valeurs hors bornes) ;
2. `schema_version` non supportée (voir §8) ;
3. carte absente du catalogue embarqué, ou de type différent (v1) ;
4. référence inconnue : spécialité, capacité, carte, motif, référence `$…` ;
5. variable de phrase incompatible avec le motif de l'action (ex. `{salle}` dans une action d'admission) ;
6. spécialité-type sans aucune maladie ;
7. maladie dont le traitement adapté n'est **réalisable par aucune combinaison standard** des cartes du catalogue (vérification exhaustive : environ 3 500 combinaisons pour le catalogue cible) ;
8. identifiants en double ;
9. `poids` d'une maladie inférieur à 1 (déjà refusé par le JSON Schema, et revérifié par le validateur sémantique, qui donne un message explicite : `maladies[12].poids : une maladie doit avoir un poids d'au moins 1 ; pour l'écarter, retirez-la du paquet`).

**Avertissements** : dossier `images/` non vide, maladie sans traitement partiel, spécialité portée par aucune carte.

## 8. Versionnement

- `schema_version` (entier) est incrémenté à chaque changement incompatible du format.
- L'application déclare la plage de versions qu'elle sait lire. Un paquet plus ancien est **migré** en mémoire ; un paquet plus récent est refusé (« Ce paquet nécessite une version plus récente de l'application »).
- `version` (texte, au format `MAJEUR.MINEUR.CORRECTIF`) est la version éditoriale du paquet. Elle est enregistrée dans les sauvegardes : au chargement d'une sauvegarde faite avec un autre paquet (identifiant, version ou empreinte différents), l'appli avertit l'utilisateur et refuse si des maladies référencées n'existent plus.
