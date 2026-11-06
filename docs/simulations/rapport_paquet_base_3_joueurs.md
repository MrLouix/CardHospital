# Rapport de simulation — CardHospital — paquet de base 2.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 3 joueurs à tour de rôle · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Analyses / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard · partage | Interne | 7,0 % | 93,0 % | 0 | 7,57 | 3,78 | 0,00 | 0,66 | -0,95 | -7,17 |
| seuil:70 · partage | Interne | 96,9 % | 3,1 % | 0 | 3,26 | 2,02 | 0,00 | 1,63 | 0,44 | 1,43 |
| couleur:70 · partage | Interne | 97,9 % | 2,1 % | 0 | 3,18 | 1,94 | 0,00 | 1,66 | 0,48 | 1,51 |
| novice:70 · partage | Interne | 34,0 % | 66,0 % | 1 | 10,48 | 3,58 | 0,00 | 0,94 | -0,74 | -7,73 |
| novice+labo:70 · partage | Interne | 84,2 % | 15,8 % | 0 | 4,52 | 1,71 | 1,01 | 1,11 | -0,01 | -0,03 |
| hasard · privé | Interne | 7,5 % | 92,5 % | 0 | 7,60 | 3,79 | 0,00 | 0,66 | -0,94 | -7,16 |
| seuil:70 · privé | Interne | 96,7 % | 3,4 % | 0 | 3,41 | 2,18 | 0,00 | 1,60 | 0,43 | 1,48 |
| couleur:70 · privé | Interne | 97,4 % | 2,6 % | 0 | 3,34 | 2,09 | 0,00 | 1,62 | 0,47 | 1,56 |
| novice:70 · privé | Interne | 28,0 % | 72,0 % | 1 | 8,82 | 4,92 | 0,00 | 0,90 | -0,70 | -6,14 |
| novice+labo:70 · privé | Interne | 86,7 % | 13,3 % | 0 | 4,54 | 2,03 | 1,18 | 1,11 | 0,14 | 0,62 |
| hasard · partage | Chirurgien | 5,0 % | 95,0 % | 0 | 5,25 | 2,64 | 0,00 | 1,26 | -1,59 | -8,35 |
| seuil:70 · partage | Chirurgien | 90,5 % | 9,6 % | 0 | 3,07 | 1,93 | 0,00 | 2,54 | 0,26 | 0,81 |
| couleur:70 · partage | Chirurgien | 92,3 % | 7,6 % | 0 | 3,05 | 1,88 | 0,00 | 2,58 | 0,32 | 0,97 |
| novice:70 · partage | Chirurgien | 32,2 % | 67,8 % | 1 | 8,96 | 3,05 | 0,00 | 1,86 | -1,23 | -11,00 |
| novice+labo:70 · partage | Chirurgien | 77,1 % | 22,9 % | 0 | 4,18 | 1,68 | 0,97 | 1,81 | -0,26 | -1,09 |
| hasard · privé | Chirurgien | 5,3 % | 94,8 % | 0 | 5,25 | 2,62 | 0,00 | 1,26 | -1,59 | -8,33 |
| seuil:70 · privé | Chirurgien | 90,2 % | 9,8 % | 0 | 3,22 | 2,08 | 0,00 | 2,51 | 0,28 | 0,91 |
| couleur:70 · privé | Chirurgien | 91,6 % | 8,4 % | 0 | 3,19 | 2,02 | 0,00 | 2,54 | 0,32 | 1,01 |
| novice:70 · privé | Chirurgien | 24,4 % | 75,6 % | 0 | 6,61 | 3,63 | 0,00 | 1,74 | -1,09 | -7,22 |
| novice+labo:70 · privé | Chirurgien | 79,2 % | 20,8 % | 0 | 4,17 | 1,93 | 1,08 | 1,79 | -0,04 | -0,16 |
| hasard · partage | Réanimation | 3,9 % | 96,1 % | 0 | 4,18 | 2,08 | 0,00 | 1,81 | -2,29 | -9,58 |
| seuil:70 · partage | Réanimation | 83,3 % | 16,7 % | 0 | 2,92 | 1,85 | 0,00 | 3,40 | 0,04 | 0,10 |
| couleur:70 · partage | Réanimation | 85,5 % | 14,5 % | 0 | 2,89 | 1,80 | 0,00 | 3,45 | 0,09 | 0,26 |
| novice:70 · partage | Réanimation | 30,5 % | 69,5 % | 0 | 7,79 | 2,68 | 0,00 | 2,76 | -1,61 | -12,54 |
| novice+labo:70 · partage | Réanimation | 66,2 % | 33,8 % | 0 | 3,81 | 1,63 | 0,91 | 2,47 | -0,54 | -2,06 |
| hasard · privé | Réanimation | 4,3 % | 95,8 % | 0 | 4,17 | 2,08 | 0,00 | 1,82 | -2,28 | -9,53 |
| seuil:70 · privé | Réanimation | 84,3 % | 15,7 % | 0 | 3,05 | 1,98 | 0,00 | 3,40 | 0,11 | 0,35 |
| couleur:70 · privé | Réanimation | 85,3 % | 14,7 % | 0 | 3,05 | 1,96 | 0,00 | 3,42 | 0,13 | 0,40 |
| novice:70 · privé | Réanimation | 23,2 % | 76,8 % | 0 | 5,74 | 3,17 | 0,00 | 2,60 | -1,39 | -7,99 |
| novice+labo:70 · privé | Réanimation | 71,0 % | 29,0 % | 0 | 3,92 | 1,87 | 1,01 | 2,43 | -0,25 | -0,99 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard · partage | Interne | -90 | -71 | -54 | -90 | -71 |
| seuil:70 · partage | Interne | 4 | 16 | 20 | -2 | 0 |
| couleur:70 · partage | Interne | 5 | 17 | 20 | -1 | 0 |
| novice:70 · partage | Interne | -123 | -76 | -37 | -123 | -77 |
| novice+labo:70 · partage | Interne | -23 | 1 | 19 | -24 | -4 |
| hasard · privé | Interne | -91 | -71 | -54 | -91 | -71 |
| seuil:70 · privé | Interne | 5 | 17 | 20 | -2 | 0 |
| couleur:70 · privé | Interne | 6 | 17 | 20 | -1 | 0 |
| novice:70 · privé | Interne | -93 | -61 | -31 | -93 | -61 |
| novice+labo:70 · privé | Interne | -11 | 8 | 20 | -14 | 0 |
| hasard · partage | Chirurgien | -104 | -84 | -66 | -104 | -84 |
| seuil:70 · partage | Chirurgien | -8 | 10 | 20 | -11 | 0 |
| couleur:70 · partage | Chirurgien | -7 | 12 | 20 | -10 | 0 |
| novice:70 · partage | Chirurgien | -184 | -108 | -46 | -184 | -109 |
| novice+labo:70 · partage | Chirurgien | -44 | -8 | 14 | -45 | -12 |
| hasard · privé | Chirurgien | -103 | -83 | -64 | -103 | -83 |
| seuil:70 · privé | Chirurgien | -6 | 10 | 20 | -11 | 0 |
| couleur:70 · privé | Chirurgien | -6 | 12 | 20 | -10 | 0 |
| novice:70 · privé | Chirurgien | -110 | -72 | -36 | -110 | -72 |
| novice+labo:70 · privé | Chirurgien | -26 | 0 | 18 | -27 | -4 |
| hasard · partage | Réanimation | -117 | -95 | -76 | -117 | -95 |
| seuil:70 · partage | Réanimation | -20 | 3 | 20 | -22 | -3 |
| couleur:70 · partage | Réanimation | -17 | 3 | 20 | -19 | -2 |
| novice:70 · partage | Réanimation | -211 | -121 | -51 | -211 | -121 |
| novice+labo:70 · partage | Réanimation | -56 | -18 | 6 | -58 | -19 |
| hasard · privé | Réanimation | -116 | -95 | -76 | -116 | -95 |
| seuil:70 · privé | Réanimation | -17 | 4 | 20 | -20 | -1 |
| couleur:70 · privé | Réanimation | -16 | 6 | 20 | -18 | -1 |
| novice:70 · privé | Réanimation | -122 | -80 | -41 | -122 | -80 |
| novice+labo:70 · privé | Réanimation | -36 | -8 | 13 | -37 | -11 |

