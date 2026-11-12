# Variantes de partage — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par variante et par population · 3 joueurs vétérans, un médecin chacun · niveau Réanimation · seuil 70 · paliers d'aggravation 5, 11, 17, 23.

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
| `actuel` | 76 % / 44 % | 48 % / 93 % | +45 pts | −0,1 | +1,5 |
| `actuel+informateur` | 75 % / 45 % | 50 % / 92 % | +42 pts | −2,3 | −0,6 |
| `actuel+masque` | 48 % / 39 % | 91 % / 97 % | +5 pts | +0,1 | +4,2 |
| `actuel+examen-cible` | 56 % / 15 % | 76 % / 100 % | +24 pts | −0,8 | +5,6 |
| `actuel+examen-cible+informateur` | 54 % / 15 % | 79 % / 100 % | +21 pts | −2,4 | +4,3 |
| `releve` | 75 % / 59 % | 48 % / 81 % | +34 pts | +0,3 | +1,7 |
| `releve+passeur` | 75 % / 61 % | 48 % / 77 % | +29 pts | −1,7 | +0,2 |
| `releve+informateur` | 74 % / 60 % | 48 % / 79 % | +31 pts | −2,1 | +0,2 |
| `releve+passeur+un-mot` | 74 % / 60 % | 46 % / 79 % | +33 pts | −1,3 | +0,4 |
| `releve+passeur+masque` | 48 % / 36 % | 88 % / 98 % | +9 pts | −1,3 | +2,9 |
| `releve+examen-cible` | 56 % / 25 % | 79 % / 100 % | +21 pts | +2,1 | +5,0 |
| `releve+passeur+examen-cible` | 56 % / 26 % | 79 % / 100 % | +20 pts | −1,1 | +3,8 |
| `releve+passeur+gradue` | 75 % / 60 % | 47 % / 78 % | +31 pts | −1,4 | +0,4 |
| `passe+passeur` | 79 % / 73 % | 36 % / 43 % | +6 pts | −0,9 | −2,1 |
| `adressage+passeur` | 77 % / 73 % | 44 % / 51 % | +7 pts | −0,1 | 0,0 |
| `adressage+passeur+examen-cible` | 58 % / 54 % | 76 % / 81 % | +5 pts | +0,3 | −0,2 |
| `services+releve+passeur` | 54 % / 35 % | 84 % / 99 % | +15 pts | −0,6 | +0,3 |
| `services+adressage+passeur` | 58 % / 51 % | 82 % / 88 % | +6 pts | −1,0 | −0,4 |

## Qui gagne quoi

Points de victoire moyens par partie. Quand un seul se tait, il est à la place 1 ; son voisin de gauche, qui reçoit ses patients, est à la place 2. « Écart » : écart moyen entre le premier et le dernier quand tous partagent. « Primes » : points versés au passeur ou à l'informateur, par partie.

| Variante | Tous partagent | Écart | Primes | Un seul se tait : lui | Son voisin de gauche | Les autres |
|---|---:|---:|---:|---:|---:|---:|
| `actuel` | 7,8 | 14,3 | 0,0 | 7,9 | 3,2 | 9,2 |
| `actuel+informateur` | 7,7 | 12,8 | 7,1 | 6,0 | 6,9 | 9,2 |
| `actuel+masque` | 2,2 | 16,3 | 0,0 | 2,5 | -3,9 | -0,5 |
| `actuel+examen-cible` | 5,9 | 15,2 | 0,0 | 5,4 | -1,9 | 2,2 |
| `actuel+examen-cible+informateur` | 5,5 | 14,4 | 5,3 | 3,1 | -0,8 | 3,0 |
| `releve` | 9,7 | 14,1 | 0,0 | 10,7 | 3,6 | 11,6 |
| `releve+passeur` | 9,7 | 12,7 | 7,3 | 8,7 | 6,7 | 11,6 |
| `releve+informateur` | 9,4 | 12,9 | 7,0 | 8,1 | 7,3 | 10,5 |
| `releve+passeur+un-mot` | 9,8 | 12,4 | 7,2 | 9,2 | 7,0 | 11,0 |
| `releve+passeur+masque` | 5,5 | 16,2 | 4,6 | 6,6 | -1,2 | 4,1 |
| `releve+examen-cible` | 7,8 | 15,5 | 0,0 | 11,7 | -0,7 | 4,5 |
| `releve+passeur+examen-cible` | 7,8 | 14,9 | 5,3 | 9,0 | -0,2 | 5,8 |
| `releve+passeur+gradue` | 9,8 | 12,3 | 7,2 | 8,9 | 6,9 | 11,3 |
| `passe+passeur` | 13,0 | 11,7 | 7,8 | 12,5 | 13,6 | 16,2 |
| `adressage+passeur` | 9,9 | 15,7 | 2,0 | 9,9 | 9,8 | 9,8 |
| `adressage+passeur+examen-cible` | 7,6 | 16,4 | 2,9 | 8,3 | 7,8 | 7,6 |
| `services+releve+passeur` | 6,0 | 15,2 | 5,1 | 7,4 | 4,5 | 5,0 |
| `services+adressage+passeur` | 4,7 | 16,6 | 3,2 | 4,2 | 4,8 | 4,8 |

