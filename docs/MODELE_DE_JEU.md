# CardHospital — Modèle de jeu

Ce document décrit les **règles calculées par l'application** : entités, cycle de vie d'un patient, diagnostic, traitement, temps, récompenses. Il est indépendant de la technique (voir [SPECIFICATION.md](SPECIFICATION.md)) et du format de fichier (voir [MOTEUR_EFFETS.md](MOTEUR_EFFETS.md)). Les termes sont définis dans le [glossaire](GLOSSAIRE.md).

Toutes les valeurs numériques citées ici sont des **valeurs par défaut du paquet de base** : elles sont paramétrables dans le JSON.

## 1. Partage des responsabilités

| Géré par l'appli (hôte) | Géré par les joueurs, hors appli |
|---|---|
| Maladie cachée de chaque patient, PV, temps du patient, maladies suspectées et passages restants des analyses (§12) | Tour de jeu, ordre des joueurs |
| Diagnostic probabiliste, issue des traitements | Points de victoire, conditions de victoire et de défaite (dont la **fermeture de l'hôpital**, §7.1) |
| Calcul des pièces gagnées et de l'impact sur la réputation, **par action** | Cumul des pièces et de la réputation |
| | Partage des pièces entre le médecin et l'hôpital, achats (salles, objets, diplômes) |
| | Pioche des cartes patient, retour des cartes sorties dans la pioche |

### 1.1 Mise en place

Règle de table, hors appli : **2 à 3 joueurs**. Chaque joueur reçoit au départ **1 carte médecin et 1 carte diplôme**. Chaque médecin porte **une seule spécialité** (ou `generaliste`).

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

Spécialités du paquet de base : `psychologie`, `chirurgie`, `pharmacie`. La valeur `generaliste` peut être portée par une carte (salle généraliste, médecin généraliste) mais **n'est jamais le type d'une maladie**. La valeur `recherche` est **réservée aux salles** (laboratoire de recherche, §12) : elle n'est jamais le type d'une maladie, ni portée par un médecin, un objet ou un diplôme.

### 2.2 Cartes

Une carte est une **identité stable** ; elle ne porte aucun état de partie.

- **Médecin** : nom, image, spécialité (ou `generaliste`), capacités.
- **Patient** : nom, image. Aucune maladie ni PV imprimés : tout est tiré à l'admission.
- **Salle** : nom, image, spécialité (ou `generaliste`), capacités (dont la précision de base du diagnostic).
- **Objet** (stéthoscope, livre, médicament, équipement…) : nom, image, spécialité facultative, capacités.
- **Diplôme** : nom, image, spécialité facultative, capacités. Un diplôme se joue **comme un accessoire** dans la combinaison : c'est sa présence qui compte. Joué comme accessoire, un diplôme de spécialité X a la même conséquence qu'un médecin de spécialité X dans les prédicats `compte` (voir [MOTEUR_EFFETS.md §5](MOTEUR_EFFETS.md#5-prédicats)).

Les éventuelles restrictions d'achat (« objet réservé aux détenteurs de tel diplôme ») sont des **règles de table**, invisibles pour l'appli.

### 2.3 Maladies

Chaque maladie définit :

| Champ | Rôle | Exemple |
|---|---|---|
| `type` | Spécialité de la maladie | `chirurgie` |
| `pv_initial` | PV à l'admission (entier > 0) | `10` |
| `aggravation` | PV perdus par action non curative, selon le temps du patient (la dernière valeur se répète) | `[1, 1, 2, 3]` |
| `attente_max` | Seuil de temps au-delà duquel chaque action coûte de la réputation | `5` |
| `poids` | Probabilité relative d'être tirée à l'admission : entier **≥ 1** (défaut 1). Une maladie présente dans le paquet doit pouvoir sortir ; pour l'écarter, on la retire du paquet | `1` |
| `traitement.adapte` | Prédicat sur la combinaison : traitement qui **soigne** | voir §6 |
| `traitement.partiel` | Prédicat facultatif : traitement qui **stabilise** (gain de PV sans guérison) | voir §6 |
| `recompenses` | Pièces et réputation propres à la maladie (sinon valeurs globales) | voir §7 |

## 3. Combinaisons

### 3.1 Motifs reconnus

| Motif | Cartes | Actions proposées |
|---|---|---|
| **Admission** | 1 patient, seul | `admettre` (si le patient n'est pas en jeu) |
| **Standard** | 1 médecin + 1 patient + 1 salle + 0 ou 1 carte parmi {objet, diplôme, second médecin} | `diagnostiquer`, `traiter` |
| **Recherche** | 1 médecin + 1 patient + 1 salle de spécialité `recherche` | `analyser` (§12) |

Toute autre sélection est **refusée avec un message explicite** indiquant ce qui manque ou ce qui est en trop (« Il faut une carte salle », « Une seule carte patient par action », « 4 cartes maximum »). Une même carte détectée deux fois ne compte qu'une fois. Quand plusieurs motifs correspondent à une même sélection, c'est le **premier motif déclaré dans le JSON** qui l'emporte : le motif `recherche` doit donc être déclaré avant `standard` (médecin + patient + salle correspond aux deux).

### 3.2 Choix de l'action

Une combinaison standard permet deux actions, une combinaison recherche une seule. L'écran de confirmation propose **un bouton par action possible** (« Diagnostiquer », « Traiter », « Analyser »), chacun avec sa phrase d'aperçu, plus « Annuler ». Le joueur annonce son intention en choisissant le bouton.

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

Un patient soigné ou mort passe à l'état **sorti** : sa maladie est révélée dans le résultat (« M. Dupont est guéri de sa péritonite »). La carte retourne dans la pioche ; si elle est de nouveau piochée et scannée seule, elle est **réadmise avec une nouvelle maladie**. Une combinaison standard contenant un patient hors jeu ou sorti est refusée (« M. Dupont n'est pas en jeu »). Les messages évitent tout accord (« n'est pas en jeu » plutôt que « n'est pas admis », qui deviendrait fautif pour Mme Garnier).

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

Dans un prédicat `compte {type: medecin, specialite: X}`, un diplôme de spécialité X joué comme accessoire **compte comme un médecin de spécialité X** (MOTEUR_EFFETS.md §5).

Le validateur de paquet vérifie que **chaque maladie a au moins un traitement adapté réalisable** avec les cartes du catalogue.

Le laboratoire de recherche (§12) révèle ce traitement sous forme de **recette lisible**, générée depuis le prédicat `adapte`.

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

### 7.1 Réputation et fermeture de l'hôpital

La réputation de l'hôpital est une **jauge collective** tenue à la main par les joueurs (piste sur le plateau) :

- elle démarre à une **valeur de départ** fixée par les règles du jeu physique ;
- chaque résultat d'action indique l'impact à reporter sur la piste ;
- si elle tombe **sous le seuil de fermeture**, l'hôpital ferme : la partie s'arrête et **tous les joueurs ont perdu**.

C'est le seul enjeu coopératif du jeu : chaque médecin joue pour ses pièces, mais un patient négligé, mal traité ou qui meurt pénalise tout le monde.

L'appli ne connaît ni la valeur de départ, ni le seuil, ni le total : elle n'annonce donc pas la fermeture. Ces deux valeurs sont des règles de table, à fixer avec le simulateur de la [feuille de route](FEUILLE_DE_ROUTE.md) (phase 1) selon les montants de réputation du paquet et le niveau de difficulté.

## 8. Diagnostic probabiliste

### 8.1 Principe

Un diagnostic produit une **liste des 5 maladies les plus probables**. Chaque maladie y figure avec :

- un **pourcentage de confiance**, de 0 à 99 % ;
- la **couleur et l'icône de sa spécialité** ([MOTEUR_EFFETS.md §2.3](MOTEUR_EFFETS.md#23-spécialités)).

La liste est **retirée à chaque diagnostic** : deux diagnostics successifs donnent des listes différentes. Elle **peut être fausse** : la maladie en tête n'est pas toujours la bonne, et la bonne peut ne pas figurer dans la liste. Les diagnostics répétés orientent les joueurs, mais chacun fait avancer le temps du patient.

Exemple, alors que la maladie est une appendicite :

> 🧠 Phobie des blouses blanches 64 % — ✂️ Appendicite 61 % — ✂️ Fracture ouverte 55 % — 💊 Angine bactérienne 48 % — 🧠 Hypocondrie aiguë 44 %

**Lecture de la liste** :

- **Les pourcentages sont indépendants** et ne somment pas à 100 : chacun mesure la confiance que cette maladie est la bonne. Une liste avec une maladie à 95 % est un diagnostic net. Une liste où toutes les maladies sont entre 40 et 60 % est un diagnostic flou, proche du bruit pur.
- **Les couleurs donnent une piste de spécialité** : quand plusieurs maladies d'une même couleur occupent le haut de la liste, la spécialité est probablement la bonne. Le joueur est alors poussé à refaire un diagnostic avec une carte de cette spécialité, pour confirmer la piste (concordance) ou l'écarter (exclusion).
- **Aucun signal n'est certain** : la liste a toujours la même forme, quelle que soit la combinaison. Rien dans sa présence ou sa composition ne prouve le type ou la maladie. C'est ce qui distingue ce diagnostic de la version précédente, où l'apparition d'une liste de noms révélait le type avec certitude.

### 8.2 Niveau de précision

```
N = min(precision_max, somme des capacités « precision » des cartes de la combinaison)
```

La salle porte la précision de base (salle généraliste : 1). Les médecins et accessoires l'augmentent (livre de médecine +1, scanner IRM +2…). Défaut : `precision_max = 5`.

### 8.3 Calcul de la liste

Notations : `n` maladies dans le paquet, `T` spécialités qui sont le type d'au moins une maladie, `n_t` maladies de type `t`, et `n̄ = n / T` le nombre moyen de maladies par spécialité.

Pour chaque maladie `m` du paquet, de type `t` :

1. **Bruit corrigé** : `w(m) ← −ln(1 − u^(n_t / n̄))`, où `u` est tiré uniformément dans `[0, 1[`. Pour `n_t = n̄`, c'est une loi exponentielle de paramètre 1. La correction donne au maximum des maladies de chaque spécialité la même loi que s'il y avait `n̄` maladies dans chacune. Sans indice, chaque spécialité a donc **la même chance** d'avoir la maladie en tête, quel que soit son nombre de maladies. Sans correction, une spécialité de 60 maladies face à deux de 25 et 15 serait en tête 60 % du temps ; avec la correction, chacune l'est un tiers du temps.
2. **Affinité du vrai type** : si `t` est le vrai type, `w(m) ← w(m) × (1 + affinite_type)`. Toutes les maladies du vrai type sont légèrement favorisées : c'est ce qui fait ressortir sa couleur.
3. **Vraie maladie** : `w(m) ← w(m) × (1 + verite + par_niveau × N)`.
4. **Spécialités de la combinaison**, si `t ∈ S(C)` :
   - **concordance** (`t` est le vrai type) : `w(m) ← w(m) × (1 + bonus_specialite)` ;
   - **exclusion** (`t` n'est pas le vrai type) : `w(m) ← w(m) × exclusion`. Les maladies de la spécialité testée reculent dans la liste, sans disparaître.

   Ces deux facteurs s'appliquent à **toutes** les maladies du type. Ils doivent rester modérés : dans une liste de 5 tirée parmi une centaine de maladies, un facteur appliqué à 33 maladies pèse beaucoup plus qu'un facteur appliqué à un seul type. Avec un bonus ×3, la couleur dominante serait juste dans 100 % des cas, et la certitude reviendrait.
5. **Liste** : les maladies sont triées par `w` décroissant ; les `taille_liste` premières sont affichées.
6. **Pourcentage** : `p(m) = 100 × (1 − e^(−k · w(m) / H))`, arrondi à l'entier et plafonné à 99 % : un diagnostic n'affiche jamais de certitude. `H = ψ(n̄ + 1) + γ` est le maximum attendu du bruit seul, soit environ `ln n̄ + 0,58` (nombre harmonique pour `n̄` entier). `k = −ln(1 − score_bruit / 100)`. Une maladie dont le poids égale ce maximum attendu affiche donc `score_bruit` %.

Valeurs par défaut :

| Paramètre | Défaut | Rôle |
|---|---|---|
| `precision_max` | 5 | Plafond du niveau de précision N |
| `verite` | 3,0 | Bonus de base de la vraie maladie |
| `par_niveau` | 1,5 | Bonus de la vraie maladie par niveau de précision |
| `affinite_type` | 0,2 | Bonus de toutes les maladies du vrai type |
| `bonus_specialite` | 0,3 | Bonus des maladies du vrai type si sa spécialité est dans la combinaison |
| `exclusion` | 0,75 | Facteur des maladies d'une spécialité de la combinaison qui n'est pas le vrai type |
| `taille_liste` | 5 | Nombre de maladies affichées |
| `score_bruit` | 50 | Pourcentage d'une maladie au niveau du maximum attendu du bruit |

### 8.4 Comportement attendu

Sur le catalogue cible (100 maladies sur 3 spécialités), pour une maladie de chirurgie, sur 20 000 tirages :

| Combinaison | N | Vraie maladie en tête | Vraie maladie dans la liste | 1ʳᵉ couleur juste | Couleur dominante juste | Pourcentage de la tête : juste / fausse |
|---|---|---:|---:|---:|---:|---:|
| Aucune spécialité | 1 | 43 % | 60 % | 72 % | 72 % | 80 % / 61 % |
| Aucune spécialité | 4 | 62 % | 75 % | 82 % | 77 % | 86 % / 62 % |
| Spécialité concordante | 1 | 46 % | 64 % | 88 % | 91 % | 85 % / 68 % |
| Spécialité concordante | 4 | 65 % | 78 % | 92 % | 94 % | 90 % / 68 % |
| Spécialité discordante (psy sur chirurgie) | 1 | 44 % | 62 % | 79 % | 80 % | 79 % / 60 % |

- La **couleur dominante** est la spécialité dont les maladies totalisent le plus de pourcentage dans la liste.
- **Bruit seul** (aucun bonus) : les 5 lignes affichent en moyenne 57, 50, 46, 43 et 41 %. Un diagnostic flou ressemble à cela.
- **Le pourcentage informe** : quand la tête est juste, elle affiche en moyenne 80 à 90 % ; quand elle est fausse, 60 à 68 %. Un joueur apprend vite qu'une tête à 95 % est presque sûre et qu'une tête à 60 % ne prouve rien, sans qu'aucun seuil ne soit infaillible.
- **La bonne spécialité est récompensée** : avec elle, la couleur dominante est juste 9 fois sur 10, contre 7 sur 10 sans spécialité.
- **La mauvaise spécialité n'est pas éliminée d'un coup** : ses maladies reculent, ce qui améliore un peu la lecture des autres couleurs, mais une seule exclusion ne prouve rien.

Ces valeurs sont vérifiées par les tests du moteur (`packages/moteur/test/diagnostic_test.dart`), à 2 points près.

### 8.5 Réglage

Ces paramètres sont dans le JSON (`parametres.diagnostic`). Leur réglage se fait avec le **simulateur** prévu à la phase 1 de la [feuille de route](FEUILLE_DE_ROUTE.md), qui remplace en partie un prototype papier. Les valeurs par défaut sont calées pour le catalogue cible : sur un petit paquet (6 maladies dans l'exemple), la vraie maladie ressort presque toujours, et le diagnostic est trop facile.

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

| Élément | Admission | Diagnostic | Traitement | Analyse (§12) |
|---|---|---|---|---|
| PV avant → après (delta) | PV initiaux | oui | oui | oui |
| Temps du patient / attente dépassée | — | oui | oui | oui |
| Liste des 5 maladies (pourcentage, couleur, icône) | — | oui | — | — |
| Liste des maladies suspectées | — | oui (affichées) | — | oui (proposées) |
| Maladie choisie pour l'analyse | — | — | — | oui |
| Passages restants / recette révélée | — | — | — | oui |
| Issue : en jeu / soigné / mort | — | oui | oui | oui |
| Maladie révélée | — | si mort | si soigné ou mort | jamais |
| Pièces gagnées | — | oui | oui | non (0) |
| Impact réputation | — | oui | oui | oui |

### 11.1 Format du résultat

Le moteur renvoie le résultat sous la forme d'un objet JSON, qui est aussi le contenu du message `resultat` du protocole ([SPECIFICATION.md §3.3](SPECIFICATION.md#33-protocole)). Code : `packages/moteur/lib/moteur/resultat.dart`. Les champs propres à l'analyse (§12) seront ajoutés avec la salle recherche.

| Clé | Type | Contenu |
|---|---|---|
| `numero` | entier | Numéro d'ordre de l'action dans la partie (à partir de 1) |
| `action`, `libelle` | texte | Identifiant et libellé de l'action appliquée |
| `phrase` | texte | Phrase de l'aperçu |
| `cartes` | liste de textes | Cartes de la combinaison, dans l'ordre de sélection |
| `patient`, `patient_nom` | texte | Carte patient et son nom affiché |
| `pv_avant` | entier ou `null` | PV avant l'action ; `null` pour une admission |
| `pv_apres` | entier | PV après l'action (PV initiaux pour une admission) |
| `temps` | entier | Temps du patient après l'action |
| `attente_depassee` | booléen | `temps > attente_max` |
| `issue` | `en_jeu`, `soigne` ou `mort` | Issue pour le patient |
| `diagnostic` | objet ou `null` | `niveau` (N) et `maladies` : liste de `{id, nom, pourcentage, specialite}` triée par pourcentage décroissant, où `specialite` vaut `{id, nom, couleur, icone}`. La couleur et l'icône sont recopiées dans le résultat, pour qu'un client puisse afficher la liste sans connaître le paquet actif de l'hôte |
| `maladie_revelee` | `{id, nom}` ou `null` | Maladie, si le patient est sorti |
| `pieces` | entier | Pièces gagnées par l'acteur, après difficulté et arrondi |
| `reputation` | entier signé | Impact total sur la réputation (soin, échec, attente et mort cumulés) |

## 12. Recherche en laboratoire

### 12.1 Principe

Une salle de spécialité `recherche` — le **laboratoire** — permet d'analyser une maladie suspectée pour découvrir son traitement. L'analyse se déroule en un ou plusieurs **passages** : une maladie compliquée exige plusieurs passages avant de révéler sa **recette**.

### 12.2 Maladies suspectées

L'hôte mémorise, pour chaque patient en jeu, l'ensemble des maladies qui ont figuré dans les listes affichées lors de ses diagnostics précédents (§8) : ce sont ses **maladies suspectées**. La liste est remise à zéro à chaque admission (le patient revient avec une nouvelle maladie). Chaque diagnostic affichant 5 maladies, un patient diagnostiqué au moins une fois a toujours des maladies suspectées. Si le patient n'a encore jamais été diagnostiqué, l'action `analyser` répond : « Aucune piste — faire d'abord un diagnostic ».

### 12.3 Déroulement d'un passage

1. Le joueur scanne 1 médecin + 1 patient + le laboratoire, puis confirme « Analyser ».
2. L'appli propose la liste des maladies suspectées du patient ; le joueur en choisit une — même une fausse, l'information reste utile pour toute la partie.
3. L'hôte décrémente de 1 le compteur de **passages restants** de cette maladie. Ce compteur est **global à la partie** et mémorisé par maladie : une recette découverte l'est pour tous les patients.
4. Tant que des passages restent : « Analyse en cours — X passage(s) restant(s) ».
5. Quand le compteur atteint 0, l'hôte révèle la **recette complète** du traitement adapté : la description des cartes requises, générée depuis le prédicat `traitement.adapte` (ex. « 2 médecins chirurgie + le bloc opératoire », « l'antibiotique »).

### 12.4 Nombre de passages

Chaque maladie peut définir `recherche.passages` dans le JSON (entier ≥ 1, défaut 1) : nombre de passages en laboratoire nécessaires pour révéler sa recette. Sans le champ, la recette se révèle en un seul passage.

### 12.5 Coût d'un passage

Un passage en laboratoire est une action sur le patient comme les autres : il avance son temps de 1, subit l'aggravation (action non curative) et éventuellement la pénalité d'attente dépassée. Il ne rapporte **aucune pièce**. Analyser plusieurs fois fait donc courir le risque de perdre le patient.

### 12.6 Capacité `recherche`

Une carte (médecin, objet ou diplôme) peut porter la capacité `recherche` : chaque point réduit d'autant le nombre de passages requis pour l'analyse en cours, sans descendre sous 1.
