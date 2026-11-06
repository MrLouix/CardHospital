# CardHospital — Modèle de jeu

Ce document décrit les **règles calculées par l'application** : entités, cycle de vie d'un patient, diagnostic, traitement, horloge et aggravation, récompenses. Il est indépendant de la technique (voir [SPECIFICATION.md](SPECIFICATION.md)) et du format de fichier (voir [MOTEUR_EFFETS.md](MOTEUR_EFFETS.md)). Les termes sont définis dans le [glossaire](GLOSSAIRE.md).

Toutes les valeurs numériques citées ici sont des **valeurs par défaut du paquet de base** : elles sont paramétrables dans le JSON.

## 1. Partage des responsabilités

| Géré par l'appli (hôte) | Géré par les joueurs, hors appli |
|---|---|
| Maladie cachée de chaque patient, PV, horloge de l'hôpital et tick d'admission de chaque patient (§5), maladies suspectées et passages restants des analyses (§12) | **Tour de jeu : les joueurs jouent à tour de rôle**, même si plusieurs smartphones sont disponibles dans la partie. L'appli n'impose aucun ordre de jeu et ne bloque pas deux actions simultanées : c'est aux joueurs de jouer chacun leur tour |
| Diagnostic probabiliste, issue des traitements (guérison, traitement partiel, échec) | Points de victoire, conditions de victoire et de défaite (dont la **fermeture de l'hôpital**, §7.1) |
| Calcul des pièces gagnées et de l'impact sur la réputation, **par action** | Cumul des pièces, de la réputation de l'hôpital et de la réputation personnelle de chaque médecin |
| | Partage des gains (pièces et réputation) entre le joueur et l'hôpital, achats, constructions, réapprovisionnements, formation |
| | Partage ou non des résultats de diagnostic et des recettes entre joueurs (§8.6) |
| | Pioche des cartes patient, nombre de patients en jeu, retour des patients guéris dans la pioche, défausse des patients morts |

L'appli **n'est pas intrusive** : elle gère les maladies et calcule le résultat de chaque action, rien de plus. Les règles hors appli sont décrites dans les [règles de table](REGLES_DE_TABLE.md).

### 1.1 Mise en place

Règle de table, hors appli, détaillée dans les [règles de table §1](REGLES_DE_TABLE.md#1-mise-en-place) : l'hôpital démarre avec la salle de consultation, la pharmacie et la radiologie ; chaque joueur tire au hasard **1 médecin**, et aussi **1 diplôme** à 2 ou 3 joueurs ; on mélange les 12 patients et on en révèle 2. Chaque médecin porte **une seule spécialité**, ou est polyvalent (sans spécialité).

## 2. Entités

### 2.1 Catalogue du paquet de base

| Entité | Nombre | Support |
|---|---|---|
| Médecins | 10 | carte |
| Patients | 12 | carte |
| Objets et diplômes | 24 (19 objets, dont 3 d'aide à la recherche, et 5 diplômes) | carte |
| Salles | 11, dont le laboratoire de recherche | carte |
| Maladies | 103 (20 par spécialité, 23 en médecine générale) | virtuelle (dans le JSON) |
| Spécialités | 5 + extensibles | virtuelle |

Un patient guéri retourne dans la pioche et peut être réadmis avec une nouvelle maladie ; un patient mort est défaussé (§4.2).

Spécialités du paquet de base (`contenu/paquet_base.json`) : `generale` (médecine générale), `cardiologie`, `psychiatrie`, `orthopedie`, `paranormal`.

Deux valeurs sont **réservées** : elles ne se déclarent pas et ne sont jamais la spécialité d'une maladie.

- **`polyvalent`** veut dire « sans spécialité ». Une carte polyvalente (le Dr Moreau, la radiologie, la réanimation…) n'oriente pas le diagnostic. Une carte sans champ `specialite` est aussi polyvalente. `generaliste` est l'ancien nom de cette valeur, encore accepté avec un avertissement.
- **`recherche`** est réservée aux salles : c'est la spécialité du laboratoire de recherche (§12). Elle n'est jamais portée par un médecin, un objet ou un diplôme.

> **Attention** : la **médecine générale** (`generale`) est une spécialité à part entière, avec sa couleur et son icône (🩺). Le Dr Lefort, la salle de consultation et le diplôme de médecine générale orientent donc le diagnostic, comme un cardiologue. Seules les cartes polyvalentes sont neutres.

### 2.2 Cartes

Une carte est une **identité stable** ; elle ne porte aucun état de partie.

- **Médecin** : nom, image, spécialité (ou `polyvalent`), capacités.
- **Patient** : nom, image. Aucune maladie ni PV imprimés : tout est tiré à l'admission.
- **Salle** : nom, image, spécialité (ou `polyvalent`, ou `recherche` pour le laboratoire), capacités (dont la précision de base du diagnostic).
- **Objet** (stéthoscope, livre, médicament, équipement…) : nom, image, spécialité facultative, capacités.
- **Diplôme** : nom, image, spécialité facultative, capacités. Un diplôme se joue **comme un accessoire** dans la combinaison : c'est sa présence qui compte.

> **Diplôme — ce qu'il compte dans une recette.** Un diplôme de spécialité X, joué comme accessoire :
>
> 1. **compte comme un médecin X** quand la recette demande un médecin **de cette spécialité** : avec le diplôme de médecine générale, toute combinaison compte « un médecin de médecine générale ». C'est voulu : un médecin polyvalent muni d'un diplôme remplace un spécialiste, ce qui évite qu'un joueur seul à détenir une spécialité fasse la loi.
>    Quand la recette exige **deux médecins** d'une spécialité, il faut **deux vrais médecins** : deux spécialistes, ou un spécialiste et un autre médecin muni du diplôme. Le diplôme seul ne remplace pas le second médecin.
> 2. **ne compte pas comme un médecin** quand la recette demande un médecin **sans préciser la spécialité** (« 2 médecins ») ou une autre spécialité.
> 3. **compte aussi dans les exclusions** : une recette « sans médecin X » est refusée si le diplôme X est présent.
>
> Le diplôme ajoute en outre sa spécialité à celles de la combinaison, qui orientent le diagnostic (§3.3). Syntaxe : [MOTEUR_EFFETS.md §5](MOTEUR_EFFETS.md#5-prédicats).

Les éventuelles restrictions d'achat (« objet réservé aux détenteurs de tel diplôme ») sont des **règles de table**, invisibles pour l'appli.

### 2.3 Maladies

Chaque maladie définit :

| Champ | Rôle | Exemple |
|---|---|---|
| `specialite` | Spécialité de la maladie (jamais `polyvalent` ni `recherche`) | `orthopedie` |
| `pv_initial` | PV à l'admission (entier > 0) | `10` |
| `aggravation` | PV perdus à chaque diagnostic, analyse ou échec de traitement, selon le palier de présence du patient (§5.2) : 1ʳᵉ valeur au palier 1, la dernière se répète | `[1, 2, 2, 3]` |
| `attente_max` | Attente maximale, en ticks de présence : au-delà, chaque action sur le patient coûte de la réputation (§5.3). Par défaut, `parametres.attente_max_defaut` | `12` |
| `poids` | Probabilité relative d'être tirée à l'admission : entier **≥ 1** (défaut 1). Une maladie présente dans le paquet doit pouvoir sortir ; pour l'écarter, on la retire du paquet | `1` |
| `traitement.adapte` | Prédicat sur la combinaison : traitement qui **guérit** | voir §6 |
| `traitement.partiel` | Prédicat facultatif : traitement qui **stabilise** (gain de PV, sans guérison ni aggravation) | voir §6 |
| `recompenses` | Pièces et réputation propres à la maladie (sinon valeurs globales) | voir §7 |

Dans le paquet de base, chaque spécialité suit le **même gabarit de gravité** : 4 paliers (A : bénin, B : modéré, C : sérieux, D : grave), avec les mêmes PV initiaux (de 6 à 16), la même aggravation, la même attente maximale, les mêmes poids et les mêmes récompenses d'une spécialité à l'autre. Les PV restent affichés : ils renseignent sur la gravité, **pas sur la spécialité** — aucune valeur de PV n'appartient à plus de 25 % à une même spécialité.

## 3. Combinaisons

### 3.1 Motifs reconnus

| Motif | Cartes | Actions proposées |
|---|---|---|
| **Admission** | 1 patient, seul | `admettre` (si le patient n'est pas en jeu) |
| **Standard** | 1 médecin + 1 patient + 1 salle, plus au choix 0 ou 1 second médecin et 0 ou 1 accessoire (objet ou diplôme) : 3 à 5 cartes | `diagnostiquer`, `traiter` — **hors laboratoire** |
| **Recherche** | 1 médecin + 1 patient + 1 salle + 0 ou 1 accessoire (objet ou diplôme) : 3 ou 4 cartes | `analyser` (§12) — **au laboratoire seulement** |

Toute autre sélection est **refusée avec un message explicite** indiquant ce qui manque ou ce qui est en trop (« Il faut une carte salle », « Une seule carte patient par action », « 2 cartes médecin au maximum »). Une même carte détectée deux fois ne compte qu'une fois.

Une même sélection peut correspondre à plusieurs motifs : médecin + patient + salle correspond à la fois à `standard` et à `recherche`. L'appli **réunit alors les actions** de tous les motifs reconnus, puis ne garde que celles dont la précondition est vérifiée. Ce sont les préconditions qui rendent le laboratoire exclusif : **le laboratoire ne permet que d'analyser, et les autres salles ne permettent pas d'analyser**. Si aucune action ne reste, la sélection est refusée : « Aucune action possible avec ces cartes. » quand les cartes sont en cause, ou un message sur le patient quand c'est son état (« Mme Garnier n'est pas en jeu. », « Aucune piste pour Mme Garnier : faire d'abord un diagnostic. »).

### 3.2 Choix de l'action

Hors laboratoire, une combinaison standard permet deux actions ; au laboratoire, seule l'analyse est possible. L'écran de confirmation propose **un bouton par action possible** (« Diagnostiquer », « Traiter », « Analyser »), chacun avec sa phrase d'aperçu, plus « Annuler ». Le joueur annonce son intention en choisissant le bouton.

### 3.3 Spécialités et capacités d'une combinaison

- **Spécialités de la combinaison** `S(C)` : l'ensemble des spécialités portées par les médecins, la salle et l'accessoire, hors valeurs réservées (`polyvalent`, `recherche`). La médecine générale (`generale`) y compte comme toute spécialité.
- **Capacité totale** : la somme, pour chaque capacité, des valeurs portées par toutes les cartes de la combinaison sauf le patient.

## 4. Cycle de vie d'un patient

```
            admettre                diagnostiquer / analyser / traiter (échec ou partiel)
 [hors jeu] ────────► [en jeu] ◄──────────────────────────────┐
     ▲                   │  └─────────────────────────────────┘
     │                   ├── traiter (adapté) ───► [guéri] ──┐
     │                   └── PV ≤ 0 ─────────────► [mort] ──► carte défaussée, hors de la partie
     └────────── la carte retourne dans la pioche ◄──────────┘   (« sorti » = guéri ou mort)
```

### 4.1 Admission

Un patient entre en jeu quand un joueur pioche sa carte, **hors jeu**, la **scanne seule**, puis confirme l'action « Admettre ».

1. L'hôte tire une maladie au hasard parmi celles du paquet actif, pondérée par `poids`. Le tirage est **indépendant de la carte**.
2. `PV ← maladie.pv_initial` ; l'hôte note le tick d'admission (l'horloge, elle, n'avance pas).
3. Le résultat affiche : « Admission de M. Dupont — 10 PV ». La maladie n'est **pas** affichée.

Scanner seul un patient déjà en jeu ne déclenche rien (« M. Dupont est déjà en jeu »). L'appli ne révèle aucune autre information.

### 4.2 Sortie

Un patient guéri ou mort passe à l'état **sorti** : sa maladie est révélée dans le résultat (« Guérison de M. Dupont — fracture fermée », « Décès de Mme Garnier — arythmie »). Règle de table :

- la carte d'un patient **guéri** retourne dans la pioche ; si elle est de nouveau piochée et scannée seule, elle est **réadmise avec une nouvelle maladie** ;
- la carte d'un patient **mort** est **défaussée** : elle sort de la partie. Une combinaison contenant un patient hors jeu (jamais admis ou sorti) est refusée (« M. Dupont n'est pas en jeu »).

Les messages évitent tout accord, qui deviendrait fautif selon la personne : style nominal (« Admission de… », « Guérison de… », « Décès de… ») et « n'est pas en jeu » plutôt que « n'est pas admis », qui deviendrait fautif pour Mme Garnier.

## 5. Horloge et aggravation

### 5.1 Horloge de l'hôpital

L'hôte tient une **horloge commune** à toute la partie, comptée en **ticks** :

- chaque action **confirmée** de diagnostic, de traitement ou d'analyse fait avancer l'horloge d'**un tick**, quel que soit le patient ;
- l'admission ne fait pas avancer l'horloge ; les sélections annulées, refusées ou non confirmées non plus ;
- l'hôte note le **tick d'admission** de chaque patient. Sa **durée de présence** est le nombre de ticks écoulés depuis : tick courant − tick d'admission.

Un patient vieillit donc avec l'hôpital, même quand personne ne s'occupe de lui.

### 5.2 Paliers d'aggravation

L'aggravation dépend de la **durée de présence**, par **paliers communs à toutes les maladies** (`parametres.paliers_aggravation`, défaut `[5, 11, 17, 23]`) :

| Durée de présence | Palier | Perte de PV par action sur le patient |
|---|---|---|
| 0 à 4 ticks | stable | aucune |
| 5 à 10 ticks | 1 (aggravation légère) | 1ʳᵉ valeur de `aggravation` |
| 11 à 16 ticks | 2 | 2ᵉ valeur |
| 17 à 22 ticks | 3 | 3ᵉ valeur |
| 23 ticks et plus | 4 | 4ᵉ valeur |

La **perte est propre à chaque maladie** : c'est sa liste `aggravation`, dont la dernière valeur se répète pour les paliers suivants. Avec `[1, 2, 2, 3]`, une fracture ouverte perd 1 PV par action au palier 1, 2 aux paliers 2 et 3, 3 ensuite. Le bonus de difficulté `pv_perdus` s'applique (§10).

**Quand** : la perte du palier atteint est appliquée **à chaque action sur ce patient** — diagnostic, analyse ou échec de traitement —, et seulement à ce moment-là. **Ni la guérison ni le traitement partiel n'aggravent le patient.**

**Pas de rattrapage** : un patient délaissé ne perd rien tant qu'on n'agit pas sur lui. Quand on le reprend en charge, il ne subit que la perte de son palier, une seule fois, et non la somme des ticks manqués. C'est un écart volontaire à la réalité : il évite que l'appli intervienne dans le déroulé du jeu. La pression vient de la montée des paliers et de l'attente maximale.

Exemple : un patient admis au tick 3, diagnostiqué au tick 6 (présence 3) ne perd rien ; laissé de côté jusqu'au tick 12, il ne perd rien entre-temps ; un traitement raté au tick 12 (présence 9) lui coûte la perte de l'échec plus la 1ʳᵉ valeur de son aggravation.

### 5.3 Attente dépassée

L'attente maximale `attente_max` d'une maladie se compte aussi en **ticks de présence** (défaut : `parametres.attente_max_defaut`, 15 ticks). Quand la durée de présence la dépasse, chaque action sur ce patient, **même celle qui le guérit**, coûte `reputation_attente` en réputation (défaut : −1), avec le bonus de difficulté `reputation` (§10). Exemple : avec une attente maximale de 12, la première action pénalisée est celle qui a lieu au 13ᵉ tick de présence ou plus tard. L'attente maximale dépend de la maladie et reste donc cachée ; le résultat signale le dépassement.

### 5.4 Mort

Si les PV tombent à 0 ou moins à la fin d'une action, le patient meurt (`PV` affichés = 0). Un traitement adapté l'emporte toujours : un patient guéri ne subit pas d'aggravation lors de cette action.

## 6. Traitement

L'issue d'une action `traiter` est évaluée dans l'ordre :

1. la combinaison satisfait `traitement.adapte` → **adapté** : le patient est **guéri** ;
2. sinon, elle satisfait `traitement.partiel` (s'il existe) → **partiel** : le patient gagne `pv_partiel` PV (défaut 2) plus la capacité `stabilisation` de la combinaison, sans dépasser `pv_initial`. Il n'est pas guéri, mais il est **stabilisé** : il ne subit pas d'aggravation lors de cette action ;
3. sinon → **échec** : le patient perd `pv_echec` PV (défaut 2), puis subit l'aggravation, et l'hôpital perd de la réputation.

Les prédicats de traitement portent sur les cartes de la combinaison : présence d'une carte précise, nombre de cartes d'un type de carte et d'une spécialité donnés, spécialité de la salle… (syntaxe : [MOTEUR_EFFETS.md §5](MOTEUR_EFFETS.md#5-prédicats)). Ils expriment typiquement :

Dans le paquet de base, les maladies de chaque spécialité sont réparties en **5 à 7 familles de traitements**, de 2 à 6 maladies chacune. Chaque recette prend l'une de ces formes :

- **un spécialiste dans une salle** (un psychiatre en salle de psychiatrie, un cardiologue en réanimation) — un médecin muni du diplôme convient aussi ;
- **un objet dans une salle**, quel que soit le médecin (l'électrocardiographe en salle de cardiologie, le plâtre à la plâtrerie, un médicament en consultation ou à la pharmacie) ;
- **deux médecins** dont un ou deux spécialistes, au bloc opératoire ou en réanimation.

Une recette n'exige jamais à la fois un spécialiste et un objet : la place d'accessoire étant unique, un médecin polyvalent muni d'un diplôme ne pourrait pas la suivre. Aucune combinaison ne soigne plus de 35 % des maladies d'une spécialité : connaître la spécialité ne suffit plus, il faut trouver la famille.

Exemples :

| Maladie (spécialité) | Traitement adapté | Traitement partiel |
|---|---|---|
| Angine bactérienne (médecine générale) | l'antibiotique, en consultation ou à la pharmacie | un médecin ou le diplôme de médecine générale, ou la salle de consultation |
| Fracture ouverte (orthopédie) | 2 médecins au bloc opératoire : 2 orthopédistes, ou 1 orthopédiste et 1 médecin muni du diplôme d'orthopédie | 1 orthopédiste à la plâtrerie |
| Burn-out (psychiatrie) | un psychiatre (ou un médecin muni du diplôme) en salle de psychiatrie | un psychiatre ailleurs |
| Arythmie (cardiologie) | l'électrocardiographe en salle de cardiologie | un cardiologue ailleurs |

Un diplôme de spécialité X compte comme un médecin X dans ces recettes : voir l'encadré « Diplôme » (§2.2).

Les traitements sont **secrets** : le livret ne donne pas la correspondance entre maladies et traitements. Les joueurs la découvrent par des essais ou au laboratoire (§12, [règles de table §9](REGLES_DE_TABLE.md#9-traitements-secrets)).

Le validateur de paquet vérifie que **chaque maladie a au moins un traitement adapté réalisable** avec les cartes du catalogue, hors laboratoire (on ne traite pas au laboratoire). Il avertit si un traitement adapté est satisfait par toutes les combinaisons, ou si aucune combinaison ne mène à un échec.

Le laboratoire de recherche (§12) révèle ce traitement sous forme de **recette lisible**, générée depuis le prédicat `adapte`.

## 7. Récompenses

Tous les montants sont des **entiers**. La difficulté leur ajoute un bonus entier (§10) ; un montant nul reste nul, et un montant non nul vaut au moins 1 en valeur absolue. **Aucune pièce n'est gagnée par une action pendant laquelle le patient meurt.**

| Événement | Pièces (acteur) | Réputation |
|---|---|---|
| Admission | 0 | 0 |
| Diagnostic | `pieces_diagnostic` (défaut 1) | 0 |
| Traitement adapté (guéri) | `pieces_traitement` (défaut 3) | `reputation_guerison` (défaut +2) |
| Traitement partiel | `pieces_partiel` (défaut 1) | 0 |
| Échec du traitement | 0 | `reputation_echec` (défaut −1) |
| Attente dépassée (par action) | — | `reputation_attente` (défaut −1) |
| Mort du patient | 0 (aucune pièce pour l'action) | `reputation_mort` (défaut −3) |

Chaque maladie peut surcharger ces valeurs (les maladies graves paient plus). Le résultat rappelle que l'acteur décide, hors appli, de ses gains ([règles de table §3](REGLES_DE_TABLE.md#3-pièces-réputation-et-points-de-victoire)) : ses pièces (les garder, les donner au budget de l'hôpital ou les verser à une construction ou à un réapprovisionnement) et la réputation gagnée (la garder pour son médecin ou la laisser à l'hôpital).

### 7.1 Réputation et fermeture de l'hôpital

La réputation de l'hôpital est une **jauge collective** tenue à la main par les joueurs (piste sur le plateau) :

- elle démarre à une **valeur de départ** fixée par les règles du jeu physique ;
- chaque résultat d'action indique l'impact à reporter sur la piste ;
- si elle devient **strictement inférieure au seuil de fermeture**, l'hôpital ferme : la partie s'arrête et **tous les joueurs ont perdu**.

C'est le seul enjeu coopératif du jeu : chaque médecin joue pour ses propres points de victoire (sa réputation personnelle et ses pièces, [règles de table §3](REGLES_DE_TABLE.md#3-pièces-réputation-et-points-de-victoire)), mais un patient négligé, mal traité ou qui meurt pénalise tout le monde.

L'appli ne connaît ni la valeur de départ, ni le seuil, ni le total : elle n'annonce donc pas la fermeture. Ces deux valeurs sont des règles de table, à fixer avec le simulateur de la [feuille de route](FEUILLE_DE_ROUTE.md) (phase 1) selon les montants de réputation du paquet et le niveau de difficulté.

## 8. Diagnostic probabiliste

### 8.1 Principe

Un diagnostic produit une **liste des 5 maladies les plus suspectes**. Chaque maladie y figure avec :

- un **indice de suspicion**, de 0 à 99, affiché sans signe « % » ;
- la **couleur et l'icône de sa spécialité** ([MOTEUR_EFFETS.md §2.3](MOTEUR_EFFETS.md#23-spécialités)).

La liste est **tirée à nouveau à chaque diagnostic** : deux diagnostics successifs donnent en général des listes différentes. Elle **peut être fausse** : la maladie en tête n'est pas toujours la bonne, et la bonne peut ne pas figurer dans la liste. Les diagnostics répétés orientent les joueurs, mais chacun fait avancer l'horloge de l'hôpital.

Exemple, alors que la maladie est une fracture fermée :

> 🦴 Entorse de la cheville 64 — 🦴 Fracture fermée 61 — 🧠 Phobie des escaliers 55 — 🩺 Torticolis 48 — 🦴 Lumbago 44

**Lecture de la liste** :

- **L'indice de suspicion n'est pas une probabilité.** Les indices sont indépendants et ne somment pas à 100. Mesuré sur le paquet de base, une maladie affichée entre 60 et 69 n'est la bonne qu'environ **une fois sur dix**. Table de lecture :

  | Indice | Lecture | La maladie est la bonne… |
  |---|---|---|
  | moins de 70 | piste faible | au plus 1 fois sur 10 |
  | 70 à 79 | piste sérieuse | environ 3 fois sur 10 |
  | 80 à 89 | piste forte | environ 3 fois sur 4 |
  | 90 et plus | quasi sûr | presque toujours |

  Une liste où toutes les maladies sont entre 40 et 60 est un diagnostic flou, proche du bruit pur.
- **Les couleurs donnent une piste de spécialité** : la **couleur dominante** est la couleur la plus présente dans la liste (« 3 bleus sur 5 ») ; en cas d'égalité, celle qui est la mieux classée. Le joueur est alors poussé à refaire un diagnostic avec une carte de cette spécialité, pour confirmer la piste (concordance) ou l'écarter (exclusion).
- **Presque aucun signal n'est certain** : la liste a toujours la même forme, quelle que soit la combinaison, et rien dans sa présence ou sa composition ne prouve la spécialité. Seule une tête de liste à 95 ou plus est presque toujours juste (§8.4). C'est ce qui distingue ce diagnostic de la version précédente, où l'apparition d'une liste de noms révélait la spécialité avec certitude.

### 8.2 Niveau de précision

```
N = min(precision_max, max(0, somme des capacités « precision » des cartes de la combinaison))
```

La salle apporte l'essentiel de la précision : de 0 (pharmacie, plâtrerie) à 3 (radiologie) dans le paquet de base, 1 pour la plupart des salles. Les médecins et accessoires l'augmentent (stéthoscope +1, traité de médecine +2…). Défaut : `precision_max = 4`.

### 8.3 Calcul de la liste

Notations : `n` maladies dans le paquet, `S` spécialités qui sont la spécialité d'au moins une maladie, `n_s` maladies de spécialité `s`, et `n̄ = n / S` le nombre moyen de maladies par spécialité.

Pour chaque maladie `m` du paquet, de spécialité `s` :

1. **Bruit corrigé** : `w(m) ← −ln(1 − u^(n_s / n̄))`, où `u` est tiré uniformément dans `[0, 1[`. Pour `n_s = n̄`, c'est une loi exponentielle de paramètre 1. La correction donne au maximum des maladies de chaque spécialité la même loi que s'il y avait `n̄` maladies dans chacune. Sans indice, chaque spécialité a donc **la même chance** d'avoir la maladie en tête, quel que soit son nombre de maladies. Sans correction, une spécialité de 60 maladies face à deux de 25 et 15 serait en tête 60 % du temps ; avec la correction, chacune l'est un tiers du temps.
   **Pondération par le poids** : `w(m) ← w(m) × (poids(m) / poids moyen)^ponderation_poids`. Les maladies fréquentes apparaissent un peu plus souvent dans les listes, qui reflètent ainsi légèrement la fréquence réelle des maladies.
2. **Affinité de la vraie spécialité** : si `s` est la spécialité de la vraie maladie, `w(m) ← w(m) × (1 + affinite_specialite)`. Toutes les maladies de la vraie spécialité sont légèrement favorisées : c'est ce qui fait ressortir sa couleur.
3. **Vraie maladie** : `w(m) ← w(m) × (1 + verite + par_niveau × N)`.
4. **Spécialités de la combinaison**, si `s ∈ S(C)` :
   - **concordance** (`s` est la vraie spécialité) : `w(m) ← w(m) × (1 + bonus_specialite)` ;
   - **exclusion** (`s` n'est pas la vraie spécialité) : `w(m) ← w(m) × exclusion`. Les maladies de la spécialité testée reculent dans la liste, sans disparaître.

   Ces deux facteurs s'appliquent à **toutes** les maladies de la spécialité. Ils doivent rester modérés : dans une liste de 5 tirée parmi une centaine de maladies, un facteur appliqué à une vingtaine de maladies pèse beaucoup plus qu'un facteur appliqué à une seule. Avec un bonus ×3, la couleur dominante serait juste dans 100 % des cas, et la certitude reviendrait.
5. **Liste** : les maladies sont triées par `w` décroissant ; les `taille_liste` premières sont affichées.
6. **Indice de suspicion** : `i(m) = 100 × (1 − e^(−k · w(m) / H))`, arrondi à l'entier et plafonné à 99 : un diagnostic n'affiche jamais de certitude. `H = ψ(n̄ + 1) + γ` est le maximum attendu du bruit seul, soit environ `ln n̄ + 0,58` (nombre harmonique pour `n̄` entier). `k = −ln(1 − score_bruit / 100)`. Une maladie dont le poids égale ce maximum attendu affiche donc l'indice `score_bruit`.

Valeurs par défaut :

| Paramètre | Défaut | Rôle |
|---|---|---|
| `precision_max` | 4 | Plafond du niveau de précision N |
| `verite` | 3,0 | Bonus de base de la vraie maladie |
| `par_niveau` | 0,8 | Bonus de la vraie maladie par niveau de précision |
| `affinite_specialite` | 0,2 | Bonus de toutes les maladies de la vraie spécialité |
| `bonus_specialite` | 0,3 | Bonus des maladies de la vraie spécialité si elle est dans la combinaison |
| `exclusion` | 0,75 | Facteur des maladies d'une spécialité de la combinaison qui n'est pas la vraie |
| `taille_liste` | 5 | Nombre de maladies affichées |
| `score_bruit` | 50 | Indice d'une maladie au niveau du maximum attendu du bruit |
| `ponderation_poids` | 0,25 | Exposant de la pondération du bruit par le poids de la maladie (0 : aucune) |

### 8.4 Comportement attendu

Sur le paquet de base (103 maladies sur 5 spécialités), pour une maladie de cardiologie, sur 20 000 tirages :

| Combinaison | N | Vraie maladie en tête | Vraie maladie dans la liste | 1ʳᵉ couleur juste | Couleur dominante juste | Indice de la tête : juste / fausse |
|---|---|---:|---:|---:|---:|---:|
| Aucune spécialité (Dr Moreau à la pharmacie) | 1 | 40 % | 58 % | 61 % | 56 % | 82 / 65 |
| Aucune spécialité (Dr Moreau en radiologie) | 4 | 55 % | 70 % | 70 % | 62 % | 86 / 65 |
| Spécialité concordante (Dr Benali en salle de cardiologie) | 1 | 45 % | 64 % | 78 % | 81 % | 86 / 70 |
| Spécialité concordante (Dr Benali en radiologie, stéthoscope) | 4 | 59 % | 75 % | 84 % | 83 % | 89 / 70 |
| Spécialité discordante (Dr Sauvage en salle de psychiatrie) | 1 | 41 % | 60 % | 64 % | 61 % | 81 / 64 |

- La **couleur dominante** est la couleur la plus présente dans la liste ; en cas d'égalité, la mieux classée.
- **Bruit seul** (aucun bonus, catalogue de 100 maladies sur 3 spécialités) : les 5 lignes affichent en moyenne 57, 50, 46, 43 et 41. Un diagnostic flou ressemble à cela.
- **L'indice informe** : quand la tête est juste, elle affiche en moyenne 81 à 89 ; quand elle est fausse, 64 à 70. Un joueur apprend vite qu'une tête à 95 est presque sûre et qu'une tête à 60 ne prouve rien.
- **Les têtes très hautes sont rares, mais presque toujours justes.** À précision maximale sans spécialité (N = 4), 18 % des diagnostics ont une tête à 95 ou plus, fausse dans 0,03 % des cas seulement ; 26 % ont une tête à 90 ou plus, fausse dans 0,6 % des cas. Le passage de `precision_max` de 5 à 4 et de `par_niveau` de 1,5 à 0,8 a divisé par deux la part de ces quasi-certitudes (33 % des diagnostics à 95 ou plus auparavant) ; leur fiabilité, elle, ne change pas, car un indice aussi haut n'est presque jamais atteint par le bruit seul.
- **La bonne spécialité est récompensée** : avec elle, la couleur dominante est juste environ 8 fois sur 10, contre 6 sur 10 sans spécialité.
- **La mauvaise spécialité n'est pas éliminée d'un coup** : ses maladies reculent, ce qui améliore un peu la lecture des autres couleurs, mais une seule exclusion ne prouve rien.

Ces valeurs sont vérifiées par les tests du moteur (`packages/moteur/test/diagnostic_test.dart`), à 2 points près.

### 8.5 Réglage

Ces paramètres sont dans le JSON (`parametres.diagnostic`). Leur réglage se fait avec le **simulateur** de la phase 1 de la [feuille de route](FEUILLE_DE_ROUTE.md), qui remplace en partie un prototype papier ; rapport de référence du paquet de base : [simulations/rapport_paquet_base.md](simulations/rapport_paquet_base.md). Les valeurs par défaut sont calées pour une centaine de maladies : sur un petit paquet (6 maladies dans l'exemple), la vraie maladie ressort presque toujours, et le diagnostic est trop facile.

### 8.6 Partage des diagnostics entre joueurs

Chaque résultat de diagnostic n'apparaît que sur le téléphone du joueur qui a agi : les joueurs peuvent **partager leurs résultats de diagnostic ou les garder pour eux**. Ce n'est pas un jeu de bluff : on peut se taire, mais mentir ne fait pas partie du comportement attendu ([règles de table §8](REGLES_DE_TABLE.md#8-partager-linformation)). Mettre en commun les listes oriente tous les joueurs ; ne rien mettre en commun laisse chacun agir dans le brouillard, au prix de patients qui s'aggravent et d'une réputation qui fond (§7.1).

Les probabilités du diagnostic (§8.3) doivent être calculées et réglées — avec le simulateur, qui devra comporter une stratégie « sans partage » où chaque joueur ne voit que ses propres diagnostics — pour que si les joueurs ne mettent **rien en commun**, la défaite commune (réputation de l'hôpital sous le seuil de fermeture, §7.1) soit **quasi inévitable**.

État mesuré au simulateur, à 3 joueurs ([plan de codage §5.4](PLAN_DE_CODAGE.md#54-premiers-constats-du-simulateur)) : pour des joueurs **vétérans**, qui connaissent les traitements, le partage ne change pas le taux de guérison ; pour des **novices** sans laboratoire, il le fait passer de 28 à 34 % en Interne, sans empêcher l'hôpital de fermer. Avec le **laboratoire** (§12), un novice soigne presque autant qu'un vétéran, et l'hôpital tient même sans partage. L'objectif n'est donc pas atteint : le laboratoire est le levier principal à régler (coût d'une analyse, nombre de passages, accès au laboratoire).

## 9. Ordre de résolution d'une action

Pour `diagnostiquer`, `traiter` et `analyser`, l'ordre par défaut est le suivant (il est écrit explicitement dans le JSON, voir [MOTEUR_EFFETS.md §6.1](MOTEUR_EFFETS.md#61-actions-du-paquet-de-base)) :

1. l'horloge avance d'un tick ;
2. effet propre à l'action (diagnostic, analyse, ou issue du traitement avec ses PV, pièces et réputation) ;
3. si le patient n'est ni guéri ni stabilisé par un traitement partiel : perte du palier de présence atteint (§5.2) ;
4. si la durée de présence dépasse `attente_max` : pénalité d'attente ;
5. si `PV ≤ 0` et que le patient n'est pas guéri : mort et pénalité de mort ;
6. si le patient est sorti : révélation de la maladie.

## 10. Difficulté

Trois niveaux, choisis au lancement de la partie. Chacun ajoute un **bonus entier** à certains montants : il s'ajoute à leur valeur absolue, si bien que chaque niveau est un cran plus dur que le précédent sur **chaque** ligne.

| Niveau | `pv_perdus` | `pieces` | `reputation` |
|---|---:|---:|---:|
| Interne | +0 | +0 | +0 |
| Chirurgien | +1 | +1 | +1 |
| Réanimation | +2 | +2 | +2 |

- `pv_perdus` s'applique aux **pertes** de PV (aggravation, échec de traitement), pas aux gains.
- `pieces` s'applique à tous les **gains** de pièces.
- `reputation` s'applique aux **pertes** de réputation seulement : les gains ne changent pas d'un niveau à l'autre.
- Un montant nul reste nul (un patient stable ne perd rien, quel que soit le niveau). Un montant non nul reste au moins égal à 1 en valeur absolue, même si un paquet utilise un bonus négatif pour un niveau plus facile.

**Valeurs effectives** du paquet de base :

| Montant | Base | Interne | Chirurgien | Réanimation |
|---|---:|---:|---:|---:|
| Perte de PV : aggravation (selon la maladie et le palier) | 1 | 1 | 2 | 3 |
| | 2 | 2 | 3 | 4 |
| | 3 | 3 | 4 | 5 |
| | 4 | 4 | 5 | 6 |
| Perte de PV : échec du traitement (`pv_echec`) | 2 | 2 | 3 | 4 |
| Pièces : diagnostic, traitement partiel | 1 | 1 | 2 | 3 |
| Pièces : guérison (selon la maladie) | 3 | 3 | 4 | 5 |
| | 4 | 4 | 5 | 6 |
| | 5 | 5 | 6 | 7 |
| Réputation : guérison | +2 | +2 | +2 | +2 |
| Réputation : échec, attente dépassée | −1 | −1 | −2 | −3 |
| Réputation : échec (maladies graves) | −2 | −2 | −3 | −4 |
| Réputation : mort | −3 | −3 | −4 | −5 |

## 11. Contenu d'un résultat

| Élément | Admission | Diagnostic | Traitement | Analyse (§12) |
|---|---|---|---|---|
| PV avant → après (delta) | PV initiaux | oui | oui | oui |
| Durée de présence / attente dépassée | — | oui | oui | oui |
| Liste des 5 maladies (indice de suspicion, couleur, icône) | — | oui | — | — |
| Liste des maladies suspectées | — | — | — | oui (proposées) |
| Maladie choisie pour l'analyse | — | — | — | oui |
| Passages restants / recette révélée | — | — | — | oui |
| Issue : en jeu / guéri / mort | — | oui | oui | oui |
| Maladie révélée | — | si mort | si guéri ou mort | si mort |
| Pièces gagnées | — | oui | oui | non (0) |
| Impact réputation | — | oui | oui | oui |

### 11.1 Format du résultat

Le moteur renvoie le résultat sous la forme d'un objet JSON, qui est aussi le contenu du message `resultat` du protocole ([SPECIFICATION.md §3.3](SPECIFICATION.md#33-protocole)). Code : `packages/moteur/lib/moteur/resultat.dart`.

| Clé | Type | Contenu |
|---|---|---|
| `numero` | entier | Numéro d'ordre de l'action dans la partie (à partir de 1) |
| `action`, `libelle` | texte | Identifiant et libellé de l'action appliquée |
| `phrase` | texte | Phrase de l'aperçu |
| `cartes` | liste de textes | Cartes de la combinaison, dans l'ordre de sélection |
| `patient`, `patient_nom` | texte | Carte patient et son nom affiché |
| `pv_avant` | entier ou `null` | PV avant l'action ; `null` pour une admission |
| `pv_apres` | entier | PV après l'action (PV initiaux pour une admission) |
| `presence` | entier | Durée de présence du patient après l'action, en ticks (0 pour une admission) |
| `attente_depassee` | booléen | `presence > attente_max` |
| `issue` | `en_jeu`, `gueri` ou `mort` | Issue pour le patient |
| `diagnostic` | objet ou `null` | `niveau` (N) et `maladies` : liste de `{id, nom, indice, specialite}` triée par indice de suspicion décroissant, où `specialite` vaut `{id, nom, couleur, icone}`. La couleur et l'icône sont recopiées dans le résultat, pour qu'un client puisse afficher la liste sans connaître le paquet actif de l'hôte |
| `analyse` | objet ou `null` | Pour une analyse (§12) : `maladie` (la maladie choisie, `{id, nom, specialite}`), `passages_restants` (0 : recette révélée) et `recette` (texte, ou `null` tant que des passages restent) |
| `maladie_revelee` | `{id, nom}` ou `null` | Maladie, si le patient est sorti |
| `pieces` | entier | Pièces gagnées par l'acteur, bonus de difficulté compris (0 si le patient meurt) |
| `reputation` | entier signé | Impact total sur la réputation (soin, échec, attente et mort cumulés) |

## 12. Recherche en laboratoire

### 12.1 Principe

Une salle de spécialité `recherche` — le **laboratoire** — permet d'analyser une maladie suspectée pour découvrir son traitement. L'analyse se déroule en un ou plusieurs **passages** : une maladie compliquée exige plusieurs passages avant de révéler sa **recette**.

### 12.2 Maladies suspectées

L'hôte mémorise, pour chaque patient en jeu, l'ensemble des maladies qui ont figuré dans les listes affichées lors de ses diagnostics précédents (§8), dans l'ordre de leur première apparition : ce sont ses **maladies suspectées**. La liste est remise à zéro à chaque admission (le patient revient avec une nouvelle maladie). Chaque diagnostic affichant 5 maladies, un patient diagnostiqué au moins une fois a toujours des maladies suspectées. Si le patient n'a encore jamais été diagnostiqué, l'action `analyser` n'est pas proposée : la sélection est refusée (« Aucune piste pour Mme Garnier : faire d'abord un diagnostic. »), sans rien coûter ni faire avancer l'horloge.

### 12.3 Déroulement d'un passage

1. Le joueur scanne 1 médecin + 1 patient + le laboratoire, avec éventuellement un accessoire (objet ou diplôme, §12.6), puis confirme « Analyser ».
2. L'appli propose la liste des maladies suspectées du patient ; le joueur en choisit une — même une fausse, l'information reste utile pour toute la partie. On peut choisir une maladie déjà analysée : le résultat s'affiche de nouveau, au coût normal d'un passage.
3. L'hôte retire 1, plus la capacité `recherche` de la combinaison (§12.6), au compteur de **passages restants** de cette maladie, sans descendre sous 0. Ce compteur est **commun à toute la partie** et mémorisé par maladie : les passages de tous les joueurs s'additionnent, et une recette découverte l'est pour tous les patients.
4. Tant que des passages restent : « Analyse en cours — X passage(s) restant(s) ».
5. Quand le compteur atteint 0, l'hôte révèle la **recette complète** du traitement adapté : la description des cartes requises, rédigée depuis le prédicat `traitement.adapte` (code : `packages/moteur/lib/moteur/recette.dart`). Exemples tirés du paquet de base :
   - « L'antibiotique, dans la salle de consultation ou à la pharmacie. »
   - « 2 médecins, dont un de spécialité Cardiologie (ou muni du diplôme de cette spécialité), au bloc opératoire. »
   - « 2 médecins de spécialité Orthopédie (l'un d'eux peut être remplacé par un médecin muni du diplôme de cette spécialité), au bloc opératoire. »
   - « Un médecin de spécialité Médecine générale (ou muni du diplôme de cette spécialité), dans la salle de consultation, sans aucun objet. »

La recette n'est **pas publique** : comme un diagnostic, elle ne s'affiche que sur le téléphone du joueur qui a analysé, qui la partage ou non. Les autres joueurs la découvrent de toute façon la première fois qu'il l'utilise, en voyant les cartes qu'il joue.

### 12.4 Nombre de passages

Chaque maladie peut définir `recherche.passages` dans le JSON (entier ≥ 1, défaut 1) : nombre de passages en laboratoire nécessaires pour révéler sa recette. Sans le champ, la recette se révèle en un seul passage.

Dans le paquet de base, le nombre de passages suit le palier de gravité de la maladie (§2.3) :

| Palier de gravité | PV initiaux | Passages |
|---|---|---|
| A, B | 6 à 11 | 1 (champ absent) |
| C | 12 à 14 | 2 |
| D | 15 et 16 | 3 |

### 12.5 Coût d'un passage

Un passage en laboratoire est une action sur le patient comme les autres : il fait avancer l'horloge d'un tick, fait subir au patient la perte de son palier de présence et éventuellement la pénalité d'attente dépassée. Il ne rapporte **aucune pièce**. Analyser plusieurs fois fait donc courir le risque de perdre le patient.

### 12.6 Capacité `recherche`

Une carte (médecin, objet ou diplôme) peut porter la capacité `recherche` : chaque point retire un passage de plus au compteur commun de la maladie analysée (§12.3). Un passage reste toujours nécessaire pour révéler une recette. La combinaison de recherche accepte un accessoire pour cela. Le paquet de base contient trois **objets d'aide à la recherche**, sans spécialité :

| Carte | Objet | `recherche` |
|---|---|---|
| OBJ-017 | Microscope | 1 |
| OBJ-018 | Centrifugeuse | 1 |
| OBJ-019 | Séquenceur d'ADN | 2 |

Ce sont des objets permanents ([règles de table §6.1](REGLES_DE_TABLE.md#61-objets-permanents)). Ils peuvent aussi servir d'accessoire dans une combinaison standard, sans effet sur le diagnostic.

### 12.7 Exclusivité du laboratoire

Le laboratoire ne sert **qu'à analyser** : on ne peut ni y diagnostiquer ni y traiter. Inversement, on ne peut analyser **que** dans le laboratoire (carte `SAL-011` dans le paquet de base).

### 12.8 Effet mesuré au simulateur

La stratégie `novice+labo:X` du simulateur joue comme le novice (`novice:X`), mais analyse au laboratoire la maladie en tête de liste dès qu'elle atteint l'indice X et que sa recette lui est inconnue, puis la traite avec la recette révélée ([plan de codage §5.4](PLAN_DE_CODAGE.md#54-premiers-constats-du-simulateur)). Le laboratoire change tout pour lui : en Interne, il soigne 89 % de ses patients, contre 28 % sans laboratoire et 95 à 97 % pour un vétéran ; en Réanimation, 67 %, contre 23 % et 81 à 84 %. Le nombre de passages et les objets d'aide à la recherche pèsent peu : même sans objet, il soigne 87 % en Interne, car une seule analyse, juste après le diagnostic, révèle la recette de la plupart des maladies (paliers A et B). Le simulateur suppose toutefois toutes les salles et toutes les cartes disponibles dès le départ, alors qu'à la table le laboratoire s'achète en cours de partie ([règles de table §1 et §5](REGLES_DE_TABLE.md#5-construire-une-salle)) : son prix de construction est donc un levier d'équilibrage.
