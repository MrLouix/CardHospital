# Rapport de simulation — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 3 joueurs à tour de rôle avec chacun son médecin · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Analyses / patient | Analyses justes | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard · partage | Interne | 8,0 % | 91,8 % | 23 | 8,30 | 4,16 | 0,00 | — | 0,70 | -0,95 | -7,93 |
| seuil:70 · partage | Interne | 84,1 % | 15,9 % | 0 | 3,81 | 2,70 | 0,00 | — | 1,42 | 0,13 | 0,50 |
| couleur:70 · partage | Interne | 84,3 % | 15,7 % | 0 | 3,81 | 2,71 | 0,00 | — | 1,43 | 0,14 | 0,52 |
| novice:70 · partage | Interne | 43,1 % | 56,5 % | 37 | 10,55 | 3,57 | 0,00 | — | 0,93 | -0,75 | -7,93 |
| novice+labo:70 · partage | Interne | 80,6 % | 19,4 % | 0 | 4,70 | 2,31 | 1,30 | 70,2 % | 1,05 | 0,02 | 0,09 |
| hasard · privé | Interne | 8,1 % | 91,8 % | 13 | 8,12 | 4,06 | 0,00 | — | 0,69 | -0,96 | -7,79 |
| seuil:70 · privé | Interne | 75,0 % | 25,0 % | 0 | 4,51 | 3,49 | 0,00 | — | 1,29 | -0,02 | -0,09 |
| couleur:70 · privé | Interne | 76,0 % | 24,0 % | 0 | 4,46 | 3,43 | 0,00 | — | 1,30 | -0,00 | -0,02 |
| novice:70 · privé | Interne | 37,0 % | 62,8 % | 21 | 10,69 | 5,45 | 0,00 | — | 0,94 | -0,74 | -7,93 |
| novice+labo:70 · privé | Interne | 71,1 % | 28,9 % | 0 | 5,46 | 2,92 | 1,55 | 68,5 % | 0,95 | -0,09 | -0,51 |
| hasard · partage | Chirurgien | 5,3 % | 94,7 % | 0 | 5,45 | 2,73 | 0,00 | — | 1,29 | -1,61 | -8,78 |
| seuil:70 · partage | Chirurgien | 79,3 % | 20,7 % | 0 | 3,42 | 2,39 | 0,00 | — | 2,34 | -0,02 | -0,07 |
| couleur:70 · partage | Chirurgien | 79,0 % | 21,0 % | 0 | 3,44 | 2,41 | 0,00 | — | 2,34 | -0,03 | -0,11 |
| novice:70 · partage | Chirurgien | 37,2 % | 62,8 % | 1 | 7,96 | 2,76 | 0,00 | — | 1,82 | -1,24 | -9,86 |
| novice+labo:70 · partage | Chirurgien | 70,6 % | 29,4 % | 0 | 4,12 | 2,03 | 1,16 | 72,5 % | 1,69 | -0,20 | -0,81 |
| hasard · privé | Chirurgien | 5,3 % | 94,7 % | 1 | 5,50 | 2,76 | 0,00 | — | 1,29 | -1,61 | -8,87 |
| seuil:70 · privé | Chirurgien | 70,3 % | 29,7 % | 0 | 3,88 | 2,94 | 0,00 | — | 2,21 | -0,16 | -0,63 |
| couleur:70 · privé | Chirurgien | 70,6 % | 29,4 % | 0 | 3,84 | 2,91 | 0,00 | — | 2,21 | -0,15 | -0,57 |
| novice:70 · privé | Chirurgien | 31,3 % | 68,7 % | 0 | 7,61 | 3,88 | 0,00 | — | 1,80 | -1,21 | -9,24 |
| novice+labo:70 · privé | Chirurgien | 61,4 % | 38,6 % | 0 | 4,70 | 2,53 | 1,34 | 70,9 % | 1,58 | -0,29 | -1,38 |
| hasard · partage | Réanimation | 3,9 % | 96,1 % | 0 | 4,28 | 2,15 | 0,00 | — | 1,86 | -2,31 | -9,90 |
| seuil:70 · partage | Réanimation | 74,7 % | 25,3 % | 0 | 3,12 | 2,16 | 0,00 | — | 3,23 | -0,20 | -0,61 |
| couleur:70 · partage | Réanimation | 74,5 % | 25,5 % | 0 | 3,15 | 2,18 | 0,00 | — | 3,22 | -0,21 | -0,66 |
| novice:70 · partage | Réanimation | 33,0 % | 67,0 % | 0 | 6,73 | 2,41 | 0,00 | — | 2,70 | -1,63 | -11,01 |
| novice+labo:70 · partage | Réanimation | 59,9 % | 40,1 % | 0 | 3,70 | 1,87 | 1,05 | 74,1 % | 2,29 | -0,49 | -1,80 |
| hasard · privé | Réanimation | 4,2 % | 95,8 % | 0 | 4,30 | 2,15 | 0,00 | — | 1,86 | -2,29 | -9,85 |
| seuil:70 · privé | Réanimation | 65,4 % | 34,6 % | 0 | 3,48 | 2,62 | 0,00 | — | 3,07 | -0,34 | -1,19 |
| couleur:70 · privé | Réanimation | 65,2 % | 34,8 % | 0 | 3,48 | 2,63 | 0,00 | — | 3,06 | -0,35 | -1,22 |
| novice:70 · privé | Réanimation | 28,7 % | 71,3 % | 0 | 6,21 | 3,22 | 0,00 | — | 2,66 | -1,56 | -9,67 |
| novice+labo:70 · privé | Réanimation | 53,5 % | 46,5 % | 0 | 4,18 | 2,28 | 1,19 | 72,8 % | 2,19 | -0,52 | -2,15 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0), tous les jetons étant reportés sur la piste de l'hôpital. « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale moyenne | Finale C5 | Finale C50 | Finale C95 | Minimum moyen | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| hasard · partage | Interne | -79,3 | -117 | -75 | -55 | -79,4 | -117 | -75 |
| seuil:70 · partage | Interne | 5,0 | -14 | 7 | 19 | -3,0 | -15 | 0 |
| couleur:70 · partage | Interne | 5,2 | -14 | 7 | 20 | -2,9 | -15 | 0 |
| novice:70 · partage | Interne | -79,3 | -144 | -75 | -28 | -79,6 | -144 | -75 |
| novice+labo:70 · partage | Interne | 0,9 | -19 | 2 | 17 | -4,8 | -19 | -1 |
| hasard · privé | Interne | -77,9 | -108 | -76 | -55 | -78,0 | -108 | -76 |
| seuil:70 · privé | Interne | -0,9 | -23 | 1 | 17 | -6,1 | -23 | -3 |
| couleur:70 · privé | Interne | -0,2 | -22 | 1 | 17 | -5,9 | -23 | -2 |
| novice:70 · privé | Interne | -79,3 | -136 | -76 | -33 | -79,6 | -136 | -76 |
| novice+labo:70 · privé | Interne | -5,1 | -27 | -4 | 13 | -8,9 | -28 | -7 |
| hasard · partage | Chirurgien | -87,8 | -116 | -86 | -66 | -87,8 | -116 | -86 |
| seuil:70 · partage | Chirurgien | -0,7 | -22 | 0 | 18 | -6,4 | -23 | -3 |
| couleur:70 · partage | Chirurgien | -1,1 | -25 | 0 | 18 | -6,7 | -26 | -2 |
| novice:70 · partage | Chirurgien | -98,6 | -176 | -94 | -39 | -98,9 | -176 | -94 |
| novice+labo:70 · partage | Chirurgien | -8,1 | -31 | -8 | 12 | -11,3 | -32 | -10 |
| hasard · privé | Chirurgien | -88,7 | -118 | -86 | -67 | -88,8 | -118 | -86 |
| seuil:70 · privé | Chirurgien | -6,3 | -28 | -6 | 14 | -10,2 | -29 | -8 |
| couleur:70 · privé | Chirurgien | -5,7 | -26 | -6 | 12 | -9,5 | -28 | -8 |
| novice:70 · privé | Chirurgien | -92,4 | -148 | -90 | -40 | -92,6 | -148 | -90 |
| novice+labo:70 · privé | Chirurgien | -13,8 | -38 | -14 | 8 | -16,0 | -39 | -14 |
| hasard · partage | Réanimation | -99,0 | -127 | -98 | -78 | -99,1 | -127 | -98 |
| seuil:70 · partage | Réanimation | -6,1 | -31 | -4 | 13 | -10,4 | -31 | -7 |
| couleur:70 · partage | Réanimation | -6,6 | -33 | -6 | 13 | -10,8 | -33 | -8 |
| novice:70 · partage | Réanimation | -110,1 | -195 | -102 | -46 | -110,3 | -195 | -103 |
| novice+labo:70 · partage | Réanimation | -18,0 | -43 | -17 | 4 | -19,5 | -44 | -18 |
| hasard · privé | Réanimation | -98,5 | -125 | -98 | -76 | -98,6 | -125 | -98 |
| seuil:70 · privé | Réanimation | -11,9 | -37 | -11 | 10 | -14,9 | -37 | -14 |
| couleur:70 · privé | Réanimation | -12,2 | -38 | -11 | 10 | -15,1 | -39 | -14 |
| novice:70 · privé | Réanimation | -96,7 | -157 | -93 | -44 | -96,9 | -157 | -93 |
| novice+labo:70 · privé | Réanimation | -21,5 | -48 | -21 | 3 | -23,0 | -49 | -21 |

