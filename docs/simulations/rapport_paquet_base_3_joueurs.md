# Rapport de simulation — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 3 joueurs à tour de rôle · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Analyses / patient | Analyses justes | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard · partage | Interne | 7,0 % | 93,0 % | 0 | 7,57 | 3,78 | 0,00 | — | 0,66 | -0,95 | -7,17 |
| seuil:70 · partage | Interne | 96,9 % | 3,1 % | 0 | 3,26 | 2,02 | 0,00 | — | 1,63 | 0,44 | 1,43 |
| couleur:70 · partage | Interne | 97,9 % | 2,1 % | 0 | 3,18 | 1,94 | 0,00 | — | 1,66 | 0,48 | 1,51 |
| novice:70 · partage | Interne | 44,8 % | 55,2 % | 0 | 9,36 | 3,25 | 0,00 | — | 0,98 | -0,65 | -6,10 |
| novice+labo:70 · partage | Interne | 91,4 % | 8,6 % | 0 | 4,24 | 1,92 | 1,14 | 75,6 % | 1,18 | 0,20 | 0,84 |
| hasard · privé | Interne | 7,5 % | 92,5 % | 0 | 7,60 | 3,79 | 0,00 | — | 0,66 | -0,94 | -7,16 |
| seuil:70 · privé | Interne | 96,7 % | 3,4 % | 0 | 3,41 | 2,18 | 0,00 | — | 1,60 | 0,43 | 1,48 |
| couleur:70 · privé | Interne | 97,4 % | 2,6 % | 0 | 3,34 | 2,09 | 0,00 | — | 1,62 | 0,47 | 1,56 |
| novice:70 · privé | Interne | 30,1 % | 69,9 % | 0 | 8,59 | 4,79 | 0,00 | — | 0,91 | -0,68 | -5,84 |
| novice+labo:70 · privé | Interne | 91,1 % | 8,8 % | 0 | 4,55 | 2,14 | 1,24 | 76,2 % | 1,15 | 0,22 | 1,00 |
| hasard · partage | Chirurgien | 5,0 % | 95,0 % | 0 | 5,25 | 2,64 | 0,00 | — | 1,26 | -1,59 | -8,35 |
| seuil:70 · partage | Chirurgien | 90,5 % | 9,6 % | 0 | 3,07 | 1,93 | 0,00 | — | 2,54 | 0,26 | 0,81 |
| couleur:70 · partage | Chirurgien | 92,3 % | 7,6 % | 0 | 3,05 | 1,88 | 0,00 | — | 2,58 | 0,32 | 0,97 |
| novice:70 · partage | Chirurgien | 40,2 % | 59,8 % | 0 | 7,98 | 2,78 | 0,00 | — | 1,89 | -1,12 | -8,93 |
| novice+labo:70 · partage | Chirurgien | 79,6 % | 20,4 % | 0 | 3,88 | 1,82 | 1,04 | 76,0 % | 1,83 | -0,04 | -0,16 |
| hasard · privé | Chirurgien | 5,3 % | 94,8 % | 0 | 5,25 | 2,62 | 0,00 | — | 1,26 | -1,59 | -8,33 |
| seuil:70 · privé | Chirurgien | 90,2 % | 9,8 % | 0 | 3,22 | 2,08 | 0,00 | — | 2,51 | 0,28 | 0,91 |
| couleur:70 · privé | Chirurgien | 91,6 % | 8,4 % | 0 | 3,19 | 2,02 | 0,00 | — | 2,54 | 0,32 | 1,01 |
| novice:70 · privé | Chirurgien | 25,6 % | 74,4 % | 0 | 6,57 | 3,63 | 0,00 | — | 1,75 | -1,07 | -7,02 |
| novice+labo:70 · privé | Chirurgien | 80,5 % | 19,4 % | 0 | 4,18 | 2,01 | 1,13 | 76,0 % | 1,80 | 0,03 | 0,13 |
| hasard · partage | Réanimation | 3,9 % | 96,1 % | 0 | 4,18 | 2,08 | 0,00 | — | 1,81 | -2,29 | -9,58 |
| seuil:70 · partage | Réanimation | 83,3 % | 16,7 % | 0 | 2,92 | 1,85 | 0,00 | — | 3,40 | 0,04 | 0,10 |
| couleur:70 · partage | Réanimation | 85,5 % | 14,5 % | 0 | 2,89 | 1,80 | 0,00 | — | 3,45 | 0,09 | 0,26 |
| novice:70 · partage | Réanimation | 37,5 % | 62,5 % | 0 | 7,08 | 2,51 | 0,00 | — | 2,79 | -1,47 | -10,43 |
| novice+labo:70 · partage | Réanimation | 67,0 % | 33,0 % | 0 | 3,51 | 1,71 | 0,95 | 76,8 % | 2,44 | -0,35 | -1,23 |
| hasard · privé | Réanimation | 4,3 % | 95,8 % | 0 | 4,17 | 2,08 | 0,00 | — | 1,82 | -2,28 | -9,53 |
| seuil:70 · privé | Réanimation | 84,3 % | 15,7 % | 0 | 3,05 | 1,98 | 0,00 | — | 3,40 | 0,11 | 0,35 |
| couleur:70 · privé | Réanimation | 85,3 % | 14,7 % | 0 | 3,05 | 1,96 | 0,00 | — | 3,42 | 0,13 | 0,40 |
| novice:70 · privé | Réanimation | 24,5 % | 75,5 % | 0 | 5,66 | 3,14 | 0,00 | — | 2,61 | -1,37 | -7,73 |
| novice+labo:70 · privé | Réanimation | 71,3 % | 28,7 % | 0 | 3,89 | 1,93 | 1,05 | 76,5 % | 2,43 | -0,18 | -0,69 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0), tous les jetons étant reportés sur la piste de l'hôpital. « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale moyenne | Finale C5 | Finale C50 | Finale C95 | Minimum moyen | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| hasard · partage | Interne | -71,7 | -90 | -71 | -54 | -71,8 | -90 | -71 |
| seuil:70 · partage | Interne | 14,3 | 4 | 16 | 20 | -0,3 | -2 | 0 |
| couleur:70 · partage | Interne | 15,1 | 5 | 17 | 20 | -0,3 | -1 | 0 |
| novice:70 · partage | Interne | -61,0 | -108 | -60 | -19 | -61,5 | -108 | -60 |
| novice+labo:70 · partage | Interne | 8,4 | -6 | 10 | 19 | -1,4 | -9 | 0 |
| hasard · privé | Interne | -71,6 | -91 | -71 | -54 | -71,7 | -91 | -71 |
| seuil:70 · privé | Interne | 14,8 | 5 | 17 | 20 | -0,4 | -2 | 0 |
| couleur:70 · privé | Interne | 15,6 | 6 | 17 | 20 | -0,3 | -1 | 0 |
| novice:70 · privé | Interne | -58,4 | -92 | -57 | -27 | -58,6 | -92 | -57 |
| novice+labo:70 · privé | Interne | 10,0 | -5 | 11 | 20 | -1,2 | -7 | 0 |
| hasard · partage | Chirurgien | -83,5 | -104 | -84 | -66 | -83,5 | -104 | -84 |
| seuil:70 · partage | Chirurgien | 8,1 | -8 | 10 | 20 | -1,9 | -11 | 0 |
| couleur:70 · partage | Chirurgien | 9,7 | -7 | 12 | 20 | -1,6 | -10 | 0 |
| novice:70 · partage | Chirurgien | -89,3 | -156 | -86 | -32 | -89,6 | -156 | -86 |
| novice+labo:70 · partage | Chirurgien | -1,6 | -22 | 0 | 14 | -6,6 | -23 | -4 |
| hasard · privé | Chirurgien | -83,3 | -103 | -83 | -64 | -83,4 | -103 | -83 |
| seuil:70 · privé | Chirurgien | 9,1 | -6 | 10 | 20 | -1,8 | -11 | 0 |
| couleur:70 · privé | Chirurgien | 10,1 | -6 | 12 | 20 | -1,6 | -10 | 0 |
| novice:70 · privé | Chirurgien | -70,2 | -108 | -70 | -36 | -70,4 | -108 | -70 |
| novice+labo:70 · privé | Chirurgien | 1,3 | -18 | 2 | 18 | -5,4 | -20 | -2 |
| hasard · partage | Réanimation | -95,8 | -117 | -95 | -76 | -95,8 | -117 | -95 |
| seuil:70 · partage | Réanimation | 1,0 | -20 | 3 | 20 | -5,9 | -22 | -3 |
| couleur:70 · partage | Réanimation | 2,6 | -17 | 3 | 20 | -5,0 | -19 | -2 |
| novice:70 · partage | Réanimation | -104,3 | -192 | -99 | -40 | -104,6 | -192 | -99 |
| novice+labo:70 · partage | Réanimation | -12,3 | -36 | -12 | 10 | -14,8 | -37 | -14 |
| hasard · privé | Réanimation | -95,3 | -116 | -95 | -76 | -95,3 | -116 | -95 |
| seuil:70 · privé | Réanimation | 3,5 | -17 | 4 | 20 | -4,6 | -20 | -1 |
| couleur:70 · privé | Réanimation | 4,0 | -16 | 6 | 20 | -4,4 | -18 | -1 |
| novice:70 · privé | Réanimation | -77,3 | -119 | -76 | -39 | -77,6 | -119 | -76 |
| novice+labo:70 · privé | Réanimation | -6,9 | -30 | -7 | 13 | -10,9 | -30 | -9 |

