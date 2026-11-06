# Rapport de simulation — CardHospital — paquet de base 2.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 3 joueurs à tour de rôle · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Analyses / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard · partage | Interne | 7,0 % | 93,0 % | 0 | 7,57 | 3,78 | 0,00 | 0,66 | -0,95 | -7,17 |
| seuil:70 · partage | Interne | 96,9 % | 3,1 % | 0 | 3,26 | 2,02 | 0,00 | 1,63 | 0,44 | 1,43 |
| couleur:70 · partage | Interne | 97,9 % | 2,1 % | 0 | 3,18 | 1,94 | 0,00 | 1,66 | 0,48 | 1,51 |
| novice:70 · partage | Interne | 44,6 % | 55,3 % | 1 | 9,26 | 3,17 | 0,00 | 0,98 | -0,65 | -6,04 |
| novice+labo:70 · partage | Interne | 84,2 % | 15,8 % | 0 | 4,27 | 1,66 | 0,98 | 1,11 | 0,03 | 0,15 |
| hasard · privé | Interne | 7,5 % | 92,5 % | 0 | 7,60 | 3,79 | 0,00 | 0,66 | -0,94 | -7,16 |
| seuil:70 · privé | Interne | 96,7 % | 3,4 % | 0 | 3,41 | 2,18 | 0,00 | 1,60 | 0,43 | 1,48 |
| couleur:70 · privé | Interne | 97,4 % | 2,6 % | 0 | 3,34 | 2,09 | 0,00 | 1,62 | 0,47 | 1,56 |
| novice:70 · privé | Interne | 30,7 % | 69,3 % | 0 | 8,62 | 4,80 | 0,00 | 0,91 | -0,67 | -5,81 |
| novice+labo:70 · privé | Interne | 87,0 % | 13,0 % | 0 | 4,55 | 2,05 | 1,18 | 1,11 | 0,14 | 0,63 |
| hasard · partage | Chirurgien | 5,0 % | 95,0 % | 0 | 5,25 | 2,64 | 0,00 | 1,26 | -1,59 | -8,35 |
| seuil:70 · partage | Chirurgien | 90,5 % | 9,6 % | 0 | 3,07 | 1,93 | 0,00 | 2,54 | 0,26 | 0,81 |
| couleur:70 · partage | Chirurgien | 92,3 % | 7,6 % | 0 | 3,05 | 1,88 | 0,00 | 2,58 | 0,32 | 0,97 |
| novice:70 · partage | Chirurgien | 41,6 % | 58,4 % | 0 | 7,97 | 2,76 | 0,00 | 1,90 | -1,11 | -8,85 |
| novice+labo:70 · partage | Chirurgien | 77,0 % | 23,0 % | 0 | 3,97 | 1,66 | 0,95 | 1,81 | -0,20 | -0,81 |
| hasard · privé | Chirurgien | 5,3 % | 94,8 % | 0 | 5,25 | 2,62 | 0,00 | 1,26 | -1,59 | -8,33 |
| seuil:70 · privé | Chirurgien | 90,2 % | 9,8 % | 0 | 3,22 | 2,08 | 0,00 | 2,51 | 0,28 | 0,91 |
| couleur:70 · privé | Chirurgien | 91,6 % | 8,4 % | 0 | 3,19 | 2,02 | 0,00 | 2,54 | 0,32 | 1,01 |
| novice:70 · privé | Chirurgien | 26,4 % | 73,6 % | 0 | 6,58 | 3,61 | 0,00 | 1,76 | -1,06 | -6,98 |
| novice+labo:70 · privé | Chirurgien | 79,3 % | 20,7 % | 0 | 4,18 | 1,91 | 1,08 | 1,78 | -0,05 | -0,21 |
| hasard · partage | Réanimation | 3,9 % | 96,1 % | 0 | 4,18 | 2,08 | 0,00 | 1,81 | -2,29 | -9,58 |
| seuil:70 · partage | Réanimation | 83,3 % | 16,7 % | 0 | 2,92 | 1,85 | 0,00 | 3,40 | 0,04 | 0,10 |
| couleur:70 · partage | Réanimation | 85,5 % | 14,5 % | 0 | 2,89 | 1,80 | 0,00 | 3,45 | 0,09 | 0,26 |
| novice:70 · partage | Réanimation | 38,8 % | 61,2 % | 0 | 7,12 | 2,49 | 0,00 | 2,80 | -1,47 | -10,48 |
| novice+labo:70 · partage | Réanimation | 67,0 % | 33,0 % | 0 | 3,60 | 1,60 | 0,90 | 2,47 | -0,46 | -1,67 |
| hasard · privé | Réanimation | 4,3 % | 95,8 % | 0 | 4,17 | 2,08 | 0,00 | 1,82 | -2,28 | -9,53 |
| seuil:70 · privé | Réanimation | 84,3 % | 15,7 % | 0 | 3,05 | 1,98 | 0,00 | 3,40 | 0,11 | 0,35 |
| couleur:70 · privé | Réanimation | 85,3 % | 14,7 % | 0 | 3,05 | 1,96 | 0,00 | 3,42 | 0,13 | 0,40 |
| novice:70 · privé | Réanimation | 24,8 % | 75,2 % | 0 | 5,67 | 3,12 | 0,00 | 2,61 | -1,38 | -7,83 |
| novice+labo:70 · privé | Réanimation | 71,1 % | 28,9 % | 0 | 3,91 | 1,87 | 1,02 | 2,43 | -0,26 | -1,03 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard · partage | Interne | -90 | -71 | -54 | -90 | -71 |
| seuil:70 · partage | Interne | 4 | 16 | 20 | -2 | 0 |
| couleur:70 · partage | Interne | 5 | 17 | 20 | -1 | 0 |
| novice:70 · partage | Interne | -108 | -59 | -19 | -108 | -59 |
| novice+labo:70 · partage | Interne | -19 | 3 | 19 | -22 | -3 |
| hasard · privé | Interne | -91 | -71 | -54 | -91 | -71 |
| seuil:70 · privé | Interne | 5 | 17 | 20 | -2 | 0 |
| couleur:70 · privé | Interne | 6 | 17 | 20 | -1 | 0 |
| novice:70 · privé | Interne | -90 | -58 | -27 | -90 | -58 |
| novice+labo:70 · privé | Interne | -11 | 8 | 20 | -13 | 0 |
| hasard · partage | Chirurgien | -104 | -84 | -66 | -104 | -84 |
| seuil:70 · partage | Chirurgien | -8 | 10 | 20 | -11 | 0 |
| couleur:70 · partage | Chirurgien | -7 | 12 | 20 | -10 | 0 |
| novice:70 · partage | Chirurgien | -158 | -84 | -32 | -158 | -85 |
| novice+labo:70 · partage | Chirurgien | -36 | -6 | 14 | -37 | -10 |
| hasard · privé | Chirurgien | -103 | -83 | -64 | -103 | -83 |
| seuil:70 · privé | Chirurgien | -6 | 10 | 20 | -11 | 0 |
| couleur:70 · privé | Chirurgien | -6 | 12 | 20 | -10 | 0 |
| novice:70 · privé | Chirurgien | -107 | -70 | -34 | -107 | -70 |
| novice+labo:70 · privé | Chirurgien | -26 | -2 | 18 | -26 | -6 |
| hasard · partage | Réanimation | -117 | -95 | -76 | -117 | -95 |
| seuil:70 · partage | Réanimation | -20 | 3 | 20 | -22 | -3 |
| couleur:70 · partage | Réanimation | -17 | 3 | 20 | -19 | -2 |
| novice:70 · partage | Réanimation | -197 | -98 | -36 | -197 | -98 |
| novice+labo:70 · partage | Réanimation | -47 | -14 | 7 | -49 | -17 |
| hasard · privé | Réanimation | -116 | -95 | -76 | -116 | -95 |
| seuil:70 · privé | Réanimation | -17 | 4 | 20 | -20 | -1 |
| couleur:70 · privé | Réanimation | -16 | 6 | 20 | -18 | -1 |
| novice:70 · privé | Réanimation | -121 | -76 | -41 | -121 | -77 |
| novice+labo:70 · privé | Réanimation | -38 | -10 | 13 | -38 | -12 |

