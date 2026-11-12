# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 3 joueurs vétérans, un médecin chacun · niveau Interne · seuil 70 · paliers d'aggravation 2, 5, 8, 11.

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
| `actuel` | 82 % / 71 % | 16 % / 24 % | +8 pts | +1,2 | +1,1 |
| `actuel+informateur` | 83 % / 72 % | 15 % / 24 % | +9 pts | −2,5 | −0,4 |
| `actuel+masque` | 57 % / 60 % | 63 % / 42 % | −22 pts | −2,4 | +3,2 |
| `actuel+examen-cible` | 71 % / 34 % | 25 % / 90 % | +65 pts | +0,1 | +4,7 |
| `actuel+examen-cible+informateur` | 70 % / 34 % | 26 % / 89 % | +63 pts | −2,5 | +3,0 |
| `releve` | 80 % / 75 % | 15 % / 26 % | +11 pts | +0,5 | +1,0 |
| `releve+passeur` | 81 % / 77 % | 13 % / 27 % | +13 pts | −2,0 | −0,4 |
| `releve+informateur` | 81 % / 77 % | 13 % / 24 % | +11 pts | −2,9 | −0,7 |
| `releve+passeur+un-mot` | 80 % / 76 % | 15 % / 27 % | +12 pts | −1,6 | −0,2 |
| `releve+passeur+masque` | 57 % / 54 % | 47 % / 60 % | +13 pts | −3,1 | +2,5 |
| `releve+examen-cible` | 67 % / 49 % | 33 % / 74 % | +41 pts | +0,9 | +3,6 |
| `releve+passeur+examen-cible` | 67 % / 48 % | 35 % / 74 % | +38 pts | −1,8 | +2,3 |
| `releve+passeur+gradue` | 80 % / 76 % | 14 % / 28 % | +14 pts | −1,8 | −0,5 |
| `passe+passeur` | 82 % / 78 % | 6 % / 9 % | +3 pts | −1,3 | −1,0 |
| `adressage+passeur` | 81 % / 80 % | 11 % / 12 % | +1 pts | +0,3 | +0,3 |
| `adressage+passeur+examen-cible` | 65 % / 61 % | 37 % / 43 % | +6 pts | −0,3 | +0,2 |
| `services+releve+passeur` | 62 % / 53 % | 49 % / 75 % | +26 pts | −0,3 | +0,2 |
| `services+adressage+passeur` | 61 % / 59 % | 47 % / 52 % | +5 pts | −0,3 | 0,0 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 6,5 | 9,6 | 0,0 | 7,3 | 0,8 | 10,1 |
| `actuel+informateur` | 6,7 | 6,7 | 7,9 | 4,5 | 5,3 | 8,5 |
| `actuel+masque` | 1,9 | 10,1 | 0,0 | -0,7 | -3,1 | 0,6 |
| `actuel+examen-cible` | 5,8 | 9,9 | 0,0 | 5,8 | -1,4 | 3,9 |
| `actuel+examen-cible+informateur` | 5,6 | 7,5 | 6,9 | 3,1 | 0,7 | 4,3 |
| `releve` | 7,0 | 9,2 | 0,0 | 7,7 | 1,5 | 10,4 |
| `releve+passeur` | 7,2 | 7,0 | 8,1 | 5,5 | 5,6 | 9,2 |
| `releve+informateur` | 7,1 | 7,1 | 7,9 | 4,6 | 5,9 | 9,4 |
| `releve+passeur+un-mot` | 7,1 | 7,1 | 8,0 | 5,6 | 5,3 | 9,2 |
| `releve+passeur+masque` | 3,8 | 9,0 | 5,7 | 1,4 | 0,7 | 1,3 |
| `releve+examen-cible` | 5,4 | 10,3 | 0,0 | 6,9 | -0,4 | 3,5 |
| `releve+passeur+examen-cible` | 5,5 | 8,0 | 6,7 | 4,4 | 1,4 | 4,2 |
| `releve+passeur+gradue` | 7,0 | 7,3 | 8,0 | 5,6 | 5,4 | 9,4 |
| `passe+passeur` | 8,5 | 6,6 | 8,2 | 7,2 | 7,1 | 11,6 |
| `adressage+passeur` | 7,3 | 10,5 | 2,2 | 7,6 | 7,2 | 6,8 |
| `adressage+passeur+examen-cible` | 4,7 | 10,7 | 3,6 | 4,7 | 4,6 | 4,3 |
| `services+releve+passeur` | 3,9 | 8,7 | 6,2 | 4,6 | 3,8 | 2,5 |
| `services+adressage+passeur` | 2,9 | 11,1 | 3,6 | 2,9 | 3,0 | 2,4 |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 40 | 0 % | 11 % | 71 % | 18 % | 5 % | 0 | 3,0 | 20 % |
| `actuel+informateur` | 40 | 0 % | 11 % | 71 % | 17 % | 6 % | 0 | 3,0 | 20 % |
| `actuel+masque` | 55 | 0 % | 34 % | 47 % | 43 % | 2 % | 0 | 3,0 | 21 % |
| `actuel+examen-cible` | 51 | 0 % | 5 % | 44 % | 29 % | 4 % | 0 | 3,0 | 20 % |
| `actuel+examen-cible+informateur` | 52 | 0 % | 5 % | 45 % | 30 % | 3 % | 0 | 3,0 | 20 % |
| `releve` | 49 | 0 % | 13 % | 72 % | 20 % | 1 % | 0 | 1,0 | 21 % |
| `releve+passeur` | 48 | 0 % | 13 % | 73 % | 19 % | 2 % | 0 | 1,0 | 20 % |
| `releve+informateur` | 49 | 0 % | 13 % | 72 % | 19 % | 2 % | 0 | 1,0 | 20 % |
| `releve+passeur+un-mot` | 49 | 0 % | 13 % | 72 % | 20 % | 1 % | 0 | 1,0 | 21 % |
| `releve+passeur+masque` | 62 | 0 % | 35 % | 51 % | 43 % | 1 % | 0 | 1,0 | 20 % |
| `releve+examen-cible` | 63 | 0 % | 8 % | 49 % | 33 % | 0 % | 0 | 1,0 | 20 % |
| `releve+passeur+examen-cible` | 62 | 0 % | 8 % | 50 % | 33 % | 0 % | 0 | 1,0 | 21 % |
| `releve+passeur+gradue` | 48 | 0 % | 13 % | 73 % | 20 % | 1 % | 0 | 1,0 | 21 % |
| `passe+passeur` | 46 | 0 % | 14 % | 72 % | 18 % | 0 % | 0 | 1,8 | 21 % |
| `adressage+passeur` | 45 | 1 % | 13 % | 24 % | 19 % | 4 % | 0 | 1,9 | 20 % |
| `adressage+passeur+examen-cible` | 69 | 10 % | 15 % | 0 % | 35 % | 5 % | 0 | 2,4 | 21 % |
| `services+releve+passeur` | 63 | 0 % | 28 % | 51 % | 38 % | 0 % | 0 | 1,0 | 22 % |
| `services+adressage+passeur` | 61 | 4 % | 26 % | 52 % | 39 % | 6 % | 0 | 2,2 | 21 % |
