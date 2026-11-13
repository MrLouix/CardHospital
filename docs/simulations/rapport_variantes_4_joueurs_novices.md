# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 4 joueurs novices, avec laboratoire, un médecin chacun · niveau Interne · seuil 70 · paliers d'aggravation 5, 11, 17, 23.

## Variantes

| Variante | Règle |
|---|---|
| `actuel` | Règles actuelles : tout joueur agit sur tout patient |
| `actuel+informateur` | Règles actuelles, 1 point de la guérison au dernier joueur dont le diagnostic partagé a servi |
| `actuel+masque` | Règles actuelles, noms des maladies visibles du seul spécialiste |
| `actuel+examen-cible` | Règles actuelles, noms visibles seulement avec une carte de la spécialité (médecin, salle ou objet) |
| `actuel+examen-cible+informateur` | Règles actuelles, examen ciblé, et 1 point de la guérison au dernier joueur dont le diagnostic partagé a servi |
| `releve` | Relève : on n'agit que sur ses patients, qui passent tous à gauche en fin de manche |
| `releve+passeur` | Relève, 1 point de la guérison au voisin qui a transmis le patient |
| `releve+informateur` | Relève, 1 point de la guérison au dernier joueur dont le diagnostic partagé a servi |
| `releve+passeur+un-mot` | Relève et prime du passeur ; on ne transmet qu'une chose : une maladie ou une spécialité |
| `releve+passeur+masque` | Relève et prime du passeur ; noms visibles du seul spécialiste |
| `releve+examen-cible` | Relève, sans prime ; noms visibles seulement avec une carte de la spécialité |
| `releve+passeur+examen-cible` | Relève et prime du passeur ; noms visibles seulement avec une carte de la spécialité |
| `releve+passeur+gradue` | Relève et prime du passeur ; on partage les diagnostics, pas les recettes |
| `passe+passeur` | Un acte, puis le patient passe à gauche ; prime du passeur |
| `adressage+passeur` | Après son acte, on adresse le patient au joueur de son choix ; prime à celui qui adresse |
| `adressage+passeur+examen-cible` | Adressage et prime ; noms visibles seulement avec une carte de la spécialité |
| `services+releve+passeur` | Salles réparties entre les joueurs, relève et prime du passeur |
| `services+adressage+passeur` | Salles réparties entre les joueurs, adressage et prime |

## Le partage compte-t-il ?

« Valeur collective » : parties fermées en moins (écart de 10 entre départ et seuil) quand tous partagent plutôt que personne. « Tentation » : points de victoire gagnés par un joueur qui se tait seul, par rapport à ce qu'il gagne quand tous partagent. « Coût pour les autres » : points perdus par chacun des autres. Un vrai dilemme demande une valeur collective forte **et** une tentation positive.

