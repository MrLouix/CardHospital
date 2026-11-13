# CardHospital — Variantes pour faire du partage un vrai dilemme

Ce document mesure au simulateur les règles envisagées pour que le partage d'information **décide de la partie** et pose un **vrai dilemme** : patients qui passent de main en main, adressage, salles réparties, transmission limitée, noms de maladies masqués, primes. Il complète l'[analyse de l'équilibre](ANALYSE_EQUILIBRE.md). Les rapports complets sont dans [`simulations/`](simulations/README.md).

Ces variantes sont des **pistes mesurées**, pas des règles adoptées.

## 1. Synthèse

| Constat | Mesure à 3 joueurs vétérans, niveau Interne |
|---|---|
| **La relève ne change presque rien au partage** | Fermetures évitées par le partage : 8 points, contre 7 avec les règles actuelles |
| **L'examen ciblé est le vrai levier** | 52 points : l'hôpital ferme dans 30 % des parties quand tous partagent, 82 % quand personne ne partage |
| **Sans prime, se taire rapporte, et c'est un seul voisin qui paie** | Le joueur qui se tait gagne 1,6 point ; celui qui joue après lui tombe de 6,6 à 2,0 |
| **Avec une prime d'un point sur deux, se taire ne rapporte plus** | Il perd 1,0 à 2,2 points : le partage devient évident, il n'y a plus de dilemme |
| **Le nombre de joueurs pèse plus que la règle** | Règles actuelles : 3 points à 2 joueurs, 7 à 3, 29 à 4, 64 à 5 |
| **Trois pistes sont à écarter** | Noms réservés au seul médecin spécialiste, salles réparties entre joueurs, adressage libre |

La piste recommandée est donc l'**examen ciblé**, avec ou sans relève, et une prime **plus faible** que celle simulée (§6). Elle demande de rééquilibrer le jeu, qui devient plus dur et plus long.

## 2. Ce qui est simulé

Le simulateur ([`packages/moteur/lib/simulation/variantes.dart`](../packages/moteur/lib/simulation/variantes.dart)) fait jouer des joueurs qui n'ont que **leur médecin** (plus un diplôme à 2 ou 3 joueurs), avec autant de patients en jeu que de joueurs.

### 2.1 Variantes

| Brique | Règle simulée |
|---|---|
| **Relève** | Chaque joueur n'agit que sur le patient posé devant lui ; à la fin de la manche, tous les patients passent au voisin de gauche |
| **Passe** | Après chaque acte, le patient passe au voisin de gauche |
| **Adressage** | Après son acte, le joueur envoie le patient à celui qui peut le soigner, ou au joueur de la bonne spécialité |
| **Services** | Les salles sont réparties entre les joueurs : chacun ne joue que dans les siennes |
| **Un mot** | On ne transmet qu'une chose : la maladie en tête, ou sa spécialité |
| **Partage gradué** | On partage les diagnostics, pas les recettes |
| **Masque** | L'appli n'affiche le nom d'une maladie qu'au joueur dont le **médecin** est de sa spécialité ; les autres lignes ne montrent que leur couleur |
| **Examen ciblé** | L'appli n'affiche le nom d'une maladie que si une **carte de la combinaison** (médecin, salle ou objet) est de sa spécialité. Un premier examen trie par couleur, un second, ciblé, nomme |
| **Prime du passeur** | 1 des 2 points de réputation d'une guérison va au joueur qui a transmis le patient |
| **Prime de l'informateur** | 1 des 2 points va au dernier autre joueur dont le diagnostic partagé a servi |

### 2.2 Trois populations, trois mesures

Chaque variante est jouée par trois tablées : **tous partagent**, **personne ne partage**, **un seul se tait**.

- **Valeur collective** : parties fermées en moins quand tous partagent plutôt que personne (écart de 10 entre la réputation de départ et le seuil). C'est ce que le partage rapporte à la table.
- **Tentation** : points de victoire gagnés par celui qui se tait seul, par rapport à ce qu'il gagne quand tous partagent. Positive : se taire rapporte.
- **Coût pour les autres** : points perdus par chacun des autres joueurs quand un seul se tait.

Un **vrai dilemme** demande une valeur collective forte **et** une tentation positive. Si la tentation est négative, partager est simplement le meilleur coup : il n'y a rien à choisir.

## 3. Résultats

### 3.1 À 3 joueurs vétérans, niveau Interne

[Rapport complet](simulations/rapport_variantes_3_joueurs.md), 1000 parties par ligne.

| Variante | Guérison (partage / privé) | Fermeture (partage / privé) | Valeur collective | Tentation | Coût pour les autres |
|---|---:|---:|---:|---:|---:|
| Règles actuelles | 84 % / 79 % | 19 % / 27 % | +7 pts | +1,6 | +0,4 |
| Règles actuelles + informateur | 84 % / 79 % | 18 % / 25 % | +7 pts | −1,9 | −1,1 |
| **Règles actuelles + examen ciblé** | 77 % / 49 % | 30 % / 82 % | **+52 pts** | **+1,2** | +3,9 |
| Règles actuelles + examen ciblé + informateur | 77 % / 50 % | 27 % / 85 % | +57 pts | −2,2 | +2,4 |
| Règles actuelles + masque | 61 % / 67 % | 71 % / 48 % | −22 pts | −2,3 | +3,6 |
| Relève | 83 % / 81 % | 18 % / 26 % | +8 pts | +0,6 | +0,8 |
| Relève + passeur | 82 % / 80 % | 19 % / 30 % | +11 pts | −1,4 | −0,8 |
| Relève + passeur + un mot | 82 % / 79 % | 18 % / 34 % | +16 pts | −1,3 | −0,6 |
| **Relève + examen ciblé** | 72 % / 62 % | 40 % / 75 % | **+35 pts** | **+1,5** | +3,8 |
| Relève + passeur + examen ciblé | 71 % / 62 % | 43 % / 73 % | +30 pts | −1,0 | +2,3 |
| Relève + passeur + masque | 61 % / 61 % | 61 % / 66 % | +6 pts | −2,8 | +3,1 |
| Passe + passeur | 84 % / 83 % | 9 % / 12 % | +3 pts | −1,7 | −1,8 |
| Adressage + passeur | 83 % / 82 % | 17 % / 16 % | −1 pt | +0,3 | +0,2 |
| Services + relève + passeur | 67 % / 59 % | 55 % / 80 % | +26 pts | −0,4 | +0,5 |
| Services + adressage + passeur | 63 % / 61 % | 58 % / 63 % | +6 pts | +0,3 | −0,1 |

### 3.2 Selon le nombre de joueurs

Valeur collective du partage, vétérans, niveau Interne ([2 joueurs](simulations/rapport_variantes_2_joueurs.md), [4 joueurs](simulations/rapport_variantes_4_joueurs.md), [5 joueurs](simulations/rapport_variantes_5_joueurs.md)).

| Variante | 2 joueurs | 3 joueurs | 4 joueurs | 5 joueurs |
|---|---:|---:|---:|---:|
| Règles actuelles | +3 pts | +7 pts | +29 pts | +64 pts |
| Règles actuelles + examen ciblé | +14 pts | +52 pts | +37 pts | +32 pts |
| Relève | +1 pt | +8 pts | +26 pts | +62 pts |
| Relève + examen ciblé | +7 pts | +35 pts | +37 pts | +42 pts |
| Passe + passeur | +2 pts | +3 pts | +8 pts | +12 pts |
| Adressage + passeur | −2 pts | −1 pt | +5 pts | +5 pts |

À 4 et 5 joueurs, l'examen ciblé plafonne parce que l'hôpital ferme déjà dans toutes les parties sans partage, et dans 63 à 68 % des parties avec : le jeu est devenu trop dur, pas le partage moins utile.

### 3.3 Novices, difficulté, temps

- **Novices avec laboratoire** ([3 joueurs](simulations/rapport_variantes_3_joueurs_novices.md), [4 joueurs](simulations/rapport_variantes_4_joueurs_novices.md)) : le partage décide déjà de la partie avec les règles actuelles (26 % de fermetures contre 95 % à 3 joueurs), parce qu'ils mettent en commun les recettes. Le problème du partage est donc celui des **joueurs qui connaissent les traitements**. Le partage gradué (diagnostics sans recettes) leur coûte cher : 52 % de fermetures au lieu de 27 %.
- **Réanimation** ([rapport](simulations/rapport_variantes_3_joueurs_reanimation.md)) : le partage compte plus (45 points avec les règles actuelles), mais l'examen ciblé y devient injouable : 76 % de fermetures même quand tous partagent.
- **Temps plus pressant** ([paliers d'aggravation deux fois plus courts](simulations/rapport_variantes_3_joueurs_paliers_courts.md)) : aucun effet notable. La relève passe de 8 à 11 points. La pression du temps n'est pas le levier.

## 4. Enseignements

1. **La relève seule ne rend pas l'information précieuse.** Un joueur qui se tait n'empêche rien : chaque voisin refait le diagnostic, et le patient revient à son premier médecin au bout d'un tour de table. Refaire un diagnostic coûte un tour mais rapporte une pièce, et les patients tiennent assez longtemps. La relève allonge la partie d'un quart (52 tours au lieu de 42) sans rien gagner sur le partage.
2. **L'examen ciblé rend l'information additive.** Le premier examen ne donne que des couleurs ; il faut un second examen, avec une carte de la bonne spécialité, pour lire le nom. Partager le tri évite à chacun de le refaire. C'est la seule variante qui multiplie la valeur du partage à 3 joueurs, et elle garde une tentation positive : c'est un dilemme.
3. **Réserver les noms au médecin spécialiste casse le jeu.** À 3 joueurs, 21 % des patients ont une maladie dont aucun joueur n'a la spécialité (38 à 40 % à 2 et 4 joueurs) : personne ne peut la nommer, donc la soigner. Plus d'un acte sur trois ne sert à rien.
4. **Les primes suppriment le dilemme au lieu de le créer.** Un point sur les deux de la guérison suffit à rendre le silence perdant. Elles ont deux vertus : l'écart entre le premier et le dernier joueur baisse de 9,5 à 6,7 points, et le voisin du joueur qui se tait n'est plus sacrifié.
5. **Passe et adressage rendent la parole inutile.** Quand le patient arrive chez le bon joueur, le geste dit déjà tout. Le « passe » donne les hôpitaux les plus sûrs (9 % de fermetures), mais partager n'y change rien.
6. **Répartir les salles est trop dur.** 55 % de fermetures quand tous partagent, 87 % pour des novices, 29 % d'actes sans intérêt.
7. **Ne transmettre qu'un mot ne coûte rien à la table.** Mêmes guérisons et mêmes fermetures qu'avec une transmission complète : la règle peut servir à garder un jeu rapide.
8. **À 2 joueurs, aucune variante ne fait compter le partage**, et celui qui se tait gagne 7 points de plus : il faut une règle propre au jeu à deux.

## 5. Risques en jeu

### 5.1 Mesurés

| Risque | Variantes touchées | Mesure |
|---|---|---|
| **Le silence punit un seul joueur** : celui qui joue juste après | Toutes sans prime | Son score tombe de 6,6 à 2,0 avec les règles actuelles, quand le troisième joueur monte à 10,7 ; de 6,2 à −0,7 avec l'examen ciblé |
| **Partie plus dure** | Examen ciblé | Fermetures quand tous partagent : 30 % au lieu de 19 % ; 76 % en Réanimation ; morts 23 % au lieu de 16 % |
| **Partie plus longue** | Relève, examen ciblé | 52 tours (relève), 58 (examen ciblé), 69 (les deux), contre 42 |
| **Tours sans intérêt** : un diagnostic refait faute de mieux | Masque (35 %), services (29 %), passe (17 %), relève (15 %) | 12 % avec les règles actuelles, 6 % avec l'examen ciblé |
| **Patients orphelins** : aucune spécialité à la table | Masque surtout | 21 % des patients à 3 joueurs, 38 à 40 % à 2 et 4 joueurs |
| **Écart entre joueurs** dû au médecin tiré | Adressage (11,3 points), services (12,2) | 9,5 avec les règles actuelles, 6,7 à 6,9 avec une prime |
| **Attente et engorgement** | Adressage | Jusqu'à 2,5 patients chez un même joueur, 2 à 10 % de tours sans patient |
| **Faute héritée** : mourir au premier acte sur un patient reçu | Adressage, règles actuelles à 4 joueurs | 3 à 6 % des morts (adressage), 11 % à 4 joueurs |
| **Injouable à deux** | Toutes | Valeur collective de −2 à +14 points |

### 5.2 Non mesurables au simulateur

Les joueurs simulés ne négocient pas, ne mentent pas et n'oublient rien. Ces risques sont à observer en parties réelles.

- **Mémoire** : avec la relève, il faut retenir ce qui s'est dit sur chaque patient. Sans support, l'information se perd ; avec un support, on ajoute du matériel.
- **Alliances et faiseur de roi** : le partage profite d'abord au voisin. Deux joueurs peuvent s'entendre contre un troisième, et un joueur distancé peut choisir qui gagne en se taisant.
- **Refiler le mourant** : avec le « passe » ou l'adressage, un joueur peut se débarrasser d'un patient qui va mourir. Les PV, affichés au seul joueur qui agit, rendent la manœuvre invisible.
- **Mensonge** : la règle « on peut se taire, pas tromper » ne tient que par la bonne foi. Une prime la met sous pression : on peut annoncer un diagnostic incertain comme sûr.
- **Deux examens par patient** : l'examen ciblé ajoute un scan par patient, donc du temps d'appli, contre l'exigence d'une appli discrète.
- **Lisibilité** : « ce que l'appli me montre dépend de mes cartes » est une règle de plus à expliquer.

### 5.3 Limites des mesures

- Un seul comportement par joueur (seuil de confiance de 70), sans stratégie de fin de partie.
- Toutes les salles et tous les objets sont disponibles dès le départ ; l'économie n'est pas simulée.
- Une partie compte 10 patients ; le score ajoute la réputation attribuée au joueur et un point par lot de 3 pièces, et toute la réputation est aussi reportée sur l'hôpital.
- L'écart de 10 entre départ et seuil n'est pas encore une règle : les taux de fermeture se comparent entre variantes, pas dans l'absolu.
- Un écart de moins de 4 points entre deux taux de fermeture n'est pas significatif à 1000 parties.

## 6. Recommandation

1. **Adopter l'examen ciblé** comme piste principale, et **écarter** le masque par médecin, les services et l'adressage libre.
2. **Rééquilibrer** : avec l'examen ciblé, viser moins de 20 % de fermetures quand tous partagent en Interne (récompenses, PV, précision des salles), et vérifier la Réanimation.
3. **Doser la prime** : simuler une prime plus faible (une pièce plutôt qu'un point de réputation) pour protéger le voisin sans supprimer la tentation. À 2 joueurs, une prime est nécessaire.
4. **Relève : à décider sur table**, pas au simulateur. Elle n'apporte rien au partage et allonge la partie ; elle garde pour elle un tour très simple et aucune attente.
5. **Garder « un mot »** en réserve si les transmissions ralentissent le jeu.

Commande, depuis `packages/moteur` : `dart run bin/simuler_variantes.dart --aide`.