## Joueurs

« Par un autre » : part des guérisons faites par un joueur qui n'avait pas diagnostiqué le patient, alors qu'un autre l'avait fait. « Écart de pièces » : écart moyen, en fin de partie, entre le joueur le plus riche et le plus pauvre.

| Stratégie | Difficulté | Informations | Guérison | Réputation / patient | Par un autre | Écart de pièces |
|---|---|---|---:|---:|---:|---:|
| hasard · partage | Interne | partagées | 7,0 % | -7,17 | 7,0 % | 4,7 |
| seuil:70 · partage | Interne | partagées | 96,9 % | 1,43 | 72,5 % | 6,4 |
| couleur:70 · partage | Interne | partagées | 97,9 % | 1,51 | 72,9 % | 6,2 |
| novice:70 · partage | Interne | partagées | 34,0 % | -7,73 | 73,2 % | 4,6 |
| novice+labo:70 · partage | Interne | partagées | 84,2 % | -0,03 | 79,3 % | 11,4 |
| hasard · privé | Interne | privées | 7,5 % | -7,16 | 5,7 % | 4,7 |
| seuil:70 · privé | Interne | privées | 96,7 % | 1,48 | 0,0 % | 5,4 |
| couleur:70 · privé | Interne | privées | 97,4 % | 1,56 | 0,0 % | 5,2 |
| novice:70 · privé | Interne | privées | 28,0 % | -6,14 | 0,0 % | 5,8 |
| novice+labo:70 · privé | Interne | privées | 86,7 % | 0,62 | 0,0 % | 5,9 |
| hasard · partage | Chirurgien | partagées | 5,0 % | -8,35 | 6,0 % | 7,1 |
| seuil:70 · partage | Chirurgien | partagées | 90,5 % | 0,81 | 77,5 % | 6,9 |
| couleur:70 · partage | Chirurgien | partagées | 92,3 % | 0,97 | 76,0 % | 6,8 |
| novice:70 · partage | Chirurgien | partagées | 32,2 % | -11,00 | 73,9 % | 6,1 |
| novice+labo:70 · partage | Chirurgien | partagées | 77,1 % | -1,09 | 83,9 % | 14,0 |
| hasard · privé | Chirurgien | privées | 5,3 % | -8,33 | 4,8 % | 7,0 |
| seuil:70 · privé | Chirurgien | privées | 90,2 % | 0,91 | 0,0 % | 6,4 |
| couleur:70 · privé | Chirurgien | privées | 91,6 % | 1,01 | 0,0 % | 6,7 |
| novice:70 · privé | Chirurgien | privées | 24,4 % | -7,22 | 0,0 % | 7,5 |
| novice+labo:70 · privé | Chirurgien | privées | 79,2 % | -0,16 | 0,0 % | 6,6 |
| hasard · partage | Réanimation | partagées | 3,9 % | -9,58 | 6,4 % | 9,0 |
| seuil:70 · partage | Réanimation | partagées | 83,3 % | 0,10 | 80,3 % | 8,0 |
| couleur:70 · partage | Réanimation | partagées | 85,5 % | 0,26 | 79,7 % | 7,7 |
| novice:70 · partage | Réanimation | partagées | 30,5 % | -12,54 | 75,5 % | 8,0 |
| novice+labo:70 · partage | Réanimation | partagées | 66,2 % | -2,06 | 89,6 % | 15,9 |
| hasard · privé | Réanimation | privées | 4,3 % | -9,53 | 6,8 % | 9,1 |
| seuil:70 · privé | Réanimation | privées | 84,3 % | 0,35 | 0,0 % | 8,2 |
| couleur:70 · privé | Réanimation | privées | 85,3 % | 0,40 | 0,0 % | 8,0 |
| novice:70 · privé | Réanimation | privées | 23,2 % | -7,99 | 0,0 % | 8,6 |
| novice+labo:70 · privé | Réanimation | privées | 71,0 % | -0,99 | 0,0 % | 7,5 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard · partage | seuil:70 · partage | couleur:70 · partage | novice:70 · partage | novice+labo:70 · partage | hasard · privé | seuil:70 · privé | couleur:70 · privé | novice:70 · privé | novice+labo:70 · privé |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 0,0 % en 6,77 | 98,2 % en 3,41 | 98,3 % en 3,23 | 57,9 % en 7,64 | 93,4 % en 5,41 | 1,7 % en 6,27 | 94,9 % en 3,41 | 97,5 % en 3,49 | 40,5 % en 6,86 | 93,3 % en 4,84 |
| Décalage horaire | generale | 2 | 1,0 % en 5,68 | 95,0 % en 2,99 | 97,5 % en 3,17 | 58,3 % en 7,43 | 96,6 % en 5,09 | 1,8 % en 5,41 | 88,7 % en 3,79 | 95,6 % en 3,14 | 35,4 % en 6,71 | 91,6 % en 4,43 |
| Maux de tête | generale | 2 | 4,0 % en 7,62 | 95,8 % en 3,34 | 100,0 % en 3,30 | 55,3 % en 8,31 | 91,5 % en 5,82 | 6,0 % en 7,26 | 99,1 % en 3,32 | 97,1 % en 3,69 | 45,4 % en 7,35 | 91,7 % en 5,04 |
| Rhume carabiné | generale | 2 | 0,8 % en 6,40 | 95,8 % en 3,63 | 98,0 % en 3,26 | 57,1 % en 7,70 | 91,5 % en 6,13 | 0,0 % en 6,63 | 95,2 % en 3,91 | 94,0 % en 3,83 | 37,1 % en 7,41 | 93,9 % en 4,74 |
| Conjonctivite | generale | 2 | 6,5 % en 7,77 | 100,0 % en 3,57 | 99,1 % en 3,08 | 56,4 % en 8,52 | 91,0 % en 5,36 | 0,9 % en 8,06 | 99,1 % en 4,06 | 98,9 % en 3,71 | 42,1 % en 9,21 | 95,6 % en 5,16 |
| Rage de dents | generale | 1 | 4,0 % en 7,62 | 97,0 % en 3,70 | 95,7 % en 3,34 | 51,9 % en 8,72 | 80,8 % en 6,04 | 1,5 % en 7,66 | 94,2 % en 4,19 | 98,3 % en 4,13 | 32,1 % en 7,79 | 94,4 % en 5,63 |
| Laryngite | generale | 2 | 4,6 % en 6,83 | 98,1 % en 3,58 | 99,0 % en 3,15 | 59,0 % en 7,05 | 91,7 % en 5,04 | 4,5 % en 7,16 | 96,2 % en 3,50 | 96,6 % en 3,52 | 38,9 % en 7,56 | 86,9 % en 5,38 |
| Torticolis | generale | 2 | 2,3 % en 6,73 | 92,2 % en 3,73 | 98,0 % en 3,06 | 55,4 % en 7,28 | 87,1 % en 5,49 | 5,0 % en 6,96 | 94,0 % en 3,87 | 93,6 % en 3,63 | 30,4 % en 7,41 | 88,0 % en 4,96 |
| Carence en vitamine D | generale | 2 | 3,3 % en 7,47 | 99,1 % en 3,50 | 97,5 % en 3,41 | 53,1 % en 7,39 | 90,7 % en 4,96 | 2,3 % en 7,22 | 99,1 % en 3,39 | 97,1 % en 3,38 | 39,8 % en 7,82 | 92,4 % en 4,91 |
| Fatigue chronique légère | generale | 2 | 2,1 % en 7,20 | 97,1 % en 3,19 | 97,1 % en 3,21 | 63,7 % en 7,50 | 87,8 % en 5,21 | 1,0 % en 7,12 | 97,7 % en 3,30 | 95,8 % en 3,65 | 38,1 % en 7,57 | 95,8 % en 4,46 |
| Otite moyenne aiguë | generale | 2 | 0,0 % en 6,34 | 94,8 % en 3,26 | 99,1 % en 2,91 | 57,0 % en 7,13 | 93,1 % en 5,47 | 2,2 % en 6,29 | 98,2 % en 3,38 | 97,4 % en 3,06 | 37,7 % en 6,53 | 87,6 % en 4,96 |
| Sinusite maxillaire | generale | 2 | 0,9 % en 7,23 | 96,1 % en 3,44 | 97,4 % en 3,34 | 62,1 % en 7,63 | 91,9 % en 5,61 | 2,6 % en 7,25 | 98,2 % en 3,42 | 93,7 % en 3,32 | 37,9 % en 8,19 | 89,7 % en 4,96 |
| Piqûre de moustique infectée | generale | 1 | 6,6 % en 7,03 | 90,0 % en 4,18 | 95,2 % en 3,60 | 52,7 % en 7,64 | 88,9 % en 6,17 | 4,9 % en 7,10 | 96,4 % en 3,58 | 94,2 % en 3,90 | 31,7 % en 8,02 | 79,6 % en 5,82 |
| Infection urinaire légère | generale | 2 | 1,7 % en 8,08 | 99,1 % en 3,65 | 97,5 % en 3,42 | 54,9 % en 8,16 | 89,5 % en 5,31 | 4,0 % en 7,97 | 98,3 % en 3,36 | 99,0 % en 3,50 | 40,0 % en 8,46 | 84,7 % en 5,60 |
| Gale | generale | 1 | 7,1 % en 6,07 | 90,4 % en 3,94 | 87,0 % en 3,96 | 0,0 % en 13,24 | 87,3 % en 5,46 | 9,1 % en 6,61 | 89,4 % en 3,85 | 87,0 % en 4,17 | 0,0 % en 10,61 | 87,0 % en 5,89 |
| Angine bactérienne | generale | 1 | 3,6 % en 7,50 | 94,8 % en 3,53 | 96,4 % en 3,57 | 57,4 % en 6,13 | 85,9 % en 5,03 | 1,7 % en 7,32 | 93,8 % en 4,03 | 98,1 % en 3,25 | 41,4 % en 7,72 | 84,3 % en 5,18 |
| Bronchite aiguë | generale | 2 | 3,7 % en 7,40 | 98,2 % en 3,44 | 98,0 % en 3,32 | 53,5 % en 7,60 | 89,3 % en 6,63 | 3,7 % en 6,85 | 96,5 % en 3,53 | 94,0 % en 3,70 | 42,1 % en 7,07 | 86,1 % en 5,05 |
| Gastro virale | generale | 1 | 5,8 % en 7,12 | 91,8 % en 4,34 | 90,9 % en 4,05 | 58,7 % en 8,27 | 90,0 % en 5,70 | 1,7 % en 7,92 | 92,3 % en 3,86 | 97,1 % en 4,01 | 41,9 % en 7,65 | 87,5 % en 5,22 |
| Hypoglycémie légère | generale | 1 | 4,2 % en 7,48 | 90,0 % en 3,62 | 94,7 % en 3,80 | 46,8 % en 8,60 | 85,5 % en 6,39 | 1,7 % en 7,72 | 98,6 % en 3,93 | 100,0 % en 3,39 | 45,1 % en 7,15 | 79,6 % en 5,83 |
| Intoxication alimentaire | generale | 1 | 2,9 % en 6,97 | 92,1 % en 3,51 | 92,2 % en 3,59 | 44,8 % en 7,98 | 85,0 % en 6,88 | 0,0 % en 7,33 | 88,9 % en 4,33 | 98,0 % en 3,73 | 43,9 % en 7,21 | 81,5 % en 5,23 |
| Varicelle | generale | 1 | 2,0 % en 6,41 | 86,2 % en 4,00 | 88,5 % en 3,58 | 0,0 % en 12,31 | 78,9 % en 6,63 | 10,8 % en 6,14 | 90,0 % en 4,10 | 97,9 % en 3,83 | 0,0 % en 9,96 | 83,3 % en 5,48 |
| Fièvre inexpliquée | generale | 1 | 0,0 % en 7,37 | 97,0 % en 3,56 | 95,5 % en 3,33 | 46,7 % en 8,85 | 92,0 % en 5,94 | 2,0 % en 7,69 | 90,4 % en 4,08 | 97,9 % en 3,40 | 47,1 % en 7,47 | 89,1 % en 5,13 |
| Rougeole | generale | 1 | 6,8 % en 6,41 | 82,0 % en 4,02 | 93,4 % en 3,70 | 0,0 % en 13,70 | 82,0 % en 5,89 | 11,1 % en 6,36 | 85,4 % en 3,77 | 90,5 % en 3,59 | 0,0 % en 9,98 | 83,3 % en 5,38 |
| Varices | cardiologie | 3 | 13,2 % en 6,64 | 95,8 % en 3,15 | 99,4 % en 3,14 | 0,0 % en 14,26 | 78,8 % en 3,88 | 9,4 % en 6,94 | 95,8 % en 3,14 | 98,7 % en 3,34 | 0,0 % en 11,21 | 88,3 % en 4,12 |
| Extrasystoles | cardiologie | 2 | 4,4 % en 6,11 | 90,8 % en 3,02 | 96,7 % en 3,08 | 82,5 % en 5,36 | 86,1 % en 3,80 | 1,0 % en 6,21 | 96,6 % en 3,41 | 90,7 % en 3,51 | 64,9 % en 5,59 | 77,1 % en 4,18 |
| Souffle au cœur | cardiologie | 3 | 8,0 % en 8,14 | 100,0 % en 2,99 | 99,4 % en 2,90 | 0,0 % en 14,49 | 85,9 % en 4,08 | 13,2 % en 7,71 | 98,7 % en 3,26 | 98,9 % en 3,13 | 0,0 % en 12,09 | 91,4 % en 4,20 |
| Hypotension orthostatique | cardiologie | 2 | 2,5 % en 6,96 | 98,2 % en 3,12 | 97,7 % en 3,13 | 86,7 % en 5,49 | 83,7 % en 4,25 | 6,8 % en 7,62 | 99,2 % en 3,24 | 96,2 % en 3,30 | 54,1 % en 6,54 | 80,9 % en 4,40 |
| Syndrome du cœur brisé | cardiologie | 2 | 1,9 % en 9,28 | 99,0 % en 3,41 | 100,0 % en 3,09 | 79,6 % en 5,58 | 82,4 % en 4,24 | 1,6 % en 9,36 | 100,0 % en 3,16 | 100,0 % en 3,24 | 64,5 % en 6,67 | 88,6 % en 4,55 |
| Hypertension artérielle | cardiologie | 3 | 3,4 % en 7,36 | 97,7 % en 3,12 | 97,7 % en 3,01 | 82,0 % en 5,16 | 87,7 % en 3,96 | 4,3 % en 7,72 | 97,2 % en 3,23 | 98,8 % en 3,17 | 60,1 % en 6,17 | 89,0 % en 4,10 |
| Bradycardie | cardiologie | 2 | 0,7 % en 7,78 | 98,9 % en 2,97 | 97,3 % en 3,27 | 74,3 % en 5,84 | 81,6 % en 4,12 | 4,4 % en 7,76 | 96,0 % en 3,30 | 96,4 % en 3,41 | 58,7 % en 7,08 | 88,0 % en 4,61 |
| Tachycardie | cardiologie | 2 | 3,6 % en 8,41 | 99,0 % en 3,23 | 97,4 % en 3,29 | 77,4 % en 6,05 | 84,7 % en 4,05 | 0,8 % en 8,30 | 98,2 % en 3,24 | 99,0 % en 3,50 | 57,4 % en 6,83 | 90,1 % en 4,59 |
| Phlébite | cardiologie | 2 | 13,5 % en 7,21 | 98,9 % en 2,84 | 99,2 % en 3,02 | 0,0 % en 13,97 | 86,6 % en 4,13 | 11,2 % en 7,55 | 94,0 % en 3,32 | 99,0 % en 3,22 | 0,0 % en 10,58 | 89,9 % en 4,25 |
| Angor | cardiologie | 2 | 11,5 % en 6,82 | 91,0 % en 3,26 | 95,5 % en 2,96 | 0,0 % en 14,04 | 77,2 % en 4,04 | 6,5 % en 6,57 | 91,5 % en 3,35 | 94,9 % en 3,38 | 0,0 % en 9,64 | 83,3 % en 4,08 |
| Péricardite | cardiologie | 2 | 14,2 % en 6,81 | 95,7 % en 3,37 | 97,4 % en 3,07 | 0,0 % en 15,09 | 73,0 % en 4,17 | 13,7 % en 7,21 | 99,0 % en 2,89 | 95,7 % en 3,19 | 0,0 % en 11,77 | 92,6 % en 4,06 |
| Arythmie | cardiologie | 1 | 2,0 % en 8,10 | 95,5 % en 3,41 | 97,9 % en 3,55 | 71,1 % en 5,91 | 82,0 % en 4,46 | 0,0 % en 8,41 | 94,5 % en 3,95 | 97,1 % en 3,55 | 58,3 % en 7,13 | 85,5 % en 4,64 |
| Fibrillation auriculaire | cardiologie | 2 | 0,9 % en 9,22 | 97,0 % en 3,40 | 98,2 % en 3,32 | 76,6 % en 5,87 | 84,3 % en 4,16 | 0,9 % en 9,31 | 96,1 % en 3,47 | 98,2 % en 3,49 | 58,6 % en 7,21 | 89,7 % en 4,45 |
| Insuffisance cardiaque | cardiologie | 1 | 11,7 % en 7,52 | 96,2 % en 3,73 | 95,8 % en 3,25 | 0,0 % en 14,87 | 72,2 % en 4,35 | 5,6 % en 7,98 | 95,3 % en 3,89 | 94,6 % en 3,61 | 0,0 % en 9,78 | 84,6 % en 4,56 |
| Endocardite | cardiologie | 2 | 11,0 % en 7,32 | 97,2 % en 3,19 | 97,4 % en 3,04 | 0,0 % en 14,93 | 80,4 % en 4,33 | 10,5 % en 7,43 | 99,1 % en 3,08 | 99,0 % en 3,25 | 0,0 % en 11,39 | 82,6 % en 4,59 |
| Cardiomyopathie | cardiologie | 1 | 10,2 % en 8,02 | 96,6 % en 3,24 | 100,0 % en 3,08 | 0,0 % en 15,13 | 74,2 % en 5,13 | 11,1 % en 7,83 | 93,5 % en 3,55 | 100,0 % en 3,20 | 0,0 % en 11,31 | 85,7 % en 4,57 |
| Rejet de greffe cardiaque | cardiologie | 1 | 18,2 % en 7,60 | 100,0 % en 3,02 | 100,0 % en 3,67 | 0,0 % en 13,00 | 77,6 % en 4,66 | 13,7 % en 8,08 | 97,7 % en 3,47 | 100,0 % en 3,14 | 0,0 % en 11,24 | 88,5 % en 4,70 |
| Œdème aigu du poumon | cardiologie | 1 | 10,5 % en 7,30 | 94,1 % en 3,63 | 100,0 % en 2,81 | 0,0 % en 15,89 | 81,5 % en 4,28 | 22,6 % en 6,53 | 92,3 % en 3,71 | 91,3 % en 3,59 | 0,0 % en 10,60 | 77,8 % en 4,75 |
| Infarctus du myocarde | cardiologie | 1 | 15,9 % en 7,43 | 94,8 % en 3,64 | 98,0 % en 3,25 | 0,0 % en 14,69 | 79,6 % en 4,26 | 18,5 % en 7,85 | 89,8 % en 4,03 | 91,7 % en 3,75 | 0,0 % en 11,24 | 86,9 % en 4,67 |
| Embolie pulmonaire | cardiologie | 1 | 3,0 % en 7,43 | 90,9 % en 3,60 | 100,0 % en 3,42 | 0,0 % en 14,09 | 76,3 % en 4,08 | 11,3 % en 6,94 | 96,2 % en 3,60 | 94,7 % en 3,32 | 0,0 % en 10,32 | 80,0 % en 4,78 |
| Tics nerveux | psychiatrie | 3 | 15,4 % en 6,47 | 95,7 % en 3,06 | 98,7 % en 3,14 | 0,0 % en 14,11 | 86,5 % en 3,78 | 13,7 % en 6,94 | 99,3 % en 3,13 | 100,0 % en 3,03 | 0,0 % en 10,98 | 86,5 % en 4,12 |
| Phobie des escaliers | psychiatrie | 2 | 0,0 % en 5,81 | 94,1 % en 3,03 | 96,4 % en 3,14 | 0,0 % en 15,46 | 83,1 % en 4,02 | 0,9 % en 5,69 | 95,2 % en 3,34 | 94,2 % en 3,08 | 0,0 % en 11,05 | 79,3 % en 4,06 |
| Dépendance à la caféine | psychiatrie | 3 | 1,3 % en 8,36 | 100,0 % en 2,99 | 100,0 % en 2,95 | 0,0 % en 16,32 | 88,1 % en 4,40 | 1,8 % en 8,59 | 98,9 % en 3,00 | 98,3 % en 3,17 | 0,0 % en 11,61 | 89,1 % en 4,50 |
| Somnambulisme | psychiatrie | 2 | 2,0 % en 6,97 | 94,1 % en 3,16 | 97,3 % en 3,08 | 0,0 % en 13,86 | 83,9 % en 4,21 | 0,0 % en 6,64 | 99,1 % en 3,20 | 97,4 % en 3,37 | 0,0 % en 11,47 | 84,5 % en 4,02 |
| Cauchemars répétés | psychiatrie | 2 | 3,2 % en 9,33 | 100,0 % en 3,16 | 99,1 % en 2,80 | 0,0 % en 14,93 | 79,2 % en 4,37 | 1,9 % en 9,07 | 99,2 % en 3,19 | 99,1 % en 3,65 | 0,0 % en 12,46 | 95,3 % en 4,30 |
| Phobie des blouses blanches | psychiatrie | 3 | 15,2 % en 6,52 | 98,6 % en 2,96 | 100,0 % en 2,87 | 83,4 % en 2,95 | 78,1 % en 3,90 | 15,8 % en 6,79 | 96,8 % en 3,04 | 98,0 % en 3,08 | 96,0 % en 2,77 | 91,3 % en 3,91 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 0,0 % en 7,58 | 96,9 % en 3,19 | 99,1 % en 2,91 | 0,0 % en 13,50 | 81,7 % en 4,17 | 0,9 % en 7,44 | 99,0 % en 3,15 | 100,0 % en 3,13 | 0,0 % en 10,93 | 86,9 % en 4,16 |
| Hypocondrie aiguë | psychiatrie | 2 | 3,8 % en 8,14 | 97,2 % en 3,11 | 96,3 % en 3,54 | 0,9 % en 14,85 | 80,4 % en 4,15 | 4,8 % en 8,13 | 98,9 % en 3,38 | 100,0 % en 3,28 | 1,6 % en 11,62 | 86,7 % en 4,54 |
| Agoraphobie | psychiatrie | 2 | 2,8 % en 8,45 | 97,3 % en 3,45 | 98,3 % en 3,20 | 0,0 % en 14,20 | 78,8 % en 4,59 | 4,2 % en 7,87 | 97,2 % en 3,64 | 98,2 % en 3,36 | 3,2 % en 11,75 | 86,9 % en 4,43 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 7,1 % en 7,30 | 96,7 % en 3,10 | 98,1 % en 3,11 | 3,1 % en 14,76 | 89,9 % en 4,11 | 1,9 % en 6,95 | 95,3 % en 3,49 | 97,5 % en 3,28 | 0,8 % en 10,15 | 88,2 % en 4,31 |
| Mutisme sélectif | psychiatrie | 2 | 11,7 % en 7,54 | 97,1 % en 3,48 | 96,8 % en 3,14 | 85,8 % en 2,88 | 81,7 % en 3,92 | 17,1 % en 7,34 | 95,8 % en 3,52 | 95,9 % en 3,05 | 94,6 % en 3,05 | 90,8 % en 4,12 |
| Addiction aux écrans | psychiatrie | 1 | 1,6 % en 8,10 | 100,0 % en 3,15 | 95,3 % en 3,59 | 0,0 % en 16,39 | 93,2 % en 3,92 | 2,1 % en 7,58 | 93,3 % en 4,00 | 93,3 % en 3,40 | 0,0 % en 11,61 | 81,4 % en 4,64 |
| Syndrome de Paris | psychiatrie | 2 | 10,1 % en 8,32 | 98,2 % en 3,19 | 98,9 % en 3,12 | 0,0 % en 14,65 | 86,4 % en 4,35 | 24,0 % en 7,36 | 96,9 % en 3,55 | 100,0 % en 3,22 | 0,0 % en 12,47 | 87,8 % en 4,83 |
| Dépression légère | psychiatrie | 1 | 8,8 % en 7,30 | 98,3 % en 3,22 | 98,0 % en 3,14 | 90,5 % en 2,65 | 82,5 % en 3,97 | 16,7 % en 7,10 | 94,3 % en 2,96 | 95,1 % en 3,49 | 91,8 % en 3,45 | 81,5 % en 4,54 |
| Trouble alimentaire léger | psychiatrie | 2 | 0,8 % en 7,88 | 98,2 % en 3,18 | 99,0 % en 2,97 | 0,0 % en 13,50 | 82,7 % en 4,29 | 2,2 % en 8,15 | 97,9 % en 3,20 | 99,2 % en 2,90 | 0,0 % en 10,03 | 85,1 % en 4,35 |
| Insomnie chronique | psychiatrie | 1 | 0,0 % en 7,98 | 98,4 % en 3,61 | 96,7 % en 3,42 | 0,0 % en 14,98 | 80,9 % en 5,45 | 0,0 % en 8,45 | 94,1 % en 3,57 | 98,0 % en 4,02 | 0,0 % en 11,80 | 77,6 % en 5,22 |
| Burn-out | psychiatrie | 1 | 22,7 % en 7,33 | 97,8 % en 3,28 | 98,3 % en 3,76 | 81,6 % en 3,10 | 75,0 % en 4,15 | 14,3 % en 7,44 | 97,7 % en 3,30 | 97,9 % en 4,02 | 94,4 % en 3,28 | 86,5 % en 4,56 |
| Attaque de panique | psychiatrie | 1 | 11,8 % en 7,46 | 94,2 % en 3,44 | 93,8 % en 3,58 | 0,0 % en 13,91 | 78,9 % en 4,31 | 11,1 % en 7,00 | 92,8 % en 3,55 | 98,0 % en 3,43 | 0,0 % en 10,26 | 83,0 % en 5,08 |
| Stress post-traumatique | psychiatrie | 1 | 13,6 % en 7,30 | 94,5 % en 3,33 | 94,4 % en 3,22 | 81,1 % en 3,28 | 86,0 % en 4,18 | 14,9 % en 7,96 | 98,4 % en 3,56 | 98,1 % en 3,41 | 90,2 % en 3,66 | 85,5 % en 4,09 |
| Jalousie délirante | psychiatrie | 1 | 18,6 % en 7,07 | 100,0 % en 3,22 | 97,9 % en 3,08 | 0,0 % en 14,36 | 72,6 % en 4,60 | 14,8 % en 7,00 | 92,7 % en 3,71 | 96,5 % en 3,77 | 0,0 % en 10,15 | 86,4 % en 4,83 |
| Hallux valgus | orthopedie | 3 | 14,6 % en 7,33 | 97,7 % en 2,99 | 98,0 % en 3,36 | 0,0 % en 14,66 | 87,3 % en 4,22 | 15,3 % en 7,16 | 99,3 % en 2,92 | 98,7 % en 2,94 | 0,0 % en 11,27 | 90,1 % en 4,08 |
| Périostite tibiale | orthopedie | 2 | 12,4 % en 6,68 | 96,3 % en 2,99 | 99,1 % en 2,96 | 3,5 % en 14,79 | 83,2 % en 4,21 | 12,5 % en 6,16 | 95,2 % en 2,98 | 95,3 % en 3,32 | 5,8 % en 10,65 | 84,0 % en 4,20 |
| Contusion sévère | orthopedie | 3 | 1,2 % en 9,23 | 99,4 % en 3,03 | 99,5 % en 3,13 | 86,1 % en 4,80 | 86,6 % en 4,26 | 2,3 % en 9,39 | 100,0 % en 3,02 | 98,9 % en 3,19 | 77,5 % en 5,09 | 89,7 % en 4,16 |
| Entorse de la cheville | orthopedie | 2 | 1,9 % en 7,88 | 99,1 % en 3,23 | 98,3 % en 2,97 | 78,4 % en 4,45 | 87,3 % en 4,14 | 3,0 % en 8,17 | 99,1 % en 3,49 | 95,9 % en 3,74 | 70,6 % en 5,15 | 90,8 % en 3,98 |
| Syndrome du canal carpien | orthopedie | 2 | 16,4 % en 9,51 | 98,9 % en 3,40 | 99,1 % en 3,12 | 0,0 % en 16,83 | 85,7 % en 4,09 | 13,7 % en 9,94 | 100,0 % en 3,28 | 100,0 % en 3,09 | 0,0 % en 12,55 | 90,1 % en 4,57 |
| Lumbago | orthopedie | 3 | 10,1 % en 7,53 | 98,0 % en 2,99 | 100,0 % en 2,86 | 6,6 % en 12,70 | 85,5 % en 4,01 | 18,1 % en 7,41 | 98,1 % en 3,38 | 99,4 % en 3,25 | 7,5 % en 10,33 | 87,0 % en 4,19 |
| Fêlure du coccyx | orthopedie | 2 | 16,0 % en 7,37 | 100,0 % en 2,90 | 100,0 % en 3,09 | 3,3 % en 12,87 | 77,6 % en 4,14 | 9,2 % en 7,66 | 99,2 % en 3,20 | 99,1 % en 3,17 | 5,7 % en 10,51 | 88,9 % en 4,11 |
| Épaule gelée | orthopedie | 2 | 16,3 % en 7,60 | 98,1 % en 3,05 | 99,2 % en 3,13 | 5,0 % en 14,22 | 85,3 % en 4,20 | 15,6 % en 8,06 | 98,4 % en 3,16 | 98,2 % en 3,12 | 6,5 % en 9,97 | 86,8 % en 4,36 |
| Entorse du genou | orthopedie | 2 | 0,0 % en 8,73 | 96,9 % en 3,02 | 97,1 % en 3,22 | 86,0 % en 4,60 | 78,1 % en 4,51 | 2,9 % en 8,75 | 98,2 % en 3,53 | 97,6 % en 3,23 | 80,5 % en 4,97 | 85,3 % en 4,32 |
| Sciatique | orthopedie | 2 | 13,3 % en 7,09 | 95,8 % en 2,97 | 98,0 % en 2,94 | 7,7 % en 13,80 | 76,6 % en 4,53 | 16,8 % en 7,28 | 96,9 % en 3,23 | 98,3 % en 3,01 | 7,5 % en 9,83 | 76,9 % en 4,64 |
| Scoliose | orthopedie | 2 | 20,0 % en 7,50 | 97,3 % en 3,25 | 100,0 % en 3,09 | 0,0 % en 14,98 | 79,4 % en 4,26 | 13,6 % en 7,67 | 98,4 % en 3,40 | 98,2 % en 3,33 | 0,0 % en 11,59 | 81,7 % en 4,38 |
| Arthrose du genou | orthopedie | 1 | 11,3 % en 7,77 | 94,1 % en 3,51 | 90,7 % en 3,81 | 0,0 % en 14,81 | 82,9 % en 4,50 | 15,6 % en 7,18 | 94,6 % en 3,91 | 96,6 % en 3,66 | 0,0 % en 11,36 | 79,2 % en 5,36 |
| Ostéoporose | orthopedie | 2 | 17,3 % en 8,88 | 100,0 % en 3,11 | 98,3 % en 3,08 | 0,0 % en 15,46 | 83,0 % en 4,39 | 14,8 % en 8,60 | 100,0 % en 3,48 | 99,0 % en 3,26 | 0,0 % en 12,40 | 86,6 % en 4,96 |
| Fracture du poignet | orthopedie | 1 | 11,3 % en 8,06 | 93,1 % en 3,34 | 96,8 % en 3,63 | 79,2 % en 5,04 | 68,4 % en 5,19 | 1,4 % en 8,48 | 95,3 % en 3,84 | 98,0 % en 4,20 | 69,9 % en 5,51 | 81,1 % en 4,36 |
| Fracture fermée | orthopedie | 2 | 1,7 % en 8,70 | 100,0 % en 3,23 | 98,2 % en 3,30 | 80,2 % en 4,93 | 86,6 % en 4,06 | 1,9 % en 8,32 | 95,3 % en 3,58 | 98,1 % en 2,99 | 73,1 % en 5,37 | 87,3 % en 4,51 |
| Luxation de l'épaule | orthopedie | 1 | 0,0 % en 9,05 | 95,3 % en 3,67 | 94,0 % en 3,72 | 81,5 % en 4,72 | 79,4 % en 4,73 | 0,0 % en 9,02 | 96,8 % en 3,44 | 100,0 % en 3,30 | 72,9 % en 5,71 | 84,6 % en 5,05 |
| Hernie discale | orthopedie | 1 | 1,8 % en 6,25 | 98,5 % en 3,45 | 98,4 % en 3,06 | 0,0 % en 14,40 | 81,8 % en 4,05 | 0,0 % en 6,63 | 92,0 % en 3,40 | 95,8 % en 3,29 | 0,0 % en 10,65 | 85,5 % en 4,73 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,58 | 90,1 % en 3,45 | 97,9 % en 3,11 | 0,0 % en 14,63 | 74,1 % en 4,13 | 1,7 % en 5,78 | 82,4 % en 3,75 | 100,0 % en 3,30 | 0,0 % en 12,08 | 74,1 % en 4,72 |
| Fracture ouverte | orthopedie | 1 | 4,0 % en 6,24 | 89,6 % en 3,70 | 92,6 % en 3,50 | 0,0 % en 14,07 | 71,4 % en 4,51 | 0,0 % en 6,07 | 86,2 % en 4,02 | 80,0 % en 3,87 | 0,0 % en 9,82 | 80,4 % en 4,78 |
| Fracture du fémur | orthopedie | 1 | 2,0 % en 5,92 | 96,2 % en 3,63 | 94,6 % en 3,20 | 0,0 % en 12,92 | 69,1 % en 4,15 | 0,0 % en 5,85 | 92,2 % en 3,49 | 95,9 % en 3,33 | 0,0 % en 10,12 | 68,9 % en 4,96 |
| Main froide éternelle | paranormal | 3 | 12,7 % en 7,03 | 99,5 % en 2,91 | 99,3 % en 2,77 | 0,0 % en 14,83 | 82,5 % en 4,08 | 19,6 % en 7,35 | 100,0 % en 2,98 | 98,3 % en 3,17 | 0,0 % en 10,94 | 83,1 % en 4,24 |
| Rire des cimetières | paranormal | 2 | 8,6 % en 5,74 | 95,4 % en 3,24 | 98,9 % en 3,16 | 0,0 % en 13,25 | 84,8 % en 4,47 | 11,8 % en 6,65 | 95,4 % en 3,24 | 96,5 % en 3,24 | 0,0 % en 10,79 | 85,2 % en 3,88 |
| Doigts qui grandissent | paranormal | 3 | 14,7 % en 8,04 | 99,4 % en 2,97 | 99,4 % en 2,95 | 0,0 % en 15,66 | 90,1 % en 3,98 | 15,2 % en 8,31 | 98,9 % en 3,09 | 98,3 % en 3,14 | 0,0 % en 12,05 | 87,8 % en 4,46 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 7,79 | 97,6 % en 3,44 | 99,1 % en 3,12 | 87,3 % en 3,82 | 83,5 % en 4,10 | 1,8 % en 8,12 | 96,9 % en 3,30 | 95,5 % en 3,30 | 74,2 % en 5,23 | 84,7 % en 4,26 |
| Nez qui saigne de l'encre | paranormal | 2 | 13,1 % en 9,11 | 99,1 % en 3,27 | 100,0 % en 2,93 | 0,0 % en 16,20 | 88,0 % en 4,31 | 18,0 % en 9,45 | 100,0 % en 3,48 | 100,0 % en 3,06 | 0,0 % en 14,54 | 85,6 % en 4,53 |
| Mauvais œil | paranormal | 3 | 0,0 % en 8,15 | 98,1 % en 2,92 | 99,4 % en 2,91 | 87,6 % en 4,39 | 83,0 % en 4,05 | 1,8 % en 7,98 | 97,2 % en 3,07 | 98,3 % en 3,15 | 72,7 % en 4,80 | 90,1 % en 4,26 |
| Malédiction des miroirs | paranormal | 2 | 1,9 % en 8,09 | 99,2 % en 3,01 | 99,2 % en 3,04 | 87,7 % en 3,98 | 86,7 % en 4,09 | 3,8 % en 8,25 | 97,9 % en 3,16 | 99,0 % en 2,79 | 71,6 % en 5,33 | 84,7 % en 4,67 |
| Malédiction du chat noir | paranormal | 2 | 0,8 % en 8,68 | 97,8 % en 3,18 | 97,4 % en 3,04 | 90,1 % en 4,22 | 88,2 % en 4,07 | 1,7 % en 8,70 | 97,2 % en 3,44 | 99,0 % en 2,96 | 72,1 % en 5,28 | 82,8 % en 4,63 |
| Malédiction du nombre 7 | paranormal | 2 | 2,6 % en 8,55 | 99,1 % en 3,50 | 99,1 % en 3,17 | 89,5 % en 4,11 | 92,0 % en 3,73 | 2,8 % en 8,09 | 96,6 % en 3,42 | 100,0 % en 3,07 | 78,9 % en 5,21 | 89,7 % en 4,03 |
| Ombre qui suit | paranormal | 2 | 7,9 % en 6,88 | 96,4 % en 3,11 | 95,7 % en 3,32 | 0,0 % en 13,69 | 87,0 % en 4,20 | 11,0 % en 7,30 | 96,8 % en 3,20 | 96,0 % en 3,55 | 0,0 % en 9,97 | 84,6 % en 4,49 |
| Brûlure lunaire | paranormal | 2 | 9,2 % en 7,93 | 96,3 % en 2,97 | 97,9 % en 3,03 | 0,0 % en 14,09 | 87,8 % en 4,16 | 10,4 % en 7,86 | 96,1 % en 3,53 | 99,1 % en 3,38 | 0,0 % en 11,53 | 84,2 % en 4,52 |
| Âme en double | paranormal | 1 | 2,0 % en 8,31 | 96,7 % en 3,30 | 100,0 % en 3,60 | 85,7 % en 4,59 | 83,3 % en 4,98 | 1,6 % en 7,93 | 95,9 % en 3,73 | 94,7 % en 3,30 | 69,2 % en 5,52 | 81,1 % en 4,38 |
| Voix du passé | paranormal | 2 | 1,0 % en 9,60 | 99,1 % en 3,13 | 99,0 % en 3,05 | 82,4 % en 4,79 | 82,5 % en 4,47 | 4,4 % en 9,38 | 97,5 % en 3,53 | 98,4 % en 3,61 | 77,8 % en 5,21 | 87,7 % en 4,78 |
| Murmures dans la tête | paranormal | 1 | 3,4 % en 8,50 | 96,6 % en 3,59 | 100,0 % en 3,66 | 80,5 % en 4,73 | 75,4 % en 4,67 | 3,8 % en 8,28 | 91,2 % en 3,84 | 97,1 % en 3,77 | 70,7 % en 4,61 | 86,5 % en 4,63 |
| Poltergeist domestique | paranormal | 2 | 16,8 % en 8,04 | 96,9 % en 3,29 | 96,4 % en 3,54 | 0,0 % en 13,23 | 80,4 % en 4,79 | 13,5 % en 7,72 | 97,9 % en 3,29 | 99,1 % en 3,13 | 0,0 % en 9,69 | 90,1 % en 4,34 |
| Vampirisme aigu | paranormal | 1 | 17,9 % en 7,86 | 98,4 % en 3,21 | 98,1 % en 3,00 | 0,0 % en 15,05 | 86,9 % en 4,08 | 23,5 % en 8,27 | 96,2 % en 3,83 | 100,0 % en 3,77 | 0,0 % en 10,95 | 72,9 % en 5,47 |
| Pétrification partielle | paranormal | 1 | 13,0 % en 8,00 | 98,1 % en 3,30 | 98,5 % en 3,40 | 0,0 % en 15,32 | 81,6 % en 4,92 | 14,9 % en 8,00 | 98,2 % en 4,35 | 98,3 % en 3,12 | 0,0 % en 10,92 | 82,5 % en 4,62 |
| Possession légère | paranormal | 1 | 3,1 % en 8,36 | 94,3 % en 3,23 | 97,9 % en 3,15 | 81,1 % en 5,45 | 80,4 % en 4,43 | 2,0 % en 8,08 | 95,7 % en 3,79 | 96,1 % en 3,41 | 75,6 % en 5,07 | 77,6 % en 4,73 |
| Lycanthropie | paranormal | 1 | 12,5 % en 8,02 | 90,4 % en 3,56 | 98,6 % en 3,86 | 0,0 % en 15,14 | 85,4 % en 5,40 | 8,1 % en 7,97 | 94,2 % en 4,25 | 94,5 % en 3,42 | 0,0 % en 11,10 | 90,9 % en 4,27 |
| Glissement temporel | paranormal | 1 | 17,9 % en 7,25 | 98,3 % en 3,46 | 98,3 % en 3,27 | 0,0 % en 14,00 | 69,2 % en 4,46 | 10,6 % en 7,45 | 100,0 % en 3,17 | 98,2 % en 3,68 | 0,0 % en 9,57 | 85,7 % en 4,86 |
