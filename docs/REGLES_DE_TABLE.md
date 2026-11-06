# CardHospital — Règles de table

Ce document décrit les **règles qui se jouent à la table, sans l'appli** : mise en place, tour de jeu, économie, victoire, formation, comportement des joueurs. Les règles calculées par l'appli (maladies, diagnostic, traitement, récompenses par action) sont dans le [modèle de jeu](MODELE_DE_JEU.md). Les termes sont définis dans le [glossaire](GLOSSAIRE.md).

> **Principe** : l'appli n'est pas intrusive. Elle gère les maladies et calcule le résultat de chaque action ; elle ne suit ni les tours, ni les joueurs, ni les achats, ni la formation, ni les scores. Tout ce qui est décrit ici se tient à la main, sur la table.

Les valeurs marquées « à fixer au simulateur » seront réglées avec le [simulateur](PLAN_DE_CODAGE.md#53-utiliser-le-moteur-et-le-simulateur). Les points encore ouverts sont listés au §11.

## 1. Mise en place

CardHospital se joue de **2 à 6 joueurs**.

1. **Salles** : l'hôpital démarre avec trois salles, posées face visible : la **salle de consultation**, la **pharmacie** et la **radiologie**. Les autres salles se construisent en cours de partie (§5).
2. **Médecins et diplômes** : chaque joueur tire au hasard **1 médecin**. À 2 ou 3 joueurs, il tire aussi au hasard **1 diplôme** ; de 4 à 6 joueurs, il ne reçoit que son médecin. Les médecins restants ne sont pas utilisés pendant la partie. Les autres diplômes s'obtiennent par la formation (§7).
3. **Patients** : on mélange les 12 cartes patient pour former la pioche, puis on en révèle 2, que l'on admet avec l'appli : ce sont les premiers patients en jeu.
4. **Réputation de l'hôpital** : on place le marqueur sur la valeur de départ. La valeur de départ et le seuil de fermeture dépendent de la difficulté choisie dans l'appli ; ils sont à fixer au simulateur.
5. **Objets** : on révèle autant d'objets permanents qu'il y a de joueurs, tous différents (§6.1). On prépare les tuiles de stock des objets consommables (§6.2, tuiles à créer).

## 2. Tour de jeu

Les joueurs jouent **à tour de rôle**, même si plusieurs smartphones sont disponibles. L'appli n'impose aucun ordre et ne bloque pas deux actions simultanées : c'est aux joueurs de respecter les tours.

1. **Début du tour : nouveau patient.** S'il y a moins de N patients en jeu, le joueur pioche un patient et l'admet avec l'appli. N dépend de la difficulté et est à fixer au simulateur. L'appli ne vérifie pas cette règle.
2. **Achat et action.** Pendant son tour, le joueur :
   - **peut acheter un objet permanent**, et un seul (§6.1). Cet achat n'est pas obligatoire ;
   - **et réalise une action** : diagnostic, traitement, recherche (au laboratoire) ou formation (§7). La formation n'est pas suivie par l'appli : le joueur qui se forme ne fait pas d'autre action pendant ce tour.

À son tour, tout joueur peut aussi prendre l'initiative de **lancer la construction d'une salle** (§5).

Une action qui réunit les médecins de deux joueurs compte comme **le tour des deux joueurs** (§3.1).

Les **salles sont communes** : tous les joueurs les utilisent. Une salle n'est jamais bloquée par un joueur : il y joue son action, puis la laisse libre pour les suivants.

## 3. Pièces, réputation et points de victoire

### 3.1 Partage des jetons

Après chaque action, l'appli affiche les pièces gagnées et l'impact sur la réputation. On les matérialise par des **jetons** : pièces, **+1 réputation**, **−1 réputation**.

**Seul le joueur qui a joué l'action** prend les jetons : il en est seul responsable. Il répartit **chaque jeton**, gain ou perte :

- **pièces** : les garder **en main** (réserve personnelle), les donner au **budget de l'hôpital**, ou les verser directement à une construction de salle (§5) ou à un réapprovisionnement de consommables (§6.2) ;
- **+1 réputation** : le garder **en main** pour son médecin (**réputation personnelle**) ou le laisser à l'hôpital (piste de réputation de l'hôpital) ;
- **−1 réputation** : le reporter sur la piste de l'hôpital, ou **le prendre pour lui**, en main, sur sa réputation personnelle. Il perd alors un point de victoire, mais la réputation de l'hôpital ne baisse pas : c'est ainsi qu'un joueur peut éviter la fermeture quand l'hôpital approche du seuil.

