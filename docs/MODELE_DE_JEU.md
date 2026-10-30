# CardHospital — Modèle de jeu

Ce document décrit les **règles calculées par l'application** : entités, cycle de vie d'un patient, diagnostic, traitement, temps, récompenses. Il est indépendant de la technique (voir [SPECIFICATION.md](SPECIFICATION.md)) et du format de fichier (voir [MOTEUR_EFFETS.md](MOTEUR_EFFETS.md)). Les termes sont définis dans le [glossaire](GLOSSAIRE.md).

Toutes les valeurs numériques citées ici sont des **valeurs par défaut du paquet de base** : elles sont paramétrables dans le JSON.

## 1. Partage des responsabilités

| Géré par l'appli (hôte) | Géré par les joueurs, hors appli |
|---|---|
| Maladie cachée de chaque patient, PV, temps du patient | Tour de jeu, ordre des joueurs |
| Diagnostic probabiliste, issue des traitements | Points de victoire, conditions de victoire |
| Calcul des pièces gagnées et de l'impact sur la réputation, **par action** | Cumul des pièces et de la réputation |
| | Partage des pièces entre le médecin et l'hôpital, achats (salles, objets, diplômes) |
| | Pioche des cartes patient, retour des cartes sorties dans la pioche |

## 2. Entités

### 2.1 Catalogue cible du paquet de base

| Entité | Nombre | Support |
|---|---|---|
| Médecins | 10 | carte |
| Patients | 30 | carte |
| Objets et diplômes | 30 | carte |
| Salles | 10 | carte |
| Maladies | 100 | virtuelle (dans le JSON) |
| Spécialités | 3 + extensibles | virtuelle |

Spécialités du paquet de base : `psychologie`, `chirurgie`, `pharmacie`. La valeur `generaliste` peut être portée par une carte (salle généraliste, médecin généraliste) mais **n'est jamais le type d'une maladie**.

### 2.2 Cartes

Une carte est une **identité stable** ; elle ne porte aucun état de partie.

- **Médecin** : nom, image, spécialité (ou `generaliste`), capacités.
- **Patient** : nom, image. Aucune maladie ni PV imprimés : tout est tiré à l'admission.
- **Salle** : nom, image, spécialité (ou `generaliste`), capacités (dont la précision de base du diagnostic).
- **Objet** (stéthoscope, livre, médicament, équipement…) : nom, image, spécialité facultative, capacités.
- **Diplôme** : nom, image, spécialité facultative, capacités. Un diplôme se joue **comme un accessoire** dans la combinaison : c'est sa présence qui compte.

Les éventuelles restrictions d'achat (« objet réservé aux détenteurs de tel diplôme ») sont des **règles de table**, invisibles pour l'appli.

### 2.3 Maladies

Chaque maladie définit :

| Champ | Rôle | Exemple |
|---|---|---|
| `type` | Spécialité de la maladie | `chirurgie` |
| `pv_initial` | PV à l'admission (entier > 0) | `10` |
| `aggravation` | PV perdus par action non curative, selon le temps du patient (la dernière valeur se répète) | `[1, 1, 2, 3]` |
| `attente_max` | Seuil de temps au-delà duquel chaque action coûte de la réputation | `5` |
| `poids` | Probabilité relative d'être tirée à l'admission | `1` |
| `traitement.adapte` | Prédicat sur la combinaison : traitement qui **soigne** | voir §6 |
| `traitement.partiel` | Prédicat facultatif : traitement qui **stabilise** (gain de PV sans guérison) | voir §6 |
| `recompenses` | Pièces et réputation propres à la maladie (sinon valeurs globales) | voir §7 |

## 3. Combinaisons

### 3.1 Motifs reconnus