## Joueurs

« Par un autre » : part des guérisons faites par un joueur qui n'avait pas diagnostiqué le patient, alors qu'un autre l'avait fait. « Écart de pièces » : écart moyen, en fin de partie, entre le joueur le plus riche et le plus pauvre.

| Stratégie | Difficulté | Informations | Guérison | Réputation / patient | Par un autre | Écart de pièces |
|---|---|---|---:|---:|---:|---:|
| hasard · partage | Interne | partagées | 7,0 % | -7,17 | 7,0 % | 4,7 |
| seuil:70 · partage | Interne | partagées | 96,9 % | 1,43 | 72,5 % | 6,4 |
| couleur:70 · partage | Interne | partagées | 97,9 % | 1,51 | 72,9 % | 6,2 |
| novice:70 · partage | Interne | partagées | 44,6 % | -6,04 | 64,7 % | 5,1 |
| novice+labo:70 · partage | Interne | partagées | 84,2 % | 0,15 | 78,7 % | 11,2 |
| hasard · privé | Interne | privées | 7,5 % | -7,16 | 5,7 % | 4,7 |
| seuil:70 · privé | Interne | privées | 96,7 % | 1,48 | 0,0 % | 5,4 |
| couleur:70 · privé | Interne | privées | 97,4 % | 1,56 | 0,0 % | 5,2 |
| novice:70 · privé | Interne | privées | 30,7 % | -5,81 | 0,0 % | 5,8 |
| novice+labo:70 · privé | Interne | privées | 87,0 % | 0,63 | 0,0 % | 5,8 |
| hasard · partage | Chirurgien | partagées | 5,0 % | -8,35 | 6,0 % | 7,1 |
| seuil:70 · partage | Chirurgien | partagées | 90,5 % | 0,81 | 77,5 % | 6,9 |
| couleur:70 · partage | Chirurgien | partagées | 92,3 % | 0,97 | 76,0 % | 6,8 |
| novice:70 · partage | Chirurgien | partagées | 41,6 % | -8,85 | 66,0 % | 6,3 |
| novice+labo:70 · partage | Chirurgien | partagées | 77,0 % | -0,81 | 83,2 % | 13,8 |
| hasard · privé | Chirurgien | privées | 5,3 % | -8,33 | 4,8 % | 7,0 |
| seuil:70 · privé | Chirurgien | privées | 90,2 % | 0,91 | 0,0 % | 6,4 |
| couleur:70 · privé | Chirurgien | privées | 91,6 % | 1,01 | 0,0 % | 6,7 |
| novice:70 · privé | Chirurgien | privées | 26,4 % | -6,98 | 0,0 % | 7,6 |
| novice+labo:70 · privé | Chirurgien | privées | 79,3 % | -0,21 | 0,0 % | 6,8 |
| hasard · partage | Réanimation | partagées | 3,9 % | -9,58 | 6,4 % | 9,0 |
| seuil:70 · partage | Réanimation | partagées | 83,3 % | 0,10 | 80,3 % | 8,0 |
| couleur:70 · partage | Réanimation | partagées | 85,5 % | 0,26 | 79,7 % | 7,7 |
| novice:70 · partage | Réanimation | partagées | 38,8 % | -10,48 | 66,9 % | 8,2 |
| novice+labo:70 · partage | Réanimation | partagées | 67,0 % | -1,67 | 88,7 % | 15,8 |
| hasard · privé | Réanimation | privées | 4,3 % | -9,53 | 6,8 % | 9,1 |
| seuil:70 · privé | Réanimation | privées | 84,3 % | 0,35 | 0,0 % | 8,2 |
| couleur:70 · privé | Réanimation | privées | 85,3 % | 0,40 | 0,0 % | 8,0 |
| novice:70 · privé | Réanimation | privées | 24,8 % | -7,83 | 0,0 % | 8,7 |
| novice+labo:70 · privé | Réanimation | privées | 71,1 % | -1,03 | 0,0 % | 7,5 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard · partage | seuil:70 · partage | couleur:70 · partage | novice:70 · partage | novice+labo:70 · partage | hasard · privé | seuil:70 · privé | couleur:70 · privé | novice:70 · privé | novice+labo:70 · privé |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 0,0 % en 6,77 | 98,2 % en 3,41 | 98,3 % en 3,23 | 68,4 % en 6,30 | 79,8 % en 4,74 | 1,7 % en 6,27 | 94,9 % en 3,41 | 97,5 % en 3,49 | 39,1 % en 7,82 | 92,4 % en 5,18 |
| Décalage horaire | generale | 2 | 1,0 % en 5,68 | 95,0 % en 2,99 | 97,5 % en 3,17 | 62,7 % en 6,60 | 89,3 % en 4,25 | 1,8 % en 5,41 | 88,7 % en 3,79 | 95,6 % en 3,14 | 32,1 % en 6,78 | 92,9 % en 4,30 |
| Maux de tête | generale | 2 | 4,0 % en 7,62 | 95,8 % en 3,34 | 100,0 % en 3,30 | 66,0 % en 7,05 | 82,7 % en 4,65 | 6,0 % en 7,26 | 99,1 % en 3,32 | 97,1 % en 3,69 | 37,9 % en 8,32 | 96,2 % en 5,44 |
| Rhume carabiné | generale | 2 | 0,8 % en 6,40 | 95,8 % en 3,63 | 98,0 % en 3,26 | 73,2 % en 6,24 | 79,7 % en 4,67 | 0,0 % en 6,63 | 95,2 % en 3,91 | 94,0 % en 3,83 | 41,2 % en 7,15 | 93,5 % en 4,98 |
| Conjonctivite | generale | 2 | 6,5 % en 7,77 | 100,0 % en 3,57 | 99,1 % en 3,08 | 71,2 % en 6,67 | 87,7 % en 4,54 | 0,9 % en 8,06 | 99,1 % en 4,06 | 98,9 % en 3,71 | 44,1 % en 8,20 | 93,8 % en 5,67 |
| Rage de dents | generale | 1 | 4,0 % en 7,62 | 97,0 % en 3,70 | 95,7 % en 3,34 | 67,2 % en 6,88 | 83,9 % en 4,57 | 1,5 % en 7,66 | 94,2 % en 4,19 | 98,3 % en 4,13 | 23,8 % en 9,32 | 88,4 % en 5,88 |
| Laryngite | generale | 2 | 4,6 % en 6,83 | 98,1 % en 3,58 | 99,0 % en 3,15 | 62,8 % en 7,02 | 84,4 % en 4,32 | 4,5 % en 7,16 | 96,2 % en 3,50 | 96,6 % en 3,52 | 40,9 % en 7,21 | 90,7 % en 4,87 |
| Torticolis | generale | 2 | 2,3 % en 6,73 | 92,2 % en 3,73 | 98,0 % en 3,06 | 63,1 % en 6,94 | 81,5 % en 4,31 | 5,0 % en 6,96 | 94,0 % en 3,87 | 93,6 % en 3,63 | 32,5 % en 8,52 | 92,0 % en 5,10 |
| Carence en vitamine D | generale | 2 | 3,3 % en 7,47 | 99,1 % en 3,50 | 97,5 % en 3,41 | 66,7 % en 6,45 | 87,9 % en 4,19 | 2,3 % en 7,22 | 99,1 % en 3,39 | 97,1 % en 3,38 | 39,3 % en 7,72 | 93,4 % en 4,79 |
| Fatigue chronique légère | generale | 2 | 2,1 % en 7,20 | 97,1 % en 3,19 | 97,1 % en 3,21 | 70,2 % en 6,11 | 90,0 % en 4,23 | 1,0 % en 7,12 | 97,7 % en 3,30 | 95,8 % en 3,65 | 41,7 % en 8,07 | 93,2 % en 4,80 |
| Otite moyenne aiguë | generale | 2 | 0,0 % en 6,34 | 94,8 % en 3,26 | 99,1 % en 2,91 | 62,5 % en 6,57 | 80,4 % en 4,32 | 2,2 % en 6,29 | 98,2 % en 3,38 | 97,4 % en 3,06 | 34,2 % en 7,04 | 85,1 % en 4,94 |
| Sinusite maxillaire | generale | 2 | 0,9 % en 7,23 | 96,1 % en 3,44 | 97,4 % en 3,34 | 62,2 % en 7,04 | 73,7 % en 4,68 | 2,6 % en 7,25 | 98,2 % en 3,42 | 93,7 % en 3,32 | 38,5 % en 7,40 | 94,6 % en 4,51 |
| Piqûre de moustique infectée | generale | 1 | 6,6 % en 7,03 | 90,0 % en 4,18 | 95,2 % en 3,60 | 66,0 % en 5,80 | 85,1 % en 4,32 | 4,9 % en 7,10 | 96,4 % en 3,58 | 94,2 % en 3,90 | 44,9 % en 7,16 | 87,9 % en 5,38 |
| Infection urinaire légère | generale | 2 | 1,7 % en 8,08 | 99,1 % en 3,65 | 97,5 % en 3,42 | 67,2 % en 6,67 | 88,9 % en 4,59 | 4,0 % en 7,97 | 98,3 % en 3,36 | 99,0 % en 3,50 | 47,1 % en 7,99 | 90,3 % en 5,39 |
| Gale | generale | 1 | 7,1 % en 6,07 | 90,4 % en 3,94 | 87,0 % en 3,96 | 0,0 % en 13,05 | 77,8 % en 5,03 | 9,1 % en 6,61 | 89,4 % en 3,85 | 87,0 % en 4,17 | 0,0 % en 10,95 | 86,2 % en 5,62 |
| Angine bactérienne | generale | 1 | 3,6 % en 7,50 | 94,8 % en 3,53 | 96,4 % en 3,57 | 63,2 % en 6,40 | 73,4 % en 5,23 | 1,7 % en 7,32 | 93,8 % en 4,03 | 98,1 % en 3,25 | 47,1 % en 6,80 | 84,9 % en 5,72 |
| Bronchite aiguë | generale | 2 | 3,7 % en 7,40 | 98,2 % en 3,44 | 98,0 % en 3,32 | 56,9 % en 7,08 | 84,7 % en 4,53 | 3,7 % en 6,85 | 96,5 % en 3,53 | 94,0 % en 3,70 | 36,7 % en 7,52 | 89,1 % en 4,93 |
| Gastro virale | generale | 1 | 5,8 % en 7,12 | 91,8 % en 4,34 | 90,9 % en 4,05 | 60,0 % en 6,72 | 85,7 % en 4,75 | 1,7 % en 7,92 | 92,3 % en 3,86 | 97,1 % en 4,01 | 43,3 % en 7,76 | 82,1 % en 5,52 |
| Hypoglycémie légère | generale | 1 | 4,2 % en 7,48 | 90,0 % en 3,62 | 94,7 % en 3,80 | 51,1 % en 8,06 | 77,2 % en 5,18 | 1,7 % en 7,72 | 98,6 % en 3,93 | 100,0 % en 3,39 | 39,0 % en 7,71 | 88,9 % en 5,48 |
| Intoxication alimentaire | generale | 1 | 2,9 % en 6,97 | 92,1 % en 3,51 | 92,2 % en 3,59 | 56,9 % en 7,57 | 76,8 % en 5,80 | 0,0 % en 7,33 | 88,9 % en 4,33 | 98,0 % en 3,73 | 48,3 % en 6,78 | 81,0 % en 5,48 |
| Varicelle | generale | 1 | 2,0 % en 6,41 | 86,2 % en 4,00 | 88,5 % en 3,58 | 0,0 % en 13,28 | 80,4 % en 4,95 | 10,8 % en 6,14 | 90,0 % en 4,10 | 97,9 % en 3,83 | 0,0 % en 9,11 | 81,0 % en 5,34 |
| Fièvre inexpliquée | generale | 1 | 0,0 % en 7,37 | 97,0 % en 3,56 | 95,5 % en 3,33 | 56,6 % en 7,34 | 77,8 % en 5,26 | 2,0 % en 7,69 | 90,4 % en 4,08 | 97,9 % en 3,40 | 34,7 % en 7,73 | 83,1 % en 5,54 |
| Rougeole | generale | 1 | 6,8 % en 6,41 | 82,0 % en 4,02 | 93,4 % en 3,70 | 0,0 % en 12,46 | 75,0 % en 4,96 | 11,1 % en 6,36 | 85,4 % en 3,77 | 90,5 % en 3,59 | 0,0 % en 9,74 | 81,7 % en 5,18 |
| Varices | cardiologie | 3 | 13,2 % en 6,64 | 95,8 % en 3,15 | 99,4 % en 3,14 | 11,2 % en 13,15 | 91,1 % en 3,77 | 9,4 % en 6,94 | 95,8 % en 3,14 | 98,7 % en 3,34 | 0,0 % en 11,57 | 87,2 % en 4,07 |
| Extrasystoles | cardiologie | 2 | 4,4 % en 6,11 | 90,8 % en 3,02 | 96,7 % en 3,08 | 86,9 % en 4,13 | 78,4 % en 3,84 | 1,0 % en 6,21 | 96,6 % en 3,41 | 90,7 % en 3,51 | 74,3 % en 5,01 | 80,9 % en 4,26 |
| Souffle au cœur | cardiologie | 3 | 8,0 % en 8,14 | 100,0 % en 2,99 | 99,4 % en 2,90 | 17,1 % en 14,43 | 86,7 % en 4,51 | 13,2 % en 7,71 | 98,7 % en 3,26 | 98,9 % en 3,13 | 2,0 % en 12,13 | 91,3 % en 4,37 |
| Hypotension orthostatique | cardiologie | 2 | 2,5 % en 6,96 | 98,2 % en 3,12 | 97,7 % en 3,13 | 86,2 % en 4,06 | 81,7 % en 4,02 | 6,8 % en 7,62 | 99,2 % en 3,24 | 96,2 % en 3,30 | 66,7 % en 5,39 | 85,6 % en 3,90 |
| Syndrome du cœur brisé | cardiologie | 2 | 1,9 % en 9,28 | 99,0 % en 3,41 | 100,0 % en 3,09 | 89,2 % en 4,36 | 86,7 % en 3,84 | 1,6 % en 9,36 | 100,0 % en 3,16 | 100,0 % en 3,24 | 77,3 % en 5,63 | 85,2 % en 4,67 |
| Hypertension artérielle | cardiologie | 3 | 3,4 % en 7,36 | 97,7 % en 3,12 | 97,7 % en 3,01 | 89,4 % en 4,04 | 85,5 % en 3,94 | 4,3 % en 7,72 | 97,2 % en 3,23 | 98,8 % en 3,17 | 66,5 % en 5,89 | 91,4 % en 4,10 |
| Bradycardie | cardiologie | 2 | 0,7 % en 7,78 | 98,9 % en 2,97 | 97,3 % en 3,27 | 89,7 % en 4,21 | 86,5 % en 3,85 | 4,4 % en 7,76 | 96,0 % en 3,30 | 96,4 % en 3,41 | 67,5 % en 5,67 | 83,3 % en 4,58 |
| Tachycardie | cardiologie | 2 | 3,6 % en 8,41 | 99,0 % en 3,23 | 97,4 % en 3,29 | 88,9 % en 4,21 | 90,7 % en 3,93 | 0,8 % en 8,30 | 98,2 % en 3,24 | 99,0 % en 3,50 | 71,4 % en 5,81 | 87,5 % en 4,40 |
| Phlébite | cardiologie | 2 | 13,5 % en 7,21 | 98,9 % en 2,84 | 99,2 % en 3,02 | 12,6 % en 13,56 | 86,1 % en 4,02 | 11,2 % en 7,55 | 94,0 % en 3,32 | 99,0 % en 3,22 | 0,0 % en 10,73 | 90,6 % en 4,17 |
| Angor | cardiologie | 2 | 11,5 % en 6,82 | 91,0 % en 3,26 | 95,5 % en 2,96 | 14,4 % en 12,31 | 83,2 % en 4,16 | 6,5 % en 6,57 | 91,5 % en 3,35 | 94,9 % en 3,38 | 0,9 % en 10,34 | 79,0 % en 4,28 |
| Péricardite | cardiologie | 2 | 14,2 % en 6,81 | 95,7 % en 3,37 | 97,4 % en 3,07 | 17,4 % en 13,45 | 86,9 % en 4,45 | 13,7 % en 7,21 | 99,0 % en 2,89 | 95,7 % en 3,19 | 1,1 % en 11,95 | 83,0 % en 4,37 |
| Arythmie | cardiologie | 1 | 2,0 % en 8,10 | 95,5 % en 3,41 | 97,9 % en 3,55 | 85,1 % en 4,26 | 93,2 % en 3,95 | 0,0 % en 8,41 | 94,5 % en 3,95 | 97,1 % en 3,55 | 62,7 % en 6,17 | 71,9 % en 4,40 |
| Fibrillation auriculaire | cardiologie | 2 | 0,9 % en 9,22 | 97,0 % en 3,40 | 98,2 % en 3,32 | 91,5 % en 4,37 | 83,5 % en 4,21 | 0,9 % en 9,31 | 96,1 % en 3,47 | 98,2 % en 3,49 | 79,2 % en 5,65 | 89,3 % en 4,65 |
| Insuffisance cardiaque | cardiologie | 1 | 11,7 % en 7,52 | 96,2 % en 3,73 | 95,8 % en 3,25 | 19,4 % en 11,55 | 64,9 % en 4,91 | 5,6 % en 7,98 | 95,3 % en 3,89 | 94,6 % en 3,61 | 2,0 % en 10,63 | 78,1 % en 4,77 |
| Endocardite | cardiologie | 2 | 11,0 % en 7,32 | 97,2 % en 3,19 | 97,4 % en 3,04 | 17,1 % en 12,17 | 81,4 % en 4,22 | 10,5 % en 7,43 | 99,1 % en 3,08 | 99,0 % en 3,25 | 0,9 % en 10,22 | 90,8 % en 4,32 |
| Cardiomyopathie | cardiologie | 1 | 10,2 % en 8,02 | 96,6 % en 3,24 | 100,0 % en 3,08 | 13,9 % en 13,81 | 79,7 % en 4,41 | 11,1 % en 7,83 | 93,5 % en 3,55 | 100,0 % en 3,20 | 0,0 % en 10,89 | 86,7 % en 5,12 |
| Rejet de greffe cardiaque | cardiologie | 1 | 18,2 % en 7,60 | 100,0 % en 3,02 | 100,0 % en 3,67 | 18,8 % en 14,44 | 64,0 % en 4,84 | 13,7 % en 8,08 | 97,7 % en 3,47 | 100,0 % en 3,14 | 2,0 % en 11,73 | 84,1 % en 4,76 |
| Œdème aigu du poumon | cardiologie | 1 | 10,5 % en 7,30 | 94,1 % en 3,63 | 100,0 % en 2,81 | 11,9 % en 12,46 | 71,4 % en 4,57 | 22,6 % en 6,53 | 92,3 % en 3,71 | 91,3 % en 3,59 | 0,0 % en 11,45 | 72,5 % en 4,98 |
| Infarctus du myocarde | cardiologie | 1 | 15,9 % en 7,43 | 94,8 % en 3,64 | 98,0 % en 3,25 | 20,4 % en 13,10 | 83,1 % en 4,86 | 18,5 % en 7,85 | 89,8 % en 4,03 | 91,7 % en 3,75 | 0,0 % en 11,26 | 82,1 % en 4,86 |
| Embolie pulmonaire | cardiologie | 1 | 3,0 % en 7,43 | 90,9 % en 3,60 | 100,0 % en 3,42 | 10,4 % en 12,04 | 78,0 % en 5,15 | 11,3 % en 6,94 | 96,2 % en 3,60 | 94,7 % en 3,32 | 0,0 % en 10,13 | 75,5 % en 4,43 |
| Tics nerveux | psychiatrie | 3 | 15,4 % en 6,47 | 95,7 % en 3,06 | 98,7 % en 3,14 | 16,4 % en 13,28 | 84,4 % en 4,03 | 13,7 % en 6,94 | 99,3 % en 3,13 | 100,0 % en 3,03 | 1,7 % en 10,44 | 83,6 % en 4,11 |
| Phobie des escaliers | psychiatrie | 2 | 0,0 % en 5,81 | 94,1 % en 3,03 | 96,4 % en 3,14 | 9,0 % en 13,04 | 87,5 % en 3,94 | 0,9 % en 5,69 | 95,2 % en 3,34 | 94,2 % en 3,08 | 3,3 % en 10,35 | 80,9 % en 4,35 |
| Dépendance à la caféine | psychiatrie | 3 | 1,3 % en 8,36 | 100,0 % en 2,99 | 100,0 % en 2,95 | 0,0 % en 15,26 | 88,5 % en 4,20 | 1,8 % en 8,59 | 98,9 % en 3,00 | 98,3 % en 3,17 | 0,0 % en 12,21 | 90,9 % en 4,09 |
| Somnambulisme | psychiatrie | 2 | 2,0 % en 6,97 | 94,1 % en 3,16 | 97,3 % en 3,08 | 9,5 % en 13,77 | 84,8 % en 4,37 | 0,0 % en 6,64 | 99,1 % en 3,20 | 97,4 % en 3,37 | 4,7 % en 10,79 | 86,5 % en 4,29 |
| Cauchemars répétés | psychiatrie | 2 | 3,2 % en 9,33 | 100,0 % en 3,16 | 99,1 % en 2,80 | 16,5 % en 15,09 | 86,5 % en 4,25 | 1,9 % en 9,07 | 99,2 % en 3,19 | 99,1 % en 3,65 | 0,9 % en 15,30 | 89,1 % en 4,85 |
| Phobie des blouses blanches | psychiatrie | 3 | 15,2 % en 6,52 | 98,6 % en 2,96 | 100,0 % en 2,87 | 90,0 % en 2,73 | 88,8 % en 3,77 | 15,8 % en 6,79 | 96,8 % en 3,04 | 98,0 % en 3,08 | 95,2 % en 2,87 | 90,7 % en 4,05 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 0,0 % en 7,58 | 96,9 % en 3,19 | 99,1 % en 2,91 | 11,5 % en 13,31 | 82,9 % en 4,20 | 0,9 % en 7,44 | 99,0 % en 3,15 | 100,0 % en 3,13 | 0,0 % en 10,58 | 80,3 % en 4,59 |
| Hypocondrie aiguë | psychiatrie | 2 | 3,8 % en 8,14 | 97,2 % en 3,11 | 96,3 % en 3,54 | 13,2 % en 12,80 | 87,0 % en 4,09 | 4,8 % en 8,13 | 98,9 % en 3,38 | 100,0 % en 3,28 | 3,6 % en 11,71 | 89,8 % en 4,56 |
| Agoraphobie | psychiatrie | 2 | 2,8 % en 8,45 | 97,3 % en 3,45 | 98,3 % en 3,20 | 3,6 % en 14,29 | 78,0 % en 5,25 | 4,2 % en 7,87 | 97,2 % en 3,64 | 98,2 % en 3,36 | 1,9 % en 10,73 | 83,3 % en 4,84 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 7,1 % en 7,30 | 96,7 % en 3,10 | 98,1 % en 3,11 | 6,5 % en 13,99 | 83,3 % en 3,89 | 1,9 % en 6,95 | 95,3 % en 3,49 | 97,5 % en 3,28 | 4,4 % en 9,31 | 86,1 % en 4,19 |
| Mutisme sélectif | psychiatrie | 2 | 11,7 % en 7,54 | 97,1 % en 3,48 | 96,8 % en 3,14 | 85,5 % en 2,94 | 89,8 % en 3,80 | 17,1 % en 7,34 | 95,8 % en 3,52 | 95,9 % en 3,05 | 94,1 % en 2,95 | 82,4 % en 4,48 |
| Addiction aux écrans | psychiatrie | 1 | 1,6 % en 8,10 | 100,0 % en 3,15 | 95,3 % en 3,59 | 0,0 % en 14,79 | 76,5 % en 5,14 | 2,1 % en 7,58 | 93,3 % en 4,00 | 93,3 % en 3,40 | 0,0 % en 11,71 | 86,0 % en 4,86 |
| Syndrome de Paris | psychiatrie | 2 | 10,1 % en 8,32 | 98,2 % en 3,19 | 98,9 % en 3,12 | 19,1 % en 13,71 | 81,7 % en 4,70 | 24,0 % en 7,36 | 96,9 % en 3,55 | 100,0 % en 3,22 | 2,0 % en 11,32 | 88,1 % en 4,69 |
| Dépression légère | psychiatrie | 1 | 8,8 % en 7,30 | 98,3 % en 3,22 | 98,0 % en 3,14 | 84,3 % en 2,94 | 85,1 % en 4,11 | 16,7 % en 7,10 | 94,3 % en 2,96 | 95,1 % en 3,49 | 88,7 % en 3,25 | 89,1 % en 4,26 |
| Trouble alimentaire léger | psychiatrie | 2 | 0,8 % en 7,88 | 98,2 % en 3,18 | 99,0 % en 2,97 | 0,0 % en 13,69 | 80,8 % en 4,43 | 2,2 % en 8,15 | 97,9 % en 3,20 | 99,2 % en 2,90 | 0,0 % en 9,79 | 83,1 % en 4,51 |
| Insomnie chronique | psychiatrie | 1 | 0,0 % en 7,98 | 98,4 % en 3,61 | 96,7 % en 3,42 | 0,0 % en 13,57 | 83,3 % en 5,04 | 0,0 % en 8,45 | 94,1 % en 3,57 | 98,0 % en 4,02 | 0,0 % en 10,48 | 91,1 % en 4,23 |
| Burn-out | psychiatrie | 1 | 22,7 % en 7,33 | 97,8 % en 3,28 | 98,3 % en 3,76 | 76,7 % en 3,32 | 76,7 % en 4,37 | 14,3 % en 7,44 | 97,7 % en 3,30 | 97,9 % en 4,02 | 95,5 % en 3,32 | 87,9 % en 4,61 |
| Attaque de panique | psychiatrie | 1 | 11,8 % en 7,46 | 94,2 % en 3,44 | 93,8 % en 3,58 | 9,6 % en 12,85 | 83,3 % en 4,33 | 11,1 % en 7,00 | 92,8 % en 3,55 | 98,0 % en 3,43 | 5,4 % en 9,91 | 82,4 % en 4,57 |
| Stress post-traumatique | psychiatrie | 1 | 13,6 % en 7,30 | 94,5 % en 3,33 | 94,4 % en 3,22 | 81,7 % en 3,42 | 80,0 % en 4,13 | 14,9 % en 7,96 | 98,4 % en 3,56 | 98,1 % en 3,41 | 95,6 % en 3,22 | 77,8 % en 4,58 |
| Jalousie délirante | psychiatrie | 1 | 18,6 % en 7,07 | 100,0 % en 3,22 | 97,9 % en 3,08 | 20,0 % en 11,77 | 76,6 % en 4,58 | 14,8 % en 7,00 | 92,7 % en 3,71 | 96,5 % en 3,77 | 5,5 % en 9,96 | 78,2 % en 4,69 |
| Hallux valgus | orthopedie | 3 | 14,6 % en 7,33 | 97,7 % en 2,99 | 98,0 % en 3,36 | 15,6 % en 13,40 | 84,8 % en 4,05 | 15,3 % en 7,16 | 99,3 % en 2,92 | 98,7 % en 2,94 | 0,0 % en 10,49 | 89,8 % en 4,07 |
| Périostite tibiale | orthopedie | 2 | 12,4 % en 6,68 | 96,3 % en 2,99 | 99,1 % en 2,96 | 25,8 % en 13,56 | 84,8 % en 3,83 | 12,5 % en 6,16 | 95,2 % en 2,98 | 95,3 % en 3,32 | 11,5 % en 10,08 | 86,2 % en 4,01 |
| Contusion sévère | orthopedie | 3 | 1,2 % en 9,23 | 99,4 % en 3,03 | 99,5 % en 3,13 | 91,8 % en 3,82 | 91,2 % en 3,85 | 2,3 % en 9,39 | 100,0 % en 3,02 | 98,9 % en 3,19 | 78,8 % en 5,15 | 91,2 % en 4,11 |
| Entorse de la cheville | orthopedie | 2 | 1,9 % en 7,88 | 99,1 % en 3,23 | 98,3 % en 2,97 | 85,0 % en 3,76 | 83,3 % en 4,06 | 3,0 % en 8,17 | 99,1 % en 3,49 | 95,9 % en 3,74 | 70,0 % en 4,95 | 83,9 % en 4,22 |
| Syndrome du canal carpien | orthopedie | 2 | 16,4 % en 9,51 | 98,9 % en 3,40 | 99,1 % en 3,12 | 17,7 % en 14,88 | 87,7 % en 4,40 | 13,7 % en 9,94 | 100,0 % en 3,28 | 100,0 % en 3,09 | 3,0 % en 13,94 | 90,8 % en 4,53 |
| Lumbago | orthopedie | 3 | 10,1 % en 7,53 | 98,0 % en 2,99 | 100,0 % en 2,86 | 22,7 % en 11,52 | 88,1 % en 4,14 | 18,1 % en 7,41 | 98,1 % en 3,38 | 99,4 % en 3,25 | 6,4 % en 9,78 | 85,1 % en 4,32 |
| Fêlure du coccyx | orthopedie | 2 | 16,0 % en 7,37 | 100,0 % en 2,90 | 100,0 % en 3,09 | 16,7 % en 12,08 | 81,7 % en 4,01 | 9,2 % en 7,66 | 99,2 % en 3,20 | 99,1 % en 3,17 | 9,9 % en 9,97 | 80,6 % en 4,66 |
| Épaule gelée | orthopedie | 2 | 16,3 % en 7,60 | 98,1 % en 3,05 | 99,2 % en 3,13 | 28,1 % en 12,08 | 88,7 % en 4,21 | 15,6 % en 8,06 | 98,4 % en 3,16 | 98,2 % en 3,12 | 10,4 % en 10,51 | 84,2 % en 4,47 |
| Entorse du genou | orthopedie | 2 | 0,0 % en 8,73 | 96,9 % en 3,02 | 97,1 % en 3,22 | 89,8 % en 3,89 | 85,7 % en 3,84 | 2,9 % en 8,75 | 98,2 % en 3,53 | 97,6 % en 3,23 | 77,6 % en 5,07 | 87,4 % en 4,57 |
| Sciatique | orthopedie | 2 | 13,3 % en 7,09 | 95,8 % en 2,97 | 98,0 % en 2,94 | 15,7 % en 11,90 | 84,3 % en 4,14 | 16,8 % en 7,28 | 96,9 % en 3,23 | 98,3 % en 3,01 | 7,6 % en 9,57 | 85,5 % en 4,14 |
| Scoliose | orthopedie | 2 | 20,0 % en 7,50 | 97,3 % en 3,25 | 100,0 % en 3,09 | 20,6 % en 13,11 | 85,1 % en 4,12 | 13,6 % en 7,67 | 98,4 % en 3,40 | 98,2 % en 3,33 | 2,5 % en 11,76 | 85,5 % en 4,41 |
| Arthrose du genou | orthopedie | 1 | 11,3 % en 7,77 | 94,1 % en 3,51 | 90,7 % en 3,81 | 23,0 % en 12,69 | 81,6 % en 5,02 | 15,6 % en 7,18 | 94,6 % en 3,91 | 96,6 % en 3,66 | 7,4 % en 11,70 | 88,7 % en 4,74 |
| Ostéoporose | orthopedie | 2 | 17,3 % en 8,88 | 100,0 % en 3,11 | 98,3 % en 3,08 | 17,9 % en 12,79 | 87,4 % en 4,37 | 14,8 % en 8,60 | 100,0 % en 3,48 | 99,0 % en 3,26 | 0,9 % en 12,16 | 90,8 % en 4,56 |
| Fracture du poignet | orthopedie | 1 | 11,3 % en 8,06 | 93,1 % en 3,34 | 96,8 % en 3,63 | 75,0 % en 4,04 | 86,4 % en 4,36 | 1,4 % en 8,48 | 95,3 % en 3,84 | 98,0 % en 4,20 | 77,4 % en 4,96 | 84,6 % en 5,15 |
| Fracture fermée | orthopedie | 2 | 1,7 % en 8,70 | 100,0 % en 3,23 | 98,2 % en 3,30 | 85,0 % en 3,73 | 90,2 % en 3,84 | 1,9 % en 8,32 | 95,3 % en 3,58 | 98,1 % en 2,99 | 66,4 % en 5,28 | 86,3 % en 4,39 |
| Luxation de l'épaule | orthopedie | 1 | 0,0 % en 9,05 | 95,3 % en 3,67 | 94,0 % en 3,72 | 91,9 % en 3,65 | 83,0 % en 4,21 | 0,0 % en 9,02 | 96,8 % en 3,44 | 100,0 % en 3,30 | 77,4 % en 5,42 | 83,0 % en 4,83 |
| Hernie discale | orthopedie | 1 | 1,8 % en 6,25 | 98,5 % en 3,45 | 98,4 % en 3,06 | 8,2 % en 11,14 | 63,6 % en 4,89 | 0,0 % en 6,63 | 92,0 % en 3,40 | 95,8 % en 3,29 | 1,8 % en 10,51 | 82,1 % en 4,89 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,58 | 90,1 % en 3,45 | 97,9 % en 3,11 | 25,5 % en 12,85 | 75,9 % en 4,10 | 1,7 % en 5,78 | 82,4 % en 3,75 | 100,0 % en 3,30 | 3,2 % en 10,52 | 67,3 % en 5,06 |
| Fracture ouverte | orthopedie | 1 | 4,0 % en 6,24 | 89,6 % en 3,70 | 92,6 % en 3,50 | 17,3 % en 11,81 | 83,7 % en 3,95 | 0,0 % en 6,07 | 86,2 % en 4,02 | 80,0 % en 3,87 | 1,7 % en 10,52 | 83,9 % en 4,58 |
| Fracture du fémur | orthopedie | 1 | 2,0 % en 5,92 | 96,2 % en 3,63 | 94,6 % en 3,20 | 7,1 % en 11,86 | 81,0 % en 4,98 | 0,0 % en 5,85 | 92,2 % en 3,49 | 95,9 % en 3,33 | 1,9 % en 9,51 | 75,4 % en 4,80 |
| Main froide éternelle | paranormal | 3 | 12,7 % en 7,03 | 99,5 % en 2,91 | 99,3 % en 2,77 | 17,3 % en 12,13 | 84,1 % en 4,14 | 19,6 % en 7,35 | 100,0 % en 2,98 | 98,3 % en 3,17 | 2,0 % en 11,27 | 89,7 % en 4,27 |
| Rire des cimetières | paranormal | 2 | 8,6 % en 5,74 | 95,4 % en 3,24 | 98,9 % en 3,16 | 16,7 % en 12,67 | 83,7 % en 3,98 | 11,8 % en 6,65 | 95,4 % en 3,24 | 96,5 % en 3,24 | 1,0 % en 9,68 | 83,5 % en 4,04 |
| Doigts qui grandissent | paranormal | 3 | 14,7 % en 8,04 | 99,4 % en 2,97 | 99,4 % en 2,95 | 18,2 % en 12,97 | 80,6 % en 4,47 | 15,2 % en 8,31 | 98,9 % en 3,09 | 98,3 % en 3,14 | 2,9 % en 12,32 | 89,9 % en 4,29 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 7,79 | 97,6 % en 3,44 | 99,1 % en 3,12 | 86,5 % en 3,73 | 91,2 % en 3,77 | 1,8 % en 8,12 | 96,9 % en 3,30 | 95,5 % en 3,30 | 73,0 % en 4,76 | 88,2 % en 3,99 |
| Nez qui saigne de l'encre | paranormal | 2 | 13,1 % en 9,11 | 99,1 % en 3,27 | 100,0 % en 2,93 | 25,5 % en 14,28 | 86,2 % en 4,58 | 18,0 % en 9,45 | 100,0 % en 3,48 | 100,0 % en 3,06 | 1,8 % en 14,16 | 93,8 % en 4,63 |
| Mauvais œil | paranormal | 3 | 0,0 % en 8,15 | 98,1 % en 2,92 | 99,4 % en 2,91 | 88,9 % en 3,59 | 86,5 % en 3,71 | 1,8 % en 7,98 | 97,2 % en 3,07 | 98,3 % en 3,15 | 77,9 % en 4,83 | 89,6 % en 4,14 |
| Malédiction des miroirs | paranormal | 2 | 1,9 % en 8,09 | 99,2 % en 3,01 | 99,2 % en 3,04 | 90,7 % en 3,82 | 83,6 % en 4,01 | 3,8 % en 8,25 | 97,9 % en 3,16 | 99,0 % en 2,79 | 75,7 % en 4,90 | 92,5 % en 4,17 |
| Malédiction du chat noir | paranormal | 2 | 0,8 % en 8,68 | 97,8 % en 3,18 | 97,4 % en 3,04 | 84,0 % en 3,69 | 89,7 % en 3,87 | 1,7 % en 8,70 | 97,2 % en 3,44 | 99,0 % en 2,96 | 80,0 % en 4,94 | 89,1 % en 4,37 |
| Malédiction du nombre 7 | paranormal | 2 | 2,6 % en 8,55 | 99,1 % en 3,50 | 99,1 % en 3,17 | 89,1 % en 3,70 | 87,3 % en 3,87 | 2,8 % en 8,09 | 96,6 % en 3,42 | 100,0 % en 3,07 | 81,3 % en 4,78 | 93,1 % en 4,08 |
| Ombre qui suit | paranormal | 2 | 7,9 % en 6,88 | 96,4 % en 3,11 | 95,7 % en 3,32 | 15,7 % en 11,64 | 85,6 % en 4,25 | 11,0 % en 7,30 | 96,8 % en 3,20 | 96,0 % en 3,55 | 0,0 % en 9,48 | 85,0 % en 4,22 |
| Brûlure lunaire | paranormal | 2 | 9,2 % en 7,93 | 96,3 % en 2,97 | 97,9 % en 3,03 | 22,2 % en 13,56 | 90,2 % en 4,24 | 10,4 % en 7,86 | 96,1 % en 3,53 | 99,1 % en 3,38 | 2,9 % en 10,76 | 90,0 % en 4,31 |
| Âme en double | paranormal | 1 | 2,0 % en 8,31 | 96,7 % en 3,30 | 100,0 % en 3,60 | 90,2 % en 3,71 | 84,9 % en 4,09 | 1,6 % en 7,93 | 95,9 % en 3,73 | 94,7 % en 3,30 | 74,5 % en 5,06 | 85,2 % en 4,33 |
| Voix du passé | paranormal | 2 | 1,0 % en 9,60 | 99,1 % en 3,13 | 99,0 % en 3,05 | 85,9 % en 3,88 | 82,7 % en 4,16 | 4,4 % en 9,38 | 97,5 % en 3,53 | 98,4 % en 3,61 | 80,6 % en 5,27 | 92,6 % en 4,68 |
| Murmures dans la tête | paranormal | 1 | 3,4 % en 8,50 | 96,6 % en 3,59 | 100,0 % en 3,66 | 84,4 % en 4,16 | 74,6 % en 4,19 | 3,8 % en 8,28 | 91,2 % en 3,84 | 97,1 % en 3,77 | 78,0 % en 5,17 | 80,8 % en 5,04 |
| Poltergeist domestique | paranormal | 2 | 16,8 % en 8,04 | 96,9 % en 3,29 | 96,4 % en 3,54 | 13,8 % en 12,52 | 88,8 % en 4,09 | 13,5 % en 7,72 | 97,9 % en 3,29 | 99,1 % en 3,13 | 1,8 % en 11,10 | 83,3 % en 4,67 |
| Vampirisme aigu | paranormal | 1 | 17,9 % en 7,86 | 98,4 % en 3,21 | 98,1 % en 3,00 | 14,8 % en 12,59 | 78,9 % en 5,46 | 23,5 % en 8,27 | 96,2 % en 3,83 | 100,0 % en 3,77 | 0,0 % en 10,83 | 85,2 % en 5,10 |
| Pétrification partielle | paranormal | 1 | 13,0 % en 8,00 | 98,1 % en 3,30 | 98,5 % en 3,40 | 14,8 % en 12,43 | 91,7 % en 4,18 | 14,9 % en 8,00 | 98,2 % en 4,35 | 98,3 % en 3,12 | 7,3 % en 10,05 | 88,1 % en 4,48 |
| Possession légère | paranormal | 1 | 3,1 % en 8,36 | 94,3 % en 3,23 | 97,9 % en 3,15 | 78,7 % en 3,77 | 76,5 % en 4,25 | 2,0 % en 8,08 | 95,7 % en 3,79 | 96,1 % en 3,41 | 80,0 % en 5,12 | 88,9 % en 4,70 |
| Lycanthropie | paranormal | 1 | 12,5 % en 8,02 | 90,4 % en 3,56 | 98,6 % en 3,86 | 2,6 % en 15,18 | 78,8 % en 4,40 | 8,1 % en 7,97 | 94,2 % en 4,25 | 94,5 % en 3,42 | 1,8 % en 9,25 | 80,0 % en 4,58 |
| Glissement temporel | paranormal | 1 | 17,9 % en 7,25 | 98,3 % en 3,46 | 98,3 % en 3,27 | 16,1 % en 12,92 | 83,6 % en 4,03 | 10,6 % en 7,45 | 100,0 % en 3,17 | 98,2 % en 3,68 | 4,3 % en 9,63 | 83,1 % en 4,73 |
