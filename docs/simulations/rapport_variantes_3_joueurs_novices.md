# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 3 joueurs novices, avec laboratoire, un médecin chacun · niveau Interne · seuil 70 · paliers d'aggravation 5, 11, 17, 23.

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
| `actuel` | 81 % / 41 % | 26 % / 95 % | +69 pts | +2,9 | +3,3 |
| `actuel+informateur` | 81 % / 41 % | 23 % / 94 % | +71 pts | −1,6 | +1,1 |
| `actuel+masque` | 57 % / 56 % | 81 % / 74 % | −7 pts | −2,8 | +3,5 |
| `actuel+examen-cible` | 71 % / 16 % | 43 % / 100 % | +57 pts | −2,5 | +5,0 |
| `actuel+examen-cible+informateur` | 71 % / 16 % | 43 % / 100 % | +57 pts | −4,3 | +3,7 |
| `releve` | 79 % / 67 % | 27 % / 75 % | +48 pts | +3,4 | +3,6 |
| `releve+passeur` | 79 % / 67 % | 27 % / 76 % | +49 pts | −0,2 | +2,0 |
| `releve+informateur` | 80 % / 67 % | 26 % / 74 % | +48 pts | −0,4 | +1,5 |
| `releve+passeur+un-mot` | 80 % / 66 % | 26 % / 78 % | +52 pts | +0,1 | +1,8 |
| `releve+passeur+masque` | 59 % / 44 % | 66 % / 97 % | +31 pts | −2,6 | +2,8 |
| `releve+examen-cible` | 69 % / 34 % | 52 % / 99 % | +47 pts | −0,7 | +4,5 |
| `releve+passeur+examen-cible` | 69 % / 33 % | 52 % / 99 % | +47 pts | −2,9 | +3,8 |
| `releve+passeur+gradue` | 71 % / 67 % | 52 % / 74 % | +22 pts | −1,8 | +0,1 |
| `passe+passeur` | 82 % / 76 % | 14 % / 26 % | +12 pts | +1,6 | +0,5 |
| `adressage+passeur` | 80 % / 78 % | 25 % / 33 % | +9 pts | +0,1 | +0,6 |
| `adressage+passeur+examen-cible` | 65 % / 62 % | 56 % / 65 % | +9 pts | +0,1 | +0,4 |
| `services+releve+passeur` | 50 % / 11 % | 87 % / 100 % | +13 pts | −2,5 | +4,1 |
| `services+adressage+passeur` | 60 % / 22 % | 71 % / 99 % | +29 pts | −5,0 | +2,5 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 5,2 | 10,9 | 0,0 | 8,1 | -0,9 | 4,5 |
| `actuel+informateur` | 5,3 | 8,2 | 7,2 | 4,4 | 4,4 | 3,3 |
| `actuel+masque` | -0,5 | 10,4 | 0,0 | -3,0 | -6,3 | -2,1 |
| `actuel+examen-cible` | 4,1 | 9,9 | 0,0 | 1,9 | -4,5 | 2,3 |
| `actuel+examen-cible+informateur` | 4,0 | 8,2 | 6,9 | -0,0 | -0,3 | 0,7 |
| `releve` | 5,5 | 10,9 | 0,0 | 9,8 | -1,0 | 4,0 |
| `releve+passeur` | 5,4 | 7,3 | 7,9 | 5,7 | 1,4 | 5,0 |
| `releve+informateur` | 5,6 | 8,2 | 7,5 | 5,7 | 5,0 | 2,6 |
| `releve+passeur+un-mot` | 5,6 | 7,4 | 8,0 | 6,1 | 1,5 | 5,7 |
| `releve+passeur+masque` | 2,2 | 8,5 | 5,9 | 1,0 | -3,4 | 0,7 |
| `releve+examen-cible` | 3,9 | 9,9 | 0,0 | 4,1 | -5,2 | 3,1 |
| `releve+passeur+examen-cible` | 3,9 | 7,8 | 6,9 | 1,9 | -3,2 | 2,5 |
| `releve+passeur+gradue` | 2,0 | 7,7 | 7,1 | 0,8 | -0,6 | 3,7 |
| `passe+passeur` | 7,6 | 7,1 | 8,2 | 9,2 | 5,0 | 9,3 |
| `adressage+passeur` | 5,6 | 11,4 | 2,2 | 5,6 | 4,8 | 5,2 |
| `adressage+passeur+examen-cible` | 3,0 | 12,5 | 3,5 | 3,1 | 2,9 | 2,3 |
| `services+releve+passeur` | -0,5 | 9,9 | 5,0 | -1,6 | -7,3 | -3,2 |
| `services+adressage+passeur` | -0,4 | 20,1 | 5,7 | -6,2 | -3,1 | -1,9 |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 52 | 0 % | 8 % | 54 % | 19 % | 2 % | 0 | 3,0 | 20 % |
| `actuel+informateur` | 52 | 0 % | 8 % | 55 % | 19 % | 2 % | 0 | 3,0 | 20 % |
| `actuel+masque` | 64 | 0 % | 31 % | 34 % | 43 % | 0 % | 0 | 3,0 | 21 % |
| `actuel+examen-cible` | 65 | 0 % | 4 % | 23 % | 29 % | 1 % | 0 | 3,0 | 20 % |
| `actuel+examen-cible+informateur` | 65 | 0 % | 4 % | 22 % | 29 % | 1 % | 0 | 3,0 | 21 % |
| `releve` | 63 | 0 % | 11 % | 57 % | 21 % | 0 % | 0 | 1,0 | 21 % |
| `releve+passeur` | 63 | 0 % | 10 % | 57 % | 21 % | 0 % | 0 | 1,0 | 20 % |
| `releve+informateur` | 63 | 0 % | 10 % | 57 % | 20 % | 0 % | 0 | 1,0 | 20 % |
| `releve+passeur+un-mot` | 63 | 0 % | 10 % | 56 % | 20 % | 0 % | 0 | 1,0 | 19 % |
| `releve+passeur+masque` | 77 | 0 % | 32 % | 28 % | 41 % | 0 % | 0 | 1,0 | 21 % |
| `releve+examen-cible` | 78 | 0 % | 8 % | 19 % | 31 % | 0 % | 0 | 1,0 | 21 % |
| `releve+passeur+examen-cible` | 78 | 0 % | 8 % | 20 % | 31 % | 0 % | 0 | 1,0 | 21 % |
| `releve+passeur+gradue` | 80 | 0 % | 6 % | 77 % | 29 % | 0 % | 0 | 1,0 | 21 % |
| `passe+passeur` | 61 | 0 % | 12 % | 58 % | 18 % | 0 % | 0 | 2,1 | 21 % |
| `adressage+passeur` | 61 | 2 % | 11 % | 24 % | 20 % | 3 % | 0 | 2,0 | 21 % |
| `adressage+passeur+examen-cible` | 88 | 12 % | 15 % | 0 % | 35 % | 3 % | 0 | 2,5 | 21 % |
| `services+releve+passeur` | 86 | 0 % | 33 % | 24 % | 50 % | 0 % | 0 | 1,0 | 21 % |
| `services+adressage+passeur` | 111 | 27 % | 19 % | 63 % | 40 % | 4 % | 0 | 3,0 | 20 % |
