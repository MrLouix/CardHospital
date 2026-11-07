# CardHospital — Règles de table

Ce document décrit les **règles qui se jouent à la table, sans l'appli** : mise en place, tour de jeu, économie, victoire, formation, comportement des joueurs. Les règles calculées par l'appli (maladies, diagnostic, traitement, récompenses par action) sont dans le [modèle de jeu](MODELE_DE_JEU.md). Les termes sont définis dans le [glossaire](GLOSSAIRE.md).

> **Principe** : l'appli n'est pas intrusive. Elle gère les maladies et calcule le résultat de chaque action ; elle ne suit ni les tours, ni les joueurs, ni les achats, ni les scores. Tout ce qui est décrit ici se tient à la main, sur la table.

Les valeurs marquées « à fixer au simulateur » seront réglées avec le [simulateur](PLAN_DE_CODAGE.md#53-utiliser-le-moteur-et-le-simulateur). Les points encore ouverts sont listés au §11.

## 1. Mise en place

1. **Salles** : l'hôpital démarre avec trois salles, posées face visible : la **salle de consultation**, la **pharmacie** et la **radiologie**. Les autres salles s'achètent en cours de partie (§5).
2. **Médecins et diplômes** : chaque joueur tire au hasard **1 médecin**. À 2 ou 3 joueurs, il tire aussi au hasard **1 diplôme** ; avec un autre nombre de joueurs, il ne reçoit que son médecin. Les médecins restants ne sont pas utilisés pendant la partie. Les autres diplômes s'obtiennent par la formation (§7).
3. **Patients** : on mélange les 12 cartes patient pour former la pioche, puis on en révèle 2, que l'on admet avec l'appli : ce sont les premiers patients en jeu.
4. **Réputation de l'hôpital** : on place le marqueur sur la valeur de départ. La valeur de départ et le seuil de fermeture dépendent de la difficulté choisie dans l'appli ; ils sont à fixer au simulateur.
5. **Objets** : on révèle autant d'objets permanents qu'il y a de joueurs, tous différents (§6.1). On prépare les tuiles de stock des objets consommables (§6.2, tuiles à créer).

## 2. Tour de jeu

Les joueurs jouent **à tour de rôle**, même si plusieurs smartphones sont disponibles. L'appli n'impose aucun ordre et ne bloque pas deux actions simultanées : c'est aux joueurs de respecter les tours.

1. **Début du tour : nouveau patient.** S'il y a moins de N patients en jeu, le joueur pioche un patient et l'admet avec l'appli. N dépend de la difficulté et est à fixer au simulateur. L'appli ne vérifie pas cette règle.
2. **Une seule option**, au choix :
   - **acheter un objet permanent** (§6.1) ;
   - ou **réaliser une action** : diagnostic, traitement, recherche (au laboratoire) ou formation (§7). La formation occupe tout le tour.

Une action qui réunit les médecins de deux joueurs compte comme **le tour des deux joueurs** (§3.1).

Les **salles sont communes** : tous les joueurs les utilisent. Une salle n'est jamais bloquée par un joueur : il y joue son action, puis la laisse libre pour les suivants.

## 3. Pièces, réputation et points de victoire

### 3.1 Partage des jetons

Après chaque action, l'appli affiche les pièces gagnées et l'impact sur la réputation. On les matérialise par des **jetons** : pièces, **+1 réputation**, **−1 réputation**.

**Seul le joueur qui a joué l'action** prend les jetons : il en est seul responsable. Il répartit **chaque jeton**, gain ou perte :

- **pièces** : les garder (réserve personnelle), les donner au **budget de l'hôpital**, ou les verser directement à une construction de salle (§5) ou à un réapprovisionnement de consommables (§6.2) ;
- **+1 réputation** : le garder pour son médecin (**réputation personnelle**) ou le laisser à l'hôpital (piste de réputation de l'hôpital) ;
- **−1 réputation** : le reporter sur la piste de l'hôpital, ou **le prendre pour lui**, sur sa réputation personnelle. Il perd alors un point de victoire, mais la réputation de l'hôpital ne baisse pas : c'est ainsi qu'un joueur peut éviter la fermeture quand l'hôpital approche du seuil.

**Action à deux joueurs** : quand une combinaison réunit les médecins de deux joueurs (par exemple les deux orthopédistes exigés au bloc opératoire), les deux joueurs sont responsables de l'action et se répartissent ses jetons. L'action compte comme **le tour des deux** : le joueur dont c'est le tour l'utilise, et son partenaire passe son prochain tour.

### 3.2 Points de victoire et victoire

- Chaque point de réputation personnelle rapporte **1 point de victoire** ; chaque −1 pris pour soi en retire un.
- Chaque lot de **3 pièces** gagnées rapporte **1 point de victoire**.
- Un joueur **gagne** quand son médecin atteint le **niveau cible** (à fixer au simulateur).

### 3.3 Défaite commune

Si la réputation de l'hôpital devient **strictement inférieure au seuil de fermeture**, l'hôpital ferme : la partie s'arrête et **tous les joueurs ont perdu**, quels que soient leurs points. C'est la tension du jeu : chaque médecin joue pour lui, mais un patient négligé, mal traité ou qui meurt pénalise tout le monde.