| Variante | Guérison (partage / privé) | Fermeture (partage / privé) | Valeur collective | Tentation | Coût pour les autres |
|---|---:|---:|---:|---:|---:|
| `actuel` | 71 % / 11 % | 57 % / 100 % | +43 pts | +0,6 | +1,3 |
| `actuel+informateur` | 71 % / 11 % | 55 % / 100 % | +45 pts | −2,4 | +0,7 |
| `actuel+masque` | 40 % / 31 % | 99 % / 100 % | +1 pts | −0,9 | +2,0 |
| `actuel+examen-cible` | 61 % / 6 % | 78 % / 100 % | +22 pts | −0,1 | +2,9 |
| `actuel+examen-cible+informateur` | 61 % / 6 % | 81 % / 100 % | +19 pts | −2,4 | +2,3 |
| `releve` | 71 % / 20 % | 52 % / 100 % | +48 pts | +0,2 | +1,0 |
| `releve+passeur` | 72 % / 19 % | 51 % / 100 % | +49 pts | −2,0 | +0,7 |
| `releve+informateur` | 70 % / 20 % | 58 % / 100 % | +42 pts | −1,7 | +0,3 |
| `releve+passeur+un-mot` | 72 % / 19 % | 50 % / 100 % | +50 pts | −1,9 | +0,6 |
| `releve+passeur+masque` | 45 % / 6 % | 91 % / 100 % | +9 pts | −2,0 | +1,9 |
| `releve+examen-cible` | 63 % / 6 % | 76 % / 100 % | +24 pts | +1,0 | +2,1 |
| `releve+passeur+examen-cible` | 63 % / 7 % | 75 % / 100 % | +25 pts | −0,8 | +1,6 |
| `releve+passeur+gradue` | 59 % / 19 % | 88 % / 100 % | +12 pts | −0,8 | +0,7 |
| `passe+passeur` | 73 % / 56 % | 31 % / 68 % | +37 pts | −1,8 | −0,6 |
| `adressage+passeur` | 71 % / 69 % | 46 % / 57 % | +11 pts | −0,2 | +0,3 |
| `adressage+passeur+examen-cible` | 64 % / 65 % | 67 % / 70 % | +2 pts | 0,0 | 0,0 |
| `services+releve+passeur` | 35 % / 1 % | 99 % / 100 % | +1 pts | −0,8 | +1,7 |
| `services+adressage+passeur` | 53 % / 14 % | 87 % / 100 % | +13 pts | −4,8 | +0,9 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 0,5 | 10,9 | 0,0 | 1,0 | -4,3 | 1,0 |
| `actuel+informateur` | 0,7 | 8,4 | 7,0 | -1,5 | -0,9 | 0,4 |
| `actuel+masque` | -5,6 | 11,0 | 0,0 | -6,5 | -8,2 | -7,2 |
| `actuel+examen-cible` | -0,7 | 10,6 | 0,0 | -0,7 | -6,4 | -2,2 |
| `actuel+examen-cible+informateur` | -0,8 | 8,8 | 6,1 | -3,0 | -5,0 | -2,2 |
| `releve` | 1,3 | 10,4 | 0,0 | 1,9 | -2,4 | 1,3 |
| `releve+passeur` | 1,5 | 8,2 | 7,2 | -0,1 | -1,0 | 1,4 |
| `releve+informateur` | 1,0 | 8,7 | 6,9 | -0,1 | 0,7 | 0,5 |
| `releve+passeur+un-mot` | 1,6 | 8,3 | 7,2 | 0,1 | -0,7 | 1,5 |
| `releve+passeur+masque` | -1,8 | 10,2 | 4,5 | -2,9 | -2,4 | -4,7 |
| `releve+examen-cible` | -0,0 | 10,7 | 0,0 | 1,8 | -3,4 | -1,9 |
| `releve+passeur+examen-cible` | 0,1 | 8,8 | 6,3 | -0,1 | -2,0 | -1,4 |
| `releve+passeur+gradue` | -3,3 | 9,2 | 5,9 | -3,0 | -3,2 | -5,0 |
| `passe+passeur` | 4,1 | 8,2 | 7,3 | 2,4 | 2,2 | 5,9 |
| `adressage+passeur` | 1,9 | 12,9 | 2,0 | 1,7 | 1,4 | 1,6 |
| `adressage+passeur+examen-cible` | 0,8 | 12,9 | 4,1 | 1,0 | 0,9 | 0,7 |
| `services+releve+passeur` | -4,1 | 11,5 | 3,5 | -3,4 | -2,9 | -8,0 |
| `services+adressage+passeur` | -3,0 | 26,4 | 5,1 | -8,3 | -4,5 | -3,4 |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 58 | 0 % | 12 % | 81 % | 29 % | 10 % | 0 | 4,0 | 39 % |
| `actuel+informateur` | 58 | 0 % | 12 % | 80 % | 29 % | 11 % | 0 | 4,0 | 39 % |
| `actuel+masque` | 68 | 0 % | 40 % | 53 % | 60 % | 7 % | 0 | 4,0 | 38 % |
| `actuel+examen-cible` | 67 | 0 % | 6 % | 51 % | 39 % | 6 % | 0 | 4,0 | 38 % |
| `actuel+examen-cible+informateur` | 68 | 0 % | 6 % | 52 % | 39 % | 6 % | 0 | 4,0 | 40 % |
| `releve` | 73 | 0 % | 13 % | 80 % | 29 % | 2 % | 0 | 1,0 | 38 % |
| `releve+passeur` | 73 | 0 % | 12 % | 80 % | 28 % | 2 % | 0 | 1,0 | 39 % |
| `releve+informateur` | 73 | 0 % | 13 % | 80 % | 30 % | 2 % | 0 | 1,0 | 39 % |
| `releve+passeur+un-mot` | 72 | 0 % | 12 % | 81 % | 28 % | 2 % | 0 | 1,0 | 38 % |
| `releve+passeur+masque` | 84 | 0 % | 39 % | 47 % | 55 % | 1 % | 0 | 1,0 | 38 % |
| `releve+examen-cible` | 85 | 0 % | 7 % | 52 % | 37 % | 1 % | 0 | 1,0 | 39 % |
| `releve+passeur+examen-cible` | 85 | 0 % | 7 % | 51 % | 37 % | 1 % | 0 | 1,0 | 39 % |
| `releve+passeur+gradue` | 93 | 0 % | 6 % | 96 % | 41 % | 0 % | 0 | 1,0 | 39 % |
| `passe+passeur` | 68 | 0 % | 15 % | 82 % | 27 % | 0 % | 0 | 2,0 | 39 % |
| `adressage+passeur` | 68 | 1 % | 14 % | 26 % | 29 % | 4 % | 0 | 1,9 | 39 % |
| `adressage+passeur+examen-cible` | 92 | 10 % | 13 % | 0 % | 36 % | 5 % | 0 | 2,6 | 39 % |
| `services+releve+passeur` | 92 | 0 % | 39 % | 33 % | 65 % | 1 % | 0 | 1,0 | 40 % |
| `services+adressage+passeur` | 150 | 28 % | 22 % | 71 % | 47 % | 5 % | 0 | 4,0 | 38 % |