## Fermeture de l'hôpital selon le seuil

Part des parties où l'hôpital aurait fermé, selon l'écart entre la réputation de départ et le seuil de fermeture : la réputation passe strictement sous le seuil quand le minimum descend sous l'opposé de l'écart.

| Stratégie | Difficulté | Écart 5 | Écart 10 | Écart 15 | Écart 20 | Écart 30 |
|---|---|---:|---:|---:|---:|---:|
| hasard · partage | Interne | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · partage | Interne | 1,0 % | 0,4 % | 0,1 % | 0,0 % | 0,0 % |
| couleur:70 · partage | Interne | 0,7 % | 0,1 % | 0,0 % | 0,0 % | 0,0 % |
| novice:70 · partage | Interne | 99,4 % | 98,6 % | 97,2 % | 95,2 % | 89,2 % |
| novice+labo:70 · partage | Interne | 9,7 % | 3,5 % | 0,9 % | 0,3 % | 0,0 % |
| hasard · privé | Interne | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · privé | Interne | 1,7 % | 0,5 % | 0,0 % | 0,0 % | 0,0 % |
| couleur:70 · privé | Interne | 0,7 % | 0,3 % | 0,0 % | 0,0 % | 0,0 % |
| novice:70 · privé | Interne | 100,0 % | 99,9 % | 99,3 % | 98,1 % | 93,4 % |
| novice+labo:70 · privé | Interne | 8,0 % | 2,2 % | 0,7 % | 0,1 % | 0,0 % |
| hasard · partage | Chirurgien | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · partage | Chirurgien | 14,0 % | 5,1 % | 2,2 % | 0,6 % | 0,0 % |
| couleur:70 · partage | Chirurgien | 11,6 % | 3,5 % | 1,5 % | 0,2 % | 0,0 % |
| novice:70 · partage | Chirurgien | 99,8 % | 99,6 % | 99,4 % | 98,9 % | 96,2 % |
| novice+labo:70 · partage | Chirurgien | 44,4 % | 24,0 % | 15,4 % | 6,6 % | 1,8 % |
| hasard · privé | Chirurgien | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · privé | Chirurgien | 13,5 % | 5,2 % | 1,3 % | 0,4 % | 0,0 % |
| couleur:70 · privé | Chirurgien | 10,2 % | 3,9 % | 1,4 % | 0,3 % | 0,0 % |
| novice:70 · privé | Chirurgien | 99,9 % | 99,8 % | 99,7 % | 99,4 % | 97,2 % |
| novice+labo:70 · privé | Chirurgien | 36,3 % | 18,9 % | 9,9 % | 4,6 % | 1,1 % |
| hasard · partage | Réanimation | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · partage | Réanimation | 38,4 % | 21,5 % | 12,0 % | 6,0 % | 1,4 % |
| couleur:70 · partage | Réanimation | 33,5 % | 19,0 % | 9,0 % | 4,3 % | 0,8 % |
| novice:70 · partage | Réanimation | 99,9 % | 99,8 % | 99,8 % | 99,4 % | 97,6 % |
| novice+labo:70 · partage | Réanimation | 74,3 % | 59,9 % | 44,7 % | 28,7 % | 9,1 % |
| hasard · privé | Réanimation | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · privé | Réanimation | 30,6 % | 16,1 % | 8,5 % | 4,4 % | 0,4 % |
| couleur:70 · privé | Réanimation | 30,1 % | 14,3 % | 7,3 % | 3,6 % | 1,0 % |
| novice:70 · privé | Réanimation | 100,0 % | 99,9 % | 99,7 % | 99,5 % | 98,1 % |
| novice+labo:70 · privé | Réanimation | 61,3 % | 44,8 % | 28,8 % | 18,2 % | 4,3 % |

## Joueurs

« Par un autre » : part des guérisons faites par un joueur qui n'avait pas diagnostiqué le patient, alors qu'un autre l'avait fait. « Écart de pièces » : écart moyen, en fin de partie, entre le joueur le plus riche et le plus pauvre.

