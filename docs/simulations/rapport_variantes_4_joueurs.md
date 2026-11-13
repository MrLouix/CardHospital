# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 4 joueurs vétérans, un médecin chacun · niveau Interne · seuil 70 · paliers d'aggravation 5, 11, 17, 23.

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
| `actuel` | 74 % / 65 % | 48 % / 77 % | +29 pts | +0,7 | +0,3 |
| `actuel+informateur` | 74 % / 64 % | 48 % / 79 % | +30 pts | −1,7 | −0,3 |
| `actuel+masque` | 44 % / 44 % | 96 % / 95 % | −2 pts | −1,5 | +2,0 |
| `actuel+examen-cible` | 67 % / 28 % | 63 % / 100 % | +37 pts | +0,4 | +1,8 |
| `actuel+examen-cible+informateur` | 67 % / 27 % | 63 % / 100 % | +38 pts | −1,5 | +1,1 |
| `releve` | 74 % / 70 % | 42 % / 69 % | +26 pts | +1,1 | +0,5 |
| `releve+passeur` | 74 % / 70 % | 43 % / 70 % | +27 pts | −1,3 | 0,0 |
| `releve+informateur` | 74 % / 70 % | 42 % / 69 % | +27 pts | −1,4 | −0,2 |
| `releve+passeur+un-mot` | 74 % / 71 % | 42 % / 65 % | +23 pts | −1,3 | 0,0 |
| `releve+passeur+masque` | 47 % / 35 % | 87 % / 99 % | +12 pts | −1,3 | +1,7 |
| `releve+examen-cible` | 68 % / 42 % | 62 % / 98 % | +37 pts | −0,7 | +1,7 |
| `releve+passeur+examen-cible` | 66 % / 43 % | 64 % / 99 % | +35 pts | −1,6 | +0,8 |
| `releve+passeur+gradue` | 74 % / 72 % | 43 % / 66 % | +23 pts | −1,1 | −0,1 |
| `passe+passeur` | 75 % / 74 % | 27 % / 34 % | +8 pts | −0,8 | −1,1 |
| `adressage+passeur` | 75 % / 74 % | 32 % / 37 % | +5 pts | −0,3 | +0,2 |
| `adressage+passeur+examen-cible` | 67 % / 67 % | 55 % / 56 % | +2 pts | −0,4 | +0,1 |
| `services+releve+passeur` | 59 % / 45 % | 76 % / 98 % | +22 pts | −0,2 | +0,2 |
| `services+adressage+passeur` | 57 % / 54 % | 75 % / 84 % | +9 pts | +0,1 | +0,1 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 1,9 | 10,0 | 0,0 | 2,5 | -2,1 | 3,6 |
| `actuel+informateur` | 1,9 | 8,0 | 7,4 | 0,1 | 0,8 | 2,9 |
| `actuel+masque` | -4,1 | 11,0 | 0,0 | -5,5 | -7,3 | -5,5 |
| `actuel+examen-cible` | 1,3 | 10,4 | 0,0 | 1,6 | -3,8 | 1,3 |
| `actuel+examen-cible+informateur` | 1,3 | 8,4 | 6,7 | -0,3 | -1,8 | 1,4 |
| `releve` | 2,6 | 10,1 | 0,0 | 4,1 | -1,1 | 3,6 |
| `releve+passeur` | 2,7 | 7,9 | 7,4 | 1,7 | 1,5 | 3,1 |
| `releve+informateur` | 2,7 | 7,9 | 7,4 | 1,6 | 2,0 | 3,2 |
| `releve+passeur+un-mot` | 2,7 | 7,9 | 7,4 | 1,8 | 1,8 | 3,0 |
| `releve+passeur+masque` | -1,0 | 10,3 | 4,7 | -1,7 | -1,7 | -3,6 |
| `releve+examen-cible` | 2,0 | 10,4 | 0,0 | 2,0 | -1,8 | 0,9 |
| `releve+passeur+examen-cible` | 1,7 | 8,5 | 6,6 | 0,7 | 0,1 | 1,1 |
| `releve+passeur+gradue` | 2,6 | 8,0 | 7,4 | 1,9 | 1,6 | 3,0 |
| `passe+passeur` | 4,7 | 7,8 | 7,5 | 4,0 | 4,1 | 6,6 |
| `adressage+passeur` | 3,3 | 12,9 | 2,2 | 3,3 | 3,1 | 3,0 |
| `adressage+passeur+examen-cible` | 2,3 | 12,1 | 4,2 | 2,1 | 2,1 | 2,1 |
| `services+releve+passeur` | 0,5 | 9,6 | 5,9 | 1,2 | 1,2 | -0,6 |
| `services+adressage+passeur` | -0,3 | 13,6 | 3,7 | -0,1 | -0,5 | -0,5 |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 49 | 0 % | 16 % | 86 % | 26 % | 11 % | 0 | 4,0 | 38 % |
| `actuel+informateur` | 48 | 0 % | 17 % | 86 % | 26 % | 12 % | 0 | 4,0 | 39 % |
| `actuel+masque` | 65 | 0 % | 43 % | 60 % | 56 % | 7 % | 0 | 4,0 | 40 % |
| `actuel+examen-cible` | 62 | 0 % | 8 % | 66 % | 33 % | 9 % | 0 | 4,0 | 39 % |
| `actuel+examen-cible+informateur` | 62 | 0 % | 8 % | 65 % | 33 % | 8 % | 0 | 4,0 | 40 % |
| `releve` | 63 | 0 % | 18 % | 87 % | 26 % | 3 % | 0 | 1,0 | 39 % |
| `releve+passeur` | 63 | 0 % | 18 % | 87 % | 26 % | 3 % | 0 | 1,0 | 39 % |
| `releve+informateur` | 64 | 0 % | 18 % | 86 % | 26 % | 2 % | 0 | 1,0 | 39 % |
| `releve+passeur+un-mot` | 64 | 0 % | 18 % | 86 % | 26 % | 2 % | 0 | 1,0 | 38 % |
| `releve+passeur+masque` | 80 | 0 % | 43 % | 63 % | 53 % | 2 % | 0 | 1,0 | 39 % |
| `releve+examen-cible` | 77 | 0 % | 9 % | 64 % | 32 % | 2 % | 0 | 1,0 | 38 % |
| `releve+passeur+examen-cible` | 77 | 0 % | 9 % | 66 % | 34 % | 1 % | 0 | 1,0 | 38 % |
| `releve+passeur+gradue` | 64 | 0 % | 18 % | 86 % | 26 % | 3 % | 0 | 1,0 | 39 % |
| `passe+passeur` | 58 | 0 % | 21 % | 87 % | 25 % | 0 % | 0 | 2,1 | 39 % |
| `adressage+passeur` | 58 | 1 % | 20 % | 25 % | 25 % | 5 % | 0 | 2,0 | 38 % |
| `adressage+passeur+examen-cible` | 80 | 8 % | 16 % | 0 % | 33 % | 5 % | 0 | 2,6 | 38 % |
| `services+releve+passeur` | 77 | 0 % | 34 % | 59 % | 41 % | 1 % | 0 | 1,0 | 38 % |
| `services+adressage+passeur` | 75 | 4 % | 30 % | 60 % | 43 % | 6 % | 0 | 2,3 | 38 % |
