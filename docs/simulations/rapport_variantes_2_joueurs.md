# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 2 joueurs vétérans, un médecin chacun · niveau Interne · seuil 70 · paliers d'aggravation 5, 11, 17, 23.

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
| `actuel` | 74 % / 74 % | 27 % / 31 % | +3 pts | +7,6 | +6,5 |
| `actuel+informateur` | 74 % / 74 % | 26 % / 31 % | +4 pts | +0,8 | +0,4 |
| `actuel+masque` | 52 % / 55 % | 63 % / 62 % | 0 pts | −3,3 | +8,1 |
| `actuel+examen-cible` | 67 % / 61 % | 41 % / 54 % | +14 pts | +0,8 | +8,7 |
| `actuel+examen-cible+informateur` | 66 % / 62 % | 42 % / 49 % | +8 pts | −3,4 | +4,0 |
| `releve` | 73 % / 74 % | 27 % / 27 % | +1 pts | +7,4 | +5,9 |
| `releve+passeur` | 73 % / 74 % | 26 % / 28 % | +2 pts | +1,7 | +0,8 |
| `releve+informateur` | 74 % / 73 % | 25 % / 32 % | +7 pts | +1,0 | +0,3 |
| `releve+passeur+un-mot` | 74 % / 73 % | 25 % / 30 % | +5 pts | +1,8 | +0,9 |
| `releve+passeur+masque` | 49 % / 55 % | 66 % / 58 % | −8 pts | −3,6 | +4,1 |
| `releve+examen-cible` | 62 % / 61 % | 46 % / 53 % | +7 pts | +2,3 | +8,4 |
| `releve+passeur+examen-cible` | 62 % / 61 % | 45 % / 52 % | +7 pts | −1,4 | +4,1 |
| `releve+passeur+gradue` | 74 % / 74 % | 26 % / 27 % | +1 pts | +2,0 | +0,7 |
| `passe+passeur` | 76 % / 75 % | 16 % / 17 % | +2 pts | +2,9 | +0,4 |
| `adressage+passeur` | 73 % / 74 % | 24 % / 22 % | −2 pts | −0,1 | −0,6 |
| `adressage+passeur+examen-cible` | 56 % / 56 % | 55 % / 54 % | −1 pts | +0,9 | +0,1 |
| `services+releve+passeur` | 66 % / 64 % | 40 % / 48 % | +8 pts | +0,5 | +0,3 |
| `services+adressage+passeur` | 63 % / 63 % | 44 % / 44 % | −1 pts | 0,0 | −1,0 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 8,1 | 8,5 | 0,0 | 15,5 | 1,8 | — |
| `actuel+informateur` | 8,2 | 5,5 | 6,9 | 8,9 | 7,9 | — |
| `actuel+masque` | 4,5 | 8,1 | 0,0 | 1,3 | -3,8 | — |
| `actuel+examen-cible` | 8,2 | 8,6 | 0,0 | 9,1 | -0,6 | — |
| `actuel+examen-cible+informateur` | 8,2 | 5,9 | 6,6 | 4,8 | 4,2 | — |
| `releve` | 9,6 | 8,7 | 0,0 | 17,5 | 3,3 | — |
| `releve+passeur` | 9,8 | 5,3 | 7,3 | 11,7 | 8,9 | — |
| `releve+informateur` | 9,8 | 5,7 | 7,0 | 11,1 | 9,3 | — |
| `releve+passeur+un-mot` | 10,0 | 5,4 | 7,4 | 11,8 | 9,0 | — |
| `releve+passeur+masque` | 5,0 | 6,9 | 4,9 | 1,1 | 1,3 | — |
| `releve+examen-cible` | 8,8 | 8,6 | 0,0 | 10,8 | 0,7 | — |
| `releve+passeur+examen-cible` | 8,9 | 6,1 | 6,2 | 7,5 | 4,9 | — |
| `releve+passeur+gradue` | 9,6 | 5,2 | 7,4 | 11,7 | 8,8 | — |
| `passe+passeur` | 12,2 | 5,0 | 7,6 | 15,0 | 12,0 | — |
| `adressage+passeur` | 9,7 | 9,8 | 1,4 | 9,9 | 10,0 | — |
| `adressage+passeur+examen-cible` | 6,6 | 9,0 | 2,2 | 7,5 | 6,7 | — |
| `services+releve+passeur` | 8,4 | 5,8 | 6,6 | 8,7 | 8,3 | — |
| `services+adressage+passeur` | 6,7 | 8,7 | 2,8 | 6,8 | 7,5 | — |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 49 | 0 % | 20 % | 49 % | 26 % | 0 % | 0 | 2,0 | 40 % |
| `actuel+informateur` | 48 | 0 % | 20 % | 50 % | 26 % | 0 % | 0 | 2,0 | 38 % |
| `actuel+masque` | 66 | 0 % | 40 % | 30 % | 48 % | 0 % | 0 | 2,0 | 39 % |
| `actuel+examen-cible` | 65 | 0 % | 14 % | 18 % | 33 % | 0 % | 0 | 2,0 | 39 % |
| `actuel+examen-cible+informateur` | 66 | 0 % | 14 % | 18 % | 34 % | 0 % | 0 | 2,0 | 39 % |
| `releve` | 56 | 0 % | 24 % | 51 % | 27 % | 0 % | 0 | 1,0 | 40 % |
| `releve+passeur` | 57 | 0 % | 23 % | 51 % | 27 % | 0 % | 0 | 1,0 | 40 % |
| `releve+informateur` | 56 | 0 % | 23 % | 50 % | 26 % | 0 % | 0 | 1,0 | 39 % |
| `releve+passeur+un-mot` | 56 | 0 % | 22 % | 50 % | 26 % | 0 % | 0 | 1,0 | 40 % |
| `releve+passeur+masque` | 78 | 0 % | 43 % | 31 % | 51 % | 0 % | 0 | 1,0 | 40 % |
| `releve+examen-cible` | 74 | 0 % | 18 % | 17 % | 38 % | 0 % | 0 | 1,0 | 40 % |
| `releve+passeur+examen-cible` | 74 | 0 % | 18 % | 17 % | 38 % | 0 % | 0 | 1,0 | 40 % |
| `releve+passeur+gradue` | 56 | 0 % | 23 % | 51 % | 26 % | 0 % | 0 | 1,0 | 40 % |
| `passe+passeur` | 56 | 0 % | 24 % | 50 % | 24 % | 0 % | 0 | 1,7 | 38 % |
| `adressage+passeur` | 55 | 2 % | 23 % | 16 % | 27 % | 2 % | 0 | 1,7 | 40 % |
| `adressage+passeur+examen-cible` | 80 | 8 % | 24 % | 0 % | 44 % | 2 % | 0 | 1,9 | 40 % |
| `services+releve+passeur` | 66 | 0 % | 30 % | 33 % | 34 % | 0 % | 0 | 1,0 | 40 % |
| `services+adressage+passeur` | 65 | 5 % | 30 % | 38 % | 37 % | 3 % | 0 | 2,0 | 39 % |
