# CardHospital — Feuille de route

Cette feuille de route dit **où en est le projet**, **ce qui reste à décider** et **dans quel ordre avancer**. Le détail technique de chaque tâche est dans le [plan de codage](PLAN_DE_CODAGE.md).

Principe : **traiter les risques en premier**. Chaque phase se termine par des critères de sortie vérifiables ; une phase qui échoue remet en cause les suivantes avant que du code inutile soit écrit.

## 1. Cap

Trois exigences guident tous les choix. Une proposition qui en dégrade une doit être refusée ou compensée.

| Exigence | Ce que cela veut dire | Garde-fou vérifiable |
|---|---|---|
| **Un jeu clair, lisible, facile à prendre en main** | Un nouveau joueur comprend son tour en une explication, et ne perd pas sa première partie sans savoir pourquoi | Règles de table sur 4 pages au plus ; tour résumé sur une carte d'aide ; première partie jouable sans livret ouvert après 10 minutes |
| **Peu de matériel** | Les cartes, un seul type de monnaie, le moins possible de pistes, tuiles et jetons annexes | Budget matériel du §4.2 : aucun nouvel élément sans en retirer un autre |
| **Une appli non intrusive** | Le téléphone calcule et se fait oublier : il ne suit ni les tours, ni les joueurs, ni les scores | Budget d'interaction du §4.3 : une action = un scan et **un** appui, résultat lu en moins de 5 s |

## 2. État des lieux

