# CardHospital — Revue de cohérence des règles

Revue du 5 novembre 2026, faite sur `main` (commit `1b4ee46`). Elle couvre le README, `docs/*.md`, le schéma, l'exemple, `contenu/paquet_base.json`, et la partie du moteur (`packages/moteur`) qui applique les règles.

Chaque constat indique **où** se trouve le problème, **pourquoi** c'en est un, et une **proposition de correction**. La revue elle-même ne modifiait rien ; les corrections décidées ensuite sont suivies dans la section « Suivi des corrections » et dans la colonne « Suivi » du tableau. Les références de lignes et les noms cités dans les constats sont ceux de la version revue.

## Méthode

- Lecture croisée de tous les documents, du schéma, de l'exemple et du paquet de base.
- Vérifications faites **avec le moteur Dart du dépôt** (Dart 3.13.7 ; `dart test` : 115 tests passés) et avec son simulateur (`bin/simuler.dart`, 400 parties par stratégie et par difficulté, graine 1) lancé sur `contenu/paquet_base.json`.
- Statistiques du diagnostic obtenues avec une reproduction fidèle de `diagnostic.dart` (20 000 à 50 000 tirages par cas), à refaire avec les tests du dépôt après correction.
- Gravité :
  - **Bloquant** : règle cassée ou contradictoire, à corriger avant tout réglage ;
  - **Important** : ambiguïté ou déséquilibre qui change l'expérience de jeu ;
  - **Mineur** : rédaction ou cohérence entre documents.

## Ce qu'il faut traiter d'abord