## 4. Sortie des patients

- Un patient **guéri** retourne dans la pioche. S'il est de nouveau pioché, il est réadmis avec une nouvelle maladie.
- Un patient **mort** est **défaussé** : sa carte sort du jeu pour le reste de la partie.

## 5. Construire une salle

1. Une salle choisie pour être construite est posée sur la table **face cachée** : son verso indique le **prix de construction**, en pièces.
2. Elle se paie de deux façons, éventuellement combinées :
   - avec le **budget de l'hôpital**, si les joueurs sont d'accord **à la majorité** ;
   - avec les pièces qu'un joueur vient de gagner : il peut décider **seul** de les verser à la construction, au lieu de les garder ou de les donner à l'hôpital.
3. Une fois payée, la salle est retournée face visible : elle est utilisable par tous.

## 6. Objets

### 6.1 Objets permanents

Les objets permanents (livres, instruments…) s'achètent pendant la partie, avec l'option « acheter un objet permanent » du tour (§2).

- On en propose toujours **autant que de joueurs**, tous **différents**, face visible.
- Le joueur paie sur sa **réserve personnelle**. Cet argent ne va pas à l'hôpital : il **sort du jeu**.
- L'objet appartient au joueur, qui le garde pour toute la partie.

### 6.2 Objets consommables

Les objets consommables (médicaments, bistouri, plâtre…) appartiennent à l'**hôpital**. Des **tuiles de stock** indiquent pour chaque consommable le nombre d'unités disponibles et le **prix de réapprovisionnement**.

Le réapprovisionnement se paie comme une construction (§5) : avec le budget de l'hôpital, après accord à la majorité, ou avec les pièces qu'un joueur vient de gagner.

## 7. Formation et diplômes

Un joueur peut **former son médecin** pour obtenir un diplôme :

- l'action **Formation** demande une combinaison **médecin + salle de formation + objet de formation** ;
- chaque formation fait avancer le pion du joueur sur la **piste de diplôme**, une tuile indépendante ;
- après plusieurs formations, le joueur obtient un **diplôme**. L'obtention doit être **chronophage** : un premier diplôme est envisageable dans une partie, un second demande trop de temps pour valoir la peine (par exemple 4 formations pour le premier, 8 de plus pour le second ; à régler en partie) ;
- le joueur qui se forme ne fait **rien d'autre** pendant son tour : ni diagnostic, ni traitement, ni recherche.

Un médecin polyvalent muni d'un diplôme remplace un spécialiste de cette spécialité : c'est voulu, pour qu'un joueur seul à détenir une spécialité ne fasse pas la loi. Les recettes qui exigent deux médecins d'une spécialité demandent toutefois deux vrais médecins : deux spécialistes, ou un spécialiste et un médecin muni du diplôme ([modèle de jeu §2.2](MODELE_DE_JEU.md#22-cartes)).

À créer : la salle de formation, les objets de formation, la piste de diplôme et le nombre exact de formations par diplôme (§11).

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
| 1 | Nombre de joueurs autorisé (la mise en place parle de « 2 ou 3 joueurs, sinon médecin seul ») | — |
| 2 | Points de victoire des pièces : pièces gagnées au total, ou pièces encore en réserve ? Les pièces données à l'hôpital ou dépensées comptent-elles ? | — |
| 3 | Niveau cible de victoire, valeur de départ et seuil de fermeture, N patients en jeu | À fixer au simulateur, par difficulté. Les rapports de simulation donnent, par configuration, la réputation moyenne en fin de partie, le minimum atteint et la part des parties fermées pour un écart de 5 à 30 entre départ et seuil ([rapport du paquet de base](simulations/rapport_paquet_base.md), [à 3 joueurs](simulations/rapport_paquet_base_3_joueurs.md)). Le seuil se règle sur le rapport [à cartes personnelles](simulations/rapport_paquet_base_3_joueurs_cartes_personnelles.md), où chaque joueur n'a que son médecin ([analyse de l'équilibre §4](ANALYSE_EQUILIBRE.md#4-pistes)) |
| 4 | Fin de partie si la pioche est vide (les morts en sortent) avant que quelqu'un gagne | — |
| 5 | Qui choisit la salle à construire, et quand | — |
| 6 | Quels objets sont permanents, lesquels sont consommables, et quand un consommable est-il utilisé (au traitement seulement ?) | Permanents : stéthoscope, traité de médecine, défibrillateur, électrocardiographe, thermomètre, tensiomètre, livre de psychanalyse, grimoire, amulette, et les objets d'aide à la recherche (microscope, centrifugeuse, séquenceur d'ADN). Consommables : antibiotique, antalgique, anti-inflammatoire, ampoules de glucose, sirop antitussif, plâtre, attelle |
| 7 | Marché d'objets permanents : remplacé après chaque achat ? Prix ? | — |
| 8 | Formation : rôle de l'appli (scan de la combinaison et validation, ou geste purement physique), nombre de formations par diplôme, choix de la spécialité du diplôme | — |
| 9 | Budget de l'hôpital au départ | — |