| Brique | État | Preuve |
|---|---|---|
| Spécification, modèle de jeu, règles de table, glossaire | Rédigés, cohérents entre eux | [Revue de cohérence](REVUE_COHERENCE.md) : 53 constats traités |
| Moteur (paquet Dart pur) : reconnaissance, effets, diagnostic, laboratoire, sauvegarde, annulation | **Fait** | 235 tests, couverture 97 %, test de robustesse sur parties aléatoires |
| Validateur de paquets | **Fait** : JSON Schema complet et contrôles sémantiques (12 règles), messages en français | Un test négatif par règle |
| Simulateur | **Fait** : plusieurs joueurs, partage ou non, cartes personnelles, novice, laboratoire. Mesuré à 1 et 3 joueurs | [Rapports reproductibles](simulations/README.md) |
| Paquet de base | **Rédigé**, pas encore équilibré : 57 cartes, 103 maladies, 5 spécialités | Validé sans avertissement en intégration continue |
| Prototype de détection multi-QR | **Appli faite**, essais physiques à mener | [`prototypes/detection`](../prototypes/detection/README.md), APK publié par la CI |
| Visuels | Style, prompt et gabarits des tuiles prêts ; illustrations à produire | [`outils/visuels`](../outils/visuels/STYLE.md) |
| Équilibre | **Non atteint** : le partage aide, mais ne décide pas de la partie ; le départ est trop dur | [Analyse de l'équilibre](ANALYSE_EQUILIBRE.md), §4.1 ci-dessous |
| Appli de jeu | Pas commencée | — |

## 3. Jalons

| # | Jalon | Risque levé | Dépend de | État |
|---|---|---|---|---|
| 0 | Prototype de détection | La caméra lit-elle 3 ou 4 cartes de façon fiable ? | — | Appli prête, **essais à faire** |
| 1 | Moteur, validateur, simulateur | Le modèle de jeu est-il cohérent ? | — | **Fait** |
| 1 bis | Règles figées et jeu équilibré | Le jeu est-il clair et tendu, avec peu de matériel ? | 1 | **En cours : priorité actuelle** |
| 2 | Appli sur un téléphone | Le parcours scan → résultat est-il fluide et discret ? | 0, 1 bis | À faire |
| 3 | Parties réelles et contenu final | Le jeu plaît-il à de vrais joueurs ? | 2 | À faire |
| 4 | Admin, sauvegardes, annulation | La partie est-elle récupérable après un incident ? | 2 | À faire |
| 5 | Plusieurs téléphones (facultatif) | Le réseau local tient-il sur une vraie partie ? | 3 | À décider (D6) |
| 6 | Paquets d'extension | Le jeu est-il extensible sans code ? | 3 | À faire |
| 7 | iOS (facultatif) | — | 3 | Plus tard |

Les jalons 0 et 1 bis avancent **en parallèle** : l'un demande une imprimante et trois téléphones, l'autre le simulateur et des décisions de règles.

## 4. Jalon 1 bis — Règles figées et jeu équilibré

C'est le jalon qui conditionne les trois exigences du §1. Il ne demande presque pas de code d'appli.

### 4.1 Décisions à prendre

Chaque ligne donne une recommandation. Les décisions D1 à D4 changent les règles : elles sont à trancher avant d'imprimer quoi que ce soit.

| # | Sujet | Constat | Recommandation |
|---|---|---|---|
| D1 | **Départ de la partie** | Avec les 3 salles de départ (consultation, pharmacie, radiologie), seules **52 % des admissions** sont soignables : 92 % en médecine générale, mais 39 % en orthopédie et 25 % en paranormal. Le prix des salles n'est pas fixé | Viser 70 % au départ : démarrer avec 5 salles, ou donner à chaque spécialité au moins une recette jouable dans une salle de départ. À mesurer au simulateur, qui doit d'abord simuler les salles construites peu à peu |
| D2 | **Première partie** | Un novice sans laboratoire guérit 29 à 43 % des patients et ferme l'hôpital dans plus de 99 % des parties ; avec le laboratoire, il en guérit 71 à 91 % | En difficulté Interne, le laboratoire est construit dès le départ. Les traitements restent secrets, mais la première partie n'est plus perdue d'avance |
| D3 | **Points de victoire** | Ils se comptent sur la main : jetons de réputation, plus 1 point par lot de 3 pièces. Le score baisse quand on dépense, et il faut diviser | Une seule source de points : les jetons de réputation en main. Les pièces ne servent qu'à acheter et à construire. À vérifier : que l'on garde une raison de construire pour l'hôpital |
| D4 | **Valeur du partage** | Le partage fait gagner 9 points de guérison, mais ne rend pas la défaite « quasi inévitable » sans lui | Seize variantes ont été simulées ([variantes de partage](VARIANTES_PARTAGE.md)) : la relève seule ne change rien, l'**examen ciblé** (le nom d'une maladie n'apparaît qu'avec une carte de sa spécialité) fait passer la valeur du partage de 7 à 52 points à 3 joueurs. L'adopter, rééquilibrer le jeu qui devient plus dur, puis doser une prime à l'informateur |
| D5 | **Patient mort** | Sa carte est défaussée ([règles de table §4](REGLES_DE_TABLE.md#4-sortie-des-patients)), mais le moteur accepte de la réadmettre si on la scanne | Le moteur refuse l'admission avec un message clair (« M. Dupont est décédé : sa carte est défaussée »). Le simulateur doit alors simuler la défausse et la pioche vide, et ses rapports sont à régénérer |
| D6 | **Un ou plusieurs téléphones** | Le mode à plusieurs téléphones (serveur embarqué, point d'accès, service de premier plan) est le plus gros risque technique, et le plus intrusif à l'installation | Le mode de référence est **un téléphone qui circule**, tenu par le joueur dont c'est le tour. Le mode à plusieurs téléphones devient le jalon 5, décidé après les parties réelles |
| D7 | Valeurs de table | Réputation de départ, seuil de fermeture, N patients en jeu, niveau cible de victoire, prix des salles et des objets, cases de formation | À fixer au simulateur sur le mode cartes personnelles, après D1 à D5 ([règles de table §11](REGLES_DE_TABLE.md#11-points-à-préciser)) |

### 4.2 Budget matériel

Le paquet de base compte **57 cartes et tuiles** (10 médecins, 12 patients, 19 objets, 5 diplômes, 11 salles). Les règles de table y ajoutent des éléments annexes ; chacun peut être remplacé par un geste sur une carte existante.

| Élément prévu | Proposition | Matériel économisé |
|---|---|---|
| 7 tuiles de stock des consommables | Un consommable utilisé est **retourné** (épuisé) ; payer son prix, imprimé sur la carte, le remet face visible | 7 tuiles |
| Piste de diplôme et pions | À chaque tour de formation, le joueur pose un jeton sur le diplôme visé ; au quatrième, il prend la carte | 1 piste, 1 pion par joueur |
| Jetons +1 et −1 de réputation | Un seul jeton recto verso (+1 / −1) | 1 type de jeton |
| Piste de réputation, budget de l'hôpital, rappel du tour | **Un seul plateau « Hôpital »** : piste de réputation avec le seuil de chaque difficulté, zone du budget, résumé du tour | Plusieurs aides séparées |
| Prix de construction au verso des salles | Gardé : aucun matériel de plus | — |

Cible : **57 cartes, 1 plateau, 2 types de jetons (pièce, réputation), 1 marqueur, 1 carte d'aide par joueur**. Les 19 objets sont à relire avec la même exigence : les 5 consommables de médecine générale (antibiotique, antalgique, anti-inflammatoire, ampoules de glucose, sirop) jouent presque le même rôle.

### 4.3 Budget d'interaction avec l'appli

| Aujourd'hui (spécification) | Proposition |
|---|---|
| Scanner, « Valider la sélection », choisir l'action, lire le résultat | **Aperçu en direct** : dès que les cartes scannées forment une combinaison, les boutons d'action apparaissent. Appuyer sur l'action la confirme. Rien n'est déclenché sans appui |
| Admission : scanner le patient seul, puis confirmer | Gardée, mais en un seul appui |
| Résultat détaillé | Un écran sans défilement : l'issue en grand, les jetons à prendre en icônes, les 5 maladies en couleur. Un bouton « Montrer à tous » agrandit l'affichage pour qui veut partager |
| — | Aucun compte, aucune notification, aucun son par défaut, aucun réseau ; écran sombre ; l'appli revient seule à la caméra |

Mesure : une action complète (4 cartes) en **moins de 10 s**, dont moins de 5 s les yeux sur l'écran.

### 4.4 Travaux

- Simulateur : salles construites peu à peu, défausse des morts et pioche vide (D5), répartition des jetons entre joueur et hôpital, parties de 4 à 6 joueurs.
- Contenu : appliquer D1, D2 et D4 au paquet de base, puis régler les paramètres restants du diagnostic (`verite`, `affinite_specialite`, `bonus_specialite`, `exclusion`).
- Règles de table : appliquer D3 et le budget matériel, fixer les valeurs de D7, fermer les [points à préciser](REGLES_DE_TABLE.md#11-points-à-préciser).
- Carte d'aide du joueur et plateau « Hôpital » : maquettes.

**Critères de sortie**

- au simulateur, avec cartes personnelles à 3 joueurs : des vétérans qui partagent ferment l'hôpital dans moins de 10 % des parties en Interne ; sans partage, au moins trois fois plus souvent ;
- un novice guérit au moins 60 % des patients en Interne ;
- au moins 70 % des admissions sont soignables avec les salles de départ ;
- les règles de table n'ont plus de point ouvert et tiennent sur 4 pages ;
- le matériel respecte la cible du §4.2.

## Phase 0 — Prototype de détection

**But** : valider `mobile_scanner` sur de vraies cartes imprimées, avant de coder l'appli de jeu.

L'appli de mesure existe ([`prototypes/detection`](../prototypes/detection/README.md)), ainsi que la [planche de QR](../outils/planche_qr/README.md). Restent les essais :

- imprimer la planche en finition mate et brillante : QR de 1,5 / 2 / 2,5 cm, niveaux de correction M et Q ;
- mesurer sur au moins 3 téléphones Android, dont un d'entrée de gamme sous API 26–28 : taux de détection et temps pour 1 à 4 cartes, distance, angle, éclairage (jour, lampe, pénombre), cartes posées à plat ou tenues en main ;
- comparer la détection simultanée et la sélection cumulative ([SPECIFICATION.md §4.1](SPECIFICATION.md#41-sélection-cumulative)).

**Critères de sortie**

- 4 cartes sélectionnées en moins de 3 s dans au moins 95 % des essais en éclairage intérieur normal ;
- aucune fausse lecture (QR attribué à tort) sur 200 essais ;
- taille de QR, niveau de correction et finition arrêtés ; mode de sélection confirmé.

**Si échec** : agrandir les QR, passer en sélection carte par carte, ou étudier une autre technologie de marquage (NFC, par exemple).

## Phase 1 — Moteur d'effets, validateur et simulateur

**But** : un paquet Dart **pur** (sans Flutter, sans réseau), testable unitairement, qui servira tel quel à l'appli. **Terminée.**

- Modèles typés du `jeu.json` (`json_serializable`).
- Validateur : JSON Schema complet ([schema/jeu.schema.json](schema/jeu.schema.json)) et contrôles sémantiques ([MOTEUR_EFFETS.md §7](MOTEUR_EFFETS.md#7-validation-à-limport)), messages en français.
- Moteur : reconnaissance des motifs, préconditions, prédicats, effets, invariants, diagnostic probabiliste, hasard injectable ; laboratoire de recherche ([MODELE_DE_JEU.md §12](MODELE_DE_JEU.md#12-recherche-en-laboratoire)).
- Instantanés de l'état, sauvegarde, reprise, annulation.
- Simulateur en ligne de commande : stratégies vétéran, novice et laboratoire, 1 à 6 joueurs, partage ou non, cartes personnelles.
- Paquet de base : `contenu/paquet_base.json`, validé en intégration continue.

**Critères de sortie**, tous atteints

- couverture de tests du moteur ≥ 90 % (97 %) ;
- l'exemple [exemples/jeu.exemple.json](exemples/jeu.exemple.json) est validé, et chaque règle de validation a un test négatif ;
- le simulateur produit un rapport d'équilibrage reproductible (même graine, même résultat).

## Phase 2 — Appli sur un téléphone

**But** : le parcours complet sur un seul téléphone, sans réseau. C'est le **mode de référence** (D6) : le téléphone circule, ou reste près du joueur qui le veut.

- Écrans : accueil, sélection avec aperçu en direct, résultat ([SPECIFICATION.md §6.1](SPECIFICATION.md#61-écrans), à mettre à jour selon le §4.3).
- Moteur de la phase 1 appelé directement, derrière l'interface que pourra utiliser un client réseau.
- Choix de la difficulté, sauvegarde automatique, reprise.
- Images provisoires des cartes.

**Critères de sortie** : une partie de test d'au moins 10 patients jouée de bout en bout sans blocage ; budget d'interaction du §4.3 mesuré et tenu ; retours de 2 ou 3 testeurs sur la lisibilité du résultat.

## Phase 3 — Parties réelles et contenu final

- Prototype imprimable : cartes aux QR validés en phase 0, plateau « Hôpital », cartes d'aide.
- Au moins 5 parties réelles, à 2, 3 et 4 joueurs ou plus, avec des joueurs qui découvrent le jeu.
- Réglage du paquet de base d'après ces parties, puis au simulateur.
- Illustrations et impression selon le [style guide](../outils/visuels/STYLE.md) et les gabarits.

**Critères de sortie** : le tour est expliqué en moins de 5 minutes ; aucune règle n'a dû être relue dans le livret pendant les deux dernières parties ; les joueurs oublient le téléphone entre deux actions (observation) ; durée de partie mesurée.

## Phase 4 — Admin, sauvegardes, annulation

- Page admin : informations cachées masquées par défaut, section debug repliée ([SPECIFICATION.md §7](SPECIFICATION.md#7-page-admin-hôte)).
- Annulation LIFO des 5 dernières actions, réservée aux erreurs de scan ; sauvegardes nommées ; journal.

**Critères de sortie** : chaque cas d'erreur de [SPECIFICATION.md §6.2](SPECIFICATION.md#62-cas-derreur) est reproduit et correctement traité.

## Phase 5 — Plusieurs téléphones (facultatif)

À ne lancer que si les parties réelles montrent que le téléphone unique gêne (D6).

- Serveur `shelf` + WebSocket, protocole de [SPECIFICATION.md §3.3](SPECIFICATION.md#33-protocole), jeton de session, version de protocole.
- QR de connexion `cardhospital://`, point d'accès de l'hôte, service de premier plan, reconnexion automatique.

**Critères de sortie** : partie de 2 h avec 3 téléphones sans perte d'action, essai à 6 téléphones ; coupure Wi-Fi de 30 s et appel entrant sur l'hôte récupérés sans intervention ; latences conformes à [SPECIFICATION.md §9](SPECIFICATION.md#9-exigences-non-fonctionnelles).

## Phase 6 — Paquets d'extension

- Import de `.zip` (système de fichiers, partage Android), rapport de validation, sélection du paquet actif.
- Une extension d'exemple (nouvelles maladies), qui efface au passage l'avantage des vétérans sur les traitements.

**Critères de sortie** : extension importée et jouée ; un paquet invalide est refusé avec des messages compréhensibles par un auteur de paquet.

## Phase 7 — iOS (facultatif)

Portage Flutter. Points d'attention : lecture de QR via AVFoundation et, si la phase 5 est faite, permission « réseau local » et serveur embarqué en arrière-plan.

## 5. Risques

| Risque | Signe | Parade |
|---|---|---|
| La caméra lit mal plusieurs cartes | Critères de la phase 0 non tenus | QR plus grands, sélection carte par carte, NFC |
| Le jeu reste trop dur au départ ou trop facile pour des vétérans | Critères du jalon 1 bis non tenus au simulateur | D1, D2, D4 ; nouveaux paquets pour renouveler les traitements |
| Le matériel s'alourdit au fil des règles | Un élément ajouté sans en retirer un autre | Budget matériel du §4.2, revu à chaque changement de règle |
| L'appli prend trop de place à la table | Plus de 10 s par action, joueurs penchés sur l'écran | Budget d'interaction du §4.3, mesuré en phase 2 et observé en phase 3 |
| Le réseau local est fragile | Coupures, Wi-Fi qui isole les appareils | Mode de référence à un téléphone (D6) |