1. **[B1](#b1)** : un `compte` sans `min` est toujours vrai. Résultat : les 114 exigences de salle du paquet de base sont ignorées.
2. **[B2](#b2)** : le motif `recherche` prévu, déclaré avant `standard`, rendrait impossible toute combinaison à 3 cartes hors du laboratoire.
3. **[T1](#t1)** : `generale` (une spécialité) et `generaliste` (aucune spécialité) se lisent presque pareil mais ont des effets opposés.
4. **[B4](#b4)** et **[E1](#e1)** : un diagnostic à précision maximale suffit souvent à trouver la bonne maladie avec certitude, et un traitement générique soigne 75 à 95 % des maladies d'une spécialité. Le diagnostic fin et le laboratoire perdent donc beaucoup de leur intérêt.
5. **[R1](#r1)**, **[R2](#r2)** et **[R3](#r3)** : la mise en place, le tour de jeu et la fin de partie ne sont pas définis. Aujourd'hui, la pression du temps n'existe que si les joueurs se l'imposent.

## Suivi des corrections

Corrections appliquées à la demande (même branche, après la revue) : **B1 à B5, T1 à T14 et D1 à D12**. Décisions prises ensuite pour **R1 à R7 et E2**, rédigées dans les [règles de table](REGLES_DE_TABLE.md). Les constats E1 et E3 à E15 ont ensuite été traités (voir ci-dessous).

Choix retenus :

- **B2 / B3** : le motif `recherche` est gardé, avec un accessoire facultatif (objet ou diplôme) pour les futurs objets d'aide à la recherche. Le moteur réunit désormais les actions de tous les motifs reconnus, et les préconditions rendent le laboratoire exclusif : il ne sert qu'à analyser, et aucune autre salle ne permet d'analyser. Le laboratoire (`SAL-011`) est dans le paquet de base. L'action `analyser` a ensuite été implémentée (voir « Laboratoire » ci-dessous), avec trois objets d'aide à la recherche.
- **B4** : `precision_max` passe de 5 à 4 et `par_niveau` de 1,5 à 0,8. **Mesure après correction** (paquet de base, précision maximale sans spécialité) : 17 % des diagnostics ont une tête à 95 ou plus (33 % avant), fausse dans 0,07 % des cas. Les quasi-certitudes sont deux fois plus rares, mais restent fiables quand elles apparaissent : le modèle de jeu le dit désormais (§8.1 et §8.4). La vraie maladie est en tête dans 55 % des diagnostics (69 % avant). Côté simulateur, les stratégies informées guérissent 90 à 93 % des patients en Interne (94 à 97 % avant) et 69 à 75 % en Réanimation (80 à 84 % avant).
- **T1** : la valeur neutre s'appelle `polyvalent` ; `generaliste` reste lu, avec un avertissement.
- **T3, T4, T7** : renommages faits directement en `schema_version` 1, qui peut encore évoluer tant qu'aucun paquet n'est publié (MOTEUR_EFFETS.md §8). `affinite_type` devient aussi `affinite_specialite`.
- **T5** : l'issue s'appelle « échec » partout ; les clés `pv_echec` et `reputation_echec` ne changent pas.
- **T7** : l'indice de suspicion s'affiche sans « % », avec une table de lecture dans le modèle de jeu (§8.1).
- **T14** : la couleur dominante est la couleur la plus présente dans la liste (« 3 bleus sur 5 ») ; en cas d'égalité, la mieux classée.
- **D3** : le catalogue cible est aligné sur le paquet de base (12 patients, 21 objets et diplômes, 11 salles, 103 maladies), puisque les patients sortis retournent dans la pioche.
- **D4** : l'exemple est maintenant un sous-ensemble exact du paquet de base (18 cartes, 6 maladies), vérifié par un test.

Décisions sur les règles manquantes (R1 à R7) et les traitements (E2) :

- **R3 (jetons)** : le joueur qui agit répartit tous les jetons, pertes de réputation comprises ; il peut prendre un −1 pour lui afin d'éviter la fermeture. Une action à deux joueurs (bloc opératoire) se partage entre eux et compte comme le tour des deux.
- **R1, R3, R4, R5, R7** : rédigées dans un nouveau document, les [règles de table](REGLES_DE_TABLE.md) — mise en place, tour, partage des gains, points de victoire, constructions, objets permanents et consommables, formation, absence de bluff, annulation réservée aux erreurs de scan. L'appli n'est pas intrusive : elle gère les maladies et les résultats, rien de plus. Les patients morts sont défaussés.
- **R2** : le temps devient une **horloge commune** ([modèle de jeu §5](MODELE_DE_JEU.md#5-horloge-et-aggravation)). Chaque diagnostic, traitement ou analyse confirmé est un tick, quel que soit le patient ; l'hôte note le tick d'admission de chaque patient. L'aggravation dépend de la durée de présence, par paliers communs (stable de 0 à 4 ticks, puis paliers à 5, 11, 17 et 23 ticks), avec une perte propre à chaque maladie (sa liste `aggravation`). Elle est appliquée à chaque action sur le patient (diagnostic, analyse, échec de traitement), sans rattrapage ; ni la guérison ni le traitement partiel n'aggravent. L'attente maximale passe en ticks de présence : les valeurs du paquet de base sont multipliées par 3 (3 patients en jeu font avancer l'horloge environ 3 fois plus vite qu'un patient seul). Le simulateur fait jouer plusieurs patients à la fois. Au tour de jeu, le joueur admet un patient s'il y en a moins de N en jeu (règles de table §2).
- **R6** : réanalyse possible, recette privée comme un diagnostic, compteur de passages commun à toute la partie ([modèle de jeu §12.3](MODELE_DE_JEU.md#123-déroulement-dun-passage)).
- **E2** : les traitements sont secrets. Les stratégies du simulateur, qui les connaissent, jouent comme des vétérans : leurs taux de guérison sont des plafonds.
- Les points encore ouverts sont listés dans les [règles de table §11](REGLES_DE_TABLE.md#11-points-à-préciser).

Équilibrage et pertinence (E1, E3 à E15) :

- **E1, E3, E8, E9, E10** : paquet de base refondu (version 2.0.0). Chaque spécialité a 5 à 7 **familles de traitements** ; une recette est un spécialiste dans une salle, un objet dans une salle, ou deux médecins, jamais un spécialiste **et** un objet (la place d'accessoire est unique, et un médecin muni d'un diplôme doit pouvoir remplacer le spécialiste). Aucune combinaison ne soigne plus de 35 % des maladies d'une spécialité (75 à 95 % auparavant). Les PV initiaux vont de 6 à 16 et suivent, comme l'aggravation, l'attente, les poids et les récompenses, un **gabarit de gravité identique** pour toutes les spécialités : aucune valeur de PV n'appartient à plus de 25 % à une même spécialité. Le plâtre, le tensiomètre et l'anti-inflammatoire ont leurs recettes ; tous les diplômes donnent +1 de précision ; le bloc opératoire et la pharmacie sont polyvalents ; chaque médicament soigne sa famille (antibiotique, antalgique, anti-inflammatoire, sirop, glucose) en consultation ou à la pharmacie. Noms rendus distincts : décalage horaire, rage de dents, laryngite, fêlure du coccyx, somnambulisme, agoraphobie, hyperactivité de l'adulte, tics nerveux, extrasystoles, rejet de greffe cardiaque, brûlure lunaire, poltergeist domestique.
- **E4, E5** : la difficulté ajoute un **bonus entier** (+0, +1, +2) aux pertes de PV, aux gains de pièces et aux pertes de réputation ; chaque niveau est un cran plus dur que le précédent sur chaque ligne de la table effective (modèle de jeu §10). Les gains de réputation ne changent pas.
- **E6** : aucune pièce pour une action pendant laquelle le patient meurt. Enchaîner les diagnostics fait avancer l'horloge, donc vieillir tous les patients.
- **E7** : « 2 médecins d'une spécialité » exige deux vrais médecins (un spécialiste et un médecin muni du diplôme, ou deux spécialistes) ; la combinaison standard accepte donc 2 médecins **et** 1 accessoire. Un polyvalent muni d'un diplôme remplace un spécialiste : c'est voulu. Le diplôme s'obtient lentement (règles de table §7).
- **E11** : le simulateur joue 2 ou 3 joueurs à tour de rôle, avec informations partagées ou privées ([rapport à 3 joueurs](simulations/rapport_paquet_base_3_joueurs.md)). En partageant, 74 à 80 % des guérisons sont faites par un joueur qui n'avait pas diagnostiqué le patient : le dilemme existe. Mais **le partage ne change pas le taux de guérison** de l'équipe (97 à 98 % en Interne, 84 à 86 % en Réanimation, partage ou non) : l'objectif « défaite quasi inévitable sans partage » n'est pas atteint, parce que les stratégies connaissent les traitements et qu'un diagnostic à précision maximale suffit souvent.
- **E2 (suite)** : stratégie `novice:X` ajoutée au simulateur : elle ne connaît pas les traitements et les apprend pendant la partie (carnet de recettes, commun quand les joueurs partagent). Elle ne guérit que 30 % des patients en Interne, contre 96 % pour un vétéran. À 3 joueurs, le partage l'aide : 45 % de guérisons au lieu de 31 %, mais avec plus de traitements ratés, donc une réputation par patient aussi négative, voire plus.
- **Laboratoire** : l'action `analyser` est implémentée, dans `schema_version` 1 ([modèle de jeu §12](MODELE_DE_JEU.md#12-recherche-en-laboratoire)) : choix d'une maladie suspectée, compteur de passages commun (au moins 2 passages : 2 aux paliers de gravité A et B, 3 au palier C, 4 au palier D), recette rédigée en français, trois objets d'aide à la recherche (microscope, centrifugeuse, séquenceur d'ADN) ; un médecin de la spécialité de la maladie compte pour un passage de plus. Une analyse n'est utile que sur la vraie maladie : le simulateur mesure qu'au seuil 70, 76 % des analyses portent sur la bonne, 93 % au seuil 80. Au simulateur, un novice qui l'utilise (`novice+labo:70`) guérit 89 % des patients en Interne, contre 30 % sans laboratoire : le laboratoire efface presque l'écart avec un vétéran, et le partage ne l'aide plus. Son prix de construction et le coût d'une analyse restent à régler.
- **E12** : le bruit du diagnostic est pondéré par `(poids / poids moyen)^0,25`.
- **E13** : sont imprimés l'image, le QR, le type, le nom, la spécialité et les capacités ; une extension ne peut pas les modifier ; le validateur compare les cartes au catalogue embarqué quand on le lui fournit.
- **E14** : champ `lieu_phrase` des salles et variable `{lieu}` (« en radiologie », « à la pharmacie »).
- **E15** : exigence de conformité ajoutée (spécification §9) ; nouvelle palette : contraste d'au moins 3:1 sur fond clair et sombre, écart d'au moins 25 entre deux spécialités en protanopie, deutéranopie et tritanopie (l'ancienne tombait à 5) ; le validateur avertit sinon.

## Tableau des constats

| # | Constat | Gravité | Suivi |
|---|---|---|---|
| [B1](#b1) | Un `compte` sans `min` est toujours vrai : les salles exigées sont ignorées | Bloquant | Corrigé |
| [B2](#b2) | Le motif `recherche` déclaré en tête bloquerait les combinaisons standard à 3 cartes | Bloquant | Corrigé |
| [B3](#b3) | La capacité `recherche` est donnée aux objets et diplômes, mais le motif `recherche` n'accepte pas d'accessoire | Bloquant | Corrigé |
| [B4](#b4) | « Aucun signal n'est certain » est faux : une tête de liste à 95 % ou plus n'est jamais fausse | Important | Corrigé (`precision_max` 4, `par_niveau` 0,8 ; voir le suivi) |
| [B5](#b5) | Le paquet de base n'est ni validé ni simulé en intégration continue | Important | Corrigé |
| [T1](#t1) | `generale` et `generaliste` | Important | Corrigé |
| [T2](#t2) | « Retiré » se lit « supprimé » alors qu'il veut dire « tiré à nouveau » | Mineur | Corrigé |
| [T3](#t3) | `type` désigne tantôt la nature de la carte, tantôt la spécialité de la maladie | Mineur | Corrigé |
| [T4](#t4) | La famille de mots « soin » a cinq sens différents | Mineur | Corrigé |
| [T5](#t5) | « Échec » et « inadapté » désignent la même issue | Mineur | Corrigé (« échec ») |
| [T6](#t6) | Le traitement « partiel » censé stabiliser peut faire perdre des PV | Important | Corrigé |
| [T7](#t7) | Le « pourcentage de confiance » n'est pas une probabilité | Important | Corrigé |
| [T8](#t8) | « L'appli ne gère pas deux diagnostics en parallèle » se lit comme une interdiction | Mineur | Corrigé |
| [T9](#t9) | L'admission « pour la première fois » contredit la réadmission | Mineur | Corrigé |
| [T10](#t10) | Les messages d'exemple font des accords, contrairement à la règle de style | Mineur | Corrigé |
| [T11](#t11) | Fermeture de l'hôpital : « sous le seuil » ou « réputation à 0 » ? | Mineur | Corrigé |
| [T12](#t12) | « 2 médecins » peut vouloir dire 1 médecin + 1 diplôme | Important | Corrigé (encadré) |
| [T13](#t13) | « Attente dépassée » : on ne sait pas à partir de quelle action elle s'applique | Mineur | Corrigé |
| [T14](#t14) | La couleur dominante oblige à additionner des pourcentages de tête | Mineur | Corrigé (couleur la plus présente) |
| [D1](#d1) | Exemples restés sur l'ancien jeu (psychologie, chirurgie, pharmacie) | Mineur | Corrigé |
| [D2](#d2) | Le tableau du §8.4 est calculé pour 3 spécialités, le paquet de base en a 5 | Important | Corrigé |
| [D3](#d3) | Chiffres du catalogue contradictoires entre les documents et le paquet de base | Mineur | Corrigé |
| [D4](#d4) | Un même identifiant de carte désigne des cartes différentes selon le fichier | Important | Corrigé |
| [D5](#d5) | Plan de codage périmé (paquet intermédiaire, `--help`, règle 3…) | Mineur | Corrigé |
| [D6](#d6) | « Maladie révélée : jamais » pour l'analyse, alors que l'analyse peut tuer le patient | Mineur | Corrigé |
| [D7](#d7) | Maladies suspectées « affichées » au diagnostic, mais aucun champ prévu dans le résultat | Mineur | Corrigé |
| [D8](#d8) | « La salle porte la précision de base (1) », alors que deux salles ont 0 | Mineur | Corrigé (texte) ; précision de la pharmacie et de la plâtrerie inchangée |
| [D9](#d9) | « Aucune piste » au laboratoire : refus ou action ? Aucune condition ne permet de l'exprimer | Mineur | Corrigé |
| [D10](#d10) | 2 à 3 joueurs, mais critères de test à 8 téléphones | Mineur | Corrigé |
| [D11](#d11) | Message d'erreur « 4 cartes total maximum. » | Mineur | Corrigé |
| [D12](#d12) | Aucune carte laboratoire dans le paquet de base, et les 10 salles sont déjà prises | Mineur | Corrigé |
| [R1](#r1) | Mise en place incomplète | Important | Décidé : règles de table §1 ; formation à créer |
| [R2](#r2) | Tour de jeu non défini : un patient laissé de côté ne s'aggrave jamais | Important | Corrigé : horloge commune et paliers (modèle de jeu §5) |
| [R3](#r3) | Victoire individuelle et fin de partie non définies | Important | Décidé : règles de table §3 et §4 |
| [R4](#r4) | Économie non définie : prix, propriété des cartes, cartes des autres joueurs | Important | Décidé : règles de table §2, §5 et §6 |
| [R5](#r5) | Partage des diagnostics : a-t-on le droit de mentir ? | Mineur | Corrigé : règles de table §8 |
| [R6](#r6) | Laboratoire : réanalyse, diffusion des recettes, effet de la capacité `recherche` | Mineur | Décidé et implémenté : modèle de jeu §12 |
| [R7](#r7) | L'annulation permet de voir un diagnostic gratuitement ou de relancer un tirage | Important | Corrigé : règles de table §10, sans code |
| [E1](#e1) | Traitements génériques : connaître la spécialité suffit presque toujours | Important | Corrigé : familles de traitements (≤ 35 % par combinaison) |
| [E2](#e2) | Traitements « connus via le livret de règles », mais laboratoire chargé de les révéler | Important | Décidé : règles de table §9 ; stratégies `novice` et `novice+labo` simulées |
| [E3](#e3) | Les PV et l'attente trahissent la maladie | Important | Corrigé : gabarit de gravité commun (≤ 25 % par valeur de PV) |
| [E4](#e4) | Arrondis : Chirurgien et Réanimation donnent le même résultat sur les petites valeurs | Important | Corrigé : bonus +0/+1/+2, table effective (modèle §10) |
| [E5](#e5) | Le modificateur de réputation s'applique aussi aux gains : Réanimation est plus facile | Important | Corrigé : pertes seulement |
| [E6](#e6) | Pièces gagnées même si le patient meurt, et diagnostics répétables pour gagner des pièces | Important | Corrigé : aucune pièce si mort ; l'horloge freine les diagnostics à répétition |
| [E7](#e7) | Le diplôme rend la spécialité du médecin presque inutile | Important | Corrigé : 2 vrais médecins ; polyvalent + diplôme voulu ; diplôme chronophage |
| [E8](#e8) | Cartes sans usage ou incohérentes (Plâtre, Tensiomètre, Pharmacie…) | Mineur | Corrigé |
| [E9](#e9) | Recettes peu crédibles (sirop antitussif contre la conjonctivite…) | Mineur | Corrigé : médicaments par famille, lieu de soins |
| [E10](#e10) | Noms de maladies trop proches d'une spécialité à l'autre | Mineur | Corrigé |
| [E11](#e11) | Objectif « défaite quasi inévitable sans partage » ni mesurable ni mesuré | Important | Simulé à 3 joueurs : dilemme mesuré, partage sans effet sur la guérison |
| [E12](#e12) | Le diagnostic ignore la fréquence des maladies (`poids`) | Mineur | Corrigé : pondération 0,25 |
| [E13](#e13) | Une extension peut changer des attributs imprimés sur les cartes | Mineur | Corrigé : attributs imprimés non modifiables, contrôle du catalogue |
| [E14](#e14) | Prépositions des salles dans les phrases (« dans la réanimation ») | Mineur | Corrigé : `lieu_phrase` et `{lieu}` |
| [E15](#e15) | Couleurs de spécialités proches ou peu contrastées | Mineur | Corrigé : exigence ajoutée, palette conforme, contrôle au validateur |

---

## 1. Bugs et contradictions bloquantes

<a id="b1"></a>
### B1. Un `compte` sans `min` est toujours vrai — Bloquant

**Où** : `packages/moteur/lib/moteur/combinaison.dart:81-83` ; schéma `jeu.schema.json:254` (`min` facultatif) ; `MOTEUR_EFFETS.md` §5, l. 150 (« Au moins `min` ») ; `contenu/paquet_base.json` (114 occurrences, par exemple l. 530).

**Constat** : `{"compte": {"type": "salle", "id": "SAL-007"}}`, sans `min` ni `max`, n'impose rien : le moteur répond « vrai » même si la carte est absente. Le paquet de base utilise cette forme pour **toutes** les salles qu'il exige par identifiant : Pharmacie 15 fois, Salle de consultation 20, Salle de psychiatrie 20, Bloc opératoire 16, Plâtrerie 20, Salle expérimentale 20, Salle d'isolement 3.

**Vérifié avec le moteur** :
- un rhume carabiné est soigné en Radiologie avec l'antalgique, sans passer par la Pharmacie ;
- un burn-out est soigné en Réanimation par un psychiatre, sans salle de psychiatrie ;
- les 20 maladies de médecine générale dont le traitement partiel est `un_de [médecin de médecine générale, salle de consultation]` ne peuvent **jamais** aboutir à un traitement inadapté ;
- le validateur accepte le paquet sans aucune erreur ni avertissement : la règle 7 (traitement réalisable) est satisfaite d'office.

**Impact mesuré** (simulateur, niveau Interne) :

| Stratégie | Guérison, paquet actuel | Guérison, paquet corrigé |
|---|---:|---:|
| `hasard` | 38,6 % (dont 12 patients abandonnés après 60 actions, soignés partiellement sans fin) | 4,8 % |
| `seuil:70` | 98,0 % | 96,8 % |

**Proposition** :
1. **Contenu** : remplacer `{"compte": {"type": "salle", "id": "SAL-XXX"}}` par `{"carte": "SAL-XXX"}`, la forme prévue pour exiger une carte précise.
2. **Règle et moteur** : écrire dans MOTEUR §5 que `min` vaut 1 quand ni `min` ni `max` n'est donné (et ajouter `"default": 1` dans le schéma). Autre possibilité : rendre l'un des deux obligatoire dans le schéma (`anyOf: [{required: [min]}, {required: [max]}]`).
3. **Validateur** : avertir pour un prédicat toujours vrai, et pour une maladie qu'aucune combinaison ne peut traiter de façon inadaptée.
4. **Intégration continue** : voir [B5](#b5).

<a id="b2"></a>
### B2. Le motif `recherche` déclaré en tête bloquerait les combinaisons à 3 cartes — Bloquant

**Où** : `MOTEUR_EFFETS.md` §9.2 (l. 273-283) et §9.3 (l. 287-290) ; `MODELE_DE_JEU.md` §3.1, l. 74 ; D23 ; `reconnaissance.dart:56` (le premier motif reconnu l'emporte) ; `partie.dart:190-198`.

**Constat** : le moteur retient le premier motif qui correspond à la sélection, sans essayer les suivants. Or le motif `recherche` (1 médecin + 1 patient + 1 salle) correspond à **n'importe quelle** salle : un motif ne connaît pas les spécialités.

Avec la conception prévue, « médecin + patient + salle de consultation » serait donc capté par `recherche`. L'action `analyser` serait ensuite écartée (ce n'est pas un laboratoire), et l'hôte répondrait « Aucune action possible avec ces cartes. »

Vérifié en ajoutant le motif au paquet de base :
- avec 3 cartes, la sélection est refusée ;
- avec 4 cartes, on obtient bien `diagnostiquer` et `traiter`.

Toutes les recettes à 3 cartes deviendraient irréalisables, par exemple l'hypertension (cardiologue + salle de cardiologie). Au laboratoire, le comportement serait lui aussi incohérent : avec 3 cartes on ne pourrait qu'analyser, avec 4 cartes on ne pourrait que diagnostiquer ou traiter.

**Proposition**, sans changement de moteur (le filtre des actions par précondition de combinaison existe déjà) :
- supprimer le motif `recherche` ;
- déclarer `analyser` sur le motif `standard`, avec la précondition :

```json
{ "et": [ "patient_en_jeu",
          { "combinaison": { "compte": { "type": "salle", "specialite": "recherche" }, "min": 1 } } ] }
```

- si l'on ne veut pas diagnostiquer ni traiter au laboratoire, ajouter la condition inverse (`non`) aux préconditions de `diagnostiquer` et `traiter`.

*Autre solution* : la reconnaissance réunit les actions de **tous** les motifs qui correspondent, puis les filtre par précondition. La règle « le premier déclaré l'emporte » disparaît alors.

À mettre à jour dans les deux cas : MODELE §3.1, MOTEUR §3 et §9.2, D23, PLAN étape 10.

<a id="b3"></a>
### B3. La capacité `recherche` ne peut jamais servir — Bloquant

**Où** : `MODELE_DE_JEU.md` §12.6, l. 354 ; `MOTEUR_EFFETS.md` §9.6, l. 311, et §9.2, l. 277 (motif `recherche` limité à 3 cartes).

**Constat** : la capacité est prévue pour les médecins, les objets et les diplômes. Mais le motif `recherche` n'accepte aucun accessoire, et aucun médecin du paquet n'a cette capacité. Elle est donc inutilisable.

**Proposition** : la solution de [B2](#b2) (motif standard) accepte un accessoire et règle le problème. Si l'on garde un motif dédié, lui ajouter `"objet|diplome": [0, 1]` et un total `[3, 4]`.

<a id="b4"></a>
### B4. « Aucun signal n'est certain » est faux pour les têtes de liste à 90 % ou plus — Important

**Où** : `MODELE_DE_JEU.md` §8.1, l. 191-193, et §8.4, l. 247 (« sans qu'aucun seuil ne soit infaillible ») ; D11.

**Mesure** (paquet de base, maladie tirée selon son `poids`, diagnostic sans spécialité) :

| N | Tête ≥ 90 % (part des diagnostics) | Erreurs | Tête ≥ 95 % (part des diagnostics) | Erreurs |
|---|---:|---:|---:|---:|
| 1 | 16,7 % | 0,8 % | 9,8 % | 0,06 % |
| 5 | 42,0 % | 0,2 % | 32,8 % | **0 sur 16 400** |

N = 5 s'obtient sans aucune spécialité : Radiologie (3) + Dr Moreau (1) + Traité de médecine (2), plafonné à 5. Un tiers des diagnostics à précision maximale donne donc une certitude de fait.

Ajouté à [E1](#e1), cela veut dire qu'un diagnostic suffit presque toujours : le simulateur guérit 97 à 98 % des patients en Interne, avec 1,5 diagnostic par patient.

**Proposition**, à choisir :
- (a) **assumer** et réécrire : « Une tête de liste à 95 % ou plus est quasi certaine ; en dessous, rien n'est sûr. »
- (b) **rétablir l'incertitude** : plafonner l'affichage plus bas (90 %), baisser `par_niveau` (1,5 → 0,8) ou `precision_max` (5 → 4), ou ajouter un bruit propre à la vraie maladie.

Dans les deux cas, régler au simulateur sur le paquet de base avec un objectif chiffré, par exemple au moins 5 % d'erreurs même pour une tête à 95 %.

<a id="b5"></a>
### B5. Le paquet de base n'est ni validé ni simulé en intégration continue — Important

**Où** : `.github/workflows/moteur.yml` (seul l'exemple est validé) ; `PLAN_DE_CODAGE.md` §4.

**Constat** : le paquet réellement joué n'est testé nulle part, et [B1](#b1) est passé inaperçu.

**Proposition** : ajouter un test `test/paquet_base_test.dart` qui vérifie que :
- `contenu/paquet_base.json` passe la validation sans erreur ;
- aucune maladie n'est soignée par plus de X % des combinaisons ;
- chaque maladie a au moins une combinaison qui donne un traitement inadapté.

Publier aussi un rapport de simulation de référence pour ce paquet (`docs/simulations/rapport_paquet_base.md`).

---

## 2. Termes confus ou ambigus

<a id="t1"></a>
### T1. `generale` et `generaliste` — Important

**Où** : `MODELE_DE_JEU.md` §1.1 (l. 20), §2.1 (l. 35) et §8.2 (l. 201) ; `MOTEUR_EFFETS.md` §2.1, l. 69 ; `combinaison.dart:4` ; dans le paquet de base : MED-001, MED-002, SAL-001, SAL-003, SAL-009, SAL-010, DIP-001.

**Constat** : deux identifiants presque identiques, aux effets opposés.
- **`generale`** est la **spécialité** « Médecine générale » : 23 maladies, couleur bleue, icône 🩺. Elle **compte** dans les spécialités de la combinaison, donc dans la concordance et l'exclusion du diagnostic, et dans les traitements.
- **`generaliste`** est la **valeur neutre**, « sans spécialité ». Elle est **ignorée**.

Or, en français, un « médecin généraliste » est justement un médecin de médecine générale. Exemples concrets dans le paquet de base :
- **Dr Moreau** (`generaliste`) et **Dr Lefort** (`generale`) passent tous deux pour des « généralistes » : l'un est neutre, l'autre spécialiste.
- La **Salle de consultation** (`generale`), la plus « généraliste » des salles, n'est pas neutre. Un diagnostic qu'on y fait en le croyant neutre teste en réalité la médecine générale : il fait reculer toutes ses maladies si le patient a une autre maladie, et les favorise sinon. À l'inverse, la Radiologie, la Salle d'isolement et la Réanimation sont neutres.
- Dr Moreau + Diplôme de médecine générale donne un « généraliste diplômé de médecine générale », qui change de spécialité.
- Le §8.2 parle de « salle généraliste : 1 » en pensant à la salle de consultation de l'exemple, qui est `generale` dans le paquet de base.
- Une troisième forme existe : l'absence de `specialite` (Pharmacie, Stéthoscope…) vaut aussi « neutre ».

**Proposition** :
- **Renommer la valeur neutre** : `generaliste` → `polyvalent`, affiché « Polyvalent » ou « Sans spécialité ». Elle reste réservée et implicite. À la lecture, `generaliste` est encore accepté comme ancien nom, avec un avertissement.
- **Une seule façon d'exprimer la neutralité** : « champ `specialite` absent = `polyvalent` », écrit dans MOTEUR §2.1.
- Garder `generale` / « Médecine générale ».
- Ajouter au glossaire « Médecine générale » et « Polyvalent (sans spécialité) ».
- Dans la prose, écrire « salle polyvalente » et « médecin polyvalent », jamais « généraliste ».

*Autre solution* : garder `generaliste` et renommer la spécialité (par exemple `courante`, « Pathologies courantes »). C'est moins naturel, car « médecin généraliste » restera compris comme « médecine générale ».

<a id="t2"></a>
### T2. « Retiré » — Mineur

**Où** : GLOSSAIRE l. 24 (« il est retiré à chaque diagnostic ») ; `MODELE_DE_JEU.md` §8.1, l. 183 (« la liste est retirée à chaque diagnostic ») ; D11 (« retiré à chaque fois »).

**Constat** : « retiré » se lit d'abord « enlevé », alors que le sens voulu est « tiré à nouveau ». Le lecteur peut croire que la liste disparaît.

**Proposition** : écrire « La liste est **tirée à nouveau** à chaque diagnostic » (ou « chaque diagnostic fait un nouveau tirage »).

<a id="t3"></a>
### T3. `type` a deux sens — Mineur

**Où** : `MOTEUR_EFFETS.md` §2.1 (type de carte), §2.2 (`type` d'une maladie) et §5 (filtre `type`) ; `MODELE_DE_JEU.md` §8 (« vrai type ») ; GLOSSAIRE l. 11.

**Constat** : dans un même fichier, `type` désigne la nature d'une carte (`medecin`, `salle`…) dans les cartes et les filtres, mais la **spécialité** dans une maladie. On lit donc `compte {type: medecin, specialite: cardiologie}` à côté de `"type": "cardiologie"`.

**Proposition** :
- en `schema_version` 2 (une migration de v1 vers v2 est déjà prévue), renommer `maladies[].type` en `specialite` ;
- dans les documents, écrire « spécialité de la maladie » et « vraie spécialité » plutôt que « type » et « vrai type ».

<a id="t4"></a>
### T4. La famille de mots « soin » — Mineur

**Où** : capacité `soin` (`paquet_base.json` l. 103 : « PV supplémentaires rendus par un traitement partiel ») ; récompenses `soin_partiel` et `reputation_soin` ; effet `soigner` ; issue `soigne` ; phrase « Tentative de soin… » ; message « est guéri » (MODELE l. 108).

**Constat** : « soin » désigne tour à tour un bonus du traitement partiel, la guérison, l'action elle-même et un gain de réputation. La capacité `soin` ne sert **qu'au** traitement partiel, ce que son nom ne dit pas. L'issue s'appelle « soigné » mais le message dit « guéri ».

**Proposition** :
- pour l'issue et l'état final, « guéri » partout (`gueri`) ;
- capacité `soin` → `stabilisation` ;
- `soin_partiel` → `pv_partiel` ;
- `reputation_soin` → `reputation_guerison` ;
- garder « soigner » et « traiter » pour l'acte.

<a id="t5"></a>
### T5. « Échec » et « inadapté » — Mineur

**Où** : `MODELE_DE_JEU.md` §6 (l'issue s'appelle « inadapté ») ; les clés correspondantes s'appellent `pv_echec` et `reputation_echec`.

**Proposition** : renommer en `pv_inadapte` et `reputation_inadapte`, ou bien appeler l'issue « échec » partout.

<a id="t6"></a>
### T6. Le traitement « partiel » peut faire perdre des PV — Important

**Où** : `MODELE_DE_JEU.md` §2.3 (l. 61, « stabilise ») et §6 (l. 129) ; GLOSSAIRE l. 27 (« partiel → gain de PV ») ; question ouverte 7.

**Constat** : le traitement partiel donne 2 PV + la capacité `soin`, sans modificateur de difficulté et plafonné à `pv_initial`. **Ensuite** vient l'aggravation, qui, elle, subit le modificateur. Exemples :
- Interne, aggravation 2 : bilan 0 ;
- Réanimation, aggravation 2 (×2 = 4) : bilan −2 ;
- patient déjà à ses PV maximum : le plafond s'applique avant l'aggravation, d'où une perte nette.

Le joueur lit « le patient gagne 2 PV » et voit ses PV baisser.

**Proposition** (recommandée) : dispenser le traitement partiel d'aggravation, pour qu'il stabilise vraiment. Dans `traiter`, la condition de l'effet `aggraver` deviendrait :

```json
{ "non": { "ou": [ "soigne", "traitement_partiel" ] } }
```

*Autre solution* : le renommer « traitement palliatif » et écrire en clair « +2 PV, puis aggravation normale ».

<a id="t7"></a>
### T7. Le « pourcentage de confiance » n'est pas une probabilité — Important

**Où** : `MODELE_DE_JEU.md` §8.1, l. 180 et l. 191 (« chacun mesure la confiance que cette maladie est la bonne »).

**Mesure** : sur toutes les lignes affichées (sans spécialité, N = 1), part des lignes qui correspondent à la vraie maladie, selon le pourcentage affiché :

| Affiché | 40-49 % | 50-59 % | 60-69 % | 70-79 % | 80-89 % | 90-99 % |
|---|---:|---:|---:|---:|---:|---:|
| Réellement juste | 3 % | 4 % | 11 % | 30 % | 74 % | 99 % |

**Constat** : un joueur lira « 60 % » comme « 6 chances sur 10 », alors que c'est juste une fois sur 10. Ce chiffre est une échelle de suspicion, pas une probabilité.

**Proposition**, à choisir :
- renommer en « **indice de suspicion** » et donner dans la règle une table de lecture (moins de 70 : piste faible ; 70 à 89 : piste sérieuse ; 90 et plus : quasi sûr) ;
- ou recalibrer l'affichage pour qu'il approche la fréquence réelle (courbe mesurée au simulateur). Les lignes ne feraient toujours pas 100 au total, mais chaque chiffre aurait un sens.

<a id="t8"></a>
### T8. « L'appli ne gère pas deux diagnostics en parallèle » — Mineur

**Où** : README l. 7 ; `MODELE_DE_JEU.md` §1, l. 11 ; `SPECIFICATION.md` §1, l. 21 ; D24.

**Constat** : la phrase se lit « l'appli refuse deux diagnostics simultanés ». C'est l'inverse de SPEC §5.4 (« Chaque scan compte » : deux confirmations font deux actions).

**Proposition** : « L'appli n'impose aucun ordre de jeu et **ne bloque pas** deux actions simultanées : c'est aux joueurs de jouer chacun leur tour. »

<a id="t9"></a>
### T9. L'admission « pour la première fois » — Mineur

**Où** : `MODELE_DE_JEU.md` §4.1, l. 98 ; D10.

**Constat** : la formule contredit la réadmission décrite au §4.2.

**Proposition** : « Un patient entre en jeu quand sa carte, **hors jeu**, est scannée seule. »

<a id="t10"></a>
### T10. Messages avec accord, contraires à la règle de style — Mineur

**Où** : `MODELE_DE_JEU.md` §4.1, l. 102 (« M. Dupont est admis — 10 PV ») et §4.2, l. 108 (« M. Dupont est guéri de sa péritonite »). La même section proscrit pourtant « n'est pas admis », qui deviendrait fautif pour Mme Garnier. Au passage, la péritonite n'existe dans aucun paquet.

**Proposition** : passer au style nominal partout : « Admission de M. Dupont — 10 PV », « Guérison de M. Dupont (fracture fermée) », « Décès de Mme Garnier (arythmie) ».

<a id="t11"></a>
### T11. Seuil de fermeture ou « réputation à 0 » — Mineur

**Où** : `MODELE_DE_JEU.md` §7.1 (l. 168, « sous le seuil ») et §8.6 (l. 261, « réputation de l'hôpital à 0 ») ; D25 ; README l. 9 (« tombe sous un seuil »).

**Proposition** : une formule unique, par exemple « si la réputation devient **strictement inférieure** au seuil de fermeture », et remplacer partout « à 0 » par « sous le seuil de fermeture ».

<a id="t12"></a>
### T12. « 2 médecins » qui peuvent être 1 médecin + 1 diplôme — Important

**Où** : `MODELE_DE_JEU.md` §6, l. 140 ; `MOTEUR_EFFETS.md` §5, l. 157 ; recettes du §12.3 (« 2 médecins chirurgie + le bloc opératoire ») ; paquet de base : fracture ouverte et fracture du fémur (`min: 2` orthopédistes).

**Constat** : un diplôme de spécialité X ne compte comme médecin X que si le filtre demande **à la fois** `type: medecin` et `specialite: X`. Les cas sont subtils :
- `compte {type: medecin}`, sans spécialité, ne compte pas le diplôme ;
- `non compte {type: medecin, specialite: X}` exclut aussi le diplôme ;
- avec le diplôme de médecine générale en main, toute combinaison obtient au moins un traitement partiel pour la médecine générale.

La recette générée « 2 médecins orthopédie + bloc » trompera le joueur qui n'a qu'un orthopédiste, alors que son diplôme d'orthopédie suffit à compléter.

**Proposition** :
1. Générer des recettes exactes : « 2 médecins ou diplômes d'orthopédie + le bloc opératoire ».
2. Ajouter dans la règle un encadré « Diplôme » qui décrit ces trois cas.
3. Ou rendre l'équivalence explicite dans le JSON (`type: ["medecin", "diplome"]` là où elle est voulue) et supprimer l'équivalence implicite : le JSON est plus long, mais aucune règle cachée.

<a id="t13"></a>
### T13. « Attente dépassée » : à partir de quelle action ? — Mineur

**Où** : `MODELE_DE_JEU.md` §5 (l. 120) et §2.3 (l. 58) ; GLOSSAIRE l. 23.

**Constat** : le temps avance avant le test. Avec `attente_max = 5`, c'est la **6ᵉ** action qui coûte de la réputation, y compris celle qui guérit. « Chaque action supplémentaire » peut se lire « dès la 5ᵉ ». De plus, `attente_max` est caché, puisqu'il dépend de la maladie.

**Proposition** : « À partir de la (`attente_max` + 1)ᵉ action sur ce patient, chaque action, même celle qui le guérit, coûte `reputation_attente`. Exemple : avec une attente de 5, la 6ᵉ action est la première pénalisée. »

<a id="t14"></a>
### T14. La couleur dominante est difficile à calculer de tête — Mineur

**Où** : `MODELE_DE_JEU.md` §8.4, l. 245 ; GLOSSAIRE.

**Constat** : la couleur dominante est définie comme la couleur dont les maladies totalisent le plus de pourcentage. Il faut additionner jusqu'à cinq nombres de tête.

**Proposition** : soit l'appli affiche la couleur dominante (ou le total par couleur), soit la règle adopte un critère simple, par exemple « la couleur la plus présente parmi les 3 premières lignes ».

---

## 3. Incohérences entre documents et contenu

<a id="d1"></a>
### D1. Exemples restés sur l'ancien jeu — Mineur

**Où** :
- GLOSSAIRE l. 11 (`psychologie`, `chirurgie`, `pharmacie`) ;
- `MODELE_DE_JEU.md` :
  - §2.3, l. 55 : type `chirurgie` ;
  - §4.2 : la péritonite ;
  - §6, l. 134-138 : tableau Pharmacie, Chirurgie, Psychologie, avec OBJ-012 présenté comme « médicament spécifique », alors que c'est l'anti-inflammatoire, exigé par aucune maladie ;
  - §8.1, l. 187 : une liste où l'Appendicite porte ✂️ et l'Angine 💊 ;
  - §8.2, l. 201 : « livre de médecine +1, scanner IRM +2 », deux cartes qui n'existent pas ;
  - §8.4 et §12.3 ;
- `MOTEUR_EFFETS.md` §2.1, l. 57 (MED-003 « Dr Lefort, chirurgie »), §2.2 (appendicite), §2.3 et §6.1 ;
- le catalogue du test `diagnostic_test.dart`.

**Proposition** : réécrire les exemples à partir du paquet de base, par exemple :
- fracture ouverte : 2 orthopédistes + bloc opératoire ;
- arythmie : cardiologue + salle de cardiologie + électrocardiographe ;
- burn-out : psychiatre + salle de psychiatrie.

Sinon, marquer clairement « exemple fictif, hors paquet de base ».

<a id="d2"></a>
### D2. Le tableau du §8.4 est calculé pour 3 spécialités — Important

**Où** : `MODELE_DE_JEU.md` §8.4, l. 235-251.

**Constat** : le tableau suppose 100 maladies réparties en 3 spécialités ; le paquet de base en compte 103 réparties en 5. Mesure sur le paquet de base, pour une maladie de cardiologie (20 000 tirages) :

| Combinaison | N | Vraie maladie en tête | Dans la liste | 1ʳᵉ couleur juste | Couleur dominante juste | % de la tête : juste / fausse |
|---|---|---:|---:|---:|---:|---:|
| Aucune spécialité | 1 | 46 % | 63 % | 64 % | 58 % | 83 / 65 |
| Aucune spécialité | 5 | 69 % | 80 % | 79 % | 67 % | 90 / 65 |
| Spécialité concordante | 1 | 50 % | 68 % | 80 % | 82 % | 87 / 70 |
| Spécialité concordante | 5 | 72 % | 83 % | 89 % | 87 % | 92 / 70 |
| Spécialité discordante | 1 | 46 % | 64 % | 67 % | 63 % | 83 / 64 |

La phrase « 9 fois sur 10 contre 7 sur 10 » devient « 8 sur 10 contre 6 sur 10 ».

**Proposition** : recalculer le tableau sur le paquet de base et faire porter `diagnostic_test.dart` sur ce paquet, ou au moins sur un catalogue à 5 spécialités.

<a id="d3"></a>
### D3. Chiffres du catalogue contradictoires — Mineur

**Où** : `MODELE_DE_JEU.md` §2.1 (30 patients, 30 objets et diplômes, 100 maladies) ; `SPECIFICATION.md` §8 (l. 204) et D20 ; `FEUILLE_DE_ROUTE.md` l. 87.

**Constat** : le paquet de base compte 12 patients, 21 objets et diplômes (16 + 5) et 103 maladies (23 + 4 × 20). Sa propre description le présente pourtant comme « complet ».

**Proposition** : trancher. Si le paquet est complet, mettre la cible à jour (12 patients, 21 accessoires, environ 100 maladies) en expliquant pourquoi 12 patients suffisent à 2 ou 3 joueurs. S'il est provisoire, corriger sa description.

<a id="d4"></a>
### D4. Un même identifiant désigne des cartes différentes selon le fichier — Important

**Où** : `docs/exemples/jeu.exemple.json` comparé à `contenu/paquet_base.json`, et `MOTEUR_EFFETS.md` §2.1.

| Identifiant | Dans l'exemple | Dans le paquet de base |
|---|---|---|---|
| MED-002 | Dr Lefort, chirurgie | Dr Lefort, médecine générale |
| MED-003 | Dr Benali, chirurgie (et « Dr Lefort » dans MOTEUR §2.1) | Dr Benali, cardiologie |
| MED-004 | Dr Sauvage | Dr Fontaine |
| SAL-002 | Bloc opératoire | Salle de psychiatrie |
| SAL-003 | Unité de psychiatrie | Radiologie |
| OBJ-011 | Antihistaminique | Antalgique |
| DIP-001 | Diplôme de pharmacologie | Diplôme de médecine générale |

**Constat** : un identifiant correspond à une carte imprimée et à une image embarquée (MOTEUR §1.2), et une extension ne peut pas changer l'image. L'exemple décrit donc un paquet qui contredit les cartes physiques.

**Proposition** : refaire l'exemple comme un sous-ensemble du paquet de base, en gardant les mêmes identifiants et les mêmes cartes.

<a id="d5"></a>
### D5. Plan de codage périmé — Mineur

**Où** : `PLAN_DE_CODAGE.md`.
- l. 14 : le message `resultat` n'y serait « pas encore » détaillé, alors que le point P1 est tranché ;
- l. 15 et l. 32 : le contenu « n'existe pas encore », avec « 6 maladies » ;
- l. 102 : l'étape 9 (paquet intermédiaire) n'est pas cochée, alors qu'un paquet complet existe ;
- l. 138-143 : « à refaire avec le paquet intermédiaire » ;
- l. 112 : « Les règles 4 à 9 sont testées, sauf la règle 3 », alors que la règle 3 ne fait pas partie de 4 à 9 ;
- l. 121 : `dart run bin/simuler.dart --help` répond « Could not find an option named "--help" », car l'option s'appelle `--aide` (ou `-h`).

**Proposition** :
- remplacer l'étape 9 par « paquet de base complet (103 maladies) livré ; réglage à faire dessus » ;
- corriger la phrase : « Les règles 4 à 9 sont testées ; restent les règles 1, 2 et 3 » ;
- documenter `--aide`, ou accepter `--help` comme autre nom dans `bin/simuler.dart`.

<a id="d6"></a>
### D6. « Maladie révélée : jamais » pour l'analyse — Mineur

**Où** : `MODELE_DE_JEU.md` §11, l. 301, comparé au §12.5 (une analyse fait subir l'aggravation) et à l'invariant 4 (MOTEUR l. 183).

**Constat** : une analyse peut tuer le patient. Il sort alors du jeu et sa maladie est révélée.

**Proposition** : remplacer « jamais » par « si mort ».

<a id="d7"></a>
### D7. Maladies suspectées affichées au diagnostic, sans champ prévu — Mineur

**Où** : `MODELE_DE_JEU.md` §11, l. 297 (« oui (affichées) »), comparé au §11.1, qui ne prévoit aucun champ pour cela.

**Proposition** : ajouter `maladies_suspectees` au résultat d'un diagnostic, ou retirer cet affichage du tableau.

<a id="d8"></a>
### D8. Précision de base des salles — Mineur

**Où** : `MODELE_DE_JEU.md` §8.2, l. 201 (« La salle porte la précision de base (salle généraliste : 1) »).

**Constat** : dans le paquet de base, la Pharmacie et la Plâtrerie ont une précision de 0, la Radiologie 3 et la Réanimation 2. Le moteur borne aussi N à 0 au minimum, ce que la formule n'indique pas.

**Proposition** : écrire « N = min(`precision_max`, max(0, somme)) ; la salle apporte en général de 0 à 3 ». Donner 1 à la Pharmacie et à la Plâtrerie si un diagnostic à N = 0 n'est pas voulu.

<a id="d9"></a>
### D9. « Aucune piste » au laboratoire : refus ou action ? — Mineur

**Où** : `MODELE_DE_JEU.md` §12.2, l. 334, comparé à `MOTEUR_EFFETS.md` §9.3 (l. 287) et à la liste des conditions (l. 176).

**Constat** : on ne sait pas si « Aucune piste » est un refus (rien ne se passe) ou une action (le temps avance de 1). Aucune condition existante ne permet d'ailleurs d'écrire « le patient a déjà été diagnostiqué ».

**Proposition** : créer une condition `patient_diagnostique` (vraie si le patient a des maladies suspectées) et l'ajouter à la précondition d'`analyser`. Le refus « Aucune piste — faire d'abord un diagnostic » ne coûte alors rien.

<a id="d10"></a>
### D10. Nombre de joueurs et nombre de téléphones — Mineur

**Où** : `MODELE_DE_JEU.md` §1.1 (2 à 3 joueurs) ; `SPECIFICATION.md` §9 (l. 214) et D2 (« testé jusqu'à ~8 clients ») ; `FEUILLE_DE_ROUTE.md` l. 71 (« partie de 2 h avec 8 téléphones »).

**Proposition** : aligner le critère de la phase 3 sur la mise en place (par exemple 3 téléphones, avec une marge jusqu'à 5), ou expliquer l'écart (spectateurs, futures extensions à plus de joueurs).

<a id="d11"></a>
### D11. Message « 4 cartes total maximum. » — Mineur

**Où** : `reconnaissance.dart:32` et `:118`. Le groupe `total` est nommé « total », ce qui donne « 4 cartes total maximum. » ou « Il faut au moins 3 cartes total. » ; la documentation annonce « 4 cartes maximum ».

**Proposition** : traiter `total` à part : « 4 cartes au maximum. » et « Il faut au moins 3 cartes. »

<a id="d12"></a>
### D12. Aucune carte laboratoire dans le paquet de base — Mineur

**Où** : `MODELE_DE_JEU.md` §2.1 et §12 ; `contenu/paquet_base.json` (les 10 salles, de SAL-001 à SAL-010, sont déjà prises).

**Proposition** : prévoir SAL-011 « Laboratoire de recherche » et passer le catalogue à 11 salles, ou transformer une salle existante. Dans le validateur, déclarer `recherche` comme valeur réservée, au même titre que `generaliste`.

---

## 4. Règles manquantes

<a id="r1"></a>
### R1. Mise en place incomplète — Important

**Où** : `MODELE_DE_JEU.md` §1.1, l. 20.

**Ce qui manque** :
- **les salles disponibles au départ** : une combinaison exige une salle, donc sans salle de départ aucune action n'est possible en dehors de l'admission ;
- les objets de départ ;
- la réputation de départ et le seuil de fermeture (question ouverte 6) ;
- la pioche des patients : mélange, nombre de patients en jeu en même temps ;
- le sort des 7 à 8 médecins et des diplômes non distribués ;
- le mode d'attribution des médecins et des diplômes (au hasard ou au choix).

**Proposition**, comme base de discussion :
1. L'hôpital démarre avec la Salle de consultation, la Pharmacie et la Radiologie. Les autres salles s'achètent.
2. Chaque joueur tire au hasard 1 médecin et 1 diplôme. Les médecins restants forment une réserve à recruter.
3. On mélange les 12 patients et on en révèle 2.
4. La réputation de départ et le seuil de fermeture dépendent de la difficulté, et sont fixés au simulateur.

<a id="r2"></a>
### R2. Tour de jeu non défini, sans pression du temps — Important

**Où** : `MODELE_DE_JEU.md` §1 (l. 11), §5 (l. 116 : « un patient jamais sollicité ne s'aggrave jamais ») et §4.1 (l'admission est volontaire).

**Constat** : rien n'oblige à admettre un patient, ni à s'occuper d'un patient admis. Un patient grave peut être laissé de côté indéfiniment, sans perte de PV ni de réputation. Le temps, qui fait toute la tension du jeu, ne s'écoule que si les joueurs le veulent. Ce qu'est un tour (une action, plusieurs ?) n'est pas défini non plus.

**Proposition**, à choisir :
- (a) **règle de table** : un tour = 1 action. Au début de son tour, le joueur pioche et admet un patient s'il y en a moins de N en jeu. Un patient ne peut pas rester plus de K tours sans action.
- (b) **dans l'appli** : un bouton de l'hôte « Fin de la manche » fait avancer le temps de tous les patients en jeu (un effet `attendre` = avancer le temps, aggraver, appliquer la pénalité d'attente). L'appli ne gère toujours pas l'ordre des tours.

**Recommandation** : (b), car seule l'appli connaît la maladie cachée et peut calculer l'aggravation des patients délaissés.

<a id="r3"></a>
### R3. Victoire individuelle et fin de partie — Important

**Où** : `MODELE_DE_JEU.md` §1, l. 12 (« points de victoire, conditions de victoire ») ; question ouverte 8 de SPEC ; README.

**Constat** : les points de victoire ne sont définis nulle part, ni la fin de partie. On ne sait donc pas pourquoi un joueur garderait ses pièces plutôt que de les céder à l'hôpital.

**Proposition**, comme base de discussion :
- **Fin** : la partie s'arrête quand la pioche de patients est vide et qu'aucun patient n'est en jeu (ou après X manches).
- **Score** : si l'hôpital est encore ouvert, chaque joueur marque ses pièces restantes, plus la valeur des objets et diplômes achetés, plus 1 point par patient qu'il a lui-même guéri. Le plus haut score gagne.
- **Patients encore en jeu** (question 8) : par exemple −1 de réputation pour chacun.

<a id="r4"></a>
### R4. Économie : prix, propriété, cartes des autres joueurs — Important

**Où** : `MODELE_DE_JEU.md` §1 (l. 14), §2.2 (l. 47) et §7 (l. 160).

**Ce qui manque** :
- le prix des cartes ;
- à qui appartiennent les salles (à l'hôpital, en commun ?) et les objets (à chaque joueur ?) ;
- si l'on peut utiliser le médecin, le diplôme ou l'objet d'un autre joueur comme second médecin ou accessoire, et qui touche alors les pièces (aujourd'hui, l'acteur seul) ;
- si un diplôme est lié à un médecin.

**Proposition** :
- une table de prix (par exemple : objet 3, diplôme 5, salle 8, versés à l'hôpital) ;
- des salles communes et des objets personnels ;
- l'emprunt de cartes possible, avec un partage des pièces à négocier ;
- un diplôme jouable seulement avec le médecin de son propriétaire, voir [E7](#e7).

<a id="r5"></a>
### R5. Partage des diagnostics : a-t-on le droit de mentir ? — Mineur

**Où** : `MODELE_DE_JEU.md` §8.6 ; `SPECIFICATION.md` §2, principe 3 (« de vive voix ou en montrant leur écran »).

**Proposition** : trancher et l'écrire. Par exemple : « Ce qu'on annonce de vive voix peut être faux (le bluff est permis) ; montrer son écran engage. » Ou interdire le mensonge. Le simulateur devra modéliser ce choix ([E11](#e11)).

<a id="r6"></a>
### R6. Laboratoire : trois points non définis — Mineur

**Où** : `MODELE_DE_JEU.md` §12.3 à §12.6 ; `MOTEUR_EFFETS.md` §9.4.

**Ce qui manque** :
1. Que se passe-t-il si l'on réanalyse une maladie dont la recette est déjà révélée : refus, action gratuite, ou nouvel affichage de la recette ?
2. La recette est-elle publique ? Elle est dite « découverte pour tous les patients », mais elle ne s'affiche que sur un téléphone.
3. La capacité `recherche` « réduit le nombre de passages requis pour l'analyse en cours », alors que le compteur est commun à toute la partie et peut déjà avoir été entamé par d'autres joueurs.

**Proposition** :
1. Réanalyser une maladie déjà révélée réaffiche la recette, au coût normal.
2. Écrire : « La recette ne s'affiche qu'au joueur qui l'a découverte ; il la partage ou non (§8.6). »
3. Une règle unique : « Chaque passage retire 1 + la capacité `recherche` de la combinaison au compteur de la maladie (sans descendre sous 0). » Un passage reste ainsi toujours nécessaire, ce qui remplace « sans descendre sous 1 ».

<a id="r7"></a>
### R7. L'annulation est exploitable — Important

**Où** : `SPECIFICATION.md` §7.3 et D3 ; §3.5 (l'état du générateur aléatoire n'est pas sauvegardé).

**Constat** : on peut diagnostiquer, lire la liste puis annuler : l'information est gratuite. Annuler puis refaire donne un nouveau tirage, ce qui permet de relancer. Même chose pour l'admission, qui permet de relancer la maladie tirée.

**Proposition** :
- sauvegarder l'état du générateur dans chaque instantané : annuler puis refaire redonne alors le même tirage, et la relance disparaît ;
- réserver l'annulation aux erreurs de scan, par une règle de table, et la faire apparaître dans le journal.

---

## 5. Équilibrage et pertinence

<a id="e1"></a>
### E1. Traitements génériques : connaître la spécialité suffit presque toujours — Important

**Mesure** (toutes les combinaisons standard du catalogue, prédicats corrigés selon [B1](#b1)) : nombre de maladies d'une spécialité soignées par **une seule** combinaison.

| Spécialité | Maladies soignées | Combinaison |
|---|---:|---|
| Médecine générale | 17 / 23 | Pharmacie + antalgique |
| Cardiologie | 17 / 20 | cardiologue + salle de cardiologie + électrocardiographe |
| Psychiatrie | 19 / 20 | n'importe quel médecin + salle de psychiatrie + diplôme de psychiatrie |
| Orthopédie | 15 / 20 | orthopédiste + bloc opératoire + diplôme d'orthopédie |
| Paranormal | 17 / 20 | médecin paranormal + salle expérimentale + amulette |

**Constat** : connaître la spécialité suffit dans 75 à 95 % des cas. La liste de 5 noms et le laboratoire n'apportent presque rien de plus.

**Proposition** : diversifier les recettes, avec 3 ou 4 familles par spécialité, chacune liée à un objet ou une salle distincts. Par exemple, en cardiologie : le défibrillateur pour les urgences, l'électrocardiographe pour les troubles du rythme, le tensiomètre pour la tension, rien de plus pour le reste. Réutiliser les cartes aujourd'hui inutiles ([E8](#e8)).

Objectif mesurable : aucune combinaison ne soigne plus de 40 % des maladies d'une spécialité.

<a id="e2"></a>
### E2. Traitements connus d'avance, mais laboratoire chargé de les révéler — Important

**Où** : `PLAN_DE_CODAGE.md` l. 132 et `strategies.dart:95-96` (les traitements sont « supposés connus des joueurs via le livret de règles »), comparés au `MODELE_DE_JEU.md` §12.

**Constat** : si le livret liste les traitements, le laboratoire ne sert à rien. S'il ne les liste pas, les chiffres du simulateur (97 à 98 % de guérison) sont trop optimistes.

**Proposition** : décider que les recettes sont secrètes, le livret ne donnant que des indications par spécialité. Ajouter au simulateur une stratégie qui ne connaît pas les traitements et les apprend par essais, par les traitements partiels et par le laboratoire.

<a id="e3"></a>
### E3. Les PV et l'attente trahissent la maladie — Important

**Où** : `MODELE_DE_JEU.md` §4.1, l. 102 (PV affichés dès l'admission) et §11 ; question ouverte 5 de SPEC (l. 280).

**Mesure** :
- des PV initiaux de 5 ou 6 indiquent **à coup sûr** la médecine générale (7 maladies) ;
- 11 PV : 3 fois sur 4 la cardiologie ; 12 PV : cardiologie (3 maladies) ou fracture du fémur ;
- sur les 16 combinaisons possibles de « PV initiaux + première aggravation », 8 n'existent que dans une seule spécialité ;
- les pertes de PV suivantes et l'apparition de l'attente dépassée (une attente de 3 ne concerne que 9 maladies) précisent encore la piste.

**Constat** : une partie du diagnostic est gratuite et n'est documentée nulle part. « Les PV ne sont pas une information cachée », mais ils dévoilent en partie la maladie.

**Proposition**, à choisir :
- **assumer et documenter** : c'est une mécanique de déduction intéressante ;
- **ou brouiller** : PV initiaux répartis par paliers communs à toutes les spécialités (8, 10, 12…), ou tirés à `pv_initial` ± 1, ou affichés de façon qualitative (stable, préoccupant, critique).

<a id="e4"></a>
### E4. Arrondis : Chirurgien et Réanimation se confondent sur les petites valeurs — Important

**Vérifié avec `moduler`** (arrondi au plus proche, demi éloigné de zéro) :

| Base | Interne ×1,0 | Chirurgien ×1,5 | Réanimation ×2,0 | Pièces ×1,2 |
|---:|---:|---:|---:|---:|
| 1 | 1 | **2** | **2** | 1 |
| 2 | 2 | 3 | 4 | 2 |
| 3 | 3 | 5 | 6 | 4 |
| −1 | −1 | **−2** | **−2** | — |
| −3 | −3 | −5 | −6 | — |

**Constat** : pour une aggravation de 1 (la plus fréquente) et pour les pénalités de −1 (attente, traitement inadapté), Chirurgien et Réanimation donnent le même résultat, le double de l'Interne. En Chirurgien, un diagnostic rapporte toujours 1 pièce, comme en Interne. Le tableau « ×1,5 » donne une fausse idée de la difficulté. Enfin, la règle « une base non nulle reste au moins égale à 1 » ne sert que pour un modificateur inférieur à 1, ce qui n'est jamais le cas aujourd'hui.

**Proposition** :
- publier la table des valeurs effectives dans le §10 ;
- choisir des modificateurs qui distinguent les petites valeurs, par exemple `pv_perdus` à 1,0 / 1,25 / 2,0, ce qui donne 1→1/1/2, 2→2/3/4, 3→3/4/6 ;
- ou passer à des modificateurs additifs sur les pertes (+0 / +1 dès 2 / +1 partout) ;
- préciser à quoi sert la règle du minimum de 1.

<a id="e5"></a>
### E5. Le modificateur de réputation s'applique aussi aux gains — Important

**Où** : `MODELE_DE_JEU.md` §10, l. 286 (« positifs comme négatifs »).

**Mesure** (simulateur, paquet de base corrigé, stratégie `seuil:70`) : réputation par patient de **1,72** en Interne, **1,89** en Chirurgien et **2,45** en Réanimation. Le rapport d'exemple du dépôt montre la même tendance (1,80 / 2,08 / 2,78).

**Constat** : pour une équipe compétente, la difficulté la plus élevée est la plus facile pour la réputation, qui est pourtant le seul enjeu collectif.

**Proposition** : n'appliquer le modificateur `reputation` qu'aux pertes, ou le séparer en `reputation_gain` et `reputation_perte`. Ou bien faire dépendre le seuil de fermeture de la difficulté (question 6) pour compenser.

<a id="e6"></a>
### E6. Pièces gagnées dans tous les cas — Important

**Où** : `MODELE_DE_JEU.md` §7 ; `MOTEUR_EFFETS.md` §6.1, l. 203-204 (le paiement a lieu avant l'aggravation).

**Constat** :
- un diagnostic rapporte 1 pièce et un traitement partiel aussi, même si l'action tue le patient ;
- sur une maladie à aggravation [0, 1] (rhume, conjonctivite, carence en vitamine D…) avec une attente de 6 à 8, on peut enchaîner des diagnostics payés presque sans coût ; la réputation commune ne souffre qu'une fois l'attente dépassée.

Comme « chaque médecin joue pour ses pièces », le jeu encourage à répéter des diagnostics pour gagner des pièces.

**Proposition** :
- pas de pièce si le patient meurt pendant l'action ;
- payer seulement le **premier** diagnostic de chaque patient (l'appli le sait), ou mettre `pieces_diagnostic` à 0 et augmenter `pieces_traitement` ;
- payer au plus un traitement partiel par patient.

<a id="e7"></a>
### E7. Le diplôme rend la spécialité du médecin presque inutile — Important

**Mesure** :
- en psychiatrie, Dr Moreau (polyvalent) + salle de psychiatrie + diplôme de psychiatrie soigne 19 maladies sur 20, autant qu'un psychiatre ;
- en orthopédie, l'exigence de « 2 orthopédistes » est remplie par 1 orthopédiste + le diplôme d'orthopédie ;
- le diplôme ajoute en plus sa spécialité au diagnostic, et souvent +1 de précision.

**Constat** : avec son médecin et son diplôme, chaque joueur couvre deux spécialités, et le médecin spécialiste perd ce qui le distinguait.

**Proposition** : si c'est voulu, l'écrire dans la règle (« un diplôme fait de n'importe quel médecin un spécialiste »). Sinon, limiter l'effet du diplôme, au choix :
- il ne compte comme médecin qu'avec un médecin polyvalent ;
- il ne compte que pour le traitement partiel ;
- il ne compte pas quand la recette exige au moins 2 médecins.

<a id="e8"></a>
### E8. Cartes sans usage ou incohérentes — Mineur

**Constat** :
- **OBJ-005 Plâtre** : aucune capacité, aucune recette, pas même pour les fractures. Son seul effet est d'ajouter l'orthopédie au diagnostic.
- **OBJ-015 Tensiomètre** : même chose en cardiologie, et l'hypertension ne le demande pas.
- **OBJ-012 Anti-inflammatoire** : ne sert que comme objet générique de médecine générale.
- **DIP-004 et DIP-005** n'ont pas de précision, alors que DIP-001 à DIP-003 donnent +1.
- **SAL-007 Pharmacie** : ni spécialité ni précision, alors qu'elle ne sert qu'aux maladies de médecine générale.
- **SAL-006 Bloc opératoire** : réservé à l'orthopédie. Et SAL-008 Plâtrerie n'a pas de précision.

**Proposition** :
- exiger le Plâtre pour la fracture fermée, la fracture du poignet et l'entorse du genou ;
- exiger le Tensiomètre pour l'hypertension et l'hypotension orthostatique ;
- exiger l'Anti-inflammatoire pour le torticolis et les maux de gorge ;
- donner la même précision à tous les diplômes (+1 partout ou nulle part) ;
- donner la spécialité `generale` à la Pharmacie, ou écrire qu'elle est polyvalente ;
- renommer le Bloc opératoire en « Bloc d'orthopédie », ou le rendre polyvalent.

<a id="e9"></a>
### E9. Recettes peu crédibles — Mineur

**Constat** :
- 15 maladies de médecine générale se soignent à la Pharmacie avec **n'importe quel** objet ou diplôme de médecine générale : la conjonctivite au sirop antitussif, la gastro virale à l'antibiotique, l'insomnie aux ampoules de glucose. Même le diplôme de médecine générale « soigne » à la Pharmacie.
- L'angine bactérienne se soigne avec l'antibiotique dans n'importe quelle salle, même en salle de psychiatrie avec un médecin d'une autre spécialité.

**Proposition** :
- exiger au minimum un médecin ou un diplôme de médecine générale dans la recette générique ;
- associer chaque médicament à une famille de maladies : antibiotique pour les infections bactériennes, antalgique pour les douleurs, sirop pour la toux, anti-inflammatoire pour les inflammations, glucose pour l'hypoglycémie ;
- pour l'angine, exiger en plus la Salle de consultation ou la Pharmacie.

<a id="e10"></a>
### E10. Noms de maladies trop proches — Mineur

**Constat** : plusieurs noms se ressemblent, souvent d'une spécialité à l'autre :
- Torticolis (médecine générale) et Torticolis congénital (orthopédie) ;
- Insomnie passagère (médecine générale), Insomnie chronique et Trouble du sommeil (psychiatrie) ;
- Maux de tête et Migraine légère ;
- Maux de gorge et Angine bactérienne ;
- Crise d'angoisse, Attaque de panique et Anxiété généralisée ;
- Ombre qui suit et Ombre vivante ;
- Crise de rire incontrôlée (psychiatrie) et Rire des cimetières (paranormal) ;
- Fièvre inexpliquée et Fièvre des étoiles ;
- Malaise cardiaque et Syndrome du cœur brisé.

« Suivi de greffe cardiaque », de son côté, n'est pas une maladie.

Dans une liste de 5 maladies aux pourcentages proches, ces ressemblances brouillent la lecture et la mémoire des recettes, surtout quand la couleur change.

**Proposition** : donner à chaque maladie un nom bien distinct, ou assumer ces ressemblances comme des maladies-pièges et le dire dans la règle. Renommer « Suivi de greffe cardiaque » en « Rejet de greffe cardiaque ».

<a id="e11"></a>
### E11. Objectif « défaite quasi inévitable sans partage » — Important

**Où** : `MODELE_DE_JEU.md` §8.6, l. 261 ; D25.

**Constat** :
1. Le simulateur ne fait jouer qu'une stratégie à la fois, sans plusieurs joueurs ni partage d'information.
2. Avec les réglages actuels, un joueur seul guérit 97 % des patients ([B4](#b4), [E1](#e1)) : le partage n'est pas nécessaire.
3. Une défaite « quasi inévitable » sans partage rendrait le partage obligatoire. Le choix de garder l'information deviendrait alors illusoire, ce qui contredit le principe semi-coopératif (« chaque médecin joue pour ses pièces »).

**Proposition** :
- se fixer un objectif chiffré, par exemple : « sans partage, l'hôpital ferme dans 60 à 80 % des parties ; avec un partage total, dans moins de 10 % » ;
- simuler plusieurs joueurs : 2 ou 3 agents, tours alternés, informations privées ou mises en commun ;
- créer un vrai dilemme : partager aide l'équipe, mais permet à un autre joueur de réaliser le traitement et de toucher les 3 pièces.

<a id="e12"></a>
### E12. Le diagnostic ignore la fréquence des maladies — Mineur

**Constat** : une maladie de poids 1 apparaît dans les listes aussi souvent qu'une maladie de poids 3. La médecine générale représente 28 % des admissions (d'après les poids), mais seulement 22 % des maladies. Un joueur averti doit corriger de tête.

**Proposition** : documenter cet écart, ou pondérer légèrement le bruit par `poids` pour que la liste reflète la fréquence réelle des maladies.

<a id="e13"></a>
### E13. Une extension peut changer des attributs imprimés — Mineur

**Où** : `MOTEUR_EFFETS.md` §1.2, l. 26.

**Constat** : si la spécialité et les capacités sont imprimées sur les cartes (ce qui aide à composer une combinaison à la table), une extension qui les change crée un écart entre la carte et l'appli.

**Proposition** : décider ce qui est imprimé. Si la spécialité et les capacités le sont, interdire leur modification en v1, ou faire afficher par l'appli les valeurs en vigueur sur les vignettes de la sélection.

<a id="e14"></a>
### E14. Prépositions des salles dans les phrases — Mineur

**Constat** : « dans la réanimation », « dans la pharmacie » ou « dans la plâtrerie » sonnent faux ; on dirait « en réanimation » ou « à la pharmacie ».

**Proposition** : ajouter un champ facultatif `lieu_phrase` aux salles (« en réanimation », « au bloc opératoire »), utilisé par `{salle}` dans les phrases d'action. Par défaut : « dans » + `nom_phrase`.

<a id="e15"></a>
### E15. Couleurs de spécialités — Mineur

**Constat** : le rouge de la cardiologie (`#C62828`) et l'orange de l'orthopédie (`#EF6C00`) se confondent pour une personne atteinte de deutéranopie. Le gris de la spécialité paranormal (`#37474F`) se voit mal sur fond sombre. Les icônes compensent en partie.

**Proposition** : vérifier le contraste (au moins 3:1 sur fond clair et sur fond sombre) et passer les couleurs dans un simulateur de daltonisme. Éclaircir la couleur du paranormal, par exemple en `#78909C`.

---

## Annexe — Reproduire B1 et B2 avec le moteur

À lancer depuis un petit paquet Dart qui dépend de `packages/moteur` (chemins relatifs à la racine du dépôt) :

```dart
final brut = jsonDecode(File('contenu/paquet_base.json').readAsStringSync());
final jeu = Jeu.fromJson(brut);

// B1 : rhume carabiné soigné en Radiologie, sans Pharmacie → true
final rhume = jeu.maladies.firstWhere((m) => m.id == 'rhume_carabine');
print(Combinaison(jeu, ['PAT-001', 'MED-001', 'SAL-003', 'OBJ-011'])
    .satisfait(rhume.traitement.adapte));

// B2 : motif « recherche » ajouté en tête → refus à 3 cartes
brut['motifs'] = {
  'recherche': {'patient': [1, 1], 'medecin': [1, 1], 'salle': [1, 1], 'total': [3, 3]},
  ...brut['motifs'],
};
// … ajouter l'action « analyser » (précondition : salle de spécialité recherche),
// admettre PAT-002, puis :
// partie.valider(['PAT-002', 'MED-003', 'SAL-001'])
//   → SelectionRefusee « Aucune action possible avec ces cartes. »
```