## Fermeture de l'hôpital selon le seuil

Part des parties où l'hôpital aurait fermé, selon l'écart entre la réputation de départ et le seuil de fermeture : la réputation passe strictement sous le seuil quand le minimum descend sous l'opposé de l'écart.

| Stratégie | Difficulté | Écart 5 | Écart 10 | Écart 15 | Écart 20 | Écart 30 |
|---|---|---:|---:|---:|---:|---:|
| hasard · partage | Interne | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · partage | Interne | 19,5 % | 10,6 % | 4,7 % | 2,4 % | 0,5 % |
| couleur:70 · partage | Interne | 19,3 % | 11,2 % | 4,7 % | 2,1 % | 0,0 % |
| novice:70 · partage | Interne | 99,7 % | 99,5 % | 99,0 % | 97,9 % | 93,6 % |
| novice+labo:70 · partage | Interne | 31,1 % | 18,7 % | 9,9 % | 3,6 % | 0,7 % |
| hasard · privé | Interne | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 99,9 % |
| seuil:70 · privé | Interne | 39,1 % | 23,8 % | 13,5 % | 7,1 % | 1,3 % |
| couleur:70 · privé | Interne | 39,1 % | 22,3 % | 12,5 % | 6,6 % | 0,7 % |
| novice:70 · privé | Interne | 99,9 % | 99,7 % | 99,5 % | 99,1 % | 96,4 % |
| novice+labo:70 · privé | Interne | 54,5 % | 36,4 % | 21,1 % | 11,4 % | 2,9 % |
| hasard · partage | Chirurgien | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · partage | Chirurgien | 42,4 % | 24,2 % | 13,9 % | 6,8 % | 1,4 % |
| couleur:70 · partage | Chirurgien | 41,9 % | 24,4 % | 15,4 % | 8,6 % | 2,6 % |
| novice:70 · partage | Chirurgien | 99,8 % | 99,6 % | 99,5 % | 98,9 % | 97,9 % |
| novice+labo:70 · partage | Chirurgien | 62,8 % | 44,3 % | 31,9 % | 19,6 % | 5,5 % |
| hasard · privé | Chirurgien | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · privé | Chirurgien | 60,4 % | 40,6 % | 28,9 % | 15,4 % | 3,7 % |
| couleur:70 · privé | Chirurgien | 57,5 % | 38,7 % | 25,9 % | 12,5 % | 3,4 % |
| novice:70 · privé | Chirurgien | 100,0 % | 100,0 % | 99,9 % | 99,4 % | 98,3 % |
| novice+labo:70 · privé | Chirurgien | 77,6 % | 61,3 % | 48,4 % | 30,8 % | 12,8 % |
| hasard · partage | Réanimation | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · partage | Réanimation | 56,6 % | 41,4 % | 26,2 % | 17,6 % | 5,7 % |
| couleur:70 · partage | Réanimation | 57,6 % | 42,5 % | 28,0 % | 17,6 % | 6,4 % |
| novice:70 · partage | Réanimation | 100,0 % | 100,0 % | 100,0 % | 99,8 % | 98,8 % |
| novice+labo:70 · partage | Réanimation | 85,2 % | 71,7 % | 57,7 % | 43,5 % | 20,3 % |
| hasard · privé | Réanimation | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:70 · privé | Réanimation | 73,3 % | 60,5 % | 43,4 % | 30,5 % | 11,1 % |
| couleur:70 · privé | Réanimation | 72,4 % | 58,0 % | 43,5 % | 31,1 % | 12,5 % |
| novice:70 · privé | Réanimation | 100,0 % | 100,0 % | 100,0 % | 99,7 % | 98,6 % |
| novice+labo:70 · privé | Réanimation | 88,8 % | 82,0 % | 68,6 % | 55,2 % | 28,2 % |

## Joueurs

« Par un autre » : part des guérisons faites par un joueur qui n'avait pas diagnostiqué le patient, alors qu'un autre l'avait fait. « Écart de pièces » : écart moyen, en fin de partie, entre le joueur le plus riche et le plus pauvre.