| Motif | Cartes | Actions proposées |
|---|---|---|
| **Admission** | 1 patient, seul | `admettre` (si le patient n'est pas en jeu) |
| **Standard** | 1 médecin + 1 patient + 1 salle + 0 ou 1 carte parmi {objet, diplôme, second médecin} | `diagnostiquer`, `traiter` |

Toute autre sélection est **refusée avec un message explicite** indiquant ce qui manque ou ce qui est en trop (« Il faut une carte salle », « Une seule carte patient par action », « 4 cartes maximum »). Une même carte détectée deux fois ne compte qu'une fois.

### 3.2 Choix de l'action

Une combinaison standard permet deux actions. L'écran de confirmation propose **un bouton par action possible** (« Diagnostiquer », « Traiter »), chacun avec sa phrase d'aperçu, plus « Annuler ». Le joueur annonce son intention en choisissant le bouton.

### 3.3 Spécialités et capacités d'une combinaison

- **Spécialités de la combinaison** `S(C)` : l'ensemble des spécialités portées par les médecins, la salle et l'accessoire, hors `generaliste`.
- **Capacité totale** : la somme, pour chaque capacité, des valeurs portées par toutes les cartes de la combinaison sauf le patient.

## 4. Cycle de vie d'un patient

```
            admettre                diagnostiquer / traiter (inadapté ou partiel)
 [hors jeu] ────────► [en jeu] ◄──────────────────────────────┐
     ▲                   │  └─────────────────────────────────┘
     │                   ├── traiter (adapté) ───► [soigné] ─┐
     │                   └── PV ≤ 0 ─────────────► [mort]  ──┤
     └─────────────── la carte retourne dans la pioche ◄─────┘   (état « sorti »)
```

### 4.1 Admission

Un patient entre en jeu quand un joueur pioche sa carte et **la scanne seule** pour la première fois, puis confirme l'action « Admettre ».

1. L'hôte tire une maladie au hasard parmi celles du paquet actif, pondérée par `poids`. Le tirage est **indépendant de la carte**.
2. `PV ← maladie.pv_initial`, `temps ← 0`.
3. Le résultat affiche : « M. Dupont est admis — 10 PV ». La maladie n'est **pas** affichée.

Scanner seul un patient déjà en jeu ne déclenche rien (« M. Dupont est déjà en jeu »). L'appli ne révèle aucune autre information.

### 4.2 Sortie

Un patient soigné ou mort passe à l'état **sorti** : sa maladie est révélée dans le résultat (« M. Dupont est guéri de sa péritonite »). La carte retourne dans la pioche ; si elle est de nouveau piochée et scannée seule, elle est **réadmise avec une nouvelle maladie**. Une combinaison standard contenant un patient hors jeu ou sorti est refusée (« M. Dupont n'est pas admis »).

## 5. Temps et aggravation

Le temps est **propre à chaque patient** et n'avance que lorsqu'on agit sur lui :

- chaque action **confirmée** de diagnostic ou de traitement sur un patient incrémente son temps de 1 ;
- les sélections annulées, refusées ou non confirmées ne comptent pas ;
- un patient jamais sollicité ne s'aggrave jamais.

**Aggravation** : après une action non curative (diagnostic, traitement partiel ou inadapté), le patient perd `aggravation[temps]` PV (le premier élément correspond à `temps = 1`, la dernière valeur de la liste se répétant ensuite), avec le modificateur de difficulté `pv_perdus`.

**Attente dépassée** : si `temps > attente_max`, chaque action supplémentaire sur ce patient (y compris celle qui le soigne) coûte `reputation_attente` en réputation (défaut : −1), avec le modificateur de difficulté `reputation`.

**Mort** : si les PV tombent à 0 ou moins à la fin d'une action, le patient meurt (`PV` affichés = 0). Un traitement adapté l'emporte toujours : un patient soigné ne subit pas d'aggravation lors de cette action.

## 6. Traitement

L'issue d'une action `traiter` est évaluée dans l'ordre :