| Stratégie | Difficulté | Informations | Guérison | Réputation / patient | Par un autre | Écart de pièces |
|---|---|---|---:|---:|---:|---:|
| hasard · partage | Interne | partagées | 7,0 % | -7,17 | 7,0 % | 4,7 |
| seuil:70 · partage | Interne | partagées | 96,9 % | 1,43 | 72,5 % | 6,4 |
| couleur:70 · partage | Interne | partagées | 97,9 % | 1,51 | 72,9 % | 6,2 |
| novice:70 · partage | Interne | partagées | 44,8 % | -6,10 | 64,4 % | 5,3 |
| novice+labo:70 · partage | Interne | partagées | 91,4 % | 0,84 | 77,0 % | 12,2 |
| hasard · privé | Interne | privées | 7,5 % | -7,16 | 5,7 % | 4,7 |
| seuil:70 · privé | Interne | privées | 96,7 % | 1,48 | 0,0 % | 5,4 |
| couleur:70 · privé | Interne | privées | 97,4 % | 1,56 | 0,0 % | 5,2 |
| novice:70 · privé | Interne | privées | 30,1 % | -5,84 | 0,0 % | 6,1 |
| novice+labo:70 · privé | Interne | privées | 91,1 % | 1,00 | 0,0 % | 5,1 |
| hasard · partage | Chirurgien | partagées | 5,0 % | -8,35 | 6,0 % | 7,1 |
| seuil:70 · partage | Chirurgien | partagées | 90,5 % | 0,81 | 77,5 % | 6,9 |
| couleur:70 · partage | Chirurgien | partagées | 92,3 % | 0,97 | 76,0 % | 6,8 |
| novice:70 · partage | Chirurgien | partagées | 40,2 % | -8,93 | 66,2 % | 6,5 |
| novice+labo:70 · partage | Chirurgien | partagées | 79,6 % | -0,16 | 83,1 % | 14,6 |
| hasard · privé | Chirurgien | privées | 5,3 % | -8,33 | 4,8 % | 7,0 |
| seuil:70 · privé | Chirurgien | privées | 90,2 % | 0,91 | 0,0 % | 6,4 |
| couleur:70 · privé | Chirurgien | privées | 91,6 % | 1,01 | 0,0 % | 6,7 |
| novice:70 · privé | Chirurgien | privées | 25,6 % | -7,02 | 0,0 % | 7,4 |
| novice+labo:70 · privé | Chirurgien | privées | 80,5 % | 0,13 | 0,0 % | 6,4 |
| hasard · partage | Réanimation | partagées | 3,9 % | -9,58 | 6,4 % | 9,0 |
| seuil:70 · partage | Réanimation | partagées | 83,3 % | 0,10 | 80,3 % | 8,0 |
| couleur:70 · partage | Réanimation | partagées | 85,5 % | 0,26 | 79,7 % | 7,7 |
| novice:70 · partage | Réanimation | partagées | 37,5 % | -10,43 | 68,1 % | 8,3 |
| novice+labo:70 · partage | Réanimation | partagées | 67,0 % | -1,23 | 89,6 % | 17,1 |
| hasard · privé | Réanimation | privées | 4,3 % | -9,53 | 6,8 % | 9,1 |
| seuil:70 · privé | Réanimation | privées | 84,3 % | 0,35 | 0,0 % | 8,2 |
| couleur:70 · privé | Réanimation | privées | 85,3 % | 0,40 | 0,0 % | 8,0 |
| novice:70 · privé | Réanimation | privées | 24,5 % | -7,73 | 0,0 % | 8,6 |
| novice+labo:70 · privé | Réanimation | privées | 71,3 % | -0,69 | 0,0 % | 7,0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard · partage | seuil:70 · partage | couleur:70 · partage | novice:70 · partage | novice+labo:70 · partage | hasard · privé | seuil:70 · privé | couleur:70 · privé | novice:70 · privé | novice+labo:70 · privé |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 0,0 % en 6,77 | 98,2 % en 3,41 | 98,3 % en 3,23 | 67,2 % en 6,02 | 99,0 % en 4,74 | 1,7 % en 6,27 | 94,9 % en 3,41 | 97,5 % en 3,49 | 44,0 % en 7,28 | 93,1 % en 5,18 |
| Décalage horaire | generale | 2 | 1,0 % en 5,68 | 95,0 % en 2,99 | 97,5 % en 3,17 | 75,2 % en 5,70 | 93,6 % en 4,76 | 1,8 % en 5,41 | 88,7 % en 3,79 | 95,6 % en 3,14 | 28,8 % en 7,12 | 95,5 % en 4,55 |
| Maux de tête | generale | 2 | 4,0 % en 7,62 | 95,8 % en 3,34 | 100,0 % en 3,30 | 71,6 % en 7,44 | 100,0 % en 4,67 | 6,0 % en 7,26 | 99,1 % en 3,32 | 97,1 % en 3,69 | 40,0 % en 7,61 | 99,1 % en 5,72 |
| Rhume carabiné | generale | 2 | 0,8 % en 6,40 | 95,8 % en 3,63 | 98,0 % en 3,26 | 65,8 % en 6,42 | 100,0 % en 4,69 | 0,0 % en 6,63 | 95,2 % en 3,91 | 94,0 % en 3,83 | 38,8 % en 7,82 | 96,4 % en 5,06 |
| Conjonctivite | generale | 2 | 6,5 % en 7,77 | 100,0 % en 3,57 | 99,1 % en 3,08 | 72,8 % en 6,77 | 100,0 % en 5,09 | 0,9 % en 8,06 | 99,1 % en 4,06 | 98,9 % en 3,71 | 44,1 % en 8,32 | 96,2 % en 5,47 |
| Rage de dents | generale | 1 | 4,0 % en 7,62 | 97,0 % en 3,70 | 95,7 % en 3,34 | 65,6 % en 7,34 | 98,0 % en 5,12 | 1,5 % en 7,66 | 94,2 % en 4,19 | 98,3 % en 4,13 | 40,0 % en 7,88 | 94,3 % en 6,19 |
| Laryngite | generale | 2 | 4,6 % en 6,83 | 98,1 % en 3,58 | 99,0 % en 3,15 | 66,2 % en 5,98 | 90,0 % en 4,62 | 4,5 % en 7,16 | 96,2 % en 3,50 | 96,6 % en 3,52 | 45,0 % en 6,76 | 95,9 % en 5,09 |
| Torticolis | generale | 2 | 2,3 % en 6,73 | 92,2 % en 3,73 | 98,0 % en 3,06 | 73,6 % en 6,14 | 96,9 % en 4,28 | 5,0 % en 6,96 | 94,0 % en 3,87 | 93,6 % en 3,63 | 43,0 % en 6,98 | 95,3 % en 4,75 |
| Carence en vitamine D | generale | 2 | 3,3 % en 7,47 | 99,1 % en 3,50 | 97,5 % en 3,41 | 66,7 % en 6,88 | 94,5 % en 4,53 | 2,3 % en 7,22 | 99,1 % en 3,39 | 97,1 % en 3,38 | 43,4 % en 7,09 | 95,6 % en 4,70 |
| Fatigue chronique légère | generale | 2 | 2,1 % en 7,20 | 97,1 % en 3,19 | 97,1 % en 3,21 | 73,1 % en 6,27 | 97,5 % en 4,58 | 1,0 % en 7,12 | 97,7 % en 3,30 | 95,8 % en 3,65 | 42,3 % en 7,63 | 92,2 % en 4,89 |
| Otite moyenne aiguë | generale | 2 | 0,0 % en 6,34 | 94,8 % en 3,26 | 99,1 % en 2,91 | 57,1 % en 6,70 | 95,2 % en 4,40 | 2,2 % en 6,29 | 98,2 % en 3,38 | 97,4 % en 3,06 | 31,1 % en 6,73 | 88,3 % en 4,96 |
| Sinusite maxillaire | generale | 2 | 0,9 % en 7,23 | 96,1 % en 3,44 | 97,4 % en 3,34 | 68,3 % en 6,84 | 98,2 % en 4,35 | 2,6 % en 7,25 | 98,2 % en 3,42 | 93,7 % en 3,32 | 37,4 % en 7,88 | 97,6 % en 4,77 |
| Piqûre de moustique infectée | generale | 1 | 6,6 % en 7,03 | 90,0 % en 4,18 | 95,2 % en 3,60 | 57,1 % en 5,94 | 90,0 % en 4,68 | 4,9 % en 7,10 | 96,4 % en 3,58 | 94,2 % en 3,90 | 42,2 % en 7,87 | 91,4 % en 5,11 |
| Infection urinaire légère | generale | 2 | 1,7 % en 8,08 | 99,1 % en 3,65 | 97,5 % en 3,42 | 59,6 % en 7,08 | 93,7 % en 4,59 | 4,0 % en 7,97 | 98,3 % en 3,36 | 99,0 % en 3,50 | 40,9 % en 7,52 | 92,1 % en 5,17 |
| Gale | generale | 1 | 7,1 % en 6,07 | 90,4 % en 3,94 | 87,0 % en 3,96 | 0,0 % en 12,56 | 94,0 % en 5,21 | 9,1 % en 6,61 | 89,4 % en 3,85 | 87,0 % en 4,17 | 0,0 % en 10,06 | 94,6 % en 5,30 |
| Angine bactérienne | generale | 1 | 3,6 % en 7,50 | 94,8 % en 3,53 | 96,4 % en 3,57 | 50,0 % en 6,50 | 95,0 % en 4,55 | 1,7 % en 7,32 | 93,8 % en 4,03 | 98,1 % en 3,25 | 38,9 % en 7,31 | 90,9 % en 4,84 |
| Bronchite aiguë | generale | 2 | 3,7 % en 7,40 | 98,2 % en 3,44 | 98,0 % en 3,32 | 58,3 % en 7,17 | 95,1 % en 4,72 | 3,7 % en 6,85 | 96,5 % en 3,53 | 94,0 % en 3,70 | 40,0 % en 7,78 | 94,7 % en 4,71 |
| Gastro virale | generale | 1 | 5,8 % en 7,12 | 91,8 % en 4,34 | 90,9 % en 4,05 | 61,5 % en 7,31 | 85,1 % en 5,19 | 1,7 % en 7,92 | 92,3 % en 3,86 | 97,1 % en 4,01 | 34,8 % en 8,03 | 92,3 % en 5,00 |
| Hypoglycémie légère | generale | 1 | 4,2 % en 7,48 | 90,0 % en 3,62 | 94,7 % en 3,80 | 66,7 % en 6,61 | 90,3 % en 5,21 | 1,7 % en 7,72 | 98,6 % en 3,93 | 100,0 % en 3,39 | 41,5 % en 7,80 | 90,7 % en 5,11 |
| Intoxication alimentaire | generale | 1 | 2,9 % en 6,97 | 92,1 % en 3,51 | 92,2 % en 3,59 | 55,7 % en 7,39 | 83,9 % en 4,97 | 0,0 % en 7,33 | 88,9 % en 4,33 | 98,0 % en 3,73 | 49,2 % en 6,35 | 92,6 % en 5,20 |
| Varicelle | generale | 1 | 2,0 % en 6,41 | 86,2 % en 4,00 | 88,5 % en 3,58 | 0,0 % en 12,98 | 88,9 % en 4,91 | 10,8 % en 6,14 | 90,0 % en 4,10 | 97,9 % en 3,83 | 0,0 % en 9,27 | 96,4 % en 4,55 |
| Fièvre inexpliquée | generale | 1 | 0,0 % en 7,37 | 97,0 % en 3,56 | 95,5 % en 3,33 | 52,6 % en 8,26 | 95,6 % en 4,20 | 2,0 % en 7,69 | 90,4 % en 4,08 | 97,9 % en 3,40 | 35,2 % en 8,02 | 90,7 % en 4,89 |
| Rougeole | generale | 1 | 6,8 % en 6,41 | 82,0 % en 4,02 | 93,4 % en 3,70 | 0,0 % en 13,18 | 86,0 % en 4,93 | 11,1 % en 6,36 | 85,4 % en 3,77 | 90,5 % en 3,59 | 0,0 % en 9,49 | 94,8 % en 4,45 |
| Varices | cardiologie | 3 | 13,2 % en 6,64 | 95,8 % en 3,15 | 99,4 % en 3,14 | 16,7 % en 13,13 | 94,4 % en 4,01 | 9,4 % en 6,94 | 95,8 % en 3,14 | 98,7 % en 3,34 | 0,0 % en 10,94 | 92,3 % en 4,22 |
| Extrasystoles | cardiologie | 2 | 4,4 % en 6,11 | 90,8 % en 3,02 | 96,7 % en 3,08 | 88,9 % en 4,02 | 84,5 % en 3,80 | 1,0 % en 6,21 | 96,6 % en 3,41 | 90,7 % en 3,51 | 59,4 % en 5,22 | 85,0 % en 4,15 |
| Souffle au cœur | cardiologie | 3 | 8,0 % en 8,14 | 100,0 % en 2,99 | 99,4 % en 2,90 | 13,1 % en 13,96 | 95,9 % en 3,91 | 13,2 % en 7,71 | 98,7 % en 3,26 | 98,9 % en 3,13 | 1,4 % en 12,05 | 95,5 % en 4,14 |
| Hypotension orthostatique | cardiologie | 2 | 2,5 % en 6,96 | 98,2 % en 3,12 | 97,7 % en 3,13 | 89,8 % en 3,85 | 86,0 % en 4,07 | 6,8 % en 7,62 | 99,2 % en 3,24 | 96,2 % en 3,30 | 67,9 % en 5,21 | 85,3 % en 4,38 |
| Syndrome du cœur brisé | cardiologie | 2 | 1,9 % en 9,28 | 99,0 % en 3,41 | 100,0 % en 3,09 | 95,2 % en 3,94 | 97,3 % en 4,30 | 1,6 % en 9,36 | 100,0 % en 3,16 | 100,0 % en 3,24 | 66,9 % en 6,07 | 97,4 % en 4,60 |
| Hypertension artérielle | cardiologie | 3 | 3,4 % en 7,36 | 97,7 % en 3,12 | 97,7 % en 3,01 | 83,2 % en 4,11 | 94,4 % en 3,68 | 4,3 % en 7,72 | 97,2 % en 3,23 | 98,8 % en 3,17 | 66,5 % en 5,61 | 92,5 % en 4,13 |
| Bradycardie | cardiologie | 2 | 0,7 % en 7,78 | 98,9 % en 2,97 | 97,3 % en 3,27 | 87,7 % en 4,32 | 84,8 % en 4,06 | 4,4 % en 7,76 | 96,0 % en 3,30 | 96,4 % en 3,41 | 65,3 % en 5,93 | 87,0 % en 4,67 |
| Tachycardie | cardiologie | 2 | 3,6 % en 8,41 | 99,0 % en 3,23 | 97,4 % en 3,29 | 87,1 % en 4,33 | 89,0 % en 4,12 | 0,8 % en 8,30 | 98,2 % en 3,24 | 99,0 % en 3,50 | 64,6 % en 5,92 | 92,8 % en 4,41 |
| Phlébite | cardiologie | 2 | 13,5 % en 7,21 | 98,9 % en 2,84 | 99,2 % en 3,02 | 14,6 % en 12,93 | 97,0 % en 3,73 | 11,2 % en 7,55 | 94,0 % en 3,32 | 99,0 % en 3,22 | 0,9 % en 10,54 | 90,5 % en 4,54 |
| Angor | cardiologie | 2 | 11,5 % en 6,82 | 91,0 % en 3,26 | 95,5 % en 2,96 | 17,1 % en 12,23 | 84,5 % en 4,03 | 6,5 % en 6,57 | 91,5 % en 3,35 | 94,9 % en 3,38 | 1,0 % en 10,90 | 87,0 % en 4,19 |
| Péricardite | cardiologie | 2 | 14,2 % en 6,81 | 95,7 % en 3,37 | 97,4 % en 3,07 | 11,7 % en 13,43 | 91,1 % en 3,82 | 13,7 % en 7,21 | 99,0 % en 2,89 | 95,7 % en 3,19 | 1,7 % en 11,93 | 93,3 % en 4,21 |
| Arythmie | cardiologie | 1 | 2,0 % en 8,10 | 95,5 % en 3,41 | 97,9 % en 3,55 | 84,7 % en 4,56 | 84,6 % en 4,31 | 0,0 % en 8,41 | 94,5 % en 3,95 | 97,1 % en 3,55 | 66,7 % en 5,94 | 83,9 % en 4,56 |
| Fibrillation auriculaire | cardiologie | 2 | 0,9 % en 9,22 | 97,0 % en 3,40 | 98,2 % en 3,32 | 88,9 % en 4,24 | 92,4 % en 4,18 | 0,9 % en 9,31 | 96,1 % en 3,47 | 98,2 % en 3,49 | 77,5 % en 5,82 | 94,1 % en 4,80 |
| Insuffisance cardiaque | cardiologie | 1 | 11,7 % en 7,52 | 96,2 % en 3,73 | 95,8 % en 3,25 | 15,3 % en 12,85 | 87,0 % en 4,46 | 5,6 % en 7,98 | 95,3 % en 3,89 | 94,6 % en 3,61 | 0,0 % en 10,74 | 87,7 % en 4,43 |
| Endocardite | cardiologie | 2 | 11,0 % en 7,32 | 97,2 % en 3,19 | 97,4 % en 3,04 | 12,1 % en 12,58 | 89,9 % en 4,27 | 10,5 % en 7,43 | 99,1 % en 3,08 | 99,0 % en 3,25 | 1,5 % en 10,61 | 91,8 % en 4,10 |
| Cardiomyopathie | cardiologie | 1 | 10,2 % en 8,02 | 96,6 % en 3,24 | 100,0 % en 3,08 | 19,1 % en 13,51 | 78,6 % en 4,59 | 11,1 % en 7,83 | 93,5 % en 3,55 | 100,0 % en 3,20 | 0,0 % en 11,26 | 88,7 % en 5,04 |
| Rejet de greffe cardiaque | cardiologie | 1 | 18,2 % en 7,60 | 100,0 % en 3,02 | 100,0 % en 3,67 | 5,3 % en 15,33 | 87,0 % en 4,56 | 13,7 % en 8,08 | 97,7 % en 3,47 | 100,0 % en 3,14 | 0,0 % en 10,63 | 83,6 % en 5,04 |
| Œdème aigu du poumon | cardiologie | 1 | 10,5 % en 7,30 | 94,1 % en 3,63 | 100,0 % en 2,81 | 12,2 % en 14,95 | 72,0 % en 4,74 | 22,6 % en 6,53 | 92,3 % en 3,71 | 91,3 % en 3,59 | 2,1 % en 10,17 | 87,0 % en 4,37 |
| Infarctus du myocarde | cardiologie | 1 | 15,9 % en 7,43 | 94,8 % en 3,64 | 98,0 % en 3,25 | 21,9 % en 13,13 | 80,0 % en 4,70 | 18,5 % en 7,85 | 89,8 % en 4,03 | 91,7 % en 3,75 | 3,7 % en 12,06 | 91,1 % en 4,32 |
| Embolie pulmonaire | cardiologie | 1 | 3,0 % en 7,43 | 90,9 % en 3,60 | 100,0 % en 3,42 | 20,8 % en 13,92 | 78,7 % en 4,47 | 11,3 % en 6,94 | 96,2 % en 3,60 | 94,7 % en 3,32 | 1,7 % en 10,17 | 84,7 % en 4,66 |
| Tics nerveux | psychiatrie | 3 | 15,4 % en 6,47 | 95,7 % en 3,06 | 98,7 % en 3,14 | 18,2 % en 12,64 | 94,6 % en 3,95 | 13,7 % en 6,94 | 99,3 % en 3,13 | 100,0 % en 3,03 | 2,6 % en 10,24 | 87,0 % en 4,52 |
| Phobie des escaliers | psychiatrie | 2 | 0,0 % en 5,81 | 94,1 % en 3,03 | 96,4 % en 3,14 | 7,0 % en 13,54 | 83,5 % en 3,89 | 0,9 % en 5,69 | 95,2 % en 3,34 | 94,2 % en 3,08 | 2,0 % en 9,25 | 78,0 % en 4,41 |
| Dépendance à la caféine | psychiatrie | 3 | 1,3 % en 8,36 | 100,0 % en 2,99 | 100,0 % en 2,95 | 0,0 % en 15,77 | 97,3 % en 3,94 | 1,8 % en 8,59 | 98,9 % en 3,00 | 98,3 % en 3,17 | 0,0 % en 10,83 | 93,2 % en 4,48 |
| Somnambulisme | psychiatrie | 2 | 2,0 % en 6,97 | 94,1 % en 3,16 | 97,3 % en 3,08 | 9,9 % en 13,27 | 89,4 % en 4,08 | 0,0 % en 6,64 | 99,1 % en 3,20 | 97,4 % en 3,37 | 5,0 % en 11,29 | 87,4 % en 4,33 |
| Cauchemars répétés | psychiatrie | 2 | 3,2 % en 9,33 | 100,0 % en 3,16 | 99,1 % en 2,80 | 8,8 % en 15,66 | 96,0 % en 4,34 | 1,9 % en 9,07 | 99,2 % en 3,19 | 99,1 % en 3,65 | 2,8 % en 12,98 | 96,6 % en 4,59 |
| Phobie des blouses blanches | psychiatrie | 3 | 15,2 % en 6,52 | 98,6 % en 2,96 | 100,0 % en 2,87 | 90,2 % en 2,85 | 92,9 % en 3,96 | 15,8 % en 6,79 | 96,8 % en 3,04 | 98,0 % en 3,08 | 98,2 % en 2,87 | 92,1 % en 4,33 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 0,0 % en 7,58 | 96,9 % en 3,19 | 99,1 % en 2,91 | 8,3 % en 12,45 | 93,3 % en 3,94 | 0,9 % en 7,44 | 99,0 % en 3,15 | 100,0 % en 3,13 | 0,8 % en 10,60 | 89,4 % en 4,50 |
| Hypocondrie aiguë | psychiatrie | 2 | 3,8 % en 8,14 | 97,2 % en 3,11 | 96,3 % en 3,54 | 6,8 % en 13,93 | 92,1 % en 4,20 | 4,8 % en 8,13 | 98,9 % en 3,38 | 100,0 % en 3,28 | 2,6 % en 10,59 | 91,1 % en 4,48 |
| Agoraphobie | psychiatrie | 2 | 2,8 % en 8,45 | 97,3 % en 3,45 | 98,3 % en 3,20 | 10,9 % en 13,94 | 92,7 % en 4,00 | 4,2 % en 7,87 | 97,2 % en 3,64 | 98,2 % en 3,36 | 0,9 % en 10,45 | 89,5 % en 4,38 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 7,1 % en 7,30 | 96,7 % en 3,10 | 98,1 % en 3,11 | 12,6 % en 12,90 | 92,4 % en 4,14 | 1,9 % en 6,95 | 95,3 % en 3,49 | 97,5 % en 3,28 | 0,0 % en 10,05 | 88,7 % en 4,36 |
| Mutisme sélectif | psychiatrie | 2 | 11,7 % en 7,54 | 97,1 % en 3,48 | 96,8 % en 3,14 | 95,5 % en 2,78 | 88,0 % en 4,09 | 17,1 % en 7,34 | 95,8 % en 3,52 | 95,9 % en 3,05 | 92,9 % en 3,05 | 92,0 % en 4,60 |
| Addiction aux écrans | psychiatrie | 1 | 1,6 % en 8,10 | 100,0 % en 3,15 | 95,3 % en 3,59 | 0,0 % en 16,90 | 85,7 % en 4,16 | 2,1 % en 7,58 | 93,3 % en 4,00 | 93,3 % en 3,40 | 0,0 % en 11,63 | 80,4 % en 4,66 |
| Syndrome de Paris | psychiatrie | 2 | 10,1 % en 8,32 | 98,2 % en 3,19 | 98,9 % en 3,12 | 14,0 % en 14,57 | 96,3 % en 4,15 | 24,0 % en 7,36 | 96,9 % en 3,55 | 100,0 % en 3,22 | 2,6 % en 13,10 | 95,5 % en 4,25 |
| Dépression légère | psychiatrie | 1 | 8,8 % en 7,30 | 98,3 % en 3,22 | 98,0 % en 3,14 | 82,0 % en 3,31 | 84,8 % en 4,39 | 16,7 % en 7,10 | 94,3 % en 2,96 | 95,1 % en 3,49 | 92,2 % en 3,42 | 82,1 % en 5,19 |
| Trouble alimentaire léger | psychiatrie | 2 | 0,8 % en 7,88 | 98,2 % en 3,18 | 99,0 % en 2,97 | 0,0 % en 13,81 | 91,7 % en 3,98 | 2,2 % en 8,15 | 97,9 % en 3,20 | 99,2 % en 2,90 | 0,0 % en 9,98 | 88,1 % en 4,63 |
| Insomnie chronique | psychiatrie | 1 | 0,0 % en 7,98 | 98,4 % en 3,61 | 96,7 % en 3,42 | 0,0 % en 15,75 | 86,0 % en 4,68 | 0,0 % en 8,45 | 94,1 % en 3,57 | 98,0 % en 4,02 | 0,0 % en 11,38 | 85,7 % en 5,02 |
| Burn-out | psychiatrie | 1 | 22,7 % en 7,33 | 97,8 % en 3,28 | 98,3 % en 3,76 | 83,3 % en 3,07 | 94,1 % en 4,18 | 14,3 % en 7,44 | 97,7 % en 3,30 | 97,9 % en 4,02 | 95,1 % en 3,25 | 90,0 % en 4,80 |
| Attaque de panique | psychiatrie | 1 | 11,8 % en 7,46 | 94,2 % en 3,44 | 93,8 % en 3,58 | 15,6 % en 14,11 | 93,6 % en 4,21 | 11,1 % en 7,00 | 92,8 % en 3,55 | 98,0 % en 3,43 | 1,9 % en 9,23 | 84,8 % en 4,56 |
| Stress post-traumatique | psychiatrie | 1 | 13,6 % en 7,30 | 94,5 % en 3,33 | 94,4 % en 3,22 | 84,6 % en 3,28 | 82,2 % en 4,51 | 14,9 % en 7,96 | 98,4 % en 3,56 | 98,1 % en 3,41 | 100,0 % en 3,00 | 94,1 % en 4,37 |
| Jalousie délirante | psychiatrie | 1 | 18,6 % en 7,07 | 100,0 % en 3,22 | 97,9 % en 3,08 | 12,5 % en 12,72 | 90,4 % en 3,96 | 14,8 % en 7,00 | 92,7 % en 3,71 | 96,5 % en 3,77 | 0,0 % en 9,49 | 76,8 % en 4,80 |
| Hallux valgus | orthopedie | 3 | 14,6 % en 7,33 | 97,7 % en 2,99 | 98,0 % en 3,36 | 21,6 % en 12,49 | 93,2 % en 3,99 | 15,3 % en 7,16 | 99,3 % en 2,92 | 98,7 % en 2,94 | 1,7 % en 11,23 | 94,8 % en 4,17 |
| Périostite tibiale | orthopedie | 2 | 12,4 % en 6,68 | 96,3 % en 2,99 | 99,1 % en 2,96 | 16,2 % en 12,92 | 90,4 % en 4,03 | 12,5 % en 6,16 | 95,2 % en 2,98 | 95,3 % en 3,32 | 8,3 % en 10,11 | 85,0 % en 4,09 |
| Contusion sévère | orthopedie | 3 | 1,2 % en 9,23 | 99,4 % en 3,03 | 99,5 % en 3,13 | 90,8 % en 3,66 | 96,3 % en 4,28 | 2,3 % en 9,39 | 100,0 % en 3,02 | 98,9 % en 3,19 | 82,0 % en 4,63 | 92,9 % en 4,47 |
| Entorse de la cheville | orthopedie | 2 | 1,9 % en 7,88 | 99,1 % en 3,23 | 98,3 % en 2,97 | 89,6 % en 3,62 | 87,4 % en 4,13 | 3,0 % en 8,17 | 99,1 % en 3,49 | 95,9 % en 3,74 | 68,1 % en 4,85 | 91,8 % en 4,30 |
| Syndrome du canal carpien | orthopedie | 2 | 16,4 % en 9,51 | 98,9 % en 3,40 | 99,1 % en 3,12 | 17,6 % en 15,15 | 95,3 % en 4,10 | 13,7 % en 9,94 | 100,0 % en 3,28 | 100,0 % en 3,09 | 1,9 % en 14,60 | 98,3 % en 4,31 |
| Lumbago | orthopedie | 3 | 10,1 % en 7,53 | 98,0 % en 2,99 | 100,0 % en 2,86 | 15,9 % en 12,90 | 95,5 % en 3,86 | 18,1 % en 7,41 | 98,1 % en 3,38 | 99,4 % en 3,25 | 6,7 % en 10,49 | 91,9 % en 4,18 |
| Fêlure du coccyx | orthopedie | 2 | 16,0 % en 7,37 | 100,0 % en 2,90 | 100,0 % en 3,09 | 25,0 % en 12,06 | 93,5 % en 3,86 | 9,2 % en 7,66 | 99,2 % en 3,20 | 99,1 % en 3,17 | 8,3 % en 10,09 | 89,6 % en 4,48 |
| Épaule gelée | orthopedie | 2 | 16,3 % en 7,60 | 98,1 % en 3,05 | 99,2 % en 3,13 | 27,5 % en 12,54 | 93,2 % en 4,07 | 15,6 % en 8,06 | 98,4 % en 3,16 | 98,2 % en 3,12 | 7,0 % en 10,87 | 92,6 % en 4,60 |
| Entorse du genou | orthopedie | 2 | 0,0 % en 8,73 | 96,9 % en 3,02 | 97,1 % en 3,22 | 84,5 % en 3,81 | 93,2 % en 4,39 | 2,9 % en 8,75 | 98,2 % en 3,53 | 97,6 % en 3,23 | 78,7 % en 5,01 | 87,4 % en 4,59 |
| Sciatique | orthopedie | 2 | 13,3 % en 7,09 | 95,8 % en 2,97 | 98,0 % en 2,94 | 29,1 % en 12,10 | 91,3 % en 4,00 | 16,8 % en 7,28 | 96,9 % en 3,23 | 98,3 % en 3,01 | 2,9 % en 8,98 | 90,7 % en 4,30 |
| Scoliose | orthopedie | 2 | 20,0 % en 7,50 | 97,3 % en 3,25 | 100,0 % en 3,09 | 17,0 % en 13,69 | 88,1 % en 3,93 | 13,6 % en 7,67 | 98,4 % en 3,40 | 98,2 % en 3,33 | 3,8 % en 11,26 | 90,1 % en 4,68 |
| Arthrose du genou | orthopedie | 1 | 11,3 % en 7,77 | 94,1 % en 3,51 | 90,7 % en 3,81 | 17,3 % en 14,10 | 83,6 % en 4,90 | 15,6 % en 7,18 | 94,6 % en 3,91 | 96,6 % en 3,66 | 5,1 % en 11,53 | 83,3 % en 4,93 |
| Ostéoporose | orthopedie | 2 | 17,3 % en 8,88 | 100,0 % en 3,11 | 98,3 % en 3,08 | 16,7 % en 15,21 | 93,3 % en 4,13 | 14,8 % en 8,60 | 100,0 % en 3,48 | 99,0 % en 3,26 | 4,3 % en 11,71 | 94,3 % en 4,34 |
| Fracture du poignet | orthopedie | 1 | 11,3 % en 8,06 | 93,1 % en 3,34 | 96,8 % en 3,63 | 84,4 % en 4,06 | 89,1 % en 4,65 | 1,4 % en 8,48 | 95,3 % en 3,84 | 98,0 % en 4,20 | 85,4 % en 5,29 | 92,3 % en 4,40 |
| Fracture fermée | orthopedie | 2 | 1,7 % en 8,70 | 100,0 % en 3,23 | 98,2 % en 3,30 | 82,7 % en 3,93 | 89,4 % en 4,02 | 1,9 % en 8,32 | 95,3 % en 3,58 | 98,1 % en 2,99 | 79,3 % en 4,82 | 91,3 % en 4,43 |
| Luxation de l'épaule | orthopedie | 1 | 0,0 % en 9,05 | 95,3 % en 3,67 | 94,0 % en 3,72 | 87,5 % en 3,71 | 89,1 % en 4,30 | 0,0 % en 9,02 | 96,8 % en 3,44 | 100,0 % en 3,30 | 79,5 % en 4,89 | 89,6 % en 4,58 |
| Hernie discale | orthopedie | 1 | 1,8 % en 6,25 | 98,5 % en 3,45 | 98,4 % en 3,06 | 19,6 % en 11,71 | 87,3 % en 4,49 | 0,0 % en 6,63 | 92,0 % en 3,40 | 95,8 % en 3,29 | 0,0 % en 11,72 | 88,9 % en 4,41 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,58 | 90,1 % en 3,45 | 97,9 % en 3,11 | 18,8 % en 11,04 | 83,9 % en 4,45 | 1,7 % en 5,78 | 82,4 % en 3,75 | 100,0 % en 3,30 | 1,3 % en 10,19 | 82,7 % en 4,81 |
| Fracture ouverte | orthopedie | 1 | 4,0 % en 6,24 | 89,6 % en 3,70 | 92,6 % en 3,50 | 14,3 % en 11,55 | 87,2 % en 4,49 | 0,0 % en 6,07 | 86,2 % en 4,02 | 80,0 % en 3,87 | 0,0 % en 10,56 | 80,7 % en 4,65 |
| Fracture du fémur | orthopedie | 1 | 2,0 % en 5,92 | 96,2 % en 3,63 | 94,6 % en 3,20 | 13,0 % en 11,13 | 83,1 % en 4,06 | 0,0 % en 5,85 | 92,2 % en 3,49 | 95,9 % en 3,33 | 2,8 % en 9,83 | 89,4 % en 4,38 |
| Main froide éternelle | paranormal | 3 | 12,7 % en 7,03 | 99,5 % en 2,91 | 99,3 % en 2,77 | 18,4 % en 12,81 | 92,8 % en 4,08 | 19,6 % en 7,35 | 100,0 % en 2,98 | 98,3 % en 3,17 | 1,1 % en 10,97 | 93,7 % en 4,28 |
| Rire des cimetières | paranormal | 2 | 8,6 % en 5,74 | 95,4 % en 3,24 | 98,9 % en 3,16 | 15,4 % en 12,83 | 84,6 % en 3,76 | 11,8 % en 6,65 | 95,4 % en 3,24 | 96,5 % en 3,24 | 2,8 % en 10,17 | 86,2 % en 4,00 |
| Doigts qui grandissent | paranormal | 3 | 14,7 % en 8,04 | 99,4 % en 2,97 | 99,4 % en 2,95 | 19,5 % en 13,72 | 93,4 % en 4,20 | 15,2 % en 8,31 | 98,9 % en 3,09 | 98,3 % en 3,14 | 4,6 % en 12,68 | 94,8 % en 4,27 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 7,79 | 97,6 % en 3,44 | 99,1 % en 3,12 | 94,1 % en 3,54 | 84,5 % en 3,79 | 1,8 % en 8,12 | 96,9 % en 3,30 | 95,5 % en 3,30 | 73,2 % en 4,34 | 88,2 % en 4,13 |
| Nez qui saigne de l'encre | paranormal | 2 | 13,1 % en 9,11 | 99,1 % en 3,27 | 100,0 % en 2,93 | 18,8 % en 15,32 | 93,0 % en 4,04 | 18,0 % en 9,45 | 100,0 % en 3,48 | 100,0 % en 3,06 | 3,6 % en 12,32 | 97,1 % en 4,18 |
| Mauvais œil | paranormal | 3 | 0,0 % en 8,15 | 98,1 % en 2,92 | 99,4 % en 2,91 | 89,4 % en 3,53 | 93,0 % en 3,89 | 1,8 % en 7,98 | 97,2 % en 3,07 | 98,3 % en 3,15 | 79,6 % en 4,66 | 89,3 % en 4,46 |
| Malédiction des miroirs | paranormal | 2 | 1,9 % en 8,09 | 99,2 % en 3,01 | 99,2 % en 3,04 | 89,7 % en 3,95 | 90,6 % en 4,41 | 3,8 % en 8,25 | 97,9 % en 3,16 | 99,0 % en 2,79 | 82,5 % en 5,02 | 89,7 % en 4,28 |
| Malédiction du chat noir | paranormal | 2 | 0,8 % en 8,68 | 97,8 % en 3,18 | 97,4 % en 3,04 | 85,6 % en 3,57 | 91,2 % en 4,08 | 1,7 % en 8,70 | 97,2 % en 3,44 | 99,0 % en 2,96 | 80,4 % en 4,45 | 97,5 % en 4,45 |
| Malédiction du nombre 7 | paranormal | 2 | 2,6 % en 8,55 | 99,1 % en 3,50 | 99,1 % en 3,17 | 84,3 % en 3,77 | 92,5 % en 4,14 | 2,8 % en 8,09 | 96,6 % en 3,42 | 100,0 % en 3,07 | 78,5 % en 4,90 | 95,4 % en 4,28 |
| Ombre qui suit | paranormal | 2 | 7,9 % en 6,88 | 96,4 % en 3,11 | 95,7 % en 3,32 | 14,1 % en 13,22 | 89,2 % en 4,06 | 11,0 % en 7,30 | 96,8 % en 3,20 | 96,0 % en 3,55 | 2,1 % en 10,46 | 93,7 % en 4,22 |
| Brûlure lunaire | paranormal | 2 | 9,2 % en 7,93 | 96,3 % en 2,97 | 97,9 % en 3,03 | 13,4 % en 14,17 | 90,8 % en 4,19 | 10,4 % en 7,86 | 96,1 % en 3,53 | 99,1 % en 3,38 | 0,0 % en 10,70 | 89,2 % en 4,57 |
| Âme en double | paranormal | 1 | 2,0 % en 8,31 | 96,7 % en 3,30 | 100,0 % en 3,60 | 68,9 % en 4,31 | 83,6 % en 4,48 | 1,6 % en 7,93 | 95,9 % en 3,73 | 94,7 % en 3,30 | 84,2 % en 5,00 | 81,1 % en 5,36 |
| Voix du passé | paranormal | 2 | 1,0 % en 9,60 | 99,1 % en 3,13 | 99,0 % en 3,05 | 86,6 % en 4,11 | 94,4 % en 4,30 | 4,4 % en 9,38 | 97,5 % en 3,53 | 98,4 % en 3,61 | 76,5 % en 5,27 | 97,8 % en 4,33 |
| Murmures dans la tête | paranormal | 1 | 3,4 % en 8,50 | 96,6 % en 3,59 | 100,0 % en 3,66 | 81,5 % en 3,62 | 83,6 % en 4,54 | 3,8 % en 8,28 | 91,2 % en 3,84 | 97,1 % en 3,77 | 83,0 % en 4,85 | 91,4 % en 4,55 |
| Poltergeist domestique | paranormal | 2 | 16,8 % en 8,04 | 96,9 % en 3,29 | 96,4 % en 3,54 | 7,6 % en 12,68 | 91,7 % en 4,09 | 13,5 % en 7,72 | 97,9 % en 3,29 | 99,1 % en 3,13 | 2,5 % en 10,31 | 86,8 % en 4,75 |
| Vampirisme aigu | paranormal | 1 | 17,9 % en 7,86 | 98,4 % en 3,21 | 98,1 % en 3,00 | 20,0 % en 12,05 | 92,7 % en 4,20 | 23,5 % en 8,27 | 96,2 % en 3,83 | 100,0 % en 3,77 | 0,0 % en 11,30 | 97,7 % en 3,95 |
| Pétrification partielle | paranormal | 1 | 13,0 % en 8,00 | 98,1 % en 3,30 | 98,5 % en 3,40 | 17,6 % en 11,35 | 92,1 % en 4,29 | 14,9 % en 8,00 | 98,2 % en 4,35 | 98,3 % en 3,12 | 3,6 % en 10,93 | 94,9 % en 4,69 |
| Possession légère | paranormal | 1 | 3,1 % en 8,36 | 94,3 % en 3,23 | 97,9 % en 3,15 | 87,1 % en 3,85 | 77,0 % en 4,75 | 2,0 % en 8,08 | 95,7 % en 3,79 | 96,1 % en 3,41 | 74,6 % en 5,34 | 85,9 % en 4,55 |
| Lycanthropie | paranormal | 1 | 12,5 % en 8,02 | 90,4 % en 3,56 | 98,6 % en 3,86 | 12,1 % en 11,71 | 88,9 % en 4,31 | 8,1 % en 7,97 | 94,2 % en 4,25 | 94,5 % en 3,42 | 3,1 % en 11,03 | 80,6 % en 5,15 |
| Glissement temporel | paranormal | 1 | 17,9 % en 7,25 | 98,3 % en 3,46 | 98,3 % en 3,27 | 3,6 % en 13,68 | 84,3 % en 4,71 | 10,6 % en 7,45 | 100,0 % en 3,17 | 98,2 % en 3,68 | 0,0 % en 10,03 | 83,6 % en 4,79 |