**Action à deux joueurs** : quand une combinaison réunit les médecins de deux joueurs (par exemple les deux orthopédistes exigés au bloc opératoire), les deux joueurs sont responsables de l'action et se répartissent ses jetons. L'action compte comme **le tour des deux** : le joueur dont c'est le tour l'utilise, et son partenaire passe son prochain tour.

### 3.2 Points de victoire et victoire

Les points de victoire n'ont **pas de jeton** : on les compte, **à tout moment**, sur le **contenu de la main** de chaque joueur.

- Chaque jeton **+1 réputation** en main rapporte **1 point de victoire** ; chaque jeton **−1 réputation** en main en retire un.
- Chaque lot de **3 pièces** en main rapporte **1 point de victoire**.

Seul ce qui est en main compte : les pièces données à l'hôpital, versées à une construction ou à un réapprovisionnement, ou dépensées pour un objet ne rapportent plus de point. Le score d'un joueur baisse donc quand il dépense ses pièces.

Un joueur **gagne** dès que sa main atteint le **niveau cible** de points de victoire (à fixer au simulateur).

### 3.3 Défaite commune

La partie s'arrête et **tous les joueurs ont perdu**, quels que soient leurs points, dans deux cas :

- **fermeture de l'hôpital** : la réputation de l'hôpital devient **strictement inférieure au seuil de fermeture** ;
- **trop de morts** : la **pioche de patients est vide**. Les patients morts sortent du jeu (§4) : quand il en meurt trop, la pioche s'épuise.

C'est la tension du jeu : chaque médecin joue pour lui, mais un patient négligé, mal traité ou qui meurt pénalise tout le monde.

## 4. Sortie des patients

- Un patient **guéri** retourne dans la pioche. S'il est de nouveau pioché, il est réadmis avec une nouvelle maladie.
- Un patient **mort** est **défaussé** : sa carte sort du jeu pour le reste de la partie. Si la pioche de patients se vide, tous les joueurs ont perdu (§3.3).

## 5. Construire une salle

1. À son tour, **tout joueur** peut prendre l'initiative de lancer la construction d'une salle. Il choisit une salle qui n'est pas encore construite et la pose sur la table **face cachée** : son verso indique le **prix de construction**, en pièces.
2. Elle se paie de deux façons, éventuellement combinées :
   - avec le **budget de l'hôpital**, si les joueurs sont d'accord **à la majorité** ;
   - avec les pièces qu'un joueur vient de gagner : il peut décider **seul** de les verser à la construction, au lieu de les garder ou de les donner à l'hôpital.
3. Une fois payée, la salle est retournée face visible : elle est utilisable par tous.

## 6. Objets

### 6.1 Objets permanents

Les objets permanents du paquet de base sont : le **stéthoscope**, le **traité de médecine**, le **défibrillateur**, l'**électrocardiographe**, le **thermomètre**, le **tensiomètre**, le **livre de psychanalyse**, le **grimoire** et l'**amulette de protection**.

À son tour, un joueur peut en acheter **un seul**, en plus de son action (§2). Cet achat n'est pas obligatoire.

- On en propose toujours **autant que de joueurs**, tous **différents**, face visible : à chaque achat, un **nouvel objet permanent** est mis en jeu à la place de l'objet acheté.
- Le joueur paie avec les pièces de sa main (**réserve personnelle**). Cet argent ne va pas à l'hôpital : il **sort du jeu**.
- L'objet appartient au joueur, qui le garde pour toute la partie.