## Signaux de problème en jeu

Quand tous partagent. « Tours vides » : tours où le joueur n'a aucun patient. « Actes sans intérêt » : diagnostics refaits faute de mieux, alors que le joueur voyait déjà un diagnostic sûr. « Sur parole » : guérisons par un joueur qui n'a jamais diagnostiqué le patient. « Morts héritées » : morts au premier acte d'un joueur sur un patient reçu d'un autre. « Engorgement » : plus grand nombre de patients tenus par un même joueur. « Patients orphelins » : patients dont la spécialité n'est celle d'aucun joueur de la table.

| Variante | Tours / partie | Tours vides | Actes sans intérêt | Sur parole | Mort | Morts héritées | Abandons | Engorgement | Patients orphelins |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `actuel` | 35 | 0 % | 7 % | 76 % | 24 % | 33 % | 0 | 3,0 | 20 % |
| `actuel+informateur` | 35 | 0 % | 8 % | 74 % | 25 % | 33 % | 0 | 3,0 | 22 % |
| `actuel+masque` | 44 | 0 % | 31 % | 57 % | 52 % | 31 % | 0 | 3,0 | 21 % |
| `actuel+examen-cible` | 42 | 0 % | 3 % | 55 % | 44 % | 32 % | 0 | 3,0 | 21 % |
| `actuel+examen-cible+informateur` | 43 | 0 % | 3 % | 54 % | 46 % | 31 % | 0 | 3,0 | 21 % |
| `releve` | 43 | 0 % | 11 % | 76 % | 25 % | 14 % | 0 | 1,0 | 20 % |
| `releve+passeur` | 42 | 0 % | 11 % | 76 % | 25 % | 13 % | 0 | 1,0 | 20 % |
| `releve+informateur` | 43 | 0 % | 11 % | 75 % | 26 % | 13 % | 0 | 1,0 | 20 % |
| `releve+passeur+un-mot` | 43 | 0 % | 11 % | 75 % | 26 % | 13 % | 0 | 1,0 | 20 % |
| `releve+passeur+masque` | 52 | 0 % | 33 % | 58 % | 52 % | 6 % | 0 | 1,0 | 21 % |
| `releve+examen-cible` | 53 | 0 % | 6 % | 57 % | 44 % | 7 % | 0 | 1,0 | 20 % |
| `releve+passeur+examen-cible` | 53 | 0 % | 6 % | 56 % | 44 % | 6 % | 0 | 1,0 | 20 % |
| `releve+passeur+gradue` | 42 | 0 % | 11 % | 76 % | 25 % | 13 % | 0 | 1,0 | 20 % |
| `passe+passeur` | 43 | 0 % | 13 % | 73 % | 21 % | 5 % | 0 | 1,8 | 21 % |
| `adressage+passeur` | 40 | 1 % | 11 % | 23 % | 23 % | 5 % | 0 | 1,9 | 21 % |
| `adressage+passeur+examen-cible` | 57 | 9 % | 10 % | 0 % | 42 % | 8 % | 0 | 2,4 | 20 % |
| `services+releve+passeur` | 51 | 0 % | 25 % | 60 % | 46 % | 9 % | 0 | 1,0 | 21 % |
| `services+adressage+passeur` | 48 | 3 % | 22 % | 54 % | 42 % | 6 % | 0 | 2,1 | 21 % |
