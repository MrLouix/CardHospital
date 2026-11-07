# CardHospital — Analyse de l'équilibre et du partage d'information

Cette analyse cherche pourquoi les règles actuelles ne favorisent pas le partage d'information entre joueurs, et ce qui déséquilibre le jeu. Elle s'appuie sur le paquet de base 2.2.0, sur les [rapports de simulation](simulations/README.md) et sur des mesures faites pour l'occasion (§2 et §3). Les termes sont ceux du [glossaire](GLOSSAIRE.md).

## 1. Synthèse

Le partage d'information ne sert que s'il permet de faire **mieux à plusieurs que chacun de son côté**. Dans CardHospital, presque tout pousse dans l'autre sens :

| # | Cause | Effet sur le partage | Nature |
|---|---|---|---|
| C1 | Le simulateur donnait toutes les cartes à chaque joueur | Il masquait l'intérêt principal du partage : envoyer le patient au bon spécialiste | Simulateur (corrigé) |
| C2 | Un joueur peut mener seul un patient du diagnostic à la guérison, une fois sur deux | Il n'a besoin de personne pour la moitié des patients, et prend « son » patient | Règles et contenu |
| C3 | L'information ne s'additionne pas : un diagnostic est un tirage neuf, qu'un autre aurait obtenu avec la même action | Partager ne crée aucune action de plus ; il change seulement qui agit | Règles |
| C4 | Le diagnostic atteint vite une quasi-certitude, pour tout le monde, dès le départ | Chacun sait seul ; l'avis d'un autre apporte peu | Contenu |
| C5 | Celui qui partage travaille pour un autre : le diagnostic rapporte 1 pièce, la guérison 3 à 5 pièces et +2 de réputation | Partager enrichit un rival ; rien ne récompense l'informateur | Règles |
| C6 | Un essai de traitement doit réussir 33 à 67 % du temps pour ne pas coûter de réputation, selon le niveau | Agir sur l'information d'un autre, moins sûre, est puni | Règles |
| C7 | Le laboratoire rend autonome, et son compteur commun partage les progrès sans qu'on parle | Il retire une raison de partager | Règles |
| C8 | La menace commune (fermeture) n'a pas encore de seuil, et elle est mal dosée | Rien n'oblige à coopérer | Réglage à faire |

**Constat principal.** Une fois le simulateur corrigé (C1), le partage **aide réellement** : à 3 joueurs, il fait gagner environ 9 points de guérison aux vétérans et 6 à 10 aux novices qui utilisent le laboratoire, et il divise par deux les fermetures en Interne (§2). Mais il ne rend pas la défaite « quasi inévitable » sans lui, comme le voulait le modèle de jeu (§8.6) : les causes C2 à C7 limitent sa valeur et le rendent coûteux pour celui qui partage.

## 2. Ce que le simulateur cachait