### 6.2 Objets consommables

Les objets consommables du paquet de base sont : l'**antibiotique**, l'**antalgique**, l'**anti-inflammatoire**, les **ampoules de glucose**, le **sirop antitussif**, le **plâtre** et l'**attelle**.

Ils appartiennent à l'**hôpital**. Des **tuiles de stock** indiquent pour chaque consommable le nombre d'unités disponibles et le **prix de réapprovisionnement**.

Le réapprovisionnement se paie comme une construction (§5) : avec le budget de l'hôpital, après accord à la majorité, ou avec les pièces qu'un joueur vient de gagner.

## 7. Formation et diplômes

Un joueur peut **former son médecin** pour obtenir un diplôme. La formation est un **geste purement physique** : l'appli ne la suit pas, et on ne scanne aucune combinaison.

- Le joueur qui choisit la formation comme action de son tour avance son pion d'**une case** sur la **piste de diplôme**, une tuile indépendante ;
- après plusieurs tours de formation, le joueur obtient un **diplôme**. L'obtention doit être **chronophage** : un premier diplôme est envisageable dans une partie, un second demande trop de temps pour valoir la peine (par exemple 4 cases pour le premier, 8 de plus pour le second ; à régler en partie) ;
- pendant ce tour, il ne fait **rien d'autre** : ni diagnostic, ni traitement, ni recherche. Il peut seulement acheter un objet permanent, s'il le souhaite (§6.1).

Un médecin polyvalent muni d'un diplôme remplace un spécialiste de cette spécialité : c'est voulu, pour qu'un joueur seul à détenir une spécialité ne fasse pas la loi. Les recettes qui exigent deux médecins d'une spécialité demandent toutefois deux vrais médecins : deux spécialistes, ou un spécialiste et un médecin muni du diplôme ([modèle de jeu §2.2](MODELE_DE_JEU.md#22-cartes)).

À créer : la piste de diplôme et le nombre exact de cases à parcourir pour un diplôme (§11).

## 8. Partager l'information

Les résultats des diagnostics et les recettes découvertes au laboratoire ne s'affichent que sur le téléphone du joueur qui a agi. Chacun décide de les **partager ou de les garder pour lui**, de vive voix ou en montrant son écran.

**CardHospital n'est pas un jeu de bluff** : mentir sur un résultat ne fait pas partie du comportement attendu des joueurs. On peut se taire, pas tromper.

Une recette gardée secrète ne le reste pas longtemps : quand un joueur l'utilise, les autres voient les cartes qu'il joue.

## 9. Traitements secrets

Le livret de règles **ne donne pas** la correspondance entre maladies et traitements. Les joueurs la découvrent par des essais, en observant les traitements des autres, ou par des analyses au laboratoire ([modèle de jeu §12](MODELE_DE_JEU.md#12-recherche-en-laboratoire)).

Après plusieurs parties, un joueur vétéran connaîtra les principaux traitements, ce qui crée une asymétrie avec un joueur novice. Un nouveau paquet de jeu (`jeu.json`) qui change les traitements la fait disparaître.

## 10. Annulation

L'annulation de la dernière action, dans la page admin de l'hôte, est réservée aux **erreurs de scan** (mauvaise carte détectée, mauvais bouton). Ce n'est pas une action de jeu : on ne s'en sert pas pour revoir un diagnostic ou relancer un tirage.

## 11. Points à préciser

| # | Sujet | Proposition |
|---|---|---|
| 1 | Niveau cible de victoire, valeur de départ et seuil de fermeture, N patients en jeu | À fixer au simulateur, par difficulté |
| 2 | Quand un consommable est-il utilisé (au traitement seulement ?) | — |
| 3 | Prix des objets permanents | — |
| 4 | Formation : nombre de cases de la piste pour obtenir un diplôme, choix de la spécialité du diplôme | — |
| 5 | Budget de l'hôpital au départ | — |
| 6 | Achat d'un objet permanent : avant ou après l'action du tour ? | Au choix du joueur |
