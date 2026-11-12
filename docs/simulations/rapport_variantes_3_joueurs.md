# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 3 joueurs vétérans, un médecin chacun · niveau Interne · seuil 70 · paliers d'aggravation 5, 11, 17, 23.

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
| `actuel` | 84 % / 79 % | 19 % / 27 % | +7 pts | +1,6 | +0,4 |
| `actuel+informateur` | 84 % / 79 % | 18 % / 25 % | +7 pts | −1,9 | −1,1 |
| `actuel+masque` | 61 % / 67 % | 71 % / 48 % | −22 pts | −2,3 | +3,6 |
| `actuel+examen-cible` | 77 % / 49 % | 30 % / 82 % | +52 pts | +1,2 | +3,9 |
| `actuel+examen-cible+informateur` | 77 % / 50 % | 27 % / 85 % | +57 pts | −2,2 | +2,4 |
| `releve` | 83 % / 81 % | 18 % / 26 % | +8 pts | +0,6 | +0,8 |
| `releve+passeur` | 82 % / 80 % | 19 % / 30 % | +11 pts | −1,4 | −0,8 |
| `releve+informateur` | 82 % / 80 % | 19 % / 32 % | +12 pts | −1,7 | −1,2 |
| `releve+passeur+un-mot` | 82 % / 79 % | 18 % / 34 % | +16 pts | −1,3 | −0,6 |
| `releve+passeur+masque` | 61 % / 61 % | 61 % / 66 % | +6 pts | −2,8 | +3,1 |
| `releve+examen-cible` | 72 % / 62 % | 40 % / 75 % | +35 pts | +1,5 | +3,8 |
| `releve+passeur+examen-cible` | 71 % / 62 % | 43 % / 73 % | +30 pts | −1,0 | +2,3 |
| `releve+passeur+gradue` | 83 % / 80 % | 14 % / 30 % | +15 pts | −1,9 | −0,1 |
| `passe+passeur` | 84 % / 83 % | 9 % / 12 % | +3 pts | −1,7 | −1,8 |
| `adressage+passeur` | 83 % / 82 % | 17 % / 16 % | −1 pts | +0,3 | +0,2 |
| `adressage+passeur+examen-cible` | 66 % / 65 % | 48 % / 51 % | +3 pts | +0,1 | +0,1 |
| `services+releve+passeur` | 67 % / 59 % | 55 % / 80 % | +26 pts | −0,4 | +0,5 |
| `services+adressage+passeur` | 63 % / 61 % | 58 % / 63 % | +6 pts | +0,3 | −0,1 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 6,6 | 9,5 | 0,0 | 7,9 | 2,0 | 10,7 |
| `actuel+informateur` | 6,7 | 6,7 | 8,1 | 4,9 | 6,0 | 9,5 |
| `actuel+masque` | 1,2 | 10,7 | 0,0 | -1,1 | -4,7 | 0,1 |
| `actuel+examen-cible` | 6,2 | 10,0 | 0,0 | 7,1 | -0,7 | 5,6 |
| `actuel+examen-cible+informateur` | 6,4 | 7,2 | 7,6 | 4,1 | 1,9 | 6,1 |
| `releve` | 7,1 | 9,6 | 0,0 | 8,1 | 1,3 | 11,0 |
| `releve+passeur` | 6,9 | 6,9 | 8,2 | 5,6 | 5,3 | 10,0 |
| `releve+informateur` | 6,8 | 6,9 | 8,0 | 5,4 | 5,9 | 9,9 |
| `releve+passeur+un-mot` | 7,1 | 6,8 | 8,2 | 6,0 | 5,3 | 10,0 |
| `releve+passeur+masque` | 3,3 | 8,8 | 6,1 | 1,9 | -2,7 | 1,7 |
| `releve+examen-cible` | 5,6 | 10,1 | 0,0 | 7,8 | -1,8 | 4,7 |
| `releve+passeur+examen-cible` | 5,4 | 7,9 | 7,1 | 5,1 | 0,3 | 5,2 |
| `releve+passeur+gradue` | 7,4 | 6,9 | 8,3 | 5,7 | 5,1 | 9,6 |
| `passe+passeur` | 8,9 | 6,6 | 8,4 | 7,4 | 8,3 | 12,9 |
| `adressage+passeur` | 7,0 | 11,3 | 2,3 | 7,3 | 6,8 | 6,8 |
| `adressage+passeur+examen-cible` | 4,2 | 11,9 | 3,7 | 4,5 | 4,1 | 4,1 |
| `services+releve+passeur` | 3,9 | 8,4 | 6,7 | 4,3 | 2,9 | 3,0 |
| `services+adressage+passeur` | 2,2 | 12,2 | 3,8 | 2,4 | 2,5 | 2,2 |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 42 | 0 % | 12 % | 71 % | 16 % | 1 % | 0 | 3,0 | 21 % |
| `actuel+informateur` | 42 | 0 % | 12 % | 70 % | 16 % | 3 % | 0 | 3,0 | 21 % |
| `actuel+masque` | 59 | 0 % | 35 % | 46 % | 39 % | 1 % | 0 | 3,0 | 22 % |
| `actuel+examen-cible` | 58 | 0 % | 6 % | 41 % | 23 % | 1 % | 0 | 3,0 | 21 % |
| `actuel+examen-cible+informateur` | 58 | 0 % | 6 % | 40 % | 23 % | 1 % | 0 | 3,0 | 22 % |
| `releve` | 52 | 0 % | 15 % | 70 % | 17 % | 0 % | 0 | 1,0 | 21 % |
| `releve+passeur` | 53 | 0 % | 16 % | 71 % | 18 % | 0 % | 0 | 1,0 | 22 % |
| `releve+informateur` | 53 | 0 % | 15 % | 71 % | 18 % | 1 % | 0 | 1,0 | 21 % |
| `releve+passeur+un-mot` | 53 | 0 % | 15 % | 69 % | 18 % | 1 % | 0 | 1,0 | 20 % |
| `releve+passeur+masque` | 72 | 0 % | 37 % | 47 % | 39 % | 0 % | 0 | 1,0 | 21 % |
| `releve+examen-cible` | 69 | 0 % | 10 % | 46 % | 28 % | 0 % | 0 | 1,0 | 20 % |
| `releve+passeur+examen-cible` | 70 | 0 % | 10 % | 45 % | 29 % | 0 % | 0 | 1,0 | 21 % |
| `releve+passeur+gradue` | 52 | 0 % | 14 % | 70 % | 17 % | 1 % | 0 | 1,0 | 20 % |
| `passe+passeur` | 50 | 0 % | 17 % | 70 % | 16 % | 0 % | 0 | 1,8 | 20 % |
| `adressage+passeur` | 50 | 2 % | 15 % | 24 % | 17 % | 3 % | 0 | 1,9 | 20 % |
| `adressage+passeur+examen-cible` | 78 | 10 % | 18 % | 0 % | 34 % | 4 % | 0 | 2,5 | 21 % |
| `services+releve+passeur` | 70 | 0 % | 29 % | 50 % | 33 % | 0 % | 0 | 1,0 | 20 % |
| `services+adressage+passeur` | 69 | 5 % | 28 % | 53 % | 37 % | 6 % | 0 | 2,2 | 21 % |
