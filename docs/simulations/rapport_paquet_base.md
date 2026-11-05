# Rapport de simulation — CardHospital — paquet de base 1.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 5,1 % | 94,9 % | 0 | 4,73 | 2,38 | 0,64 | -1,11 | -5,25 |
| seuil:60 | Interne | 89,8 % | 10,3 % | 0 | 2,83 | 1,54 | 1,53 | 0,38 | 1,09 |
| seuil:80 | Interne | 89,4 % | 10,6 % | 0 | 3,36 | 2,42 | 1,53 | 0,38 | 1,29 |
| couleur:60 | Interne | 90,7 % | 9,3 % | 0 | 2,85 | 1,55 | 1,54 | 0,40 | 1,14 |
| couleur:80 | Interne | 92,7 % | 7,3 % | 0 | 3,23 | 2,25 | 1,58 | 0,46 | 1,48 |
| hasard | Chirurgien | 3,1 % | 96,9 % | 0 | 3,15 | 1,57 | 0,64 | -2,37 | -7,44 |
| seuil:60 | Chirurgien | 74,0 % | 26,0 % | 0 | 2,43 | 1,37 | 1,82 | 0,14 | 0,35 |
| seuil:80 | Chirurgien | 73,4 % | 26,6 % | 0 | 2,91 | 2,15 | 1,76 | 0,28 | 0,80 |
| couleur:60 | Chirurgien | 75,5 % | 24,5 % | 0 | 2,43 | 1,36 | 1,84 | 0,20 | 0,49 |
| couleur:80 | Chirurgien | 77,5 % | 22,5 % | 0 | 2,91 | 2,09 | 1,80 | 0,39 | 1,12 |
| hasard | Réanimation | 2,9 % | 97,1 % | 0 | 2,78 | 1,40 | 1,26 | -2,91 | -8,09 |
| seuil:60 | Réanimation | 72,5 % | 27,5 % | 0 | 2,30 | 1,26 | 2,73 | 0,29 | 0,68 |
| seuil:80 | Réanimation | 69,3 % | 30,7 % | 0 | 2,80 | 2,08 | 2,74 | 0,31 | 0,87 |
| couleur:60 | Réanimation | 74,0 % | 26,0 % | 0 | 2,31 | 1,26 | 2,76 | 0,37 | 0,84 |
| couleur:80 | Réanimation | 75,3 % | 24,7 % | 0 | 2,78 | 1,99 | 2,81 | 0,53 | 1,47 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -64 | -53 | -41 | -64 | -53 |
| seuil:60 | Interne | -1 | 12 | 19 | -7 | 0 |
| seuil:80 | Interne | 2 | 13 | 20 | -5 | 0 |
| couleur:60 | Interne | -1 | 12 | 19 | -7 | 0 |
| couleur:80 | Interne | 6 | 15 | 20 | -4 | 0 |
| hasard | Chirurgien | -85 | -76 | -61 | -85 | -76 |
| seuil:60 | Chirurgien | -20 | 2 | 20 | -25 | -6 |
| seuil:80 | Chirurgien | -12 | 6 | 22 | -16 | -2 |
| couleur:60 | Chirurgien | -20 | 8 | 30 | -23 | -5 |
| couleur:80 | Chirurgien | -10 | 14 | 30 | -14 | -2 |
| hasard | Réanimation | -92 | -82 | -66 | -92 | -82 |
| seuil:60 | Réanimation | -20 | 4 | 28 | -28 | -6 |
| seuil:80 | Réanimation | -20 | 10 | 30 | -22 | -4 |
| couleur:60 | Réanimation | -20 | 6 | 38 | -26 | -4 |
| couleur:80 | Réanimation | -10 | 18 | 40 | -16 | -2 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Angine bactérienne | generale | 3 | 10,5 % en 5,23 | 86,8 % en 3,08 | 91,8 % en 3,91 | 86,4 % en 3,31 | 92,3 % en 3,38 |
| Rhume carabiné | generale | 3 | 3,3 % en 4,29 | 85,4 % en 2,73 | 89,2 % en 3,32 | 88,5 % en 2,73 | 92,5 % en 3,37 |
| Gastro virale | generale | 3 | 4,0 % en 4,89 | 83,4 % en 2,96 | 92,9 % en 3,33 | 87,8 % en 2,87 | 92,3 % en 3,30 |
| Otite moyenne aiguë | generale | 2 | 1,9 % en 5,15 | 89,9 % en 3,11 | 93,3 % en 3,58 | 91,2 % en 2,90 | 93,5 % en 3,56 |
| Infection urinaire légère | generale | 2 | 5,9 % en 4,53 | 92,1 % en 3,01 | 89,2 % en 3,79 | 91,8 % en 3,12 | 96,9 % en 3,67 |
| Conjonctivite | generale | 2 | 8,3 % en 4,98 | 87,0 % en 2,86 | 93,1 % en 3,45 | 86,9 % en 3,07 | 97,2 % en 3,25 |
| Bronchite aiguë | generale | 2 | 8,1 % en 4,22 | 80,4 % en 3,04 | 82,3 % en 3,30 | 84,0 % en 2,95 | 87,7 % en 3,29 |
| Sinusite maxillaire | generale | 2 | 6,0 % en 5,37 | 93,2 % en 3,05 | 90,9 % en 3,64 | 88,0 % en 3,06 | 95,6 % en 3,19 |
| Piqûre de moustique infectée | generale | 2 | 3,7 % en 4,14 | 89,3 % en 2,88 | 83,8 % en 3,35 | 90,2 % en 2,77 | 90,3 % en 3,39 |
| Intoxication alimentaire | generale | 2 | 3,5 % en 4,40 | 84,1 % en 2,80 | 80,2 % en 3,32 | 88,4 % en 2,80 | 85,6 % en 3,16 |
| Maux de tête | generale | 3 | 2,8 % en 4,22 | 81,0 % en 3,05 | 84,3 % en 3,58 | 83,1 % en 3,11 | 90,0 % en 3,30 |
| Maux de gorge | generale | 3 | 6,1 % en 4,85 | 92,1 % en 2,98 | 93,3 % en 3,48 | 89,9 % en 3,02 | 93,2 % en 3,35 |
| Torticolis | generale | 2 | 4,3 % en 4,37 | 88,6 % en 2,75 | 89,4 % en 3,38 | 90,2 % en 2,77 | 94,3 % en 3,17 |
| Fatigue chronique légère | generale | 1 | 4,4 % en 5,84 | 95,4 % en 3,05 | 96,7 % en 3,77 | 93,4 % en 2,80 | 98,0 % en 3,36 |
| Carence en vitamine D | generale | 1 | 9,0 % en 6,75 | 96,8 % en 2,79 | 98,4 % en 3,79 | 95,6 % en 3,18 | 97,8 % en 3,31 |
| Insomnie passagère | generale | 2 | 9,1 % en 5,00 | 90,2 % en 2,83 | 93,4 % en 3,57 | 91,0 % en 3,02 | 93,3 % en 3,53 |
| Migraine légère | generale | 2 | 6,4 % en 3,42 | 60,4 % en 2,59 | 68,9 % en 3,06 | 61,6 % en 2,67 | 71,7 % en 3,08 |
| Hoquet persistant | generale | 1 | 9,6 % en 5,27 | 96,2 % en 2,69 | 89,0 % en 3,60 | 82,0 % en 3,21 | 96,2 % en 3,19 |
| Hypoglycémie légère | generale | 2 | 7,3 % en 4,73 | 79,7 % en 3,23 | 87,2 % en 3,75 | 92,8 % en 3,00 | 88,5 % en 3,70 |
| Fièvre inexpliquée | generale | 1 | 6,8 % en 4,10 | 82,8 % en 2,78 | 79,2 % en 3,25 | 88,4 % en 2,74 | 88,6 % en 3,04 |
| Rougeole | generale | 2 | 0,8 % en 4,08 | 80,7 % en 2,94 | 85,6 % en 3,21 | 85,6 % en 3,02 | 87,0 % en 3,11 |
| Varicelle | generale | 3 | 2,7 % en 3,99 | 77,8 % en 2,99 | 81,6 % en 3,45 | 73,1 % en 3,08 | 89,7 % en 3,25 |
| Gale | generale | 1 | 1,6 % en 4,00 | 75,4 % en 3,08 | 70,2 % en 3,74 | 76,5 % en 2,96 | 83,8 % en 3,32 |
| Hypertension artérielle | cardiologie | 2 | 11,1 % en 4,86 | 95,3 % en 2,73 | 93,4 % en 3,36 | 95,7 % en 2,62 | 97,4 % en 3,14 |
| Arythmie | cardiologie | 2 | 0,0 % en 4,95 | 92,4 % en 3,14 | 86,8 % en 3,42 | 93,6 % en 3,06 | 89,1 % en 3,35 |
| Infarctus du myocarde | cardiologie | 1 | 0,0 % en 4,50 | 84,5 % en 3,16 | 82,3 % en 3,24 | 83,7 % en 3,04 | 84,6 % en 3,14 |
| Angor | cardiologie | 2 | 5,9 % en 4,49 | 96,2 % en 2,60 | 87,6 % en 3,22 | 96,0 % en 2,57 | 90,7 % en 3,06 |
| Insuffisance cardiaque | cardiologie | 1 | 3,7 % en 4,89 | 98,1 % en 2,76 | 93,5 % en 3,02 | 94,8 % en 2,84 | 98,6 % en 3,01 |
| Tachycardie | cardiologie | 2 | 0,0 % en 4,77 | 84,8 % en 3,05 | 88,3 % en 3,03 | 90,9 % en 2,85 | 91,0 % en 3,28 |
| Bradycardie | cardiologie | 1 | 0,0 % en 4,34 | 89,0 % en 2,93 | 75,0 % en 3,50 | 90,9 % en 3,20 | 90,6 % en 3,58 |
| Fibrillation auriculaire | cardiologie | 2 | 1,0 % en 5,16 | 93,9 % en 3,09 | 89,6 % en 3,39 | 95,8 % en 3,18 | 95,6 % en 3,24 |
| Péricardite | cardiologie | 1 | 6,2 % en 4,32 | 91,4 % en 2,76 | 93,3 % en 2,90 | 94,2 % en 2,52 | 87,3 % en 3,11 |
| Endocardite | cardiologie | 1 | 6,8 % en 3,98 | 88,6 % en 2,69 | 88,5 % en 3,15 | 93,0 % en 2,67 | 85,5 % en 3,33 |
| Syndrome du cœur brisé | cardiologie | 1 | 13,9 % en 5,75 | 98,4 % en 2,62 | 93,9 % en 3,62 | 96,7 % en 2,85 | 100,0 % en 3,14 |
| Hypotension orthostatique | cardiologie | 2 | 9,9 % en 5,40 | 97,4 % en 2,64 | 90,4 % en 3,32 | 96,6 % en 2,79 | 93,7 % en 3,43 |
| Varices | cardiologie | 2 | 6,3 % en 6,63 | 94,3 % en 2,78 | 98,5 % en 3,48 | 94,9 % en 2,79 | 100,0 % en 3,41 |
| Phlébite | cardiologie | 2 | 5,7 % en 4,25 | 90,8 % en 2,56 | 87,7 % en 3,18 | 92,6 % en 2,76 | 95,2 % en 2,99 |
| Embolie pulmonaire | cardiologie | 1 | 1,5 % en 4,60 | 87,0 % en 2,91 | 87,3 % en 3,05 | 78,1 % en 3,28 | 88,2 % en 3,43 |
| Souffle au cœur | cardiologie | 2 | 6,3 % en 5,96 | 97,2 % en 2,81 | 97,2 % en 3,37 | 97,5 % en 2,64 | 97,5 % en 3,27 |
| Œdème aigu du poumon | cardiologie | 1 | 0,0 % en 4,29 | 91,5 % en 2,92 | 85,2 % en 3,33 | 94,5 % en 3,40 | 84,8 % en 3,48 |
| Malaise cardiaque | cardiologie | 3 | 5,2 % en 5,32 | 95,3 % en 2,58 | 94,4 % en 3,41 | 98,4 % en 2,61 | 97,4 % en 3,30 |
| Cardiomyopathie | cardiologie | 1 | 5,2 % en 4,47 | 98,0 % en 2,52 | 79,2 % en 3,51 | 94,9 % en 2,47 | 87,5 % en 3,11 |
| Suivi de greffe cardiaque | cardiologie | 1 | 1,7 % en 5,45 | 91,4 % en 2,87 | 87,8 % en 3,26 | 97,1 % en 2,50 | 90,4 % en 3,56 |
| Phobie des blouses blanches | psychiatrie | 2 | 6,7 % en 5,33 | 96,8 % en 2,67 | 93,0 % en 3,30 | 94,9 % en 2,78 | 93,3 % en 3,06 |
| Hypocondrie aiguë | psychiatrie | 2 | 3,6 % en 5,39 | 97,4 % en 2,79 | 96,6 % en 3,41 | 89,1 % en 2,69 | 97,4 % en 3,26 |
| Crise d'angoisse | psychiatrie | 2 | 5,6 % en 4,26 | 87,1 % en 2,61 | 90,4 % en 3,18 | 92,1 % en 2,48 | 90,8 % en 3,29 |
| Dépression légère | psychiatrie | 2 | 6,9 % en 6,37 | 96,4 % en 2,78 | 99,1 % en 3,60 | 96,9 % en 2,79 | 99,2 % en 3,25 |
| Trouble du sommeil | psychiatrie | 2 | 5,1 % en 6,08 | 94,0 % en 2,87 | 97,3 % en 2,81 | 94,2 % en 2,80 | 98,9 % en 3,29 |
| Anxiété généralisée | psychiatrie | 2 | 7,7 % en 4,92 | 92,7 % en 2,85 | 88,3 % en 3,42 | 97,3 % en 2,84 | 96,7 % en 3,00 |
| Attaque de panique | psychiatrie | 2 | 3,7 % en 3,54 | 82,3 % en 2,36 | 80,0 % en 2,94 | 72,5 % en 2,45 | 77,3 % en 3,01 |
| Trouble obsessionnel compulsif léger | psychiatrie | 1 | 8,1 % en 5,97 | 96,8 % en 2,76 | 100,0 % en 3,64 | 98,6 % en 2,60 | 100,0 % en 3,30 |
| Phobie des escaliers | psychiatrie | 1 | 11,7 % en 4,73 | 100,0 % en 2,76 | 89,9 % en 3,55 | 92,2 % en 2,96 | 98,5 % en 3,05 |
| Syndrome de Paris | psychiatrie | 1 | 1,8 % en 6,21 | 96,6 % en 2,63 | 95,9 % en 3,02 | 97,0 % en 2,70 | 96,1 % en 3,29 |
| Burn-out | psychiatrie | 1 | 4,6 % en 5,32 | 95,8 % en 2,71 | 89,6 % en 3,42 | 93,0 % en 2,93 | 92,4 % en 3,29 |
| Addiction aux écrans | psychiatrie | 1 | 0,0 % en 5,63 | 90,2 % en 3,51 | 91,2 % en 3,38 | 96,8 % en 3,50 | 95,4 % en 3,20 |
| Cauchemars répétés | psychiatrie | 2 | 7,4 % en 5,65 | 95,2 % en 2,76 | 99,2 % en 3,48 | 93,3 % en 2,70 | 99,2 % en 3,03 |
| Mutisme sélectif | psychiatrie | 1 | 15,3 % en 6,58 | 92,7 % en 2,83 | 98,5 % en 3,48 | 96,7 % en 2,82 | 97,0 % en 3,33 |
| Trouble alimentaire léger | psychiatrie | 2 | 3,7 % en 4,22 | 95,5 % en 2,49 | 80,0 % en 3,22 | 93,3 % en 2,80 | 91,3 % en 2,89 |
| Stress post-traumatique | psychiatrie | 1 | 2,2 % en 5,16 | 94,8 % en 2,53 | 84,2 % en 3,56 | 95,8 % en 2,67 | 95,5 % en 3,27 |
| Jalousie délirante | psychiatrie | 1 | 7,5 % en 4,39 | 92,2 % en 2,71 | 86,7 % en 3,02 | 94,0 % en 2,66 | 84,4 % en 3,19 |
| Insomnie chronique | psychiatrie | 2 | 4,8 % en 4,61 | 93,6 % en 2,51 | 87,4 % en 3,24 | 89,6 % en 2,63 | 89,2 % en 3,18 |
| Dépendance à la caféine | psychiatrie | 1 | 10,5 % en 5,19 | 96,4 % en 2,70 | 100,0 % en 3,30 | 90,2 % en 2,80 | 100,0 % en 3,02 |
| Crise de rire incontrôlée | psychiatrie | 1 | 10,6 % en 5,91 | 92,9 % en 2,95 | 95,6 % en 3,33 | 95,5 % en 2,69 | 98,7 % en 3,16 |
| Fracture ouverte | orthopedie | 2 | 0,0 % en 3,99 | 85,2 % en 2,75 | 83,9 % en 3,31 | 83,6 % en 2,84 | 87,0 % en 3,10 |
| Fracture fermée | orthopedie | 2 | 7,8 % en 4,23 | 90,2 % en 2,75 | 93,3 % en 3,24 | 91,5 % en 2,75 | 96,3 % en 3,13 |
| Entorse de la cheville | orthopedie | 3 | 2,4 % en 5,03 | 91,2 % en 3,12 | 94,6 % en 3,64 | 96,6 % en 3,16 | 97,3 % en 3,31 |
| Entorse du genou | orthopedie | 2 | 6,5 % en 4,32 | 83,6 % en 3,07 | 89,2 % en 3,13 | 86,1 % en 3,16 | 93,6 % en 3,09 |
| Luxation de l'épaule | orthopedie | 2 | 0,0 % en 3,64 | 76,3 % en 2,86 | 78,9 % en 3,25 | 79,5 % en 3,10 | 90,0 % en 2,92 |
| Lumbago | orthopedie | 3 | 4,7 % en 3,81 | 93,0 % en 2,65 | 94,5 % en 3,56 | 91,7 % en 2,71 | 97,8 % en 3,18 |
| Sciatique | orthopedie | 2 | 4,3 % en 3,65 | 89,1 % en 2,69 | 89,9 % en 3,13 | 90,6 % en 2,70 | 93,8 % en 2,91 |
| Hernie discale | orthopedie | 1 | 7,7 % en 3,46 | 97,1 % en 2,54 | 90,3 % en 3,08 | 86,6 % en 2,73 | 90,3 % en 3,16 |
| Fracture du poignet | orthopedie | 2 | 4,4 % en 3,57 | 92,2 % en 2,62 | 82,7 % en 3,38 | 90,5 % en 2,70 | 86,4 % en 3,25 |
| Rupture du ligament croisé | orthopedie | 1 | 3,4 % en 4,33 | 95,3 % en 2,47 | 90,0 % en 3,20 | 95,6 % en 2,60 | 94,5 % en 3,33 |
| Scoliose | orthopedie | 1 | 9,0 % en 5,48 | 96,4 % en 3,02 | 98,3 % en 3,56 | 96,2 % en 2,81 | 100,0 % en 3,23 |
| Arthrose du genou | orthopedie | 2 | 7,0 % en 4,21 | 93,4 % en 2,73 | 89,8 % en 3,48 | 96,0 % en 2,79 | 96,9 % en 3,06 |
| Syndrome du canal carpien | orthopedie | 2 | 6,0 % en 4,42 | 90,4 % en 2,84 | 94,6 % en 3,57 | 96,3 % en 2,68 | 98,3 % en 3,40 |
| Épaule gelée | orthopedie | 1 | 7,5 % en 5,08 | 96,9 % en 2,80 | 98,4 % en 3,56 | 96,7 % en 3,02 | 98,6 % en 3,13 |
| Hallux valgus | orthopedie | 2 | 5,3 % en 4,34 | 94,3 % en 2,86 | 97,2 % en 3,39 | 95,3 % en 2,78 | 97,4 % en 3,33 |
| Fracture du fémur | orthopedie | 1 | 0,0 % en 4,13 | 81,7 % en 2,82 | 79,7 % en 3,08 | 89,7 % en 2,79 | 93,8 % en 2,95 |
| Périostite tibiale | orthopedie | 2 | 6,2 % en 5,11 | 91,7 % en 3,29 | 95,1 % en 3,44 | 96,9 % en 3,09 | 96,8 % en 3,45 |
| Torticolis congénital | orthopedie | 1 | 6,7 % en 4,42 | 97,8 % en 2,50 | 93,5 % en 3,61 | 93,8 % en 2,58 | 100,0 % en 3,30 |
| Ostéoporose | orthopedie | 1 | 14,5 % en 4,60 | 93,3 % en 2,87 | 97,8 % en 3,63 | 93,0 % en 2,83 | 96,8 % en 3,23 |
| Contusion sévère | orthopedie | 2 | 4,3 % en 4,44 | 86,5 % en 2,92 | 83,5 % en 3,24 | 89,6 % en 3,09 | 95,2 % en 3,14 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 4,61 | 87,7 % en 3,02 | 87,7 % en 3,28 | 88,0 % en 3,00 | 87,8 % en 3,22 |
| Possession légère | paranormal | 1 | 0,0 % en 4,74 | 90,3 % en 3,21 | 84,4 % en 3,05 | 94,5 % en 2,98 | 89,7 % en 3,21 |
| Vampirisme aigu | paranormal | 1 | 6,6 % en 4,70 | 90,0 % en 2,72 | 84,8 % en 3,21 | 92,1 % en 2,65 | 88,1 % en 3,06 |
| Lycanthropie | paranormal | 1 | 2,8 % en 4,11 | 90,6 % en 2,61 | 78,3 % en 3,00 | 94,0 % en 2,63 | 89,8 % en 2,92 |
| Mauvais œil | paranormal | 2 | 0,0 % en 4,39 | 85,2 % en 2,91 | 84,3 % en 3,33 | 91,5 % en 2,80 | 88,1 % en 3,19 |
| Âme en double | paranormal | 1 | 10,8 % en 5,06 | 95,1 % en 2,48 | 94,1 % en 2,87 | 96,2 % en 2,62 | 94,1 % en 3,22 |
| Malédiction des miroirs | paranormal | 1 | 0,0 % en 4,56 | 83,6 % en 3,21 | 83,1 % en 3,37 | 87,3 % en 3,49 | 89,6 % en 3,19 |
| Fièvre des étoiles | paranormal | 1 | 7,5 % en 4,08 | 87,0 % en 2,76 | 95,3 % en 3,14 | 89,9 % en 2,63 | 88,9 % en 3,05 |
| Murmures dans la tête | paranormal | 2 | 0,0 % en 4,67 | 90,8 % en 2,99 | 84,8 % en 3,29 | 94,4 % en 3,11 | 88,6 % en 3,23 |
| Ombre qui suit | paranormal | 2 | 5,6 % en 4,22 | 90,2 % en 2,83 | 89,3 % en 3,12 | 90,9 % en 2,58 | 88,2 % en 3,03 |
| Pétrification partielle | paranormal | 1 | 2,3 % en 4,00 | 88,7 % en 2,47 | 87,9 % en 3,33 | 87,8 % en 2,57 | 89,8 % en 2,98 |
| Rire des cimetières | paranormal | 1 | 5,2 % en 5,16 | 91,7 % en 2,68 | 92,3 % en 3,08 | 97,1 % en 2,67 | 95,5 % en 3,30 |
| Main froide éternelle | paranormal | 2 | 12,0 % en 5,64 | 97,1 % en 2,65 | 97,6 % en 3,33 | 97,4 % en 2,79 | 97,6 % en 3,44 |
| Voix du passé | paranormal | 1 | 0,0 % en 5,27 | 88,9 % en 2,95 | 89,6 % en 3,45 | 94,6 % en 3,16 | 96,6 % en 3,19 |
| Malédiction du nombre 7 | paranormal | 1 | 0,0 % en 4,68 | 93,2 % en 2,70 | 88,5 % en 3,21 | 90,9 % en 3,05 | 93,1 % en 3,19 |
| Nez qui saigne de l'encre | paranormal | 1 | 1,5 % en 4,34 | 90,9 % en 2,43 | 85,2 % en 3,21 | 93,0 % en 2,74 | 85,5 % en 3,24 |
| Glissement temporel | paranormal | 1 | 8,2 % en 3,97 | 93,8 % en 2,59 | 84,1 % en 3,19 | 88,9 % en 2,76 | 95,5 % en 3,09 |
| Doigts qui grandissent | paranormal | 1 | 2,7 % en 4,63 | 88,5 % en 2,77 | 85,7 % en 2,98 | 94,4 % en 2,74 | 84,2 % en 3,32 |
| Malédiction du chat noir | paranormal | 1 | 0,0 % en 4,42 | 95,2 % en 2,87 | 83,1 % en 3,12 | 85,2 % en 2,80 | 93,8 % en 3,06 |
| Ombre vivante | paranormal | 1 | 7,7 % en 4,27 | 91,2 % en 2,74 | 92,3 % en 3,04 | 86,2 % en 2,58 | 92,5 % en 2,87 |
