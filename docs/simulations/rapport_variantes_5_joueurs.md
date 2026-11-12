# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 5 joueurs vétérans, un médecin chacun · niveau Interne · seuil 70 · paliers d'aggravation 5, 11, 17, 23.

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
| `actuel` | 80 % / 45 % | 36 % / 100 % | +64 pts | +0,5 | +0,7 |
| `actuel+informateur` | 80 % / 45 % | 37 % / 100 % | +63 pts | −1,7 | 0,0 |
| `actuel+masque` | 47 % / 31 % | 98 % / 100 % | +2 pts | −0,4 | +1,4 |
| `actuel+examen-cible` | 70 % / 16 % | 68 % / 100 % | +32 pts | −0,5 | +1,5 |
| `actuel+examen-cible+informateur` | 71 % / 17 % | 66 % / 100 % | +34 pts | −2,4 | +1,3 |
| `releve` | 79 % / 69 % | 33 % / 95 % | +62 pts | +0,1 | +0,4 |
| `releve+passeur` | 79 % / 69 % | 36 % / 94 % | +58 pts | −0,9 | −0,3 |
| `releve+informateur` | 79 % / 69 % | 36 % / 94 % | +58 pts | −1,3 | −0,1 |
| `releve+passeur+un-mot` | 79 % / 68 % | 35 % / 94 % | +59 pts | −1,2 | −0,1 |
| `releve+passeur+masque` | 50 % / 27 % | 92 % / 100 % | +8 pts | −1,6 | +1,1 |
| `releve+examen-cible` | 72 % / 29 % | 58 % / 100 % | +42 pts | 0,0 | +1,2 |
| `releve+passeur+examen-cible` | 72 % / 28 % | 59 % / 100 % | +42 pts | −1,6 | +0,7 |
| `releve+passeur+gradue` | 80 % / 68 % | 32 % / 94 % | +63 pts | −1,3 | +0,2 |
| `passe+passeur` | 80 % / 78 % | 20 % / 31 % | +12 pts | −1,6 | −0,4 |
| `adressage+passeur` | 79 % / 78 % | 28 % / 33 % | +5 pts | +0,2 | 0,0 |
| `adressage+passeur+examen-cible` | 75 % / 74 % | 48 % / 49 % | +1 pts | 0,0 | +0,1 |
| `services+releve+passeur` | 56 % / 34 % | 89 % / 100 % | +11 pts | −0,4 | +0,5 |
| `services+adressage+passeur` | 55 % / 54 % | 81 % / 90 % | +8 pts | +0,6 | −0,2 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 2,2 | 10,0 | 0,0 | 2,2 | -1,6 | 2,7 |
| `actuel+informateur` | 2,1 | 7,5 | 8,0 | 0,7 | 1,1 | 2,5 |
| `actuel+masque` | -3,9 | 11,5 | 0,0 | -4,5 | -6,5 | -4,8 |
| `actuel+examen-cible` | 0,4 | 10,2 | 0,0 | -0,1 | -3,8 | -0,2 |
| `actuel+examen-cible+informateur` | 0,6 | 8,4 | 7,1 | -1,7 | -2,4 | -0,1 |
| `releve` | 2,4 | 9,7 | 0,0 | 2,9 | -1,2 | 3,0 |
| `releve+passeur` | 2,3 | 7,8 | 7,9 | 1,6 | 1,2 | 3,0 |
| `releve+informateur` | 2,4 | 7,7 | 7,9 | 1,4 | 1,3 | 2,8 |
| `releve+passeur+un-mot` | 2,5 | 7,7 | 7,9 | 1,4 | 1,2 | 2,9 |
| `releve+passeur+masque` | -1,5 | 9,8 | 5,0 | -1,7 | -4,7 | -2,4 |
| `releve+examen-cible` | 1,4 | 10,1 | 0,0 | 1,9 | -2,8 | 1,1 |
| `releve+passeur+examen-cible` | 1,4 | 8,2 | 7,2 | 0,5 | -1,5 | 1,1 |
| `releve+passeur+gradue` | 2,7 | 7,7 | 8,0 | 1,6 | 1,1 | 2,8 |
| `passe+passeur` | 4,1 | 7,6 | 8,0 | 2,7 | 3,2 | 4,9 |
| `adressage+passeur` | 2,9 | 12,4 | 2,7 | 2,9 | 3,0 | 2,9 |
| `adressage+passeur+examen-cible` | 2,2 | 11,6 | 5,3 | 2,2 | 2,1 | 2,1 |
| `services+releve+passeur` | -1,2 | 9,8 | 5,6 | -0,3 | -2,0 | -1,9 |
| `services+adressage+passeur` | -1,2 | 13,5 | 3,8 | -0,8 | -1,0 | -0,9 |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 45 | 0 % | 13 % | 92 % | 20 % | 28 % | 0 | 5,0 | 27 % |
| `actuel+informateur` | 46 | 0 % | 13 % | 92 % | 20 % | 28 % | 0 | 5,0 | 28 % |
| `actuel+masque` | 63 | 0 % | 42 % | 72 % | 53 % | 32 % | 0 | 5,0 | 27 % |
| `actuel+examen-cible` | 58 | 0 % | 6 % | 79 % | 30 % | 24 % | 0 | 5,0 | 27 % |
| `actuel+examen-cible+informateur` | 57 | 0 % | 5 % | 80 % | 29 % | 25 % | 0 | 5,0 | 28 % |
| `releve` | 66 | 0 % | 14 % | 92 % | 21 % | 10 % | 0 | 1,0 | 27 % |
| `releve+passeur` | 67 | 0 % | 15 % | 92 % | 21 % | 9 % | 0 | 1,0 | 29 % |
| `releve+informateur` | 66 | 0 % | 14 % | 92 % | 21 % | 10 % | 0 | 1,0 | 28 % |
| `releve+passeur+un-mot` | 66 | 0 % | 14 % | 92 % | 21 % | 8 % | 0 | 1,0 | 28 % |
| `releve+passeur+masque` | 81 | 0 % | 42 % | 73 % | 50 % | 6 % | 0 | 1,0 | 28 % |
| `releve+examen-cible` | 79 | 0 % | 7 % | 78 % | 28 % | 6 % | 0 | 1,0 | 27 % |
| `releve+passeur+examen-cible` | 79 | 0 % | 6 % | 78 % | 28 % | 5 % | 0 | 1,0 | 28 % |
| `releve+passeur+gradue` | 65 | 0 % | 14 % | 92 % | 20 % | 10 % | 0 | 1,0 | 27 % |
| `passe+passeur` | 55 | 0 % | 16 % | 93 % | 20 % | 3 % | 0 | 2,1 | 29 % |
| `adressage+passeur` | 58 | 1 % | 16 % | 29 % | 21 % | 5 % | 0 | 2,0 | 28 % |
| `adressage+passeur+examen-cible` | 83 | 6 % | 12 % | 0 % | 26 % | 7 % | 0 | 2,8 | 28 % |
| `services+releve+passeur` | 83 | 0 % | 34 % | 69 % | 44 % | 5 % | 0 | 1,0 | 27 % |
| `services+adressage+passeur` | 80 | 3 % | 30 % | 64 % | 45 % | 7 % | 0 | 2,4 | 28 % |