1. la combinaison satisfait `traitement.adapte` → **adapté** : le patient est **soigné** ;
2. sinon, elle satisfait `traitement.partiel` (s'il existe) → **partiel** : le patient gagne `soin_partiel` PV (défaut 2) plus la capacité `soin` de la combinaison, sans dépasser `pv_initial` ; il n'est pas soigné ;
3. sinon → **inadapté** : le patient perd `pv_echec` PV (défaut 2) et l'hôpital perd de la réputation.

Les prédicats de traitement portent sur les cartes de la combinaison : présence d'une carte précise, nombre de cartes d'un type et d'une spécialité donnés, spécialité de la salle… (syntaxe : [MOTEUR_EFFETS.md §5](MOTEUR_EFFETS.md#5-prédicats)). Ils expriment typiquement :

| Type de maladie | Traitement adapté (exemple) | Traitement partiel (exemple) |
|---|---|---|
| Pharmacie | la carte médicament spécifique à la maladie (ex. `OBJ-012`) | un autre médicament de spécialité `pharmacie` |
| Chirurgie | 2 médecins de spécialité `chirurgie` + une salle `chirurgie` | 1 seul chirurgien en salle `chirurgie` |
| Psychologie | un médecin `psychologie` (psychiatre) + une salle `psychologie` | un médecin `psychologie` hors salle dédiée |

Le validateur de paquet vérifie que **chaque maladie a au moins un traitement adapté réalisable** avec les cartes du catalogue.

## 7. Récompenses

Tous les montants sont des **entiers**. Après application des modificateurs de difficulté, chaque montant est arrondi à l'entier le plus proche, les demis étant arrondis en s'éloignant de zéro (2,5 → 3 ; −2,5 → −3). Un montant de base non nul ne peut pas devenir nul : il vaut au minimum 1 en valeur absolue.

| Événement | Pièces (acteur) | Réputation |
|---|---|---|
| Admission | 0 | 0 |
| Diagnostic | `pieces_diagnostic` (défaut 1) | 0 |
| Traitement adapté (soigné) | `pieces_traitement` (défaut 3) | `reputation_soin` (défaut +2) |
| Traitement partiel | `pieces_partiel` (défaut 1) | 0 |
| Traitement inadapté | 0 | `reputation_echec` (défaut −1) |
| Attente dépassée (par action) | — | `reputation_attente` (défaut −1) |
| Mort du patient | — | `reputation_mort` (défaut −3) |

Chaque maladie peut surcharger ces valeurs (les maladies graves paient plus). Le résultat rappelle que l'acteur choisit, hors appli, la part qu'il garde (achat d'objets et de diplômes) et la part qu'il cède à l'hôpital (achat de salles).

## 8. Diagnostic probabiliste

### 8.1 Principe

Un diagnostic produit une **distribution de probabilités** sur le type de maladie, et éventuellement sur son nom. Elle est **retirée à chaque diagnostic** : deux diagnostics successifs donnent des chiffres différents. Elle **peut être fausse** : le type le plus probable n'est pas toujours le bon. Les diagnostics répétés orientent les joueurs, mais chacun fait avancer le temps du patient.

Exemple de résultat : *« Psychologie 60 % — Chirurgie 30 % — Pharmacie 10 % »*, alors que la maladie est de type chirurgie.

### 8.2 Niveau de précision

```
N = min(precision_max, somme des capacités « precision » des cartes de la combinaison)
```

La salle porte la précision de base (salle généraliste : 1). Les médecins et accessoires l'augmentent (livre de médecine +1, scanner IRM +2…). Défaut : `precision_max = 5`.

### 8.3 Distribution sur le type

Pour chaque spécialité-type `t` du paquet :

1. `w(t) ← tirage aléatoire selon une loi exponentielle de paramètre 1`. Ce bruit non borné garantit qu'aucun diagnostic n'est infaillible.
2. Si `t` est le vrai type : `w(t) ← w(t) × (1 + verite + par_niveau × N)`.
3. Si `t ∈ S(C)` (spécialité présente dans la combinaison) :
   - `t` est le vrai type (**concordance**) : `w(t) ← w(t) × (1 + bonus_specialite)` ;
   - sinon (**exclusion**) : `w(t) ← w(t) × exclusion`. Utiliser un psychiatre sur un patient chirurgical **disqualifie rapidement** la piste psychologie.
4. Normalisation en pourcentages entiers de somme 100 (méthode du plus fort reste). Les types sous `seuil_affichage` (défaut 5 %) sont regroupés en « Autres ».

Valeurs par défaut : `verite = 0.5`, `par_niveau = 0.5`, `bonus_specialite = 2.0`, `exclusion = 0.15`.

Comportement attendu avec 3 types (simulation de 20 000 tirages) :

| Combinaison | N | Vrai type en tête | Probabilité moyenne affichée pour le vrai type |
|---|---|---|---|
| Aucune spécialité | 1 | 53 % | 46 % |
| Aucune spécialité | 4 | 68 % | 56 % |
| Spécialité discordante (ex. psy sur chirurgie) | 1 | 66 % | 57 % (psy tombe à ~7 %) |
| Spécialité concordante | 1 | 79 % | 65 % |
| Spécialité concordante | 4 | 87 % | 73 % |

### 8.4 Distribution sur le nom

Si le **vrai type ∈ S(C)**, c'est-à-dire si le médecin, l'accessoire ou la salle concorde avec la maladie, le résultat ajoute une distribution sur les **noms** des maladies de ce type :

1. `w(m) ← loi exponentielle de paramètre 1` pour chaque maladie `m` du vrai type ;
2. pour la vraie maladie : `w(m) ← w(m) × (1 + verite_nom + par_niveau_nom × N)` ;
3. normalisation ; affichage des `nb_noms` premières (défaut 3) puis « Autres ».

Valeurs par défaut : `verite_nom = 3.0`, `par_niveau_nom = 1.5`. Avec environ 25 maladies par type, la vraie maladie figure dans les 3 premières environ 2 fois sur 3 (de 57 % à N = 0 à 79 % à N = 4).

Conséquence assumée : l'apparition de la liste de noms **confirme le type** de la maladie. C'est la récompense de la bonne spécialité.

### 8.5 Réglage

Ces paramètres sont dans le JSON (`parametres.diagnostic`). Leur réglage se fait avec le **simulateur** prévu à la phase 1 de la [feuille de route](FEUILLE_DE_ROUTE.md), qui remplace en partie un prototype papier.

## 9. Ordre de résolution d'une action

Pour `diagnostiquer` et `traiter`, l'ordre par défaut est le suivant (il est écrit explicitement dans le JSON, voir [MOTEUR_EFFETS.md §6.1](MOTEUR_EFFETS.md#61-actions-du-paquet-de-base)) :

1. `temps ← temps + 1` ;
2. effet propre à l'action (diagnostic, ou issue du traitement avec ses PV, pièces et réputation) ;
3. si le patient n'est pas soigné : aggravation ;
4. si `temps > attente_max` : pénalité d'attente ;
5. si `PV ≤ 0` et que le patient n'est pas soigné : mort et pénalité de mort ;
6. si le patient est sorti : révélation de la maladie.

## 10. Difficulté

Trois niveaux, choisis au lancement de la partie :

| Niveau | `pv_perdus` | `pieces` | `reputation` |
|---|---|---|---|
| Interne | ×1,0 | ×1,0 | ×1,0 |
| Chirurgien | ×1,5 | ×1,2 | ×1,5 |
| Réanimation | ×2,0 | ×1,5 | ×2,0 |

- `pv_perdus` s'applique aux pertes de PV (aggravation, traitement inadapté).
- `pieces` s'applique à tous les gains de pièces.
- `reputation` s'applique aux impacts de réputation, positifs comme négatifs.

L'arrondi (§7) s'applique **après** le modificateur.

## 11. Contenu d'un résultat

| Élément | Admission | Diagnostic | Traitement |
|---|---|---|---|
| PV avant → après (delta) | PV initiaux | oui | oui |
| Temps du patient / attente dépassée | — | oui | oui |
| Distribution type (et noms) | — | oui | — |
| Issue : en jeu / soigné / mort | — | oui | oui |
| Maladie révélée | — | si mort | si soigné ou mort |
| Pièces gagnées | — | oui | oui |
| Impact réputation | — | oui | oui |
