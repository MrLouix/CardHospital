# Rapport de simulation — CardHospital — paquet de base 1.2.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, pris en charge à tour de rôle · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 6,4 % | 93,6 % | 0 | 5,78 | 2,91 | 0,64 | -1,06 | -6,11 |
| seuil:60 | Interne | 93,4 % | 6,6 % | 0 | 2,94 | 1,59 | 1,53 | 0,41 | 1,22 |
| seuil:80 | Interne | 94,9 % | 5,1 % | 0 | 3,50 | 2,50 | 1,54 | 0,42 | 1,46 |
| couleur:60 | Interne | 95,1 % | 4,9 % | 0 | 2,91 | 1,57 | 1,56 | 0,46 | 1,35 |
| couleur:80 | Interne | 97,0 % | 3,0 % | 0 | 3,32 | 2,30 | 1,59 | 0,49 | 1,64 |
| hasard | Chirurgien | 4,7 % | 95,3 % | 0 | 3,98 | 1,97 | 0,64 | -2,09 | -8,30 |
| seuil:60 | Chirurgien | 84,2 % | 15,8 % | 0 | 2,72 | 1,51 | 1,83 | 0,38 | 1,04 |
| seuil:80 | Chirurgien | 85,9 % | 14,1 % | 0 | 3,26 | 2,36 | 1,79 | 0,50 | 1,63 |
| couleur:60 | Chirurgien | 86,5 % | 13,5 % | 0 | 2,70 | 1,49 | 1,87 | 0,48 | 1,28 |
| couleur:80 | Chirurgien | 89,9 % | 10,1 % | 0 | 3,18 | 2,24 | 1,85 | 0,62 | 1,98 |
| hasard | Réanimation | 4,0 % | 96,0 % | 0 | 3,66 | 1,84 | 1,26 | -2,42 | -8,85 |
| seuil:60 | Réanimation | 81,1 % | 18,9 % | 0 | 2,62 | 1,47 | 2,74 | 0,57 | 1,49 |
| seuil:80 | Réanimation | 84,9 % | 15,1 % | 0 | 3,24 | 2,35 | 2,78 | 0,71 | 2,28 |
| couleur:60 | Réanimation | 82,0 % | 18,0 % | 0 | 2,62 | 1,46 | 2,75 | 0,61 | 1,59 |
| couleur:80 | Réanimation | 88,9 % | 11,1 % | 0 | 3,14 | 2,21 | 2,84 | 0,87 | 2,72 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -75 | -61 | -47 | -75 | -61 |
| seuil:60 | Interne | 0 | 13 | 19 | -5 | 0 |
| seuil:80 | Interne | 5 | 16 | 20 | -2 | 0 |
| couleur:60 | Interne | 4 | 15 | 19 | -3 | 0 |
| couleur:80 | Interne | 9 | 18 | 20 | -1 | 0 |
| hasard | Chirurgien | -97 | -84 | -68 | -97 | -84 |
| seuil:60 | Chirurgien | -14 | 11 | 28 | -17 | -1 |
| seuil:80 | Chirurgien | 0 | 18 | 30 | -9 | 0 |
| couleur:60 | Chirurgien | -7 | 16 | 30 | -15 | 0 |
| couleur:80 | Chirurgien | 4 | 20 | 30 | -5 | 0 |
| hasard | Réanimation | -102 | -90 | -72 | -102 | -90 |
| seuil:60 | Réanimation | -12 | 16 | 38 | -18 | 0 |
| seuil:80 | Réanimation | -2 | 26 | 40 | -10 | 0 |
| couleur:60 | Réanimation | -12 | 16 | 38 | -16 | 0 |
| couleur:80 | Réanimation | 6 | 28 | 40 | -6 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Angine bactérienne | generale | 3 | 11,0 % en 6,36 | 86,9 % en 3,26 | 96,6 % en 3,65 | 88,4 % en 3,39 | 95,4 % en 3,60 |
| Rhume carabiné | generale | 3 | 4,1 % en 5,52 | 91,5 % en 2,97 | 97,8 % en 3,62 | 94,8 % en 2,82 | 96,3 % en 3,51 |
| Gastro virale | generale | 3 | 7,3 % en 5,84 | 93,1 % en 2,97 | 96,3 % en 3,58 | 91,8 % en 3,09 | 97,7 % en 3,24 |
| Otite moyenne aiguë | generale | 2 | 5,7 % en 5,53 | 94,2 % en 3,03 | 96,6 % en 3,33 | 92,2 % en 2,82 | 98,1 % en 3,57 |
| Infection urinaire légère | generale | 2 | 7,6 % en 5,32 | 89,7 % en 3,04 | 93,2 % en 3,50 | 94,5 % en 2,99 | 93,9 % en 3,46 |
| Conjonctivite | generale | 2 | 11,7 % en 5,74 | 87,3 % en 3,14 | 98,4 % en 3,67 | 93,4 % en 3,04 | 97,2 % en 3,56 |
| Bronchite aiguë | generale | 2 | 11,4 % en 5,94 | 94,3 % en 3,00 | 93,2 % en 3,72 | 88,1 % en 3,36 | 92,2 % en 3,57 |
| Sinusite maxillaire | generale | 2 | 5,5 % en 5,88 | 91,8 % en 2,89 | 93,7 % en 3,62 | 93,7 % en 2,84 | 93,2 % en 3,89 |
| Piqûre de moustique infectée | generale | 2 | 11,6 % en 4,79 | 88,9 % en 2,94 | 92,5 % en 3,71 | 92,5 % en 2,80 | 95,6 % en 3,36 |
| Intoxication alimentaire | generale | 2 | 2,9 % en 5,14 | 92,4 % en 2,81 | 87,3 % en 3,51 | 93,7 % en 3,12 | 97,3 % en 3,13 |
| Maux de tête | generale | 3 | 9,1 % en 4,78 | 85,1 % en 3,10 | 90,5 % en 3,63 | 87,0 % en 3,08 | 95,8 % en 3,39 |
| Maux de gorge | generale | 3 | 5,4 % en 6,02 | 95,5 % en 3,01 | 97,7 % en 3,57 | 96,8 % en 2,78 | 96,4 % en 3,55 |
| Torticolis | generale | 2 | 3,1 % en 4,70 | 89,1 % en 2,87 | 94,8 % en 3,26 | 90,0 % en 3,08 | 97,8 % en 3,45 |
| Fatigue chronique légère | generale | 1 | 4,9 % en 5,97 | 78,6 % en 3,29 | 96,0 % en 3,64 | 88,2 % en 3,00 | 96,9 % en 3,26 |
| Carence en vitamine D | generale | 1 | 15,9 % en 8,35 | 98,5 % en 3,16 | 100,0 % en 3,41 | 97,9 % en 3,13 | 100,0 % en 3,38 |
| Insomnie passagère | generale | 2 | 5,2 % en 5,67 | 92,2 % en 2,88 | 92,6 % en 3,79 | 91,0 % en 2,79 | 97,5 % en 3,50 |
| Migraine légère | generale | 2 | 10,6 % en 5,02 | 86,9 % en 2,95 | 88,1 % en 3,47 | 85,6 % en 3,05 | 86,6 % en 3,45 |
| Hoquet persistant | generale | 1 | 6,3 % en 6,84 | 96,6 % en 2,88 | 100,0 % en 3,24 | 98,7 % en 2,92 | 98,4 % en 3,52 |
| Hypoglycémie légère | generale | 2 | 9,4 % en 5,55 | 85,8 % en 3,24 | 93,8 % en 3,63 | 90,2 % en 3,09 | 94,3 % en 3,53 |
| Fièvre inexpliquée | generale | 1 | 5,2 % en 5,17 | 86,2 % en 2,74 | 89,4 % en 3,30 | 95,8 % en 2,85 | 93,0 % en 3,75 |
| Rougeole | generale | 2 | 2,7 % en 5,41 | 91,4 % en 3,22 | 87,9 % en 4,16 | 83,2 % en 3,29 | 93,7 % en 3,34 |
| Varicelle | generale | 3 | 5,1 % en 5,33 | 83,1 % en 3,35 | 88,5 % en 4,14 | 85,8 % en 3,57 | 95,2 % en 3,55 |
| Gale | generale | 1 | 5,4 % en 5,34 | 84,5 % en 3,57 | 83,0 % en 3,89 | 88,1 % en 3,07 | 91,9 % en 3,50 |
| Hypertension artérielle | cardiologie | 2 | 8,6 % en 7,03 | 98,4 % en 2,79 | 97,3 % en 3,53 | 98,4 % en 2,89 | 99,1 % en 3,35 |
| Arythmie | cardiologie | 2 | 0,9 % en 6,05 | 94,7 % en 3,17 | 91,9 % en 3,58 | 90,4 % en 3,46 | 96,0 % en 3,30 |
| Infarctus du myocarde | cardiologie | 1 | 0,0 % en 5,85 | 95,1 % en 3,28 | 87,7 % en 3,51 | 96,2 % en 3,11 | 92,9 % en 3,70 |
| Angor | cardiologie | 2 | 6,6 % en 5,85 | 96,5 % en 2,83 | 96,3 % en 3,22 | 93,7 % en 2,80 | 96,6 % en 3,19 |
| Insuffisance cardiaque | cardiologie | 1 | 8,1 % en 6,85 | 97,0 % en 2,67 | 100,0 % en 3,08 | 98,3 % en 2,88 | 100,0 % en 3,15 |
| Tachycardie | cardiologie | 2 | 0,0 % en 6,42 | 91,7 % en 3,24 | 96,8 % en 3,52 | 96,3 % en 3,18 | 92,4 % en 3,81 |
| Bradycardie | cardiologie | 1 | 0,0 % en 6,43 | 94,4 % en 3,20 | 88,7 % en 3,94 | 98,1 % en 3,40 | 96,0 % en 3,22 |
| Fibrillation auriculaire | cardiologie | 2 | 0,0 % en 7,01 | 94,7 % en 3,17 | 95,5 % en 3,56 | 95,9 % en 3,07 | 93,9 % en 3,28 |
| Péricardite | cardiologie | 1 | 4,5 % en 6,36 | 96,1 % en 2,71 | 96,2 % en 3,32 | 98,6 % en 2,66 | 94,0 % en 3,24 |
| Endocardite | cardiologie | 1 | 12,9 % en 6,00 | 96,2 % en 2,87 | 90,3 % en 3,27 | 98,5 % en 2,65 | 96,9 % en 3,08 |
| Syndrome du cœur brisé | cardiologie | 1 | 4,8 % en 6,52 | 98,2 % en 2,60 | 100,0 % en 3,44 | 98,3 % en 2,75 | 100,0 % en 3,07 |
| Hypotension orthostatique | cardiologie | 2 | 9,2 % en 5,28 | 96,7 % en 2,67 | 98,3 % en 3,38 | 95,7 % en 2,68 | 98,1 % en 3,30 |
| Varices | cardiologie | 2 | 7,6 % en 7,70 | 98,4 % en 2,97 | 100,0 % en 3,64 | 98,3 % en 2,74 | 100,0 % en 3,26 |
| Phlébite | cardiologie | 2 | 6,1 % en 5,77 | 97,9 % en 2,71 | 94,7 % en 3,53 | 94,8 % en 2,66 | 99,2 % en 3,15 |
| Embolie pulmonaire | cardiologie | 1 | 0,0 % en 5,84 | 96,4 % en 3,38 | 88,9 % en 3,78 | 94,3 % en 2,79 | 97,9 % en 3,19 |
| Souffle au cœur | cardiologie | 2 | 8,1 % en 6,15 | 95,6 % en 2,74 | 98,1 % en 3,56 | 98,4 % en 2,65 | 97,2 % en 3,46 |
| Œdème aigu du poumon | cardiologie | 1 | 0,0 % en 5,90 | 90,5 % en 3,14 | 98,4 % en 3,37 | 96,7 % en 3,12 | 94,4 % en 3,17 |
| Malaise cardiaque | cardiologie | 3 | 7,0 % en 5,49 | 95,5 % en 2,79 | 97,7 % en 3,47 | 97,8 % en 2,65 | 97,8 % en 3,34 |
| Cardiomyopathie | cardiologie | 1 | 6,6 % en 5,77 | 97,9 % en 2,74 | 90,8 % en 3,29 | 98,1 % en 2,50 | 94,6 % en 3,36 |
| Suivi de greffe cardiaque | cardiologie | 1 | 2,7 % en 6,04 | 95,8 % en 2,67 | 96,2 % en 3,47 | 100,0 % en 2,77 | 96,9 % en 3,17 |
| Phobie des blouses blanches | psychiatrie | 2 | 3,4 % en 6,76 | 97,9 % en 2,79 | 96,9 % en 3,35 | 99,1 % en 2,67 | 98,3 % en 3,08 |
| Hypocondrie aiguë | psychiatrie | 2 | 5,3 % en 5,76 | 93,4 % en 2,85 | 95,7 % en 3,21 | 98,1 % en 2,88 | 99,2 % en 3,43 |
| Crise d'angoisse | psychiatrie | 2 | 8,2 % en 5,04 | 93,3 % en 2,91 | 92,9 % en 3,38 | 97,5 % en 2,71 | 95,5 % en 3,12 |
| Dépression légère | psychiatrie | 2 | 8,9 % en 7,13 | 97,1 % en 2,89 | 99,1 % en 3,43 | 100,0 % en 2,75 | 99,2 % en 3,17 |
| Trouble du sommeil | psychiatrie | 2 | 14,0 % en 6,45 | 94,0 % en 2,78 | 98,5 % en 3,64 | 99,0 % en 2,55 | 99,0 % en 3,34 |
| Anxiété généralisée | psychiatrie | 2 | 8,5 % en 6,16 | 97,4 % en 2,86 | 98,2 % en 3,34 | 98,4 % en 2,67 | 100,0 % en 3,25 |
| Attaque de panique | psychiatrie | 2 | 10,5 % en 4,07 | 93,2 % en 2,60 | 81,1 % en 3,26 | 97,4 % en 2,46 | 92,6 % en 3,06 |
| Trouble obsessionnel compulsif léger | psychiatrie | 1 | 7,9 % en 7,19 | 98,5 % en 2,48 | 100,0 % en 3,37 | 100,0 % en 2,68 | 98,4 % en 3,33 |
| Phobie des escaliers | psychiatrie | 1 | 9,6 % en 5,25 | 100,0 % en 2,51 | 96,7 % en 3,25 | 100,0 % en 2,58 | 100,0 % en 3,19 |
| Syndrome de Paris | psychiatrie | 1 | 9,0 % en 6,79 | 98,2 % en 2,65 | 97,7 % en 3,48 | 100,0 % en 2,64 | 98,2 % en 3,43 |
| Burn-out | psychiatrie | 1 | 8,2 % en 6,14 | 98,5 % en 2,88 | 98,7 % en 3,34 | 92,3 % en 2,62 | 98,0 % en 2,78 |
| Addiction aux écrans | psychiatrie | 1 | 0,0 % en 6,42 | 90,6 % en 3,64 | 86,0 % en 4,12 | 98,3 % en 3,43 | 100,0 % en 3,34 |
| Cauchemars répétés | psychiatrie | 2 | 9,1 % en 6,15 | 95,4 % en 2,62 | 97,7 % en 3,32 | 96,3 % en 2,80 | 99,0 % en 3,39 |
| Mutisme sélectif | psychiatrie | 1 | 13,2 % en 7,50 | 96,8 % en 2,98 | 98,2 % en 3,49 | 100,0 % en 2,36 | 100,0 % en 3,18 |
| Trouble alimentaire léger | psychiatrie | 2 | 12,1 % en 5,27 | 92,9 % en 2,56 | 91,0 % en 3,32 | 95,9 % en 2,81 | 95,7 % en 3,06 |
| Stress post-traumatique | psychiatrie | 1 | 5,9 % en 6,01 | 98,1 % en 2,70 | 98,3 % en 3,24 | 100,0 % en 2,55 | 98,4 % en 3,36 |
| Jalousie délirante | psychiatrie | 1 | 10,2 % en 5,54 | 98,1 % en 2,44 | 94,8 % en 3,43 | 97,3 % en 2,74 | 98,3 % en 3,29 |
| Insomnie chronique | psychiatrie | 2 | 3,9 % en 6,05 | 96,6 % en 2,76 | 96,6 % en 3,27 | 95,8 % en 2,82 | 95,5 % en 3,23 |
| Dépendance à la caféine | psychiatrie | 1 | 7,3 % en 5,80 | 100,0 % en 2,56 | 98,6 % en 3,33 | 100,0 % en 2,78 | 97,1 % en 3,31 |
| Crise de rire incontrôlée | psychiatrie | 1 | 3,0 % en 6,79 | 95,7 % en 2,66 | 98,5 % en 3,38 | 97,0 % en 2,79 | 97,9 % en 2,77 |
| Fracture ouverte | orthopedie | 2 | 0,8 % en 4,96 | 90,7 % en 3,17 | 92,6 % en 3,54 | 94,9 % en 2,85 | 96,5 % en 3,26 |
| Fracture fermée | orthopedie | 2 | 7,0 % en 5,24 | 100,0 % en 2,78 | 96,6 % en 3,53 | 98,2 % en 2,80 | 99,3 % en 3,13 |
| Entorse de la cheville | orthopedie | 3 | 7,2 % en 5,47 | 93,7 % en 3,24 | 97,7 % en 3,49 | 93,5 % en 3,16 | 98,9 % en 3,44 |
| Entorse du genou | orthopedie | 2 | 8,1 % en 6,13 | 94,6 % en 3,28 | 100,0 % en 3,24 | 98,5 % en 3,32 | 96,6 % en 3,46 |
| Luxation de l'épaule | orthopedie | 2 | 0,8 % en 5,13 | 87,6 % en 3,16 | 93,4 % en 3,60 | 89,7 % en 3,05 | 97,7 % en 3,21 |
| Lumbago | orthopedie | 3 | 8,2 % en 4,46 | 94,0 % en 2,75 | 96,9 % en 3,39 | 94,7 % en 2,76 | 97,8 % en 3,18 |
| Sciatique | orthopedie | 2 | 3,2 % en 4,37 | 89,6 % en 2,90 | 89,7 % en 3,46 | 96,9 % en 3,08 | 93,5 % en 3,12 |
| Hernie discale | orthopedie | 1 | 4,8 % en 4,84 | 91,8 % en 2,86 | 95,9 % en 3,16 | 96,4 % en 2,77 | 98,0 % en 3,16 |
| Fracture du poignet | orthopedie | 2 | 8,2 % en 4,80 | 93,2 % en 2,85 | 94,8 % en 3,73 | 95,5 % en 2,73 | 97,7 % en 3,44 |
| Rupture du ligament croisé | orthopedie | 1 | 3,4 % en 5,12 | 97,1 % en 2,90 | 90,9 % en 3,51 | 97,9 % en 2,77 | 98,7 % en 3,23 |
| Scoliose | orthopedie | 1 | 8,6 % en 6,53 | 98,2 % en 2,88 | 98,1 % en 3,43 | 97,3 % en 3,21 | 100,0 % en 3,23 |
| Arthrose du genou | orthopedie | 2 | 6,5 % en 6,20 | 96,2 % en 3,00 | 100,0 % en 3,65 | 99,2 % en 2,88 | 99,1 % en 3,38 |
| Syndrome du canal carpien | orthopedie | 2 | 6,2 % en 4,96 | 93,4 % en 2,97 | 97,4 % en 3,71 | 96,0 % en 2,69 | 100,0 % en 3,33 |
| Épaule gelée | orthopedie | 1 | 9,0 % en 5,54 | 94,0 % en 2,76 | 96,3 % en 3,26 | 98,5 % en 2,59 | 100,0 % en 3,16 |
| Hallux valgus | orthopedie | 2 | 5,9 % en 5,41 | 96,9 % en 2,82 | 97,0 % en 3,43 | 97,5 % en 3,08 | 99,1 % en 3,31 |
| Fracture du fémur | orthopedie | 1 | 0,0 % en 5,05 | 87,3 % en 3,05 | 92,5 % en 3,27 | 86,3 % en 2,94 | 95,0 % en 3,33 |
| Périostite tibiale | orthopedie | 2 | 5,6 % en 5,69 | 89,9 % en 3,28 | 94,9 % en 3,39 | 95,2 % en 3,32 | 100,0 % en 3,51 |
| Torticolis congénital | orthopedie | 1 | 7,5 % en 4,86 | 90,0 % en 2,96 | 98,4 % en 3,22 | 96,2 % en 2,87 | 100,0 % en 3,14 |
| Ostéoporose | orthopedie | 1 | 2,4 % en 6,60 | 96,4 % en 2,91 | 98,5 % en 3,33 | 100,0 % en 2,85 | 98,2 % en 3,38 |
| Contusion sévère | orthopedie | 2 | 6,2 % en 5,52 | 90,3 % en 3,19 | 96,0 % en 3,38 | 94,6 % en 3,38 | 95,7 % en 3,19 |
| Malédiction du lundi | paranormal | 2 | 0,9 % en 5,54 | 93,9 % en 3,18 | 92,2 % en 3,42 | 92,9 % en 2,71 | 97,8 % en 3,17 |
| Possession légère | paranormal | 1 | 0,0 % en 6,18 | 94,4 % en 3,24 | 92,3 % en 3,68 | 93,7 % en 3,10 | 96,8 % en 3,47 |
| Vampirisme aigu | paranormal | 1 | 7,6 % en 5,70 | 95,9 % en 2,71 | 94,2 % en 3,35 | 98,4 % en 2,56 | 100,0 % en 2,85 |
| Lycanthropie | paranormal | 1 | 7,2 % en 5,12 | 98,2 % en 2,53 | 96,9 % en 3,48 | 93,8 % en 2,50 | 97,0 % en 3,31 |
| Mauvais œil | paranormal | 2 | 0,0 % en 5,70 | 92,4 % en 2,96 | 96,6 % en 3,53 | 93,0 % en 3,34 | 97,7 % en 3,37 |
| Âme en double | paranormal | 1 | 17,4 % en 6,04 | 96,2 % en 2,80 | 98,1 % en 3,35 | 100,0 % en 2,67 | 100,0 % en 2,89 |
| Malédiction des miroirs | paranormal | 1 | 1,8 % en 5,84 | 89,9 % en 3,00 | 89,6 % en 3,55 | 94,7 % en 3,14 | 91,9 % en 3,29 |
| Fièvre des étoiles | paranormal | 1 | 8,3 % en 5,69 | 94,9 % en 2,54 | 100,0 % en 3,11 | 98,1 % en 2,30 | 98,4 % en 3,39 |
| Murmures dans la tête | paranormal | 2 | 0,0 % en 6,09 | 93,5 % en 3,16 | 95,5 % en 3,38 | 97,5 % en 2,80 | 95,8 % en 3,38 |
| Ombre qui suit | paranormal | 2 | 9,8 % en 5,97 | 92,3 % en 2,88 | 95,8 % en 3,23 | 97,5 % en 2,76 | 95,3 % en 3,17 |
| Pétrification partielle | paranormal | 1 | 9,8 % en 5,90 | 95,7 % en 2,64 | 89,7 % en 3,66 | 94,8 % en 2,57 | 100,0 % en 3,00 |
| Rire des cimetières | paranormal | 1 | 10,2 % en 5,78 | 95,3 % en 2,61 | 98,3 % en 3,43 | 98,6 % en 2,58 | 100,0 % en 3,38 |
| Main froide éternelle | paranormal | 2 | 5,6 % en 7,02 | 97,7 % en 2,83 | 99,1 % en 3,67 | 100,0 % en 2,55 | 100,0 % en 3,24 |
| Voix du passé | paranormal | 1 | 0,0 % en 6,91 | 93,3 % en 3,35 | 96,7 % en 3,80 | 96,0 % en 3,30 | 100,0 % en 3,30 |
| Malédiction du nombre 7 | paranormal | 1 | 0,0 % en 6,08 | 98,4 % en 2,89 | 95,7 % en 3,75 | 100,0 % en 3,11 | 97,2 % en 3,25 |
| Nez qui saigne de l'encre | paranormal | 1 | 4,8 % en 6,30 | 97,1 % en 2,60 | 96,9 % en 3,53 | 100,0 % en 2,71 | 100,0 % en 2,98 |
| Glissement temporel | paranormal | 1 | 1,4 % en 5,85 | 95,4 % en 2,68 | 92,2 % en 3,39 | 96,4 % en 2,73 | 100,0 % en 2,94 |
| Doigts qui grandissent | paranormal | 1 | 15,6 % en 5,33 | 92,3 % en 2,75 | 86,0 % en 3,42 | 100,0 % en 2,45 | 100,0 % en 2,97 |
| Malédiction du chat noir | paranormal | 1 | 1,6 % en 5,40 | 89,9 % en 3,57 | 87,9 % en 3,35 | 93,2 % en 3,49 | 94,2 % en 3,13 |
| Ombre vivante | paranormal | 1 | 9,2 % en 5,91 | 98,4 % en 2,45 | 88,5 % en 3,48 | 96,7 % en 2,72 | 98,5 % en 3,09 |
