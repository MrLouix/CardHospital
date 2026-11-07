# Rapport de simulation — CardHospital — paquet de base 2.2.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 1 joueur · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Analyses / patient | Analyses justes | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 7,0 % | 93,0 % | 0 | 7,57 | 3,78 | 0,00 | — | 0,66 | -0,95 | -7,17 |
| seuil:60 | Interne | 95,3 % | 4,7 % | 0 | 3,27 | 1,77 | 0,00 | — | 1,57 | 0,36 | 1,17 |
| seuil:80 | Interne | 95,6 % | 4,4 % | 0 | 3,52 | 2,50 | 0,00 | — | 1,60 | 0,39 | 1,38 |
| couleur:60 | Interne | 96,5 % | 3,5 % | 0 | 3,25 | 1,75 | 0,00 | — | 1,59 | 0,39 | 1,27 |
| couleur:80 | Interne | 97,2 % | 2,8 % | 0 | 3,44 | 2,37 | 0,00 | — | 1,63 | 0,44 | 1,52 |
| novice:70 | Interne | 29,1 % | 70,9 % | 0 | 8,19 | 4,60 | 0,00 | — | 0,90 | -0,69 | -5,66 |
| novice+labo:70 | Interne | 91,4 % | 8,6 % | 0 | 4,23 | 1,92 | 1,14 | 76,1 % | 1,18 | 0,21 | 0,87 |
| novice+labo:80 | Interne | 91,2 % | 8,8 % | 0 | 4,41 | 2,47 | 0,96 | 92,8 % | 1,24 | 0,19 | 0,85 |
| hasard | Chirurgien | 5,0 % | 95,0 % | 0 | 5,25 | 2,64 | 0,00 | — | 1,26 | -1,59 | -8,35 |
| seuil:60 | Chirurgien | 87,4 % | 12,6 % | 0 | 3,05 | 1,67 | 0,00 | — | 2,44 | 0,11 | 0,35 |
| seuil:80 | Chirurgien | 88,0 % | 12,0 % | 0 | 3,34 | 2,40 | 0,00 | — | 2,52 | 0,22 | 0,75 |
| couleur:60 | Chirurgien | 88,9 % | 11,1 % | 0 | 3,03 | 1,65 | 0,00 | — | 2,46 | 0,16 | 0,48 |
| couleur:80 | Chirurgien | 91,2 % | 8,8 % | 0 | 3,28 | 2,29 | 0,00 | — | 2,57 | 0,30 | 0,97 |
| novice:70 | Chirurgien | 26,0 % | 74,0 % | 0 | 6,26 | 3,46 | 0,00 | — | 1,74 | -1,10 | -6,86 |
| novice+labo:70 | Chirurgien | 79,1 % | 20,9 % | 0 | 3,85 | 1,80 | 1,03 | 76,6 % | 1,82 | -0,04 | -0,16 |
| novice+labo:80 | Chirurgien | 77,3 % | 22,7 % | 0 | 4,00 | 2,31 | 0,86 | 93,2 % | 1,92 | -0,05 | -0,19 |
| hasard | Réanimation | 3,9 % | 96,1 % | 0 | 4,18 | 2,08 | 0,00 | — | 1,81 | -2,29 | -9,58 |
| seuil:60 | Réanimation | 80,8 % | 19,1 % | 0 | 2,80 | 1,55 | 0,00 | — | 3,30 | -0,12 | -0,33 |
| seuil:80 | Réanimation | 80,8 % | 19,2 % | 0 | 3,12 | 2,25 | 0,00 | — | 3,39 | 0,05 | 0,15 |
| couleur:60 | Réanimation | 81,6 % | 18,4 % | 0 | 2,81 | 1,54 | 0,00 | — | 3,31 | -0,11 | -0,30 |
| couleur:80 | Réanimation | 83,8 % | 16,2 % | 0 | 3,10 | 2,19 | 0,00 | — | 3,44 | 0,11 | 0,33 |
| novice:70 | Réanimation | 23,7 % | 76,3 % | 0 | 5,31 | 2,92 | 0,00 | — | 2,56 | -1,44 | -7,67 |
| novice+labo:70 | Réanimation | 66,3 % | 33,8 % | 0 | 3,52 | 1,72 | 0,95 | 76,4 % | 2,43 | -0,36 | -1,27 |
| novice+labo:80 | Réanimation | 64,4 % | 35,6 % | 0 | 3,66 | 2,19 | 0,78 | 93,4 % | 2,57 | -0,34 | -1,25 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0), tous les jetons étant reportés sur la piste de l'hôpital. « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale moyenne | Finale C5 | Finale C50 | Finale C95 | Minimum moyen | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | -71,7 | -90 | -71 | -54 | -71,8 | -90 | -71 |
| seuil:60 | Interne | 11,7 | -1 | 13 | 20 | -1,0 | -5 | 0 |
| seuil:80 | Interne | 13,8 | 2 | 15 | 20 | -0,3 | -1 | 0 |
| couleur:60 | Interne | 12,7 | 1 | 14 | 19 | -0,7 | -4 | 0 |
| couleur:80 | Interne | 15,2 | 5 | 17 | 20 | -0,1 | -1 | 0 |
| novice:70 | Interne | -56,6 | -86 | -56 | -27 | -56,8 | -86 | -56 |
| novice+labo:70 | Interne | 8,7 | -6 | 10 | 20 | -1,4 | -8 | 0 |
| novice+labo:80 | Interne | 8,5 | -4 | 9 | 19 | -1,0 | -6 | 0 |
| hasard | Chirurgien | -83,5 | -104 | -84 | -66 | -83,5 | -104 | -84 |
| seuil:60 | Chirurgien | 3,5 | -16 | 4 | 18 | -4,5 | -18 | -2 |
| seuil:80 | Chirurgien | 7,5 | -10 | 8 | 20 | -1,8 | -12 | 0 |
| couleur:60 | Chirurgien | 4,8 | -14 | 6 | 20 | -3,8 | -16 | -2 |
| couleur:80 | Chirurgien | 9,7 | -6 | 12 | 20 | -1,3 | -8 | 0 |
| novice:70 | Chirurgien | -68,6 | -106 | -68 | -36 | -68,8 | -106 | -68 |
| novice+labo:70 | Chirurgien | -1,6 | -22 | 0 | 14 | -6,6 | -23 | -4 |
| novice+labo:80 | Chirurgien | -1,9 | -20 | 0 | 14 | -6,1 | -20 | -4 |
| hasard | Réanimation | -95,8 | -117 | -95 | -76 | -95,8 | -117 | -95 |
| seuil:60 | Réanimation | -3,3 | -27 | -2 | 17 | -9,2 | -30 | -6 |
| seuil:80 | Réanimation | 1,5 | -17 | 3 | 17 | -4,7 | -18 | -1 |
| couleur:60 | Réanimation | -3,0 | -27 | -2 | 20 | -9,3 | -29 | -6 |
| couleur:80 | Réanimation | 3,3 | -16 | 4 | 20 | -4,1 | -18 | 0 |
| novice:70 | Réanimation | -76,7 | -116 | -76 | -40 | -76,9 | -116 | -76 |
| novice+labo:70 | Réanimation | -12,7 | -36 | -11 | 6 | -15,0 | -36 | -13 |
| novice+labo:80 | Réanimation | -12,5 | -33 | -11 | 6 | -14,3 | -34 | -13 |