Jusqu'ici, chaque joueur simulé disposait de **toutes les cartes** : n'importe lequel pouvait jouer le cardiologue, l'orthopédiste ou le séquenceur d'ADN. Or, à la table, chaque joueur n'a qu'un médecin, plus un diplôme à 2 ou 3 joueurs ([règles de table §1](REGLES_DE_TABLE.md#1-mise-en-place)). Le simulateur ne pouvait donc pas montrer l'intérêt principal du partage : **dire au bon spécialiste qu'un patient l'attend**.

Le simulateur a maintenant un mode **cartes personnelles** (`--cartes personnelles`) : chaque joueur tire un médecin, plus un diplôme à 2 ou 3 joueurs, et ne joue que des combinaisons avec son médecin. Une combinaison qui réunit son médecin et celui d'un autre joueur est une action à deux : le partenaire voit le résultat et passe son prochain tour. Salles et objets restent communs et disponibles. Rapport : [rapport_paquet_base_3_joueurs_cartes_personnelles.md](simulations/rapport_paquet_base_3_joueurs_cartes_personnelles.md).

**Guérison à 3 joueurs**, informations partagées / gardées pour soi :

| Configuration | Cartes | Interne | Chirurgien | Réanimation |
|---|---|---:|---:|---:|
| Vétéran (`seuil:70`) | toutes à chacun | 97 % / 97 % | 90 % / 90 % | 83 % / 84 % |
| Vétéran (`seuil:70`) | **personnelles** | **84 % / 75 %** | **79 % / 70 %** | **75 % / 65 %** |
| Novice avec laboratoire | toutes à chacun | 91 % / 91 % | 80 % / 80 % | 67 % / 71 % |
| Novice avec laboratoire | **personnelles** | **81 % / 71 %** | **71 % / 61 %** | **60 % / 54 %** |
| Novice sans laboratoire | personnelles | 43 % / 37 % | 37 % / 31 % | 33 % / 29 % |

**Parties où l'hôpital ferme**, pour un écart de 10 entre la réputation de départ et le seuil (cartes personnelles, partagées / gardées pour soi) :

| Configuration | Interne | Chirurgien | Réanimation |
|---|---:|---:|---:|
| Vétéran | 11 % / 24 % | 24 % / 41 % | 41 % / 61 % |
| Novice avec laboratoire | 19 % / 36 % | 44 % / 61 % | 72 % / 82 % |
| Novice sans laboratoire | 99,5 % / 99,7 % | 99,6 % / 100 % | 100 % / 100 % |

Trois enseignements :

- **Le partage compte dès que les médecins sont personnels** : sans lui, un patient qu'aucune des cartes du joueur ne peut soigner reste avec lui jusqu'à sa mort ou à son abandon.
- **Le jeu réel est plus dur que les premières mesures** : un vétéran qui partage ferme l'hôpital dans 11 % des parties en Interne pour un écart de 10, contre moins de 1 % quand il avait toutes les cartes. La proposition d'un écart de 10 à tous les niveaux est donc à revoir (§4, P6).
- **Le novice sans laboratoire perd quoi qu'il fasse** : il essaie à l'aveugle, et le partage ne compense pas cela (C6).

## 3. Causes du déséquilibre

### C2. Un joueur peut porter un patient seul

Les recettes du paquet de base se répartissent ainsi, en part des admissions (pondérée par le poids des maladies) :

| Recette | Part | Qui peut la jouer |
|---|---:|---|
| Un objet dans une salle | 42 % | N'importe quel joueur |
| Un spécialiste dans une salle | 44 % | Le joueur qui a ce spécialiste, ou le diplôme |
| Deux médecins, dont un ou deux spécialistes | 10 % | Deux joueurs, ou un seul avec médecin et diplôme |
| Deux spécialistes de spécialités différentes | 4 % | Deux joueurs |

Un joueur, avec son seul médecin, soigne donc **50 % des admissions** (42 à 54 % selon le médecin), toutes salles construites. La moitié des patients n'a besoin de personne. Les objets, communs, font de 42 % des maladies des affaires « sans spécialiste » : l'information utile se réduit alors à « quelle maladie ? », que chacun peut établir seul.

En plus, il y a autant de patients en jeu que de joueurs (N = 3 à 3 joueurs) : chacun peut prendre « son » patient et ne jamais toucher à celui des autres. C'est ce que fait le simulateur quand les joueurs ne partagent rien, et c'est ce que feront des joueurs qui ne se parlent pas.

### C3. L'information ne s'additionne pas

Chaque diagnostic est un **tirage neuf** : deux listes sur le même patient en disent plus qu'une, mais un joueur seul obtient la seconde en jouant une action de plus. Le facteur limitant est l'**action** (une par tour), pas l'information. Partager ne donne aucune action de plus à l'équipe ; cela change seulement qui joue la suivante.

Le partage ne peut donc rapporter que de trois façons :

1. **orienter le patient** vers le joueur qui a les bonnes cartes (C2) : c'est l'effet mesuré au §2 ;
2. **éviter les doublons** : deux joueurs qui diagnostiquent le même patient chacun de leur côté ;
3. **concentrer les actions** sur le patient le plus urgent.

Le jeu ne récompense pas spécialement le deuxième avis : un diagnostic fait par un autre médecin vaut exactement un diagnostic de plus par le même.

### C4. Le diagnostic est vite sûr, pour tout le monde

La radiologie, salle de départ commune, porte une précision de 3. Avec n'importe quel médecin, le niveau de précision est donc de 3 dès le premier tour, et de 4 (le maximum) avec le Dr Moreau, la Dr Reyer ou la Dr Mystère. À ce niveau, sans spécialité, la vraie maladie est en tête 55 % du temps, et 18 % des diagnostics ont une tête à 95 ou plus, presque toujours juste ([modèle de jeu §8.4](MODELE_DE_JEU.md#84-comportement-attendu)). Un vétéran traite après 1,6 à 2,5 diagnostics en moyenne.

L'avantage d'une spécialité concordante reste modeste : la vraie maladie passe de 55 à 59 % en tête. Un joueur n'a donc pas besoin du spécialiste d'un autre pour savoir de quoi souffre un patient ; il en a seulement besoin pour le soigner (C2).

Mesure : baisser la précision de la radiologie de 3 à 1 ne change rien au simulateur, parce qu'il suppose toutes les salles et tous les objets disponibles (réanimation à 2, traité de médecine à 2). À la table, en début de partie, seules les trois salles de départ existent : la radiologie y fait toute la différence.

### C5. Celui qui partage travaille pour un autre

| Action | Pièces | Réputation |
|---|---:|---:|
| Diagnostic | 1 | 0 |
| Guérison | 3 à 5 | +2 |

La victoire est individuelle : réputation personnelle et pièces ([règles de table §3](REGLES_DE_TABLE.md#3-pièces-réputation-et-points-de-victoire)). Quand les joueurs partagent, 60 à 80 % des guérisons sont faites par un joueur qui n'avait pas diagnostiqué le patient. Celui qui partage cède donc à un rival l'essentiel de la valeur du patient. L'écart de pièces entre le plus riche et le plus pauvre augmente : 9,5 pièces au lieu de 6,1 en Interne pour des novices avec laboratoire, 14,8 au lieu de 8,6 en Réanimation.

Rien ne récompense l'informateur. Seule la peur de la fermeture pousse à partager, et un joueur rationnel partagera le moins possible, au dernier moment.

L'action à deux joueurs ajoute un frein : elle compte comme le tour des deux ([règles de table §2](REGLES_DE_TABLE.md#2-tour-de-jeu)). Aider un autre à soigner coûte son propre tour au partenaire, qui ne partage que les jetons de cette action.

### C6. L'essai et l'erreur coûtent cher en réputation

Une guérison rapporte +2 de réputation, à tous les niveaux. Un échec coûte −1 (−2 pour les maladies graves), plus le bonus de difficulté ([modèle de jeu §10](MODELE_DE_JEU.md#10-difficulté)). Pour qu'un essai de traitement ne fasse pas perdre de réputation en moyenne, il doit réussir au moins :

| Niveau | Échec −1 | Échec −2 (maladies graves) |
|---|---:|---:|
| Interne | 33 % | 50 % |
| Chirurgien | 50 % | 60 % |
| Réanimation | 60 % | 67 % |

Agir sur le diagnostic d'un autre, ou essayer une recette devinée, devient vite perdant. C'est ce que montrent les novices sans laboratoire : le partage leur fait guérir plus de patients (43 % au lieu de 37 % en Interne), mais leur réputation par patient ne s'améliore pas, parce que plus de joueurs tentent des traitements et échouent. Le choix de ne moduler que les pertes ([revue, E5](REVUE_COHERENCE.md#e5)) rend chaque niveau plus dur, mais aussi plus hostile à la coopération.

### C7. Le laboratoire rend autonome et partage tout seul

Le laboratoire donne à un joueur seul un chemin complet : diagnostic, analyse, traitement. Avec un spécialiste, la plupart des maladies se révèlent en une analyse.

Deux règles réduisent encore l'intérêt de partager une recette :

- **le compteur de passages est commun** ([modèle de jeu §12.3](MODELE_DE_JEU.md#123-déroulement-dun-passage)) : les analyses des autres font avancer la mienne sans qu'ils aient à me parler ;
- **les recettes servent rarement deux fois** : sur 10 admissions, 5 % seulement sont une maladie déjà vue dans la partie (10 % sur 20 admissions, 14 % sur 30). Une recette sert surtout au patient en cours.

### C8. La menace commune n'est pas encore réglée

La défaite commune est la seule incitation à partager, et son seuil n'est pas fixé. Avec toutes les cartes à chacun, les vétérans gardaient une réputation positive, et la menace ne pesait rien ; les novices sans laboratoire fermaient l'hôpital à coup sûr, partage ou non. Avec cartes personnelles, la menace existe enfin : à écart égal, partager divise environ par deux les fermetures en Interne (§2). C'est sur ce mode qu'il faut régler le seuil.

### Limites des mesures

- Les stratégies ne lisent que le dernier diagnostic d'un patient : elles ne combinent pas plusieurs listes, ce qui sous-estime un peu la valeur des diagnostics partagés.
- Les joueurs simulés ne négocient pas : ils ne demandent pas « qui a un cardiologue ? », et ne gardent pas une information pour la monnayer.
- Les salles et les objets sont tous disponibles dès le départ : l'économie (construction, achats) n'est pas simulée.
- Une partie simulée compte 10 admissions, et tous les jetons vont à la piste de l'hôpital.

## 4. Pistes

Chaque piste vise une ou plusieurs causes. Les effets annoncés sont attendus, pas encore mesurés, sauf mention contraire.

| # | Piste | Causes | Effet attendu | Test au simulateur |
|---|---|---|---|---|
| P1 | **Rendre les médecins indispensables** : moins de recettes « objet dans une salle » (42 % → 20 à 25 %), ou des consommables qui exigent aussi un médecin de la spécialité | C2 | Un joueur soigne seul moins d'un patient sur trois : il doit orienter les autres vers un collègue | Contenu, mode cartes personnelles |
| P2 | **Rendre le diagnostic dépendant du spécialiste** : radiologie à 1 ou 2 de précision, `bonus_specialite` du diagnostic plus fort, ou précision maximale réservée aux combinaisons de la bonne spécialité | C4 | Le diagnostic sûr demande le bon spécialiste : l'avis d'un collègue devient précieux | Demande de simuler les salles construites peu à peu |
| P3 | **Prime à l'informateur** : à la guérison d'un patient, chaque joueur qui a partagé un diagnostic de ce patient reçoit 1 pièce, prise sur les gains de celui qui guérit (règle de table) | C5 | Partager rapporte, au lieu d'enrichir un rival | Stratégie qui partage selon le gain |
| P4 | **Prime au second avis** : un diagnostic fait par un médecin qui n'a pas encore examiné ce patient gagne 1 niveau de précision (l'appli connaît les cartes de chaque diagnostic) | C3 | Passer le patient à un collègue devient plus efficace que s'acharner seul | Nouvelle condition du moteur |
| P5 | **Récompenser autant que punir** : appliquer aussi le bonus de difficulté aux gains de réputation d'une guérison (+2, +3, +4) | C6 | Le seuil de rentabilité d'un essai passe à 33, 40 et 43 % : agir sur l'information d'un autre redevient raisonnable | Paramètre de difficulté |
| P6 | **Régler le seuil de fermeture sur le jeu réel** (cartes personnelles), pour que garder ses informations fasse souvent perdre (voir ci-dessous) | C8 | La menace commune pèse vraiment | Fait : rapport à cartes personnelles |
| P7 | **Alléger l'action à deux** : elle ne coûte plus le tour du partenaire, ou lui rapporte un jeton de plus | C5 | Coopérer au bloc opératoire ne coûte plus rien | Mode cartes personnelles |
| P8 | **Laboratoire** : un compteur de passages propre à chaque joueur, pour qu'une recette se transmette en la partageant ; ou une analyse payée sur le budget de l'hôpital, décidée en commun | C7 | Une recette devient une information à échanger | Variante du moteur |
| P9 | **Moins de patients en jeu que de joueurs** (N = 2 à 3 joueurs) | C2 | Plus de « mon patient » : les joueurs se partagent les mêmes patients | Fait : effet mitigé (ci-dessous) |

**Mesures déjà faites** (3 joueurs, cartes personnelles, 300 parties) :

- **P9** (2 patients en jeu au lieu de 3) : la guérison progresse et les fermetures reculent pour tous. En Interne, l'avantage du partage diminue pour les vétérans (85 % contre 81 %, au lieu de 84 % contre 75 %). En Réanimation, il grandit pour les novices au laboratoire (69 % contre 50 %, au lieu de 60 % contre 55 %).
- **P2** (radiologie à 1 de précision) : aucun effet tant que le simulateur suppose toutes les salles et tous les objets disponibles, puisque d'autres cartes atteignent la précision maximale (C4).

**Seuil de fermeture (P6).** Parties fermées selon l'écart entre départ et seuil, pour des vétérans à 3 joueurs avec cartes personnelles, partage / sans partage :

| Écart | Interne | Chirurgien | Réanimation |
|---:|---:|---:|---:|
| 10 | 11 % / 24 % | 24 % / 41 % | 41 % / 61 % |
| 15 | 5 % / 14 % | 14 % / 29 % | 26 % / 43 % |
| 20 | 2 % / 7 % | 7 % / 15 % | 18 % / 31 % |
| 30 | 0,5 % / 1 % | 1 % / 4 % | 6 % / 11 % |

Aucun écart ne rend aujourd'hui la défaite « quasi inévitable » sans partage tout en laissant gagner ceux qui partagent : l'écart entre les deux colonnes ne dépasse pas un facteur 2 à 3. Pour atteindre l'objectif du modèle de jeu (§8.6), il faut d'abord **augmenter la valeur du partage** (P1 à P5, P7), puis régler le seuil.

**Ordre proposé** : P1 et P3 d'abord, qui agissent sur les deux leviers principaux (besoin de l'autre, intérêt à partager) ; puis P5 et P7, simples à régler ; enfin P6, une fois les autres pistes mesurées.