| Stratégie | Difficulté | Informations | Guérison | Réputation / patient | Par un autre | Écart de pièces | Actions à deux |
|---|---|---|---:|---:|---:|---:|---:|
| hasard · partage | Interne | partagées | 8,0 % | -7,93 | 29,6 % | 7,3 | 66,7 % |
| seuil:70 · partage | Interne | partagées | 84,1 % | 0,50 | 74,4 % | 7,3 | 6,4 % |
| couleur:70 · partage | Interne | partagées | 84,3 % | 0,52 | 73,9 % | 7,5 | 6,6 % |
| novice:70 · partage | Interne | partagées | 43,1 % | -7,93 | 59,2 % | 10,1 | 50,6 % |
| novice+labo:70 · partage | Interne | partagées | 80,6 % | 0,09 | 68,4 % | 9,5 | 5,2 % |
| hasard · privé | Interne | privées | 8,1 % | -7,79 | 31,0 % | 6,9 | 66,7 % |
| seuil:70 · privé | Interne | privées | 75,0 % | -0,09 | 0,0 % | 6,7 | 5,1 % |
| couleur:70 · privé | Interne | privées | 76,0 % | -0,02 | 0,0 % | 6,8 | 4,9 % |
| novice:70 · privé | Interne | privées | 37,0 % | -7,93 | 0,0 % | 9,2 | 38,0 % |
| novice+labo:70 · privé | Interne | privées | 71,1 % | -0,51 | 0,0 % | 6,1 | 4,2 % |
| hasard · partage | Chirurgien | partagées | 5,3 % | -8,78 | 31,5 % | 10,7 | 66,6 % |
| seuil:70 · partage | Chirurgien | partagées | 79,3 % | -0,07 | 76,5 % | 8,9 | 7,0 % |
| couleur:70 · partage | Chirurgien | partagées | 79,0 % | -0,11 | 76,0 % | 8,6 | 7,0 % |
| novice:70 · partage | Chirurgien | partagées | 37,2 % | -9,86 | 63,4 % | 15,0 | 50,0 % |
| novice+labo:70 · partage | Chirurgien | partagées | 70,6 % | -0,81 | 72,4 % | 12,0 | 5,2 % |
| hasard · privé | Chirurgien | privées | 5,3 % | -8,87 | 30,2 % | 10,5 | 66,6 % |
| seuil:70 · privé | Chirurgien | privées | 70,3 % | -0,63 | 0,0 % | 8,1 | 5,5 % |
| couleur:70 · privé | Chirurgien | privées | 70,6 % | -0,57 | 0,0 % | 8,3 | 5,5 % |
| novice:70 · privé | Chirurgien | privées | 31,3 % | -9,24 | 0,0 % | 13,4 | 38,1 % |
| novice+labo:70 · privé | Chirurgien | privées | 61,4 % | -1,38 | 0,0 % | 7,2 | 3,9 % |
| hasard · partage | Réanimation | partagées | 3,9 % | -9,90 | 32,1 % | 13,8 | 66,6 % |
| seuil:70 · partage | Réanimation | partagées | 74,7 % | -0,61 | 79,1 % | 10,8 | 7,0 % |
| couleur:70 · partage | Réanimation | partagées | 74,5 % | -0,66 | 79,2 % | 10,9 | 7,3 % |
| novice:70 · partage | Réanimation | partagées | 33,0 % | -11,01 | 67,0 % | 21,0 | 50,0 % |
| novice+labo:70 · partage | Réanimation | partagées | 59,9 % | -1,80 | 76,4 % | 14,8 | 5,0 % |
| hasard · privé | Réanimation | privées | 4,2 % | -9,85 | 36,1 % | 14,3 | 66,6 % |
| seuil:70 · privé | Réanimation | privées | 65,4 % | -1,19 | 0,0 % | 9,5 | 5,6 % |
| couleur:70 · privé | Réanimation | privées | 65,2 % | -1,22 | 0,0 % | 9,5 | 5,4 % |
| novice:70 · privé | Réanimation | privées | 28,7 % | -9,67 | 0,0 % | 17,6 | 37,6 % |
| novice+labo:70 · privé | Réanimation | privées | 53,5 % | -2,15 | 0,0 % | 8,6 | 3,9 % |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard · partage | seuil:70 · partage | couleur:70 · partage | novice:70 · partage | novice+labo:70 · partage | hasard · privé | seuil:70 · privé | couleur:70 · privé | novice:70 · privé | novice+labo:70 · privé |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 1,7 % en 6,64 | 68,5 % en 4,84 | 68,9 % en 4,55 | 24,0 % en 13,33 | 70,9 % en 5,60 | 0,0 % en 7,31 | 50,0 % en 6,34 | 44,4 % en 6,73 | 11,9 % en 14,00 | 37,2 % en 8,48 |
| Décalage horaire | generale | 2 | 0,0 % en 5,45 | 67,3 % en 4,26 | 67,5 % en 4,19 | 21,1 % en 12,95 | 68,6 % en 4,96 | 0,0 % en 5,30 | 42,0 % en 5,40 | 52,4 % en 4,93 | 16,1 % en 13,72 | 35,8 % en 6,61 |
| Maux de tête | generale | 2 | 0,0 % en 8,17 | 98,1 % en 3,16 | 100,0 % en 3,26 | 80,4 % en 7,39 | 96,5 % en 4,47 | 2,0 % en 7,54 | 99,1 % en 3,46 | 96,6 % en 3,30 | 66,7 % en 8,58 | 96,7 % en 4,57 |
| Rhume carabiné | generale | 2 | 4,3 % en 7,10 | 98,2 % en 3,00 | 95,2 % en 3,13 | 79,6 % en 6,47 | 91,5 % en 4,56 | 1,7 % en 6,79 | 98,3 % en 3,42 | 96,5 % en 3,45 | 69,9 % en 8,15 | 97,3 % en 4,64 |
| Conjonctivite | generale | 2 | 3,1 % en 9,66 | 99,1 % en 3,15 | 99,0 % en 3,47 | 80,8 % en 6,55 | 98,1 % en 4,49 | 0,9 % en 9,54 | 100,0 % en 3,35 | 99,3 % en 3,49 | 78,3 % en 9,24 | 99,1 % en 4,94 |
| Rage de dents | generale | 1 | 1,9 % en 7,81 | 98,1 % en 3,72 | 92,2 % en 3,67 | 80,0 % en 6,53 | 97,9 % en 4,52 | 0,0 % en 8,88 | 98,2 % en 4,13 | 92,3 % en 4,19 | 70,5 % en 8,87 | 98,4 % en 5,06 |
| Laryngite | generale | 2 | 7,2 % en 7,66 | 96,3 % en 3,45 | 98,2 % en 3,18 | 78,3 % en 6,19 | 95,5 % en 4,09 | 7,3 % en 6,68 | 97,8 % en 3,47 | 96,4 % en 3,46 | 57,5 % en 7,89 | 92,9 % en 4,62 |
| Torticolis | generale | 2 | 2,8 % en 7,92 | 97,4 % en 3,19 | 96,7 % en 3,37 | 81,3 % en 5,98 | 93,6 % en 4,21 | 2,7 % en 6,83 | 94,9 % en 3,64 | 94,6 % en 3,25 | 65,4 % en 7,83 | 93,8 % en 4,45 |
| Carence en vitamine D | generale | 2 | 2,4 % en 7,73 | 75,7 % en 4,45 | 70,2 % en 4,76 | 19,5 % en 12,03 | 62,3 % en 5,80 | 1,9 % en 7,79 | 49,1 % en 6,22 | 55,7 % en 5,76 | 13,5 % en 13,24 | 41,3 % en 7,13 |
| Fatigue chronique légère | generale | 2 | 1,0 % en 7,44 | 76,4 % en 4,31 | 67,3 % en 4,89 | 29,0 % en 13,38 | 65,0 % en 5,53 | 2,9 % en 7,22 | 45,5 % en 6,15 | 47,1 % en 6,06 | 16,1 % en 13,24 | 42,9 % en 6,80 |
| Otite moyenne aiguë | generale | 2 | 5,0 % en 6,43 | 94,9 % en 3,44 | 96,7 % en 3,03 | 71,2 % en 6,27 | 93,8 % en 4,27 | 2,8 % en 6,90 | 96,1 % en 3,13 | 95,0 % en 3,34 | 57,4 % en 6,99 | 92,6 % en 4,21 |
| Sinusite maxillaire | generale | 2 | 3,5 % en 6,95 | 98,2 % en 3,24 | 97,4 % en 2,99 | 80,5 % en 6,57 | 92,8 % en 4,46 | 0,0 % en 7,28 | 96,6 % en 3,00 | 96,0 % en 3,45 | 67,2 % en 7,90 | 95,6 % en 4,57 |
| Piqûre de moustique infectée | generale | 1 | 3,4 % en 7,53 | 96,7 % en 3,84 | 91,4 % en 3,84 | 79,3 % en 6,31 | 85,7 % en 4,27 | 5,2 % en 7,09 | 98,4 % en 3,40 | 86,4 % en 3,63 | 61,4 % en 8,00 | 88,2 % en 4,73 |
| Infection urinaire légère | generale | 2 | 3,5 % en 7,76 | 97,0 % en 3,23 | 100,0 % en 3,20 | 84,3 % en 6,01 | 98,0 % en 4,33 | 5,5 % en 7,71 | 98,0 % en 3,79 | 98,1 % en 3,46 | 76,4 % en 7,72 | 92,3 % en 4,50 |
| Gale | generale | 1 | 5,6 % en 6,85 | 68,3 % en 4,53 | 72,6 % en 4,63 | 3,8 % en 8,13 | 60,3 % en 5,40 | 1,6 % en 6,31 | 39,1 % en 6,28 | 54,0 % en 6,14 | 0,0 % en 13,64 | 45,0 % en 6,42 |
| Angine bactérienne | generale | 1 | 3,4 % en 7,55 | 98,1 % en 3,02 | 97,9 % en 3,81 | 76,3 % en 5,76 | 91,0 % en 4,64 | 5,3 % en 7,70 | 93,8 % en 3,83 | 95,5 % en 3,90 | 55,1 % en 7,30 | 94,9 % en 4,54 |
| Bronchite aiguë | generale | 2 | 5,0 % en 7,45 | 97,2 % en 3,45 | 99,2 % en 3,38 | 74,4 % en 6,57 | 89,0 % en 4,57 | 3,2 % en 7,81 | 100,0 % en 3,54 | 97,5 % en 3,69 | 59,0 % en 7,60 | 83,5 % en 5,07 |
| Gastro virale | generale | 1 | 1,7 % en 8,05 | 96,2 % en 4,11 | 88,5 % en 3,60 | 67,3 % en 7,22 | 94,5 % en 4,42 | 1,6 % en 8,16 | 100,0 % en 3,88 | 100,0 % en 3,85 | 64,3 % en 7,71 | 79,6 % en 5,67 |
| Hypoglycémie légère | generale | 1 | 6,1 % en 7,57 | 96,6 % en 3,49 | 92,5 % en 3,60 | 86,3 % en 7,33 | 85,7 % en 4,69 | 2,1 % en 7,38 | 94,6 % en 3,80 | 95,2 % en 3,43 | 56,5 % en 7,72 | 87,3 % en 5,41 |
| Intoxication alimentaire | generale | 1 | 3,7 % en 7,31 | 86,2 % en 4,02 | 95,4 % en 3,32 | 70,6 % en 7,45 | 80,4 % en 4,73 | 0,0 % en 7,24 | 94,1 % en 4,16 | 91,2 % en 4,18 | 66,7 % en 7,02 | 81,8 % en 4,73 |
| Varicelle | generale | 1 | 5,8 % en 6,83 | 51,9 % en 5,23 | 76,3 % en 4,19 | 0,0 % en 9,94 | 64,2 % en 5,49 | 6,6 % en 6,59 | 40,6 % en 5,94 | 59,6 % en 5,70 | 0,0 % en 9,40 | 27,1 % en 6,97 |
| Fièvre inexpliquée | generale | 1 | 1,9 % en 7,17 | 96,0 % en 3,32 | 100,0 % en 3,25 | 83,3 % en 6,54 | 85,9 % en 5,13 | 6,3 % en 7,00 | 90,2 % en 4,00 | 95,5 % en 3,79 | 54,2 % en 7,71 | 76,5 % en 5,84 |
| Rougeole | generale | 1 | 5,5 % en 6,78 | 59,6 % en 4,92 | 68,9 % en 4,62 | 0,0 % en 7,99 | 59,6 % en 5,48 | 6,7 % en 6,40 | 44,9 % en 5,20 | 36,6 % en 5,90 | 0,0 % en 10,72 | 33,8 % en 6,62 |
| Varices | cardiologie | 3 | 18,4 % en 7,08 | 83,1 % en 3,79 | 75,4 % en 4,17 | 13,8 % en 12,50 | 83,5 % en 4,57 | 17,5 % en 7,03 | 62,6 % en 5,12 | 70,1 % en 4,69 | 8,3 % en 13,70 | 61,3 % en 6,01 |
| Extrasystoles | cardiologie | 2 | 0,0 % en 8,51 | 91,1 % en 3,17 | 97,3 % en 3,02 | 70,2 % en 4,06 | 84,9 % en 3,95 | 2,1 % en 8,62 | 91,4 % en 3,34 | 94,2 % en 3,08 | 67,0 % en 4,64 | 83,3 % en 4,37 |
| Souffle au cœur | cardiologie | 3 | 16,7 % en 8,47 | 78,8 % en 4,23 | 78,7 % en 4,04 | 19,3 % en 13,66 | 82,3 % en 4,70 | 7,6 % en 7,52 | 69,9 % en 4,72 | 61,9 % en 5,63 | 9,1 % en 15,29 | 63,1 % en 5,98 |
| Hypotension orthostatique | cardiologie | 2 | 5,4 % en 10,26 | 97,3 % en 2,97 | 94,6 % en 2,84 | 81,4 % en 4,35 | 93,2 % en 3,85 | 5,4 % en 9,42 | 99,2 % en 2,85 | 95,1 % en 2,92 | 79,0 % en 4,66 | 95,8 % en 4,22 |
| Syndrome du cœur brisé | cardiologie | 2 | 5,1 % en 13,26 | 99,0 % en 3,26 | 100,0 % en 3,03 | 83,7 % en 4,42 | 98,2 % en 3,88 | 9,8 % en 13,00 | 100,0 % en 2,96 | 100,0 % en 3,23 | 80,9 % en 4,76 | 95,1 % en 4,56 |
| Hypertension artérielle | cardiologie | 3 | 5,6 % en 8,86 | 99,5 % en 2,96 | 99,3 % en 2,95 | 77,8 % en 4,36 | 94,9 % en 4,00 | 3,0 % en 8,82 | 100,0 % en 2,96 | 97,1 % en 3,01 | 77,1 % en 4,42 | 95,5 % en 4,30 |
| Bradycardie | cardiologie | 2 | 3,8 % en 8,70 | 97,6 % en 3,04 | 98,1 % en 3,24 | 89,5 % en 4,38 | 93,6 % en 4,26 | 1,9 % en 7,57 | 96,0 % en 3,40 | 99,1 % en 3,37 | 75,6 % en 4,57 | 94,1 % en 4,39 |
| Tachycardie | cardiologie | 2 | 2,5 % en 9,49 | 97,8 % en 3,33 | 98,2 % en 2,97 | 85,8 % en 4,61 | 93,1 % en 4,01 | 2,7 % en 9,56 | 97,2 % en 3,05 | 97,3 % en 3,35 | 78,7 % en 5,07 | 94,2 % en 4,31 |
| Phlébite | cardiologie | 2 | 15,5 % en 8,26 | 82,2 % en 4,10 | 87,4 % en 3,52 | 11,0 % en 12,47 | 76,0 % en 4,79 | 18,4 % en 7,70 | 67,5 % en 4,68 | 68,1 % en 4,86 | 4,7 % en 12,50 | 60,8 % en 5,70 |
| Angor | cardiologie | 2 | 14,3 % en 6,88 | 76,5 % en 4,11 | 81,2 % en 3,83 | 7,8 % en 12,92 | 71,8 % en 4,53 | 14,3 % en 6,46 | 60,2 % en 4,70 | 66,9 % en 4,20 | 11,5 % en 11,81 | 57,5 % en 5,16 |
| Péricardite | cardiologie | 2 | 17,4 % en 8,15 | 77,3 % en 3,98 | 84,1 % en 3,56 | 13,1 % en 13,44 | 73,0 % en 4,74 | 22,7 % en 7,31 | 67,8 % en 4,64 | 61,5 % en 4,95 | 4,1 % en 12,42 | 53,5 % en 5,98 |
| Arythmie | cardiologie | 1 | 1,8 % en 8,98 | 96,0 % en 3,28 | 96,2 % en 3,48 | 77,1 % en 3,90 | 91,7 % en 4,50 | 0,0 % en 9,30 | 98,4 % en 3,42 | 98,0 % en 3,10 | 73,7 % en 5,05 | 90,2 % en 4,70 |
| Fibrillation auriculaire | cardiologie | 2 | 2,7 % en 10,10 | 99,2 % en 3,01 | 97,0 % en 3,36 | 85,7 % en 4,63 | 98,1 % en 4,02 | 3,6 % en 9,23 | 97,4 % en 3,23 | 99,1 % en 3,61 | 78,3 % en 4,78 | 94,6 % en 4,59 |
| Insuffisance cardiaque | cardiologie | 1 | 17,0 % en 7,06 | 67,3 % en 4,42 | 74,2 % en 4,18 | 16,0 % en 11,60 | 66,7 % en 5,35 | 10,9 % en 6,89 | 60,3 % en 5,02 | 62,5 % en 4,81 | 1,7 % en 11,37 | 55,0 % en 6,15 |
| Endocardite | cardiologie | 2 | 11,1 % en 7,15 | 71,1 % en 4,30 | 84,8 % en 3,92 | 15,2 % en 12,13 | 73,9 % en 4,79 | 14,0 % en 7,36 | 65,8 % en 4,94 | 70,7 % en 4,60 | 8,5 % en 11,73 | 62,2 % en 5,23 |
| Cardiomyopathie | cardiologie | 1 | 17,2 % en 8,36 | 81,1 % en 3,87 | 80,0 % en 4,47 | 15,9 % en 12,33 | 73,5 % en 5,12 | 14,8 % en 7,24 | 75,0 % en 4,70 | 69,7 % en 5,05 | 2,6 % en 11,71 | 48,0 % en 6,60 |
| Rejet de greffe cardiaque | cardiologie | 1 | 23,0 % en 8,30 | 68,6 % en 4,55 | 82,0 % en 4,12 | 15,5 % en 12,93 | 72,1 % en 5,26 | 15,4 % en 7,63 | 59,4 % en 5,38 | 59,3 % en 5,61 | 5,1 % en 12,29 | 53,3 % en 6,85 |
| Œdème aigu du poumon | cardiologie | 1 | 19,0 % en 8,57 | 81,3 % en 3,70 | 78,7 % en 4,00 | 15,2 % en 14,15 | 80,0 % en 4,96 | 15,4 % en 6,42 | 64,7 % en 4,82 | 60,4 % en 4,85 | 1,8 % en 11,67 | 58,0 % en 5,22 |
| Infarctus du myocarde | cardiologie | 1 | 15,3 % en 7,53 | 82,7 % en 4,00 | 86,4 % en 3,68 | 5,6 % en 13,59 | 74,5 % en 5,55 | 17,9 % en 7,19 | 72,7 % en 5,16 | 53,8 % en 5,15 | 6,1 % en 14,14 | 58,0 % en 5,92 |
| Embolie pulmonaire | cardiologie | 1 | 15,3 % en 7,34 | 72,0 % en 4,32 | 78,8 % en 4,08 | 6,5 % en 11,70 | 64,4 % en 5,20 | 16,1 % en 7,07 | 63,8 % en 5,00 | 62,5 % en 5,09 | 0,0 % en 9,87 | 59,0 % en 5,62 |
| Tics nerveux | psychiatrie | 3 | 11,7 % en 7,46 | 75,5 % en 4,10 | 77,9 % en 3,91 | 15,9 % en 12,32 | 76,7 % en 4,70 | 13,7 % en 6,79 | 59,9 % en 5,48 | 67,8 % en 4,83 | 7,2 % en 12,93 | 62,2 % en 5,73 |
| Phobie des escaliers | psychiatrie | 2 | 1,0 % en 7,48 | 94,8 % en 3,11 | 94,9 % en 2,84 | 21,1 % en 12,53 | 91,8 % en 4,05 | 1,9 % en 8,47 | 97,6 % en 3,22 | 97,3 % en 2,91 | 11,8 % en 10,52 | 88,6 % en 4,18 |
| Dépendance à la caféine | psychiatrie | 3 | 2,4 % en 11,97 | 51,2 % en 6,26 | 45,6 % en 6,56 | 1,9 % en 15,93 | 46,8 % en 6,76 | 2,9 % en 10,20 | 31,5 % en 7,84 | 30,4 % en 8,22 | 0,0 % en 16,14 | 33,1 % en 8,76 |
| Somnambulisme | psychiatrie | 2 | 1,7 % en 7,87 | 100,0 % en 2,86 | 99,2 % en 2,93 | 21,4 % en 14,06 | 93,7 % en 4,12 | 1,0 % en 8,82 | 98,0 % en 3,25 | 99,1 % en 3,03 | 12,4 % en 15,83 | 94,9 % en 4,34 |
| Cauchemars répétés | psychiatrie | 2 | 1,6 % en 9,56 | 100,0 % en 2,97 | 100,0 % en 3,28 | 23,2 % en 17,05 | 97,4 % en 4,25 | 2,0 % en 12,04 | 99,0 % en 3,16 | 99,1 % en 3,23 | 9,5 % en 16,25 | 99,1 % en 4,43 |
| Phobie des blouses blanches | psychiatrie | 3 | 16,0 % en 6,81 | 77,4 % en 3,89 | 83,2 % en 3,81 | 60,1 % en 3,69 | 85,1 % en 4,22 | 13,8 % en 6,97 | 64,1 % en 5,01 | 69,4 % en 4,75 | 55,9 % en 3,91 | 62,4 % en 5,57 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 1,0 % en 7,94 | 96,9 % en 3,00 | 97,2 % en 3,03 | 17,7 % en 13,81 | 90,9 % en 4,20 | 6,7 % en 8,66 | 99,1 % en 3,23 | 99,2 % en 3,17 | 11,9 % en 11,44 | 93,3 % en 4,40 |
| Hypocondrie aiguë | psychiatrie | 2 | 2,7 % en 9,29 | 74,6 % en 4,18 | 75,9 % en 4,28 | 4,6 % en 12,91 | 80,9 % en 4,46 | 1,7 % en 8,18 | 70,9 % en 4,56 | 59,4 % en 5,09 | 1,9 % en 12,35 | 57,9 % en 5,88 |
| Agoraphobie | psychiatrie | 2 | 4,7 % en 8,26 | 81,6 % en 3,79 | 72,2 % en 4,30 | 2,9 % en 14,31 | 72,7 % en 4,77 | 0,9 % en 9,00 | 64,6 % en 5,35 | 73,7 % en 4,53 | 0,8 % en 13,74 | 67,8 % en 5,54 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 1,6 % en 8,39 | 78,3 % en 3,85 | 75,7 % en 4,01 | 2,9 % en 15,32 | 80,0 % en 4,30 | 1,2 % en 7,17 | 68,2 % en 4,25 | 71,2 % en 4,34 | 0,9 % en 11,65 | 67,5 % en 5,05 |
| Mutisme sélectif | psychiatrie | 2 | 14,4 % en 7,92 | 71,4 % en 4,27 | 75,6 % en 3,97 | 63,3 % en 3,72 | 83,7 % en 4,52 | 16,1 % en 7,58 | 65,9 % en 4,82 | 63,9 % en 4,89 | 63,9 % en 3,91 | 54,9 % en 5,88 |
| Addiction aux écrans | psychiatrie | 1 | 1,9 % en 9,15 | 50,0 % en 5,40 | 53,7 % en 5,31 | 0,0 % en 12,18 | 36,8 % en 6,23 | 1,8 % en 8,49 | 35,6 % en 6,64 | 25,5 % en 6,68 | 0,0 % en 15,16 | 15,3 % en 7,86 |
| Syndrome de Paris | psychiatrie | 2 | 13,8 % en 7,62 | 78,2 % en 4,09 | 80,2 % en 4,38 | 20,4 % en 14,29 | 90,6 % en 4,55 | 14,0 % en 7,90 | 69,2 % en 5,22 | 67,0 % en 5,46 | 7,5 % en 12,43 | 60,3 % en 6,12 |
| Dépression légère | psychiatrie | 1 | 14,3 % en 6,64 | 79,6 % en 3,76 | 75,0 % en 4,12 | 56,3 % en 3,98 | 62,3 % en 5,42 | 20,4 % en 6,80 | 61,1 % en 5,11 | 60,7 % en 5,27 | 58,8 % en 4,18 | 63,8 % en 5,66 |
| Trouble alimentaire léger | psychiatrie | 2 | 2,7 % en 7,63 | 41,4 % en 5,68 | 44,2 % en 5,55 | 2,7 % en 13,42 | 48,1 % en 5,78 | 0,9 % en 8,24 | 24,3 % en 7,26 | 25,5 % en 7,22 | 0,9 % en 13,17 | 30,7 % en 6,89 |
| Insomnie chronique | psychiatrie | 1 | 0,0 % en 9,15 | 45,3 % en 5,57 | 50,0 % en 5,92 | 0,0 % en 15,60 | 37,3 % en 6,49 | 3,2 % en 8,79 | 29,2 % en 7,48 | 42,9 % en 6,93 | 0,0 % en 12,38 | 24,6 % en 7,90 |
| Burn-out | psychiatrie | 1 | 17,9 % en 7,54 | 81,0 % en 4,43 | 82,5 % en 3,75 | 63,6 % en 4,15 | 70,4 % en 5,06 | 9,6 % en 7,50 | 64,9 % en 5,02 | 63,0 % en 5,33 | 54,7 % en 4,94 | 66,0 % en 5,56 |
| Attaque de panique | psychiatrie | 1 | 6,3 % en 7,10 | 77,8 % en 4,04 | 78,9 % en 4,54 | 19,3 % en 12,40 | 66,1 % en 4,81 | 16,7 % en 6,90 | 65,6 % en 5,02 | 58,1 % en 5,05 | 6,7 % en 12,20 | 56,5 % en 5,39 |
| Stress post-traumatique | psychiatrie | 1 | 7,5 % en 8,40 | 67,9 % en 4,66 | 74,5 % en 4,33 | 66,0 % en 3,75 | 74,0 % en 5,32 | 16,1 % en 7,05 | 68,6 % en 4,57 | 64,2 % en 4,89 | 60,7 % en 4,16 | 35,1 % en 6,89 |
| Jalousie délirante | psychiatrie | 1 | 20,0 % en 7,27 | 80,8 % en 3,85 | 78,0 % en 4,05 | 8,2 % en 10,71 | 72,9 % en 5,39 | 15,7 % en 7,55 | 64,9 % en 4,68 | 70,9 % en 4,22 | 7,8 % en 11,53 | 47,8 % en 6,04 |
| Hallux valgus | orthopedie | 3 | 15,5 % en 7,92 | 79,8 % en 3,89 | 77,0 % en 4,25 | 11,6 % en 17,16 | 76,4 % en 4,78 | 20,8 % en 7,80 | 65,0 % en 5,13 | 64,2 % en 5,29 | 11,5 % en 17,17 | 59,9 % en 6,07 |
| Périostite tibiale | orthopedie | 2 | 16,2 % en 6,39 | 84,5 % en 3,58 | 79,5 % en 3,56 | 18,8 % en 17,54 | 75,6 % en 4,21 | 16,7 % en 7,15 | 64,7 % en 4,37 | 59,0 % en 4,77 | 14,3 % en 15,00 | 55,9 % en 5,36 |
| Contusion sévère | orthopedie | 3 | 2,2 % en 11,02 | 100,0 % en 3,00 | 100,0 % en 2,78 | 97,2 % en 3,66 | 97,2 % en 4,03 | 3,0 % en 11,37 | 99,4 % en 3,09 | 100,0 % en 2,89 | 93,5 % en 4,20 | 98,2 % en 4,52 |
| Entorse de la cheville | orthopedie | 2 | 3,4 % en 11,63 | 99,1 % en 2,96 | 94,5 % en 3,13 | 91,1 % en 3,63 | 94,3 % en 4,04 | 1,0 % en 9,75 | 94,1 % en 3,23 | 99,0 % en 3,19 | 89,8 % en 4,42 | 94,3 % en 4,06 |
| Syndrome du canal carpien | orthopedie | 2 | 19,1 % en 10,10 | 89,6 % en 3,86 | 81,7 % en 4,52 | 21,9 % en 21,44 | 82,5 % en 5,12 | 19,5 % en 10,31 | 68,3 % en 5,72 | 76,1 % en 5,50 | 19,0 % en 22,20 | 62,9 % en 6,85 |
| Lumbago | orthopedie | 3 | 14,4 % en 7,74 | 80,7 % en 3,86 | 81,3 % en 3,90 | 22,1 % en 16,27 | 77,7 % en 4,63 | 17,6 % en 7,54 | 73,7 % en 4,39 | 66,1 % en 4,99 | 14,3 % en 15,65 | 60,4 % en 5,72 |
| Fêlure du coccyx | orthopedie | 2 | 17,0 % en 7,30 | 85,6 % en 3,60 | 79,2 % en 3,93 | 17,2 % en 15,90 | 79,1 % en 4,92 | 12,6 % en 8,13 | 73,7 % en 4,86 | 60,7 % en 5,09 | 14,7 % en 14,50 | 62,6 % en 5,64 |
| Épaule gelée | orthopedie | 2 | 17,0 % en 7,60 | 89,6 % en 3,54 | 76,9 % en 4,11 | 20,2 % en 16,35 | 73,2 % en 5,09 | 11,4 % en 8,03 | 66,7 % en 5,15 | 61,5 % en 5,29 | 12,5 % en 14,89 | 62,0 % en 5,68 |
| Entorse du genou | orthopedie | 2 | 2,9 % en 9,25 | 98,4 % en 3,01 | 100,0 % en 2,99 | 89,0 % en 3,95 | 96,9 % en 4,07 | 0,8 % en 9,84 | 99,0 % en 3,26 | 99,2 % en 2,93 | 88,9 % en 4,50 | 96,3 % en 4,11 |
| Sciatique | orthopedie | 2 | 12,3 % en 6,84 | 80,4 % en 3,71 | 80,2 % en 3,63 | 25,0 % en 16,50 | 67,3 % en 4,63 | 16,2 % en 7,65 | 70,0 % en 4,47 | 72,7 % en 4,26 | 17,4 % en 17,01 | 62,9 % en 5,25 |
| Scoliose | orthopedie | 2 | 19,2 % en 8,37 | 84,5 % en 3,59 | 82,5 % en 3,58 | 12,6 % en 17,85 | 82,4 % en 4,50 | 18,1 % en 7,99 | 66,3 % en 4,82 | 64,7 % en 4,87 | 9,6 % en 16,98 | 57,3 % en 5,95 |
| Arthrose du genou | orthopedie | 1 | 14,8 % en 9,56 | 79,4 % en 3,86 | 86,2 % en 3,84 | 13,3 % en 18,20 | 79,2 % en 4,75 | 15,3 % en 8,37 | 68,2 % en 4,66 | 64,7 % en 5,16 | 8,3 % en 19,46 | 58,9 % en 5,84 |
| Ostéoporose | orthopedie | 2 | 8,6 % en 9,29 | 78,8 % en 4,44 | 74,2 % en 4,59 | 18,6 % en 19,12 | 77,5 % en 4,96 | 17,9 % en 9,60 | 63,4 % en 5,35 | 70,3 % en 5,21 | 9,5 % en 17,25 | 71,4 % en 5,96 |
| Fracture du poignet | orthopedie | 1 | 3,8 % en 9,65 | 94,6 % en 3,54 | 98,1 % en 3,21 | 93,7 % en 3,98 | 88,1 % en 4,52 | 1,9 % en 8,83 | 96,2 % en 3,79 | 93,6 % en 3,74 | 97,8 % en 4,02 | 83,6 % en 5,05 |
| Fracture fermée | orthopedie | 2 | 1,9 % en 8,51 | 99,0 % en 3,17 | 97,6 % en 3,17 | 93,9 % en 3,74 | 95,0 % en 4,40 | 2,8 % en 8,98 | 99,1 % en 3,21 | 99,0 % en 3,19 | 91,4 % en 4,29 | 95,8 % en 4,30 |
| Luxation de l'épaule | orthopedie | 1 | 2,5 % en 10,65 | 98,0 % en 3,67 | 100,0 % en 3,46 | 94,2 % en 3,37 | 90,7 % en 4,54 | 1,6 % en 9,82 | 98,3 % en 3,53 | 97,8 % en 3,54 | 91,1 % en 4,21 | 97,0 % en 4,33 |
| Hernie discale | orthopedie | 1 | 0,0 % en 6,25 | 30,9 % en 6,27 | 41,8 % en 5,78 | 0,0 % en 9,39 | 40,5 % en 6,14 | 0,0 % en 6,65 | 18,6 % en 6,97 | 8,9 % en 7,48 | 0,0 % en 10,21 | 22,6 % en 6,98 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,46 | 31,3 % en 5,73 | 26,1 % en 5,84 | 0,0 % en 9,60 | 32,0 % en 5,60 | 0,0 % en 5,78 | 10,2 % en 7,10 | 20,0 % en 6,52 | 2,0 % en 9,06 | 13,0 % en 6,83 |
| Fracture ouverte | orthopedie | 1 | 2,4 % en 6,26 | 29,8 % en 5,89 | 29,0 % en 6,01 | 1,9 % en 9,60 | 29,9 % en 6,39 | 1,9 % en 6,21 | 21,8 % en 6,73 | 7,7 % en 7,50 | 0,0 % en 9,95 | 17,0 % en 7,38 |
| Fracture du fémur | orthopedie | 1 | 0,0 % en 5,86 | 30,8 % en 5,77 | 39,1 % en 5,26 | 5,2 % en 9,07 | 22,1 % en 6,25 | 0,0 % en 5,85 | 29,0 % en 6,16 | 19,7 % en 6,34 | 1,8 % en 8,71 | 26,9 % en 6,73 |
| Main froide éternelle | paranormal | 3 | 14,6 % en 8,43 | 81,7 % en 4,01 | 83,1 % en 3,83 | 20,9 % en 16,16 | 81,0 % en 4,61 | 13,7 % en 7,04 | 60,3 % en 5,56 | 69,4 % en 4,89 | 10,4 % en 17,84 | 66,7 % en 6,02 |
| Rire des cimetières | paranormal | 2 | 7,6 % en 7,46 | 76,1 % en 3,91 | 72,1 % en 4,11 | 15,4 % en 18,35 | 75,2 % en 4,52 | 10,3 % en 6,76 | 61,0 % en 4,56 | 62,3 % en 4,68 | 7,1 % en 15,12 | 58,4 % en 5,35 |
| Doigts qui grandissent | paranormal | 3 | 21,3 % en 8,67 | 79,9 % en 4,37 | 77,7 % en 4,44 | 12,3 % en 19,85 | 71,9 % en 5,46 | 19,1 % en 8,04 | 59,7 % en 6,16 | 70,9 % en 5,65 | 12,2 % en 19,70 | 72,3 % en 5,85 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 9,41 | 98,0 % en 3,28 | 98,4 % en 2,88 | 92,1 % en 3,90 | 91,7 % en 4,18 | 3,8 % en 9,71 | 96,0 % en 3,40 | 95,5 % en 3,27 | 83,8 % en 4,03 | 92,2 % en 4,52 |
| Nez qui saigne de l'encre | paranormal | 2 | 17,4 % en 9,63 | 76,1 % en 4,80 | 81,1 % en 4,80 | 23,7 % en 21,68 | 82,1 % en 4,96 | 22,4 % en 9,20 | 74,0 % en 5,40 | 65,4 % en 6,31 | 14,9 % en 22,79 | 63,6 % en 7,02 |
| Mauvais œil | paranormal | 3 | 3,9 % en 8,87 | 98,6 % en 2,81 | 97,5 % en 2,97 | 93,2 % en 3,55 | 98,0 % en 3,89 | 3,0 % en 8,46 | 98,2 % en 2,93 | 99,4 % en 3,00 | 91,0 % en 4,19 | 96,1 % en 4,07 |
| Malédiction des miroirs | paranormal | 2 | 3,6 % en 9,46 | 98,3 % en 3,10 | 100,0 % en 2,81 | 95,2 % en 3,69 | 92,7 % en 4,05 | 0,9 % en 8,60 | 96,5 % en 3,45 | 98,1 % en 3,24 | 91,9 % en 4,29 | 93,1 % en 4,45 |
| Malédiction du chat noir | paranormal | 2 | 1,1 % en 8,36 | 99,2 % en 2,85 | 99,2 % en 2,92 | 90,8 % en 3,80 | 94,9 % en 4,14 | 4,8 % en 8,27 | 99,0 % en 3,04 | 97,3 % en 3,12 | 93,0 % en 3,89 | 90,5 % en 4,35 |
| Malédiction du nombre 7 | paranormal | 2 | 1,0 % en 9,66 | 100,0 % en 3,05 | 100,0 % en 3,15 | 86,8 % en 3,80 | 98,0 % en 4,03 | 2,4 % en 8,95 | 99,0 % en 3,04 | 99,2 % en 3,02 | 96,6 % en 4,12 | 95,4 % en 4,24 |
| Ombre qui suit | paranormal | 2 | 8,7 % en 7,20 | 78,8 % en 3,71 | 87,1 % en 3,45 | 9,1 % en 17,49 | 73,1 % en 4,77 | 11,1 % en 7,73 | 71,4 % en 4,46 | 62,5 % en 4,89 | 6,4 % en 16,17 | 68,4 % en 5,08 |
| Brûlure lunaire | paranormal | 2 | 19,6 % en 8,79 | 74,8 % en 4,25 | 82,8 % en 3,72 | 12,1 % en 19,33 | 68,3 % en 5,04 | 15,7 % en 8,23 | 66,0 % en 4,78 | 71,9 % en 4,65 | 6,8 % en 17,74 | 68,7 % en 5,68 |
| Âme en double | paranormal | 1 | 5,5 % en 8,58 | 98,0 % en 3,45 | 100,0 % en 3,33 | 85,7 % en 4,35 | 94,4 % en 4,43 | 3,3 % en 8,68 | 97,6 % en 3,24 | 96,0 % en 3,24 | 98,0 % en 4,00 | 88,9 % en 4,80 |
| Voix du passé | paranormal | 2 | 4,0 % en 10,27 | 99,1 % en 3,26 | 99,2 % en 2,97 | 94,5 % en 4,00 | 95,0 % en 4,08 | 0,8 % en 10,84 | 100,0 % en 3,08 | 99,1 % en 3,14 | 93,6 % en 4,12 | 92,6 % en 4,69 |
| Murmures dans la tête | paranormal | 1 | 2,0 % en 8,29 | 98,2 % en 3,45 | 97,8 % en 3,36 | 88,5 % en 3,75 | 92,7 % en 4,75 | 5,2 % en 9,71 | 98,1 % en 3,81 | 98,5 % en 3,54 | 94,5 % en 4,31 | 98,1 % en 4,79 |
| Poltergeist domestique | paranormal | 2 | 10,3 % en 8,15 | 82,2 % en 3,92 | 81,2 % en 3,88 | 7,1 % en 15,91 | 81,7 % en 4,58 | 15,5 % en 7,97 | 61,1 % en 5,22 | 59,8 % en 5,32 | 5,7 % en 14,47 | 65,1 % en 5,71 |
| Vampirisme aigu | paranormal | 1 | 19,2 % en 8,25 | 80,0 % en 4,20 | 81,1 % en 4,58 | 8,0 % en 16,80 | 75,4 % en 5,45 | 18,5 % en 8,33 | 58,6 % en 5,41 | 76,6 % en 5,13 | 1,8 % en 15,77 | 63,3 % en 6,18 |
| Pétrification partielle | paranormal | 1 | 17,3 % en 8,33 | 74,1 % en 4,67 | 82,8 % en 4,57 | 22,6 % en 17,17 | 73,6 % en 4,83 | 11,3 % en 8,19 | 60,0 % en 5,44 | 63,6 % en 5,24 | 6,0 % en 14,66 | 53,6 % en 6,54 |
| Possession légère | paranormal | 1 | 6,0 % en 8,70 | 96,8 % en 3,35 | 100,0 % en 3,31 | 88,5 % en 3,81 | 91,7 % en 4,23 | 2,1 % en 9,06 | 96,3 % en 3,83 | 92,2 % en 3,43 | 83,6 % en 4,51 | 88,7 % en 4,77 |
| Lycanthropie | paranormal | 1 | 17,5 % en 7,79 | 79,4 % en 4,12 | 75,0 % en 4,15 | 15,0 % en 15,22 | 73,3 % en 5,30 | 16,7 % en 7,81 | 58,9 % en 5,50 | 71,7 % en 4,98 | 2,0 % en 15,68 | 57,1 % en 6,21 |
| Glissement temporel | paranormal | 1 | 4,5 % en 7,68 | 74,5 % en 4,08 | 75,0 % en 4,75 | 8,9 % en 14,67 | 63,5 % en 5,65 | 10,9 % en 7,00 | 48,8 % en 5,49 | 64,6 % en 5,02 | 15,8 % en 14,09 | 52,9 % en 6,04 |