## Fermeture de l'hôpital selon le seuil

Part des parties où l'hôpital aurait fermé, selon l'écart entre la réputation de départ et le seuil de fermeture : la réputation passe strictement sous le seuil quand le minimum descend sous l'opposé de l'écart.

| Stratégie | Difficulté | Écart 5 | Écart 10 | Écart 15 | Écart 20 | Écart 30 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:60 | Interne | 4,6 % | 1,5 % | 0,3 % | 0,1 % | 0,0 % |
| seuil:80 | Interne | 1,5 % | 0,2 % | 0,1 % | 0,0 % | 0,0 % |
| couleur:60 | Interne | 2,5 % | 0,6 % | 0,1 % | 0,0 % | 0,0 % |
| couleur:80 | Interne | 0,5 % | 0,0 % | 0,0 % | 0,0 % | 0,0 % |
| novice:70 | Interne | 99,6 % | 99,4 % | 99,0 % | 97,6 % | 93,1 % |
| novice+labo:70 | Interne | 8,7 % | 3,4 % | 1,1 % | 0,2 % | 0,0 % |
| novice+labo:80 | Interne | 7,0 % | 1,2 % | 0,6 % | 0,1 % | 0,0 % |
| hasard | Chirurgien | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:60 | Chirurgien | 30,0 % | 14,5 % | 8,4 % | 3,4 % | 0,5 % |
| seuil:80 | Chirurgien | 13,6 % | 5,4 % | 2,5 % | 0,4 % | 0,0 % |
| couleur:60 | Chirurgien | 25,6 % | 12,5 % | 5,7 % | 2,4 % | 0,5 % |
| couleur:80 | Chirurgien | 10,4 % | 3,0 % | 0,9 % | 0,1 % | 0,0 % |
| novice:70 | Chirurgien | 100,0 % | 100,0 % | 99,9 % | 99,5 % | 97,1 % |
| novice+labo:70 | Chirurgien | 44,9 % | 24,2 % | 14,4 % | 6,3 % | 1,3 % |
| novice+labo:80 | Chirurgien | 41,5 % | 23,1 % | 15,1 % | 4,5 % | 0,6 % |
| hasard | Réanimation | 100,0 % | 100,0 % | 100,0 % | 100,0 % | 100,0 % |
| seuil:60 | Réanimation | 53,8 % | 34,2 % | 22,4 % | 13,3 % | 4,2 % |
| seuil:80 | Réanimation | 33,6 % | 16,4 % | 8,0 % | 3,2 % | 0,5 % |
| couleur:60 | Réanimation | 54,3 % | 35,5 % | 22,8 % | 13,7 % | 4,2 % |
| couleur:80 | Réanimation | 28,7 % | 15,2 % | 7,1 % | 3,1 % | 0,5 % |
| novice:70 | Réanimation | 99,9 % | 99,9 % | 99,9 % | 99,8 % | 98,3 % |
| novice+labo:70 | Réanimation | 78,0 % | 58,7 % | 43,3 % | 28,4 % | 9,3 % |
| novice+labo:80 | Réanimation | 76,7 % | 58,9 % | 41,0 % | 27,3 % | 8,2 % |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 | novice:70 | novice+labo:70 | novice+labo:80 |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 0,0 % en 6,77 | 96,0 % en 3,27 | 92,6 % en 3,66 | 96,8 % en 3,04 | 97,3 % en 3,77 | 34,7 % en 6,61 | 98,5 % en 4,54 | 92,5 % en 4,66 |
| Décalage horaire | generale | 2 | 1,0 % en 5,68 | 89,2 % en 3,02 | 93,8 % en 3,48 | 89,8 % en 2,98 | 89,5 % en 3,71 | 34,5 % en 6,08 | 97,3 % en 4,73 | 90,6 % en 4,37 |
| Maux de tête | generale | 2 | 4,0 % en 7,62 | 95,7 % en 3,68 | 97,5 % en 3,83 | 99,1 % en 3,33 | 97,3 % en 3,66 | 27,6 % en 8,20 | 99,2 % en 5,15 | 97,6 % en 5,03 |
| Rhume carabiné | generale | 2 | 0,8 % en 6,40 | 89,6 % en 3,51 | 98,3 % en 3,83 | 88,7 % en 3,31 | 96,8 % en 3,42 | 30,6 % en 7,89 | 95,8 % en 4,56 | 91,0 % en 4,90 |
| Conjonctivite | generale | 2 | 6,5 % en 7,77 | 96,3 % en 3,53 | 96,4 % en 4,01 | 98,1 % en 3,66 | 98,4 % en 3,61 | 43,5 % en 7,70 | 99,1 % en 4,64 | 97,2 % en 4,78 |
| Rage de dents | generale | 1 | 4,0 % en 7,62 | 88,2 % en 4,18 | 98,1 % en 4,70 | 90,3 % en 3,97 | 100,0 % en 4,04 | 42,4 % en 7,42 | 95,0 % en 5,27 | 92,0 % en 4,66 |
| Laryngite | generale | 2 | 4,6 % en 6,83 | 89,3 % en 3,52 | 95,8 % en 3,31 | 95,8 % en 3,35 | 96,2 % en 3,42 | 36,2 % en 6,97 | 94,4 % en 4,67 | 95,4 % en 4,27 |
| Torticolis | generale | 2 | 2,3 % en 6,73 | 96,4 % en 3,41 | 96,4 % en 3,54 | 92,7 % en 3,33 | 96,3 % en 3,50 | 32,3 % en 7,31 | 95,2 % en 4,63 | 82,4 % en 4,75 |
| Carence en vitamine D | generale | 2 | 3,3 % en 7,47 | 95,7 % en 3,14 | 95,9 % en 3,68 | 96,3 % en 3,62 | 94,9 % en 3,64 | 37,8 % en 7,89 | 98,1 % en 4,15 | 89,8 % en 4,61 |
| Fatigue chronique légère | generale | 2 | 2,1 % en 7,20 | 96,3 % en 3,43 | 93,9 % en 3,69 | 99,2 % en 3,25 | 94,9 % en 3,70 | 40,9 % en 7,56 | 95,4 % en 4,56 | 91,7 % en 4,60 |
| Otite moyenne aiguë | generale | 2 | 0,0 % en 6,34 | 95,2 % en 3,62 | 92,1 % en 3,69 | 94,9 % en 3,42 | 94,1 % en 3,64 | 45,2 % en 6,71 | 92,9 % en 4,36 | 87,0 % en 4,34 |
| Sinusite maxillaire | generale | 2 | 0,9 % en 7,23 | 97,1 % en 3,11 | 96,0 % en 3,66 | 97,3 % en 3,12 | 94,0 % en 3,55 | 41,6 % en 7,33 | 94,5 % en 4,43 | 90,9 % en 4,61 |
| Piqûre de moustique infectée | generale | 1 | 6,6 % en 7,03 | 95,3 % en 3,16 | 77,1 % en 4,48 | 94,8 % en 3,12 | 96,8 % en 3,68 | 41,8 % en 7,46 | 96,1 % en 4,51 | 87,0 % en 4,80 |
| Infection urinaire légère | generale | 2 | 1,7 % en 8,08 | 98,1 % en 3,43 | 100,0 % en 3,68 | 99,0 % en 3,68 | 97,9 % en 3,59 | 43,3 % en 7,49 | 97,9 % en 4,75 | 89,8 % en 4,96 |
| Gale | generale | 1 | 7,1 % en 6,07 | 89,1 % en 4,16 | 92,1 % en 4,21 | 91,5 % en 3,62 | 89,7 % en 4,07 | 0,0 % en 9,72 | 81,1 % en 5,74 | 91,5 % en 5,01 |
| Angine bactérienne | generale | 1 | 3,6 % en 7,50 | 96,7 % en 3,43 | 81,4 % en 4,32 | 94,8 % en 3,84 | 92,0 % en 3,62 | 34,9 % en 7,02 | 93,1 % en 4,57 | 85,7 % en 4,57 |
| Bronchite aiguë | generale | 2 | 3,7 % en 7,40 | 96,5 % en 3,57 | 92,8 % en 3,85 | 96,8 % en 3,60 | 99,1 % en 3,56 | 38,2 % en 7,39 | 94,4 % en 4,33 | 89,3 % en 4,26 |
| Gastro virale | generale | 1 | 5,8 % en 7,12 | 89,8 % en 3,83 | 96,8 % en 4,06 | 98,1 % en 3,34 | 88,3 % en 4,42 | 37,3 % en 7,18 | 96,2 % en 4,37 | 86,7 % en 5,11 |
| Hypoglycémie légère | generale | 1 | 4,2 % en 7,48 | 97,9 % en 3,73 | 96,7 % en 3,95 | 96,9 % en 3,95 | 94,0 % en 3,64 | 46,0 % en 7,86 | 92,5 % en 4,55 | 84,6 % en 4,92 |
| Intoxication alimentaire | generale | 1 | 2,9 % en 6,97 | 82,4 % en 4,12 | 88,0 % en 4,10 | 96,4 % en 3,13 | 97,7 % en 4,09 | 34,1 % en 7,52 | 80,6 % en 5,34 | 86,5 % en 4,79 |
| Varicelle | generale | 1 | 2,0 % en 6,41 | 85,5 % en 4,02 | 81,7 % en 4,37 | 89,1 % en 3,93 | 96,3 % en 3,65 | 0,0 % en 9,68 | 92,0 % en 4,66 | 77,9 % en 5,01 |
| Fièvre inexpliquée | generale | 1 | 0,0 % en 7,37 | 94,6 % en 3,38 | 91,1 % en 3,91 | 92,3 % en 3,87 | 95,4 % en 3,82 | 39,3 % en 7,77 | 94,5 % en 4,96 | 79,1 % en 5,09 |
| Rougeole | generale | 1 | 6,8 % en 6,41 | 82,0 % en 3,74 | 81,8 % en 4,05 | 80,0 % en 3,73 | 86,4 % en 4,12 | 0,0 % en 9,18 | 86,9 % en 4,92 | 89,6 % en 4,60 |
| Varices | cardiologie | 3 | 13,2 % en 6,64 | 96,3 % en 2,85 | 98,9 % en 3,20 | 94,7 % en 2,95 | 100,0 % en 3,05 | 0,0 % en 10,04 | 96,2 % en 3,96 | 96,9 % en 4,05 |
| Extrasystoles | cardiologie | 2 | 4,4 % en 6,11 | 91,7 % en 3,07 | 98,2 % en 3,19 | 93,7 % en 3,39 | 93,9 % en 3,30 | 63,8 % en 4,78 | 82,8 % en 4,06 | 88,9 % en 4,19 |
| Souffle au cœur | cardiologie | 3 | 8,0 % en 8,14 | 95,7 % en 3,31 | 97,9 % en 3,33 | 98,0 % en 3,08 | 100,0 % en 3,14 | 1,2 % en 10,74 | 94,7 % en 3,89 | 95,5 % en 4,34 |
| Hypotension orthostatique | cardiologie | 2 | 2,5 % en 6,96 | 98,3 % en 3,25 | 96,9 % en 3,26 | 96,2 % en 3,27 | 94,6 % en 3,54 | 74,8 % en 4,86 | 82,0 % en 4,10 | 93,9 % en 4,23 |
| Syndrome du cœur brisé | cardiologie | 2 | 1,9 % en 9,28 | 99,0 % en 3,01 | 99,0 % en 3,43 | 97,6 % en 3,20 | 100,0 % en 3,37 | 74,8 % en 5,99 | 96,9 % en 4,16 | 94,5 % en 4,71 |
| Hypertension artérielle | cardiologie | 3 | 3,4 % en 7,36 | 96,0 % en 3,18 | 99,4 % en 3,19 | 98,9 % en 2,88 | 98,9 % en 3,23 | 69,2 % en 5,19 | 90,6 % en 4,02 | 91,1 % en 4,11 |
| Bradycardie | cardiologie | 2 | 0,7 % en 7,78 | 93,6 % en 3,06 | 96,0 % en 3,22 | 97,3 % en 3,49 | 99,0 % en 3,07 | 70,4 % en 4,84 | 88,1 % en 3,94 | 94,3 % en 4,10 |
| Tachycardie | cardiologie | 2 | 3,6 % en 8,41 | 94,7 % en 3,53 | 97,2 % en 3,50 | 97,1 % en 3,11 | 96,0 % en 3,50 | 73,0 % en 5,58 | 82,3 % en 4,42 | 93,2 % en 4,46 |
| Phlébite | cardiologie | 2 | 13,5 % en 7,21 | 97,3 % en 3,05 | 98,0 % en 3,39 | 97,1 % en 3,29 | 96,9 % en 3,41 | 0,0 % en 10,49 | 91,1 % en 4,07 | 93,6 % en 4,12 |
| Angor | cardiologie | 2 | 11,5 % en 6,82 | 97,4 % en 2,95 | 94,8 % en 3,33 | 96,3 % en 3,15 | 94,9 % en 3,47 | 1,0 % en 9,72 | 82,5 % en 4,13 | 94,1 % en 3,97 |
| Péricardite | cardiologie | 2 | 14,2 % en 6,81 | 96,3 % en 2,91 | 96,5 % en 3,25 | 95,6 % en 3,11 | 95,4 % en 3,31 | 0,0 % en 11,17 | 83,9 % en 3,99 | 90,9 % en 4,55 |
| Arythmie | cardiologie | 1 | 2,0 % en 8,10 | 98,0 % en 3,32 | 86,0 % en 3,93 | 92,7 % en 3,85 | 96,8 % en 3,73 | 61,7 % en 6,47 | 81,0 % en 4,53 | 85,5 % en 4,58 |
| Fibrillation auriculaire | cardiologie | 2 | 0,9 % en 9,22 | 94,6 % en 3,50 | 99,0 % en 3,31 | 98,2 % en 3,13 | 98,2 % en 3,34 | 67,6 % en 5,81 | 92,2 % en 3,87 | 96,5 % en 4,30 |
| Insuffisance cardiaque | cardiologie | 1 | 11,7 % en 7,52 | 96,2 % en 2,96 | 88,6 % en 3,89 | 98,1 % en 3,33 | 90,7 % en 3,56 | 0,0 % en 10,55 | 87,1 % en 4,47 | 84,2 % en 4,70 |
| Endocardite | cardiologie | 2 | 11,0 % en 7,32 | 97,1 % en 3,44 | 97,8 % en 3,18 | 99,1 % en 3,17 | 97,4 % en 3,37 | 0,0 % en 9,97 | 91,5 % en 4,08 | 86,7 % en 4,45 |
| Cardiomyopathie | cardiologie | 1 | 10,2 % en 8,02 | 96,4 % en 3,68 | 95,0 % en 3,70 | 96,7 % en 3,43 | 95,2 % en 3,95 | 0,0 % en 10,00 | 92,1 % en 4,84 | 86,2 % en 4,88 |
| Rejet de greffe cardiaque | cardiologie | 1 | 18,2 % en 7,60 | 94,8 % en 3,19 | 94,9 % en 3,58 | 93,0 % en 3,42 | 100,0 % en 3,07 | 1,6 % en 10,59 | 81,3 % en 4,61 | 78,8 % en 4,56 |
| Œdème aigu du poumon | cardiologie | 1 | 10,5 % en 7,30 | 88,6 % en 3,55 | 84,4 % en 3,91 | 86,0 % en 3,90 | 96,3 % en 4,07 | 0,0 % en 10,20 | 84,7 % en 4,34 | 77,1 % en 4,67 |
| Infarctus du myocarde | cardiologie | 1 | 15,9 % en 7,43 | 95,1 % en 3,67 | 94,9 % en 3,75 | 97,6 % en 3,62 | 92,0 % en 3,94 | 0,0 % en 9,70 | 85,1 % en 4,40 | 82,1 % en 4,57 |
| Embolie pulmonaire | cardiologie | 1 | 3,0 % en 7,43 | 94,4 % en 3,37 | 94,1 % en 3,67 | 89,1 % en 3,83 | 94,2 % en 3,35 | 0,0 % en 9,68 | 77,6 % en 4,49 | 79,7 % en 4,38 |
| Tics nerveux | psychiatrie | 3 | 15,4 % en 6,47 | 98,3 % en 3,12 | 98,8 % en 3,22 | 98,2 % en 3,04 | 97,9 % en 3,14 | 2,9 % en 10,23 | 91,1 % en 4,17 | 93,7 % en 4,15 |
| Phobie des escaliers | psychiatrie | 2 | 0,0 % en 5,81 | 92,7 % en 3,04 | 88,0 % en 3,86 | 91,5 % en 3,25 | 98,1 % en 3,34 | 1,9 % en 9,71 | 83,6 % en 3,99 | 92,6 % en 4,05 |
| Dépendance à la caféine | psychiatrie | 3 | 1,3 % en 8,36 | 97,9 % en 2,87 | 98,8 % en 3,28 | 98,9 % en 3,21 | 99,4 % en 3,13 | 0,0 % en 11,01 | 94,0 % en 4,13 | 97,3 % en 4,29 |
| Somnambulisme | psychiatrie | 2 | 2,0 % en 6,97 | 96,8 % en 3,20 | 98,4 % en 3,30 | 97,2 % en 3,17 | 97,6 % en 3,45 | 0,0 % en 11,17 | 93,7 % en 4,11 | 93,5 % en 4,04 |
| Cauchemars répétés | psychiatrie | 2 | 3,2 % en 9,33 | 93,9 % en 3,39 | 100,0 % en 3,61 | 99,1 % en 3,17 | 99,0 % en 3,71 | 0,9 % en 11,41 | 97,1 % en 4,25 | 100,0 % en 4,16 |
| Phobie des blouses blanches | psychiatrie | 3 | 15,2 % en 6,52 | 96,8 % en 3,03 | 97,6 % en 3,33 | 98,0 % en 3,07 | 99,4 % en 3,41 | 92,3 % en 2,68 | 92,7 % en 3,89 | 94,4 % en 4,19 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 0,0 % en 7,58 | 92,2 % en 3,75 | 92,9 % en 3,61 | 97,5 % en 2,95 | 98,4 % en 3,18 | 3,2 % en 10,02 | 89,7 % en 4,47 | 88,5 % en 4,49 |
| Hypocondrie aiguë | psychiatrie | 2 | 3,8 % en 8,14 | 98,1 % en 3,44 | 95,5 % en 3,24 | 98,3 % en 2,97 | 97,7 % en 3,26 | 3,7 % en 10,60 | 92,9 % en 4,25 | 84,8 % en 4,65 |
| Agoraphobie | psychiatrie | 2 | 2,8 % en 8,45 | 95,9 % en 3,41 | 97,5 % en 3,24 | 99,1 % en 3,10 | 98,2 % en 3,35 | 0,9 % en 10,43 | 91,2 % en 4,19 | 86,7 % en 4,47 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 7,1 % en 7,30 | 93,4 % en 3,31 | 96,7 % en 3,40 | 89,5 % en 3,24 | 96,0 % en 3,34 | 0,0 % en 9,44 | 93,4 % en 4,02 | 90,9 % en 4,26 |
| Mutisme sélectif | psychiatrie | 2 | 11,7 % en 7,54 | 95,7 % en 3,39 | 97,3 % en 3,27 | 96,3 % en 3,39 | 97,6 % en 3,30 | 95,1 % en 2,86 | 89,8 % en 4,08 | 92,8 % en 4,22 |
| Addiction aux écrans | psychiatrie | 1 | 1,6 % en 8,10 | 98,0 % en 2,86 | 96,7 % en 3,48 | 93,0 % en 3,42 | 100,0 % en 3,63 | 0,0 % en 10,34 | 92,3 % en 4,06 | 88,7 % en 4,60 |
| Syndrome de Paris | psychiatrie | 2 | 10,1 % en 8,32 | 95,6 % en 3,37 | 97,2 % en 3,24 | 97,4 % en 3,48 | 100,0 % en 3,53 | 4,5 % en 11,00 | 91,1 % en 4,27 | 92,4 % en 4,48 |
| Dépression légère | psychiatrie | 1 | 8,8 % en 7,30 | 97,1 % en 3,10 | 86,0 % en 3,90 | 93,2 % en 3,32 | 96,5 % en 3,60 | 95,8 % en 2,73 | 85,7 % en 4,71 | 84,4 % en 4,76 |
| Trouble alimentaire léger | psychiatrie | 2 | 0,8 % en 7,88 | 96,2 % en 3,31 | 96,3 % en 3,44 | 98,3 % en 2,98 | 99,0 % en 3,38 | 0,0 % en 9,78 | 87,5 % en 4,10 | 89,7 % en 4,29 |
| Insomnie chronique | psychiatrie | 1 | 0,0 % en 7,98 | 91,4 % en 3,17 | 91,9 % en 3,95 | 98,0 % en 3,84 | 96,1 % en 3,76 | 0,0 % en 10,46 | 96,9 % en 3,95 | 85,7 % en 4,96 |
| Burn-out | psychiatrie | 1 | 22,7 % en 7,33 | 94,3 % en 3,79 | 96,4 % en 4,04 | 95,3 % en 3,33 | 100,0 % en 3,65 | 88,1 % en 3,55 | 86,9 % en 4,59 | 100,0 % en 4,40 |
| Attaque de panique | psychiatrie | 1 | 11,8 % en 7,46 | 96,4 % en 3,30 | 85,4 % en 4,19 | 95,7 % en 3,26 | 95,2 % en 3,71 | 3,6 % en 10,07 | 83,0 % en 3,94 | 87,5 % en 4,16 |
| Stress post-traumatique | psychiatrie | 1 | 13,6 % en 7,30 | 91,5 % en 3,66 | 96,8 % en 3,81 | 95,5 % en 3,52 | 94,1 % en 3,65 | 96,3 % en 2,89 | 86,7 % en 4,17 | 87,3 % en 4,43 |
| Jalousie délirante | psychiatrie | 1 | 18,6 % en 7,07 | 87,9 % en 3,59 | 92,1 % en 3,49 | 91,3 % en 3,65 | 98,5 % en 2,95 | 7,4 % en 9,30 | 83,3 % en 4,35 | 87,2 % en 4,32 |
| Hallux valgus | orthopedie | 3 | 14,6 % en 7,33 | 98,1 % en 2,88 | 98,1 % en 3,34 | 98,3 % en 2,92 | 99,4 % en 3,13 | 4,3 % en 10,16 | 92,0 % en 4,08 | 94,9 % en 4,32 |
| Périostite tibiale | orthopedie | 2 | 12,4 % en 6,68 | 94,3 % en 2,99 | 95,9 % en 3,11 | 95,9 % en 3,15 | 98,9 % en 3,28 | 8,1 % en 8,90 | 80,7 % en 3,97 | 85,3 % en 4,25 |
| Contusion sévère | orthopedie | 3 | 1,2 % en 9,23 | 95,8 % en 3,32 | 99,4 % en 3,20 | 100,0 % en 3,29 | 98,9 % en 3,22 | 79,8 % en 4,90 | 94,5 % en 4,19 | 96,1 % en 4,06 |
| Entorse de la cheville | orthopedie | 2 | 1,9 % en 7,88 | 91,3 % en 3,37 | 97,0 % en 3,56 | 96,7 % en 3,07 | 94,1 % en 3,49 | 79,4 % en 4,58 | 88,9 % en 4,04 | 89,3 % en 4,47 |
| Syndrome du canal carpien | orthopedie | 2 | 16,4 % en 9,51 | 100,0 % en 3,22 | 98,3 % en 3,52 | 99,1 % en 3,20 | 100,0 % en 3,40 | 5,0 % en 13,03 | 97,9 % en 4,19 | 97,5 % en 4,50 |
| Lumbago | orthopedie | 3 | 10,1 % en 7,53 | 99,4 % en 2,74 | 96,4 % en 3,32 | 98,4 % en 2,97 | 98,8 % en 3,22 | 7,7 % en 9,37 | 90,8 % en 4,02 | 94,6 % en 4,20 |
| Fêlure du coccyx | orthopedie | 2 | 16,0 % en 7,37 | 99,0 % en 3,11 | 94,6 % en 3,48 | 98,3 % en 2,86 | 98,2 % en 3,35 | 11,7 % en 9,14 | 94,4 % en 3,79 | 92,5 % en 4,35 |
| Épaule gelée | orthopedie | 2 | 16,3 % en 7,60 | 100,0 % en 2,99 | 95,2 % en 3,52 | 97,5 % en 3,29 | 99,1 % en 3,29 | 6,1 % en 9,68 | 91,9 % en 4,34 | 92,6 % en 4,30 |
| Entorse du genou | orthopedie | 2 | 0,0 % en 8,73 | 96,3 % en 3,16 | 94,0 % en 3,91 | 98,1 % en 3,18 | 97,6 % en 3,45 | 78,1 % en 4,76 | 92,2 % en 4,08 | 95,5 % en 4,11 |
| Sciatique | orthopedie | 2 | 13,3 % en 7,09 | 97,4 % en 2,79 | 93,1 % en 3,47 | 96,1 % en 3,12 | 99,2 % en 3,14 | 10,8 % en 9,46 | 85,3 % en 4,01 | 88,0 % en 4,32 |
| Scoliose | orthopedie | 2 | 20,0 % en 7,50 | 94,5 % en 3,34 | 93,7 % en 3,50 | 98,9 % en 2,99 | 97,1 % en 3,64 | 2,6 % en 10,95 | 91,5 % en 4,01 | 94,4 % en 4,15 |
| Arthrose du genou | orthopedie | 1 | 11,3 % en 7,77 | 96,2 % en 3,55 | 93,5 % en 3,76 | 92,6 % en 3,44 | 96,1 % en 3,51 | 3,8 % en 10,68 | 91,7 % en 4,40 | 86,3 % en 4,51 |
| Ostéoporose | orthopedie | 2 | 17,3 % en 8,88 | 98,3 % en 3,25 | 96,8 % en 3,66 | 99,2 % en 3,22 | 100,0 % en 3,38 | 2,5 % en 11,75 | 93,3 % en 4,21 | 94,6 % en 4,41 |
| Fracture du poignet | orthopedie | 1 | 11,3 % en 8,06 | 95,1 % en 3,36 | 94,8 % en 3,76 | 96,7 % en 3,75 | 96,1 % en 3,24 | 72,9 % en 4,49 | 92,5 % en 4,33 | 87,5 % en 5,19 |
| Fracture fermée | orthopedie | 2 | 1,7 % en 8,70 | 94,7 % en 3,18 | 95,2 % en 3,36 | 96,0 % en 3,46 | 99,1 % en 2,95 | 70,6 % en 5,21 | 92,7 % en 3,90 | 89,2 % en 4,37 |
| Luxation de l'épaule | orthopedie | 1 | 0,0 % en 9,05 | 96,5 % en 3,74 | 92,2 % en 3,75 | 96,0 % en 4,40 | 88,2 % en 4,49 | 68,4 % en 4,88 | 88,5 % en 4,51 | 92,9 % en 4,45 |
| Hernie discale | orthopedie | 1 | 1,8 % en 6,25 | 93,9 % en 3,49 | 88,9 % en 3,95 | 95,6 % en 3,20 | 94,6 % en 3,80 | 4,8 % en 10,43 | 83,3 % en 4,47 | 88,4 % en 4,35 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,58 | 94,7 % en 2,88 | 91,8 % en 3,95 | 84,3 % en 3,43 | 93,3 % en 3,48 | 1,5 % en 9,36 | 86,8 % en 4,13 | 85,7 % en 4,61 |
| Fracture ouverte | orthopedie | 1 | 4,0 % en 6,24 | 86,2 % en 3,32 | 94,9 % en 3,56 | 91,5 % en 3,19 | 98,5 % en 3,50 | 5,4 % en 9,84 | 82,7 % en 4,35 | 83,8 % en 4,63 |
| Fracture du fémur | orthopedie | 1 | 2,0 % en 5,92 | 90,2 % en 3,21 | 91,8 % en 3,60 | 93,2 % en 3,18 | 96,7 % en 3,48 | 0,0 % en 9,61 | 80,9 % en 4,51 | 82,5 % en 4,57 |
| Main froide éternelle | paranormal | 3 | 12,7 % en 7,03 | 95,9 % en 3,09 | 98,2 % en 3,07 | 98,8 % en 2,83 | 99,4 % en 3,35 | 0,7 % en 9,81 | 94,3 % en 3,97 | 94,5 % en 4,33 |
| Rire des cimetières | paranormal | 2 | 8,6 % en 5,74 | 93,9 % en 3,06 | 94,8 % en 3,32 | 96,0 % en 3,04 | 97,2 % en 3,32 | 1,6 % en 8,94 | 89,1 % en 3,83 | 87,1 % en 4,33 |
| Doigts qui grandissent | paranormal | 3 | 14,7 % en 8,04 | 98,6 % en 3,16 | 98,9 % en 3,26 | 97,1 % en 3,10 | 99,4 % en 3,20 | 2,3 % en 11,03 | 97,4 % en 3,78 | 98,1 % en 3,96 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 7,79 | 94,9 % en 3,01 | 98,2 % en 3,43 | 95,5 % en 2,88 | 96,2 % en 3,47 | 72,3 % en 4,66 | 90,2 % en 3,99 | 97,5 % en 4,21 |
| Nez qui saigne de l'encre | paranormal | 2 | 13,1 % en 9,11 | 96,9 % en 3,22 | 100,0 % en 3,03 | 98,3 % en 3,27 | 100,0 % en 3,43 | 0,8 % en 11,88 | 98,1 % en 4,10 | 97,2 % en 4,35 |
| Mauvais œil | paranormal | 3 | 0,0 % en 8,15 | 96,0 % en 2,92 | 97,0 % en 3,34 | 98,2 % en 2,99 | 97,1 % en 3,43 | 75,3 % en 4,51 | 93,8 % en 3,95 | 92,3 % en 3,92 |
| Malédiction des miroirs | paranormal | 2 | 1,9 % en 8,09 | 95,8 % en 3,12 | 97,3 % en 2,96 | 98,1 % en 3,26 | 100,0 % en 3,13 | 82,8 % en 4,13 | 90,9 % en 4,06 | 93,2 % en 4,05 |
| Malédiction du chat noir | paranormal | 2 | 0,8 % en 8,68 | 95,0 % en 3,12 | 96,3 % en 3,49 | 99,0 % en 2,98 | 99,2 % en 3,27 | 73,6 % en 4,75 | 92,5 % en 4,30 | 94,2 % en 4,41 |
| Malédiction du nombre 7 | paranormal | 2 | 2,6 % en 8,55 | 97,4 % en 3,06 | 97,3 % en 3,39 | 97,5 % en 3,20 | 100,0 % en 3,12 | 73,0 % en 4,77 | 91,8 % en 4,11 | 89,6 % en 4,64 |
| Ombre qui suit | paranormal | 2 | 7,9 % en 6,88 | 94,1 % en 3,60 | 91,1 % en 3,63 | 97,5 % en 2,93 | 94,9 % en 3,37 | 1,6 % en 9,34 | 89,4 % en 4,15 | 87,9 % en 4,21 |
| Brûlure lunaire | paranormal | 2 | 9,2 % en 7,93 | 95,2 % en 3,43 | 96,6 % en 3,41 | 100,0 % en 2,95 | 97,1 % en 3,56 | 3,3 % en 9,93 | 96,1 % en 3,87 | 90,7 % en 4,62 |
| Âme en double | paranormal | 1 | 2,0 % en 8,31 | 91,3 % en 3,55 | 97,8 % en 3,27 | 89,5 % en 3,72 | 91,7 % en 3,94 | 72,0 % en 4,94 | 91,4 % en 4,22 | 88,0 % en 4,64 |
| Voix du passé | paranormal | 2 | 1,0 % en 9,60 | 95,8 % en 3,37 | 99,2 % en 3,57 | 100,0 % en 2,90 | 97,3 % en 3,50 | 75,2 % en 5,62 | 93,7 % en 4,22 | 95,9 % en 4,49 |
| Murmures dans la tête | paranormal | 1 | 3,4 % en 8,50 | 92,5 % en 3,02 | 91,4 % en 4,01 | 96,2 % en 3,64 | 98,6 % en 3,49 | 74,2 % en 5,42 | 93,1 % en 4,07 | 87,5 % en 4,53 |
| Poltergeist domestique | paranormal | 2 | 16,8 % en 8,04 | 100,0 % en 3,36 | 97,3 % en 3,44 | 100,0 % en 3,52 | 97,9 % en 3,36 | 2,7 % en 9,80 | 92,8 % en 3,88 | 93,4 % en 4,30 |
| Vampirisme aigu | paranormal | 1 | 17,9 % en 7,86 | 98,1 % en 3,07 | 92,5 % en 3,84 | 98,6 % en 3,45 | 97,8 % en 3,47 | 2,1 % en 10,25 | 86,8 % en 4,49 | 91,7 % en 4,67 |
| Pétrification partielle | paranormal | 1 | 13,0 % en 8,00 | 94,7 % en 3,25 | 94,7 % en 3,19 | 100,0 % en 3,39 | 98,2 % en 3,45 | 0,0 % en 10,54 | 85,4 % en 4,60 | 82,5 % en 4,98 |
| Possession légère | paranormal | 1 | 3,1 % en 8,36 | 97,1 % en 3,71 | 93,7 % en 3,84 | 92,7 % en 3,62 | 93,9 % en 3,67 | 61,7 % en 4,95 | 94,8 % en 4,19 | 88,5 % en 4,11 |
| Lycanthropie | paranormal | 1 | 12,5 % en 8,02 | 95,7 % en 3,60 | 98,4 % en 3,87 | 98,3 % en 3,73 | 93,2 % en 3,69 | 0,0 % en 10,35 | 83,3 % en 4,56 | 86,7 % en 4,68 |
| Glissement temporel | paranormal | 1 | 17,9 % en 7,25 | 93,3 % en 3,53 | 90,6 % en 4,00 | 96,4 % en 3,75 | 92,6 % en 3,87 | 1,7 % en 9,13 | 88,9 % en 4,67 | 84,7 % en 4,37 |
