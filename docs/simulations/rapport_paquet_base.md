# Rapport de simulation — CardHospital — paquet de base 2.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 1 joueur · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Analyses / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 7,0 % | 93,0 % | 0 | 7,57 | 3,78 | 0,00 | 0,66 | -0,95 | -7,17 |
| seuil:60 | Interne | 95,3 % | 4,7 % | 0 | 3,27 | 1,77 | 0,00 | 1,57 | 0,36 | 1,17 |
| seuil:80 | Interne | 95,6 % | 4,4 % | 0 | 3,52 | 2,50 | 0,00 | 1,60 | 0,39 | 1,38 |
| couleur:60 | Interne | 96,5 % | 3,5 % | 0 | 3,25 | 1,75 | 0,00 | 1,59 | 0,39 | 1,27 |
| couleur:80 | Interne | 97,2 % | 2,8 % | 0 | 3,44 | 2,37 | 0,00 | 1,63 | 0,44 | 1,52 |
| novice:70 | Interne | 30,0 % | 70,0 % | 0 | 8,09 | 4,52 | 0,00 | 0,90 | -0,69 | -5,54 |
| novice+labo:70 | Interne | 88,8 % | 11,2 % | 0 | 4,26 | 1,84 | 1,08 | 1,15 | 0,14 | 0,58 |
| hasard | Chirurgien | 5,0 % | 95,0 % | 0 | 5,25 | 2,64 | 0,00 | 1,26 | -1,59 | -8,35 |
| seuil:60 | Chirurgien | 87,4 % | 12,6 % | 0 | 3,05 | 1,67 | 0,00 | 2,44 | 0,11 | 0,35 |
| seuil:80 | Chirurgien | 88,0 % | 12,0 % | 0 | 3,34 | 2,40 | 0,00 | 2,52 | 0,22 | 0,75 |
| couleur:60 | Chirurgien | 88,9 % | 11,1 % | 0 | 3,03 | 1,65 | 0,00 | 2,46 | 0,16 | 0,48 |
| couleur:80 | Chirurgien | 91,2 % | 8,8 % | 0 | 3,28 | 2,29 | 0,00 | 2,57 | 0,30 | 0,97 |
| novice:70 | Chirurgien | 26,6 % | 73,4 % | 0 | 6,25 | 3,44 | 0,00 | 1,74 | -1,10 | -6,89 |
| novice+labo:70 | Chirurgien | 78,1 % | 21,9 % | 0 | 3,90 | 1,75 | 0,99 | 1,81 | -0,13 | -0,50 |
| hasard | Réanimation | 3,9 % | 96,1 % | 0 | 4,18 | 2,08 | 0,00 | 1,81 | -2,29 | -9,58 |
| seuil:60 | Réanimation | 80,8 % | 19,1 % | 0 | 2,80 | 1,55 | 0,00 | 3,30 | -0,12 | -0,33 |
| seuil:80 | Réanimation | 80,8 % | 19,2 % | 0 | 3,12 | 2,25 | 0,00 | 3,39 | 0,05 | 0,15 |
| couleur:60 | Réanimation | 81,6 % | 18,4 % | 0 | 2,81 | 1,54 | 0,00 | 3,31 | -0,11 | -0,30 |
| couleur:80 | Réanimation | 83,8 % | 16,2 % | 0 | 3,10 | 2,19 | 0,00 | 3,44 | 0,11 | 0,33 |
| novice:70 | Réanimation | 23,3 % | 76,7 % | 0 | 5,39 | 2,96 | 0,00 | 2,57 | -1,44 | -7,77 |
| novice+labo:70 | Réanimation | 66,6 % | 33,4 % | 0 | 3,54 | 1,66 | 0,93 | 2,43 | -0,42 | -1,48 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -90 | -71 | -54 | -90 | -71 |
| seuil:60 | Interne | -1 | 13 | 20 | -5 | 0 |
| seuil:80 | Interne | 2 | 15 | 20 | -1 | 0 |
| couleur:60 | Interne | 1 | 14 | 19 | -4 | 0 |
| couleur:80 | Interne | 5 | 17 | 20 | -1 | 0 |
| novice:70 | Interne | -83 | -55 | -28 | -83 | -56 |
| novice+labo:70 | Interne | -10 | 6 | 19 | -12 | 0 |
| hasard | Chirurgien | -104 | -84 | -66 | -104 | -84 |
| seuil:60 | Chirurgien | -16 | 4 | 18 | -18 | -2 |
| seuil:80 | Chirurgien | -10 | 8 | 20 | -12 | 0 |
| couleur:60 | Chirurgien | -14 | 6 | 20 | -16 | -2 |
| couleur:80 | Chirurgien | -6 | 12 | 20 | -8 | 0 |
| novice:70 | Chirurgien | -104 | -68 | -36 | -104 | -68 |
| novice+labo:70 | Chirurgien | -28 | -4 | 14 | -30 | -8 |
| hasard | Réanimation | -117 | -95 | -76 | -117 | -95 |
| seuil:60 | Réanimation | -27 | -2 | 17 | -30 | -6 |
| seuil:80 | Réanimation | -17 | 3 | 17 | -18 | -1 |
| couleur:60 | Réanimation | -27 | -2 | 20 | -29 | -6 |
| couleur:80 | Réanimation | -16 | 4 | 20 | -18 | 0 |
| novice:70 | Réanimation | -118 | -76 | -42 | -118 | -76 |
| novice+labo:70 | Réanimation | -41 | -14 | 7 | -43 | -16 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 | novice:70 | novice+labo:70 |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 0,0 % en 6,77 | 96,0 % en 3,27 | 92,6 % en 3,66 | 96,8 % en 3,04 | 97,3 % en 3,77 | 40,4 % en 7,57 | 96,7 % en 4,33 |
| Décalage horaire | generale | 2 | 1,0 % en 5,68 | 89,2 % en 3,02 | 93,8 % en 3,48 | 89,8 % en 2,98 | 89,5 % en 3,71 | 27,8 % en 6,58 | 90,2 % en 4,67 |
| Maux de tête | generale | 2 | 4,0 % en 7,62 | 95,7 % en 3,68 | 97,5 % en 3,83 | 99,1 % en 3,33 | 97,3 % en 3,66 | 38,6 % en 7,79 | 97,2 % en 5,16 |
| Rhume carabiné | generale | 2 | 0,8 % en 6,40 | 89,6 % en 3,51 | 98,3 % en 3,83 | 88,7 % en 3,31 | 96,8 % en 3,42 | 33,9 % en 7,04 | 95,6 % en 4,48 |
| Conjonctivite | generale | 2 | 6,5 % en 7,77 | 96,3 % en 3,53 | 96,4 % en 4,01 | 98,1 % en 3,66 | 98,4 % en 3,61 | 42,4 % en 7,97 | 99,1 % en 4,93 |
| Rage de dents | generale | 1 | 4,0 % en 7,62 | 88,2 % en 4,18 | 98,1 % en 4,70 | 90,3 % en 3,97 | 100,0 % en 4,04 | 54,9 % en 7,59 | 98,2 % en 6,13 |
| Laryngite | generale | 2 | 4,6 % en 6,83 | 89,3 % en 3,52 | 95,8 % en 3,31 | 95,8 % en 3,35 | 96,2 % en 3,42 | 41,9 % en 6,56 | 94,4 % en 5,04 |
| Torticolis | generale | 2 | 2,3 % en 6,73 | 96,4 % en 3,41 | 96,4 % en 3,54 | 92,7 % en 3,33 | 96,3 % en 3,50 | 33,3 % en 6,94 | 92,2 % en 4,70 |
| Carence en vitamine D | generale | 2 | 3,3 % en 7,47 | 95,7 % en 3,14 | 95,9 % en 3,68 | 96,3 % en 3,62 | 94,9 % en 3,64 | 33,3 % en 7,55 | 96,5 % en 4,34 |
| Fatigue chronique légère | generale | 2 | 2,1 % en 7,20 | 96,3 % en 3,43 | 93,9 % en 3,69 | 99,2 % en 3,25 | 94,9 % en 3,70 | 41,0 % en 7,54 | 98,2 % en 4,53 |
| Otite moyenne aiguë | generale | 2 | 0,0 % en 6,34 | 95,2 % en 3,62 | 92,1 % en 3,69 | 94,9 % en 3,42 | 94,1 % en 3,64 | 41,5 % en 6,68 | 92,7 % en 4,54 |
| Sinusite maxillaire | generale | 2 | 0,9 % en 7,23 | 97,1 % en 3,11 | 96,0 % en 3,66 | 97,3 % en 3,12 | 94,0 % en 3,55 | 36,1 % en 7,46 | 94,9 % en 4,62 |
| Piqûre de moustique infectée | generale | 1 | 6,6 % en 7,03 | 95,3 % en 3,16 | 77,1 % en 4,48 | 94,8 % en 3,12 | 96,8 % en 3,68 | 38,3 % en 8,08 | 82,5 % en 5,70 |
| Infection urinaire légère | generale | 2 | 1,7 % en 8,08 | 98,1 % en 3,43 | 100,0 % en 3,68 | 99,0 % en 3,68 | 97,9 % en 3,59 | 32,0 % en 8,30 | 99,1 % en 4,60 |
| Gale | generale | 1 | 7,1 % en 6,07 | 89,1 % en 4,16 | 92,1 % en 4,21 | 91,5 % en 3,62 | 89,7 % en 4,07 | 0,0 % en 10,19 | 91,3 % en 5,13 |
| Angine bactérienne | generale | 1 | 3,6 % en 7,50 | 96,7 % en 3,43 | 81,4 % en 4,32 | 94,8 % en 3,84 | 92,0 % en 3,62 | 48,3 % en 6,68 | 90,7 % en 4,70 |
| Bronchite aiguë | generale | 2 | 3,7 % en 7,40 | 96,5 % en 3,57 | 92,8 % en 3,85 | 96,8 % en 3,60 | 99,1 % en 3,56 | 33,3 % en 7,47 | 97,1 % en 4,49 |
| Gastro virale | generale | 1 | 5,8 % en 7,12 | 89,8 % en 3,83 | 96,8 % en 4,06 | 98,1 % en 3,34 | 88,3 % en 4,42 | 31,1 % en 7,76 | 89,7 % en 5,29 |
| Hypoglycémie légère | generale | 1 | 4,2 % en 7,48 | 97,9 % en 3,73 | 96,7 % en 3,95 | 96,9 % en 3,95 | 94,0 % en 3,64 | 35,9 % en 7,39 | 86,8 % en 5,55 |
| Intoxication alimentaire | generale | 1 | 2,9 % en 6,97 | 82,4 % en 4,12 | 88,0 % en 4,10 | 96,4 % en 3,13 | 97,7 % en 4,09 | 25,0 % en 8,13 | 75,0 % en 5,58 |
| Varicelle | generale | 1 | 2,0 % en 6,41 | 85,5 % en 4,02 | 81,7 % en 4,37 | 89,1 % en 3,93 | 96,3 % en 3,65 | 0,0 % en 9,50 | 90,9 % en 4,42 |
| Fièvre inexpliquée | generale | 1 | 0,0 % en 7,37 | 94,6 % en 3,38 | 91,1 % en 3,91 | 92,3 % en 3,87 | 95,4 % en 3,82 | 37,1 % en 7,13 | 93,3 % en 5,15 |
| Rougeole | generale | 1 | 6,8 % en 6,41 | 82,0 % en 3,74 | 81,8 % en 4,05 | 80,0 % en 3,73 | 86,4 % en 4,12 | 0,0 % en 8,94 | 91,1 % en 5,14 |
| Varices | cardiologie | 3 | 13,2 % en 6,64 | 96,3 % en 2,85 | 98,9 % en 3,20 | 94,7 % en 2,95 | 100,0 % en 3,05 | 0,5 % en 9,91 | 85,9 % en 3,89 |
| Extrasystoles | cardiologie | 2 | 4,4 % en 6,11 | 91,7 % en 3,07 | 98,2 % en 3,19 | 93,7 % en 3,39 | 93,9 % en 3,30 | 67,2 % en 5,01 | 85,3 % en 4,04 |
| Souffle au cœur | cardiologie | 3 | 8,0 % en 8,14 | 95,7 % en 3,31 | 97,9 % en 3,33 | 98,0 % en 3,08 | 100,0 % en 3,14 | 0,6 % en 11,13 | 89,4 % en 4,08 |
| Hypotension orthostatique | cardiologie | 2 | 2,5 % en 6,96 | 98,3 % en 3,25 | 96,9 % en 3,26 | 96,2 % en 3,27 | 94,6 % en 3,54 | 60,3 % en 5,38 | 87,9 % en 3,96 |
| Syndrome du cœur brisé | cardiologie | 2 | 1,9 % en 9,28 | 99,0 % en 3,01 | 99,0 % en 3,43 | 97,6 % en 3,20 | 100,0 % en 3,37 | 72,2 % en 5,50 | 92,4 % en 4,34 |
| Hypertension artérielle | cardiologie | 3 | 3,4 % en 7,36 | 96,0 % en 3,18 | 99,4 % en 3,19 | 98,9 % en 2,88 | 98,9 % en 3,23 | 59,8 % en 5,77 | 91,1 % en 3,86 |
| Bradycardie | cardiologie | 2 | 0,7 % en 7,78 | 93,6 % en 3,06 | 96,0 % en 3,22 | 97,3 % en 3,49 | 99,0 % en 3,07 | 61,1 % en 5,70 | 87,6 % en 4,05 |
| Tachycardie | cardiologie | 2 | 3,6 % en 8,41 | 94,7 % en 3,53 | 97,2 % en 3,50 | 97,1 % en 3,11 | 96,0 % en 3,50 | 71,9 % en 5,64 | 84,5 % en 4,41 |
| Phlébite | cardiologie | 2 | 13,5 % en 7,21 | 97,3 % en 3,05 | 98,0 % en 3,39 | 97,1 % en 3,29 | 96,9 % en 3,41 | 2,5 % en 10,18 | 93,3 % en 3,88 |
| Angor | cardiologie | 2 | 11,5 % en 6,82 | 97,4 % en 2,95 | 94,8 % en 3,33 | 96,3 % en 3,15 | 94,9 % en 3,47 | 0,9 % en 10,20 | 80,3 % en 3,98 |
| Péricardite | cardiologie | 2 | 14,2 % en 6,81 | 96,3 % en 2,91 | 96,5 % en 3,25 | 95,6 % en 3,11 | 95,4 % en 3,31 | 0,0 % en 10,14 | 85,8 % en 4,02 |
| Arythmie | cardiologie | 1 | 2,0 % en 8,10 | 98,0 % en 3,32 | 86,0 % en 3,93 | 92,7 % en 3,85 | 96,8 % en 3,73 | 75,0 % en 5,95 | 80,8 % en 4,33 |
| Fibrillation auriculaire | cardiologie | 2 | 0,9 % en 9,22 | 94,6 % en 3,50 | 99,0 % en 3,31 | 98,2 % en 3,13 | 98,2 % en 3,34 | 71,2 % en 5,91 | 88,1 % en 4,23 |
| Insuffisance cardiaque | cardiologie | 1 | 11,7 % en 7,52 | 96,2 % en 2,96 | 88,6 % en 3,89 | 98,1 % en 3,33 | 90,7 % en 3,56 | 1,8 % en 10,21 | 80,4 % en 4,43 |
| Endocardite | cardiologie | 2 | 11,0 % en 7,32 | 97,1 % en 3,44 | 97,8 % en 3,18 | 99,1 % en 3,17 | 97,4 % en 3,37 | 1,9 % en 10,19 | 86,2 % en 4,23 |
| Cardiomyopathie | cardiologie | 1 | 10,2 % en 8,02 | 96,4 % en 3,68 | 95,0 % en 3,70 | 96,7 % en 3,43 | 95,2 % en 3,95 | 0,0 % en 10,53 | 78,0 % en 4,81 |
| Rejet de greffe cardiaque | cardiologie | 1 | 18,2 % en 7,60 | 94,8 % en 3,19 | 94,9 % en 3,58 | 93,0 % en 3,42 | 100,0 % en 3,07 | 0,0 % en 10,59 | 86,8 % en 4,18 |
| Œdème aigu du poumon | cardiologie | 1 | 10,5 % en 7,30 | 88,6 % en 3,55 | 84,4 % en 3,91 | 86,0 % en 3,90 | 96,3 % en 4,07 | 0,0 % en 10,42 | 91,3 % en 3,91 |
| Infarctus du myocarde | cardiologie | 1 | 15,9 % en 7,43 | 95,1 % en 3,67 | 94,9 % en 3,75 | 97,6 % en 3,62 | 92,0 % en 3,94 | 0,0 % en 10,67 | 88,9 % en 4,50 |
| Embolie pulmonaire | cardiologie | 1 | 3,0 % en 7,43 | 94,4 % en 3,37 | 94,1 % en 3,67 | 89,1 % en 3,83 | 94,2 % en 3,35 | 0,0 % en 9,44 | 68,0 % en 5,26 |
| Tics nerveux | psychiatrie | 3 | 15,4 % en 6,47 | 98,3 % en 3,12 | 98,8 % en 3,22 | 98,2 % en 3,04 | 97,9 % en 3,14 | 8,4 % en 9,65 | 89,4 % en 3,98 |
| Phobie des escaliers | psychiatrie | 2 | 0,0 % en 5,81 | 92,7 % en 3,04 | 88,0 % en 3,86 | 91,5 % en 3,25 | 98,1 % en 3,34 | 0,0 % en 9,91 | 86,7 % en 3,82 |
| Dépendance à la caféine | psychiatrie | 3 | 1,3 % en 8,36 | 97,9 % en 2,87 | 98,8 % en 3,28 | 98,9 % en 3,21 | 99,4 % en 3,13 | 0,0 % en 10,88 | 93,7 % en 4,04 |
| Somnambulisme | psychiatrie | 2 | 2,0 % en 6,97 | 96,8 % en 3,20 | 98,4 % en 3,30 | 97,2 % en 3,17 | 97,6 % en 3,45 | 0,0 % en 9,80 | 92,9 % en 3,64 |
| Cauchemars répétés | psychiatrie | 2 | 3,2 % en 9,33 | 93,9 % en 3,39 | 100,0 % en 3,61 | 99,1 % en 3,17 | 99,0 % en 3,71 | 1,9 % en 12,16 | 90,4 % en 4,42 |
| Phobie des blouses blanches | psychiatrie | 3 | 15,2 % en 6,52 | 96,8 % en 3,03 | 97,6 % en 3,33 | 98,0 % en 3,07 | 99,4 % en 3,41 | 96,6 % en 2,64 | 89,1 % en 3,72 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 0,0 % en 7,58 | 92,2 % en 3,75 | 92,9 % en 3,61 | 97,5 % en 2,95 | 98,4 % en 3,18 | 1,0 % en 9,60 | 88,3 % en 4,31 |
| Hypocondrie aiguë | psychiatrie | 2 | 3,8 % en 8,14 | 98,1 % en 3,44 | 95,5 % en 3,24 | 98,3 % en 2,97 | 97,7 % en 3,26 | 0,9 % en 10,51 | 95,2 % en 4,12 |
| Agoraphobie | psychiatrie | 2 | 2,8 % en 8,45 | 95,9 % en 3,41 | 97,5 % en 3,24 | 99,1 % en 3,10 | 98,2 % en 3,35 | 3,4 % en 10,29 | 87,9 % en 4,15 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 7,1 % en 7,30 | 93,4 % en 3,31 | 96,7 % en 3,40 | 89,5 % en 3,24 | 96,0 % en 3,34 | 2,5 % en 9,50 | 80,6 % en 4,06 |
| Mutisme sélectif | psychiatrie | 2 | 11,7 % en 7,54 | 95,7 % en 3,39 | 97,3 % en 3,27 | 96,3 % en 3,39 | 97,6 % en 3,30 | 89,4 % en 2,97 | 88,8 % en 3,84 |
| Addiction aux écrans | psychiatrie | 1 | 1,6 % en 8,10 | 98,0 % en 2,86 | 96,7 % en 3,48 | 93,0 % en 3,42 | 100,0 % en 3,63 | 0,0 % en 10,27 | 85,5 % en 4,45 |
| Syndrome de Paris | psychiatrie | 2 | 10,1 % en 8,32 | 95,6 % en 3,37 | 97,2 % en 3,24 | 97,4 % en 3,48 | 100,0 % en 3,53 | 3,2 % en 10,99 | 91,8 % en 4,35 |
| Dépression légère | psychiatrie | 1 | 8,8 % en 7,30 | 97,1 % en 3,10 | 86,0 % en 3,90 | 93,2 % en 3,32 | 96,5 % en 3,60 | 94,9 % en 2,97 | 84,1 % en 4,25 |
| Trouble alimentaire léger | psychiatrie | 2 | 0,8 % en 7,88 | 96,2 % en 3,31 | 96,3 % en 3,44 | 98,3 % en 2,98 | 99,0 % en 3,38 | 0,0 % en 9,77 | 88,7 % en 4,15 |
| Insomnie chronique | psychiatrie | 1 | 0,0 % en 7,98 | 91,4 % en 3,17 | 91,9 % en 3,95 | 98,0 % en 3,84 | 96,1 % en 3,76 | 0,0 % en 10,16 | 86,6 % en 4,21 |
| Burn-out | psychiatrie | 1 | 22,7 % en 7,33 | 94,3 % en 3,79 | 96,4 % en 4,04 | 95,3 % en 3,33 | 100,0 % en 3,65 | 91,7 % en 3,31 | 90,6 % en 4,05 |
| Attaque de panique | psychiatrie | 1 | 11,8 % en 7,46 | 96,4 % en 3,30 | 85,4 % en 4,19 | 95,7 % en 3,26 | 95,2 % en 3,71 | 2,0 % en 9,44 | 81,0 % en 4,67 |
| Stress post-traumatique | psychiatrie | 1 | 13,6 % en 7,30 | 91,5 % en 3,66 | 96,8 % en 3,81 | 95,5 % en 3,52 | 94,1 % en 3,65 | 95,6 % en 3,11 | 92,3 % en 4,31 |
| Jalousie délirante | psychiatrie | 1 | 18,6 % en 7,07 | 87,9 % en 3,59 | 92,1 % en 3,49 | 91,3 % en 3,65 | 98,5 % en 2,95 | 6,5 % en 9,16 | 88,1 % en 3,97 |
| Hallux valgus | orthopedie | 3 | 14,6 % en 7,33 | 98,1 % en 2,88 | 98,1 % en 3,34 | 98,3 % en 2,92 | 99,4 % en 3,13 | 1,6 % en 9,83 | 91,3 % en 3,83 |
| Périostite tibiale | orthopedie | 2 | 12,4 % en 6,68 | 94,3 % en 2,99 | 95,9 % en 3,11 | 95,9 % en 3,15 | 98,9 % en 3,28 | 5,0 % en 9,99 | 90,8 % en 4,04 |
| Contusion sévère | orthopedie | 3 | 1,2 % en 9,23 | 95,8 % en 3,32 | 99,4 % en 3,20 | 100,0 % en 3,29 | 98,9 % en 3,22 | 69,1 % en 5,23 | 91,4 % en 4,17 |
| Entorse de la cheville | orthopedie | 2 | 1,9 % en 7,88 | 91,3 % en 3,37 | 97,0 % en 3,56 | 96,7 % en 3,07 | 94,1 % en 3,49 | 79,6 % en 3,96 | 88,5 % en 3,94 |
| Syndrome du canal carpien | orthopedie | 2 | 16,4 % en 9,51 | 100,0 % en 3,22 | 98,3 % en 3,52 | 99,1 % en 3,20 | 100,0 % en 3,40 | 5,3 % en 12,02 | 91,9 % en 4,59 |
| Lumbago | orthopedie | 3 | 10,1 % en 7,53 | 99,4 % en 2,74 | 96,4 % en 3,32 | 98,4 % en 2,97 | 98,8 % en 3,22 | 7,5 % en 9,48 | 89,4 % en 3,95 |
| Fêlure du coccyx | orthopedie | 2 | 16,0 % en 7,37 | 99,0 % en 3,11 | 94,6 % en 3,48 | 98,3 % en 2,86 | 98,2 % en 3,35 | 13,0 % en 9,58 | 85,0 % en 3,79 |
| Épaule gelée | orthopedie | 2 | 16,3 % en 7,60 | 100,0 % en 2,99 | 95,2 % en 3,52 | 97,5 % en 3,29 | 99,1 % en 3,29 | 12,1 % en 10,47 | 84,9 % en 4,57 |
| Entorse du genou | orthopedie | 2 | 0,0 % en 8,73 | 96,3 % en 3,16 | 94,0 % en 3,91 | 98,1 % en 3,18 | 97,6 % en 3,45 | 73,4 % en 4,81 | 90,4 % en 4,14 |
| Sciatique | orthopedie | 2 | 13,3 % en 7,09 | 97,4 % en 2,79 | 93,1 % en 3,47 | 96,1 % en 3,12 | 99,2 % en 3,14 | 5,7 % en 9,07 | 78,7 % en 4,12 |
| Scoliose | orthopedie | 2 | 20,0 % en 7,50 | 94,5 % en 3,34 | 93,7 % en 3,50 | 98,9 % en 2,99 | 97,1 % en 3,64 | 1,8 % en 11,11 | 86,7 % en 4,23 |
| Arthrose du genou | orthopedie | 1 | 11,3 % en 7,77 | 96,2 % en 3,55 | 93,5 % en 3,76 | 92,6 % en 3,44 | 96,1 % en 3,51 | 0,0 % en 10,32 | 87,3 % en 4,13 |
| Ostéoporose | orthopedie | 2 | 17,3 % en 8,88 | 98,3 % en 3,25 | 96,8 % en 3,66 | 99,2 % en 3,22 | 100,0 % en 3,38 | 0,9 % en 11,29 | 89,3 % en 4,68 |
| Fracture du poignet | orthopedie | 1 | 11,3 % en 8,06 | 95,1 % en 3,36 | 94,8 % en 3,76 | 96,7 % en 3,75 | 96,1 % en 3,24 | 80,0 % en 4,55 | 87,3 % en 3,87 |
| Fracture fermée | orthopedie | 2 | 1,7 % en 8,70 | 94,7 % en 3,18 | 95,2 % en 3,36 | 96,0 % en 3,46 | 99,1 % en 2,95 | 77,4 % en 5,12 | 86,4 % en 4,27 |
| Luxation de l'épaule | orthopedie | 1 | 0,0 % en 9,05 | 96,5 % en 3,74 | 92,2 % en 3,75 | 96,0 % en 4,40 | 88,2 % en 4,49 | 79,7 % en 4,78 | 86,4 % en 4,44 |
| Hernie discale | orthopedie | 1 | 1,8 % en 6,25 | 93,9 % en 3,49 | 88,9 % en 3,95 | 95,6 % en 3,20 | 94,6 % en 3,80 | 3,8 % en 9,67 | 80,8 % en 4,27 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,58 | 94,7 % en 2,88 | 91,8 % en 3,95 | 84,3 % en 3,43 | 93,3 % en 3,48 | 2,2 % en 9,20 | 75,9 % en 4,37 |
| Fracture ouverte | orthopedie | 1 | 4,0 % en 6,24 | 86,2 % en 3,32 | 94,9 % en 3,56 | 91,5 % en 3,19 | 98,5 % en 3,50 | 0,0 % en 9,88 | 84,1 % en 4,12 |
| Fracture du fémur | orthopedie | 1 | 2,0 % en 5,92 | 90,2 % en 3,21 | 91,8 % en 3,60 | 93,2 % en 3,18 | 96,7 % en 3,48 | 2,1 % en 9,94 | 78,5 % en 4,11 |
| Main froide éternelle | paranormal | 3 | 12,7 % en 7,03 | 95,9 % en 3,09 | 98,2 % en 3,07 | 98,8 % en 2,83 | 99,4 % en 3,35 | 1,3 % en 10,25 | 90,7 % en 3,94 |
| Rire des cimetières | paranormal | 2 | 8,6 % en 5,74 | 93,9 % en 3,06 | 94,8 % en 3,32 | 96,0 % en 3,04 | 97,2 % en 3,32 | 2,0 % en 9,09 | 82,9 % en 3,84 |
| Doigts qui grandissent | paranormal | 3 | 14,7 % en 8,04 | 98,6 % en 3,16 | 98,9 % en 3,26 | 97,1 % en 3,10 | 99,4 % en 3,20 | 1,9 % en 11,31 | 92,1 % en 4,22 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 7,79 | 94,9 % en 3,01 | 98,2 % en 3,43 | 95,5 % en 2,88 | 96,2 % en 3,47 | 77,0 % en 3,83 | 82,9 % en 4,00 |
| Nez qui saigne de l'encre | paranormal | 2 | 13,1 % en 9,11 | 96,9 % en 3,22 | 100,0 % en 3,03 | 98,3 % en 3,27 | 100,0 % en 3,43 | 2,4 % en 11,56 | 98,1 % en 4,17 |
| Mauvais œil | paranormal | 3 | 0,0 % en 8,15 | 96,0 % en 2,92 | 97,0 % en 3,34 | 98,2 % en 2,99 | 97,1 % en 3,43 | 80,5 % en 4,35 | 88,5 % en 3,69 |
| Malédiction des miroirs | paranormal | 2 | 1,9 % en 8,09 | 95,8 % en 3,12 | 97,3 % en 2,96 | 98,1 % en 3,26 | 100,0 % en 3,13 | 75,7 % en 4,48 | 86,0 % en 3,77 |
| Malédiction du chat noir | paranormal | 2 | 0,8 % en 8,68 | 95,0 % en 3,12 | 96,3 % en 3,49 | 99,0 % en 2,98 | 99,2 % en 3,27 | 79,8 % en 4,61 | 84,4 % en 4,28 |
| Malédiction du nombre 7 | paranormal | 2 | 2,6 % en 8,55 | 97,4 % en 3,06 | 97,3 % en 3,39 | 97,5 % en 3,20 | 100,0 % en 3,12 | 76,8 % en 4,48 | 91,8 % en 3,89 |
| Ombre qui suit | paranormal | 2 | 7,9 % en 6,88 | 94,1 % en 3,60 | 91,1 % en 3,63 | 97,5 % en 2,93 | 94,9 % en 3,37 | 4,4 % en 9,41 | 87,7 % en 4,32 |
| Brûlure lunaire | paranormal | 2 | 9,2 % en 7,93 | 95,2 % en 3,43 | 96,6 % en 3,41 | 100,0 % en 2,95 | 97,1 % en 3,56 | 4,1 % en 10,02 | 80,0 % en 4,28 |
| Âme en double | paranormal | 1 | 2,0 % en 8,31 | 91,3 % en 3,55 | 97,8 % en 3,27 | 89,5 % en 3,72 | 91,7 % en 3,94 | 87,0 % en 4,39 | 87,2 % en 3,97 |
| Voix du passé | paranormal | 2 | 1,0 % en 9,60 | 95,8 % en 3,37 | 99,2 % en 3,57 | 100,0 % en 2,90 | 97,3 % en 3,50 | 84,7 % en 4,63 | 90,2 % en 4,13 |
| Murmures dans la tête | paranormal | 1 | 3,4 % en 8,50 | 92,5 % en 3,02 | 91,4 % en 4,01 | 96,2 % en 3,64 | 98,6 % en 3,49 | 77,1 % en 4,90 | 87,0 % en 4,63 |
| Poltergeist domestique | paranormal | 2 | 16,8 % en 8,04 | 100,0 % en 3,36 | 97,3 % en 3,44 | 100,0 % en 3,52 | 97,9 % en 3,36 | 0,9 % en 9,47 | 80,2 % en 4,48 |
| Vampirisme aigu | paranormal | 1 | 17,9 % en 7,86 | 98,1 % en 3,07 | 92,5 % en 3,84 | 98,6 % en 3,45 | 97,8 % en 3,47 | 1,4 % en 10,13 | 85,7 % en 4,44 |
| Pétrification partielle | paranormal | 1 | 13,0 % en 8,00 | 94,7 % en 3,25 | 94,7 % en 3,19 | 100,0 % en 3,39 | 98,2 % en 3,45 | 0,0 % en 9,98 | 89,8 % en 4,20 |
| Possession légère | paranormal | 1 | 3,1 % en 8,36 | 97,1 % en 3,71 | 93,7 % en 3,84 | 92,7 % en 3,62 | 93,9 % en 3,67 | 69,1 % en 5,16 | 88,4 % en 4,14 |
| Lycanthropie | paranormal | 1 | 12,5 % en 8,02 | 95,7 % en 3,60 | 98,4 % en 3,87 | 98,3 % en 3,73 | 93,2 % en 3,69 | 0,0 % en 9,89 | 86,7 % en 4,73 |
| Glissement temporel | paranormal | 1 | 17,9 % en 7,25 | 93,3 % en 3,53 | 90,6 % en 4,00 | 96,4 % en 3,75 | 92,6 % en 3,87 | 0,0 % en 9,52 | 71,4 % en 4,39 |
