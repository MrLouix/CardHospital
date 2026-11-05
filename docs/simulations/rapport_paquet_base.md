# Rapport de simulation — CardHospital — paquet de base 1.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 5,1 % | 94,9 % | 0 | 4,73 | 2,38 | 0,64 | -1,11 | -5,25 |
| seuil:60 | Interne | 93,8 % | 6,2 % | 0 | 2,62 | 1,40 | 1,64 | 0,53 | 1,40 |
| seuil:80 | Interne | 95,2 % | 4,8 % | 0 | 2,93 | 1,95 | 1,65 | 0,57 | 1,66 |
| couleur:60 | Interne | 94,6 % | 5,4 % | 0 | 2,62 | 1,39 | 1,65 | 0,55 | 1,45 |
| couleur:80 | Interne | 96,9 % | 3,1 % | 0 | 2,85 | 1,85 | 1,69 | 0,62 | 1,77 |
| hasard | Chirurgien | 3,1 % | 96,9 % | 0 | 3,15 | 1,57 | 0,64 | -2,37 | -7,44 |
| seuil:60 | Chirurgien | 80,4 % | 19,6 % | 0 | 2,32 | 1,28 | 1,96 | 0,43 | 1,01 |
| seuil:80 | Chirurgien | 85,2 % | 14,8 % | 0 | 2,69 | 1,81 | 1,96 | 0,66 | 1,77 |
| couleur:60 | Chirurgien | 81,0 % | 19,0 % | 0 | 2,32 | 1,27 | 1,98 | 0,46 | 1,06 |
| couleur:80 | Chirurgien | 87,4 % | 12,6 % | 0 | 2,67 | 1,76 | 1,99 | 0,73 | 1,93 |
| hasard | Réanimation | 2,9 % | 97,1 % | 0 | 2,78 | 1,40 | 1,26 | -2,91 | -8,09 |
| seuil:60 | Réanimation | 79,5 % | 20,5 % | 0 | 2,24 | 1,20 | 2,90 | 0,68 | 1,51 |
| seuil:80 | Réanimation | 81,7 % | 18,3 % | 0 | 2,61 | 1,77 | 2,94 | 0,81 | 2,12 |
| couleur:60 | Réanimation | 80,0 % | 20,0 % | 0 | 2,24 | 1,20 | 2,91 | 0,70 | 1,56 |
| couleur:80 | Réanimation | 83,9 % | 16,1 % | 0 | 2,60 | 1,74 | 2,97 | 0,90 | 2,35 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -64 | -53 | -41 | -64 | -53 |
| seuil:60 | Interne | 3 | 15 | 20 | -5 | 0 |
| seuil:80 | Interne | 8 | 19 | 20 | -3 | 0 |
| couleur:60 | Interne | 5 | 16 | 20 | -5 | 0 |
| couleur:80 | Interne | 11 | 19 | 20 | -2 | 0 |
| hasard | Chirurgien | -85 | -76 | -61 | -85 | -76 |
| seuil:60 | Chirurgien | -11 | 10 | 30 | -19 | -2 |
| seuil:80 | Chirurgien | 3 | 22 | 30 | -10 | 0 |
| couleur:60 | Chirurgien | -10 | 10 | 30 | -18 | -1 |
| couleur:80 | Chirurgien | 4 | 22 | 30 | -7 | 0 |
| hasard | Réanimation | -92 | -82 | -66 | -92 | -82 |
| seuil:60 | Réanimation | -10 | 16 | 40 | -20 | 0 |
| seuil:80 | Réanimation | 0 | 20 | 40 | -12 | 0 |
| couleur:60 | Réanimation | -10 | 16 | 40 | -20 | 0 |
| couleur:80 | Réanimation | 0 | 28 | 40 | -10 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Angine bactérienne | generale | 3 | 10,5 % en 5,23 | 94,9 % en 2,95 | 97,7 % en 3,31 | 93,2 % en 2,94 | 99,5 % en 3,10 |
| Rhume carabiné | generale | 3 | 3,3 % en 4,29 | 94,4 % en 2,51 | 93,3 % en 3,02 | 92,9 % en 2,62 | 97,8 % en 2,80 |
| Gastro virale | generale | 3 | 4,0 % en 4,89 | 94,6 % en 2,63 | 93,9 % en 3,43 | 94,9 % en 2,71 | 98,4 % en 2,91 |
| Otite moyenne aiguë | generale | 2 | 1,9 % en 5,15 | 97,7 % en 2,65 | 94,0 % en 2,97 | 96,4 % en 2,74 | 99,1 % en 2,90 |
| Infection urinaire légère | generale | 2 | 5,9 % en 4,53 | 91,8 % en 2,82 | 94,4 % en 3,30 | 96,5 % en 2,57 | 97,4 % en 3,16 |
| Conjonctivite | generale | 2 | 8,3 % en 4,98 | 95,5 % en 2,80 | 93,4 % en 3,12 | 96,0 % en 2,69 | 96,0 % en 3,10 |
| Bronchite aiguë | generale | 2 | 8,1 % en 4,22 | 86,3 % en 2,77 | 94,6 % en 2,89 | 87,0 % en 2,81 | 92,6 % en 2,98 |
| Sinusite maxillaire | generale | 2 | 6,0 % en 5,37 | 97,3 % en 2,67 | 95,7 % en 3,02 | 91,4 % en 2,65 | 98,3 % en 2,78 |
| Piqûre de moustique infectée | generale | 2 | 3,7 % en 4,14 | 91,1 % en 2,61 | 88,7 % en 3,15 | 89,0 % en 2,70 | 96,9 % en 2,69 |
| Intoxication alimentaire | generale | 2 | 3,5 % en 4,40 | 90,4 % en 2,70 | 90,6 % en 3,08 | 90,4 % en 2,69 | 92,0 % en 3,05 |
| Maux de tête | generale | 3 | 2,8 % en 4,22 | 86,7 % en 2,68 | 92,4 % en 3,22 | 90,1 % en 2,71 | 96,3 % en 2,93 |
| Maux de gorge | generale | 3 | 6,1 % en 4,85 | 95,0 % en 2,78 | 96,3 % en 2,99 | 97,3 % en 2,65 | 98,1 % en 3,06 |
| Torticolis | generale | 2 | 4,3 % en 4,37 | 90,8 % en 2,54 | 95,3 % en 2,82 | 93,0 % en 2,62 | 94,2 % en 2,96 |
| Fatigue chronique légère | generale | 1 | 4,4 % en 5,84 | 93,9 % en 2,67 | 100,0 % en 3,02 | 94,3 % en 2,81 | 96,4 % en 3,29 |
| Carence en vitamine D | generale | 1 | 9,0 % en 6,75 | 97,7 % en 2,95 | 100,0 % en 3,00 | 100,0 % en 2,51 | 100,0 % en 2,78 |
| Insomnie passagère | generale | 2 | 9,1 % en 5,00 | 96,3 % en 2,70 | 97,2 % en 3,01 | 94,2 % en 2,60 | 99,1 % en 3,13 |
| Migraine légère | generale | 2 | 6,4 % en 3,42 | 67,2 % en 2,47 | 88,0 % en 2,73 | 72,9 % en 2,49 | 84,9 % en 2,78 |
| Hoquet persistant | generale | 1 | 9,6 % en 5,27 | 98,1 % en 2,52 | 97,0 % en 2,82 | 98,6 % en 2,54 | 100,0 % en 2,89 |
| Hypoglycémie légère | generale | 2 | 7,3 % en 4,73 | 95,7 % en 2,75 | 98,4 % en 3,04 | 94,3 % en 2,86 | 96,9 % en 2,98 |
| Fièvre inexpliquée | generale | 1 | 6,8 % en 4,10 | 90,6 % en 2,55 | 91,7 % en 2,73 | 95,0 % en 2,57 | 94,8 % en 2,67 |
| Rougeole | generale | 2 | 0,8 % en 4,08 | 85,3 % en 2,76 | 88,4 % en 3,13 | 89,8 % en 2,74 | 90,6 % en 2,95 |
| Varicelle | generale | 3 | 2,7 % en 3,99 | 87,8 % en 2,78 | 94,2 % en 2,90 | 89,5 % en 2,80 | 96,0 % en 2,82 |
| Gale | generale | 1 | 1,6 % en 4,00 | 88,5 % en 2,62 | 84,2 % en 3,07 | 88,5 % en 2,79 | 86,5 % en 3,10 |
| Hypertension artérielle | cardiologie | 2 | 11,1 % en 4,86 | 94,2 % en 2,61 | 99,2 % en 2,76 | 97,6 % en 2,36 | 100,0 % en 2,84 |
| Arythmie | cardiologie | 2 | 0,0 % en 4,95 | 93,5 % en 2,69 | 96,9 % en 2,95 | 95,1 % en 2,62 | 97,6 % en 2,86 |
| Infarctus du myocarde | cardiologie | 1 | 0,0 % en 4,50 | 96,3 % en 2,85 | 95,2 % en 2,81 | 90,6 % en 2,97 | 92,6 % en 2,88 |
| Angor | cardiologie | 2 | 5,9 % en 4,49 | 93,1 % en 2,51 | 94,6 % en 2,75 | 97,8 % en 2,47 | 99,2 % en 2,63 |
| Insuffisance cardiaque | cardiologie | 1 | 3,7 % en 4,89 | 98,1 % en 2,44 | 98,2 % en 3,05 | 95,9 % en 2,59 | 98,6 % en 2,79 |
| Tachycardie | cardiologie | 2 | 0,0 % en 4,77 | 93,4 % en 2,66 | 90,4 % en 2,91 | 94,1 % en 2,81 | 95,7 % en 2,75 |
| Bradycardie | cardiologie | 1 | 0,0 % en 4,34 | 90,8 % en 2,65 | 90,7 % en 3,04 | 98,3 % en 2,67 | 89,4 % en 3,23 |
| Fibrillation auriculaire | cardiologie | 2 | 1,0 % en 5,16 | 96,9 % en 2,86 | 97,6 % en 2,97 | 96,5 % en 2,65 | 97,3 % en 3,02 |
| Péricardite | cardiologie | 1 | 6,2 % en 4,32 | 91,1 % en 2,57 | 94,7 % en 2,75 | 92,3 % en 2,48 | 96,1 % en 2,82 |
| Endocardite | cardiologie | 1 | 6,8 % en 3,98 | 94,0 % en 2,48 | 98,3 % en 2,95 | 96,8 % en 2,52 | 100,0 % en 2,78 |
| Syndrome du cœur brisé | cardiologie | 1 | 13,9 % en 5,75 | 96,8 % en 2,38 | 100,0 % en 2,86 | 98,5 % en 2,43 | 100,0 % en 2,85 |
| Hypotension orthostatique | cardiologie | 2 | 9,9 % en 5,40 | 99,2 % en 2,44 | 96,2 % en 2,94 | 95,2 % en 2,63 | 97,5 % en 2,94 |
| Varices | cardiologie | 2 | 6,3 % en 6,63 | 96,6 % en 2,65 | 100,0 % en 2,99 | 97,2 % en 2,41 | 99,2 % en 2,68 |
| Phlébite | cardiologie | 2 | 5,7 % en 4,25 | 96,0 % en 2,43 | 96,2 % en 2,60 | 96,6 % en 2,39 | 95,0 % en 2,88 |
| Embolie pulmonaire | cardiologie | 1 | 1,5 % en 4,60 | 91,5 % en 2,85 | 93,4 % en 2,75 | 92,6 % en 2,72 | 94,5 % en 2,80 |
| Souffle au cœur | cardiologie | 2 | 6,3 % en 5,96 | 95,3 % en 2,52 | 100,0 % en 3,00 | 98,2 % en 2,41 | 100,0 % en 2,89 |
| Œdème aigu du poumon | cardiologie | 1 | 0,0 % en 4,29 | 92,2 % en 2,96 | 94,9 % en 2,92 | 94,1 % en 2,68 | 96,5 % en 2,54 |
| Malaise cardiaque | cardiologie | 3 | 5,2 % en 5,32 | 98,2 % en 2,39 | 96,6 % en 3,00 | 98,5 % en 2,38 | 100,0 % en 2,81 |
| Cardiomyopathie | cardiologie | 1 | 5,2 % en 4,47 | 96,0 % en 2,53 | 92,4 % en 2,77 | 96,1 % en 2,25 | 95,5 % en 2,74 |
| Suivi de greffe cardiaque | cardiologie | 1 | 1,7 % en 5,45 | 98,1 % en 2,54 | 94,7 % en 2,82 | 100,0 % en 2,40 | 95,8 % en 2,75 |
| Phobie des blouses blanches | psychiatrie | 2 | 6,7 % en 5,33 | 96,6 % en 2,58 | 97,3 % en 3,02 | 98,1 % en 2,53 | 96,9 % en 2,82 |
| Hypocondrie aiguë | psychiatrie | 2 | 3,6 % en 5,39 | 92,7 % en 2,81 | 97,0 % en 2,87 | 95,0 % en 2,77 | 99,3 % en 2,80 |
| Crise d'angoisse | psychiatrie | 2 | 5,6 % en 4,26 | 98,0 % en 2,42 | 94,5 % en 2,86 | 93,4 % en 2,51 | 93,7 % en 2,82 |
| Dépression légère | psychiatrie | 2 | 6,9 % en 6,37 | 98,4 % en 2,56 | 99,2 % en 2,91 | 99,2 % en 2,42 | 100,0 % en 2,74 |
| Trouble du sommeil | psychiatrie | 2 | 5,1 % en 6,08 | 95,5 % en 2,57 | 98,5 % en 2,97 | 100,0 % en 2,40 | 100,0 % en 2,78 |
| Anxiété généralisée | psychiatrie | 2 | 7,7 % en 4,92 | 98,2 % en 2,38 | 97,5 % en 2,75 | 97,5 % en 2,44 | 99,1 % en 2,80 |
| Attaque de panique | psychiatrie | 2 | 3,7 % en 3,54 | 85,3 % en 2,24 | 88,7 % en 2,60 | 80,5 % en 2,39 | 92,7 % en 2,63 |
| Trouble obsessionnel compulsif léger | psychiatrie | 1 | 8,1 % en 5,97 | 96,8 % en 2,53 | 98,4 % en 2,86 | 96,3 % en 2,50 | 100,0 % en 2,78 |
| Phobie des escaliers | psychiatrie | 1 | 11,7 % en 4,73 | 100,0 % en 2,55 | 100,0 % en 2,74 | 100,0 % en 2,51 | 100,0 % en 2,75 |
| Syndrome de Paris | psychiatrie | 1 | 1,8 % en 6,21 | 96,7 % en 2,48 | 100,0 % en 3,22 | 100,0 % en 2,48 | 98,3 % en 2,64 |
| Burn-out | psychiatrie | 1 | 4,6 % en 5,32 | 92,9 % en 2,84 | 97,6 % en 2,93 | 100,0 % en 2,59 | 100,0 % en 2,68 |
| Addiction aux écrans | psychiatrie | 1 | 0,0 % en 5,63 | 97,9 % en 3,04 | 91,9 % en 3,06 | 97,4 % en 3,00 | 96,2 % en 2,94 |
| Cauchemars répétés | psychiatrie | 2 | 7,4 % en 5,65 | 98,3 % en 2,67 | 99,1 % en 3,20 | 99,2 % en 2,48 | 100,0 % en 2,89 |
| Mutisme sélectif | psychiatrie | 1 | 15,3 % en 6,58 | 90,9 % en 2,60 | 100,0 % en 2,66 | 100,0 % en 2,40 | 100,0 % en 2,84 |
| Trouble alimentaire léger | psychiatrie | 2 | 3,7 % en 4,22 | 97,3 % en 2,52 | 91,2 % en 2,88 | 92,0 % en 2,60 | 93,9 % en 2,73 |
| Stress post-traumatique | psychiatrie | 1 | 2,2 % en 5,16 | 98,2 % en 2,29 | 96,2 % en 2,94 | 98,4 % en 2,75 | 100,0 % en 2,96 |
| Jalousie délirante | psychiatrie | 1 | 7,5 % en 4,39 | 94,3 % en 2,36 | 96,2 % en 2,75 | 100,0 % en 2,50 | 95,1 % en 2,61 |
| Insomnie chronique | psychiatrie | 2 | 4,8 % en 4,61 | 96,2 % en 2,44 | 94,0 % en 2,79 | 93,4 % en 2,49 | 96,2 % en 2,83 |
| Dépendance à la caféine | psychiatrie | 1 | 10,5 % en 5,19 | 95,5 % en 2,53 | 100,0 % en 2,53 | 93,5 % en 2,57 | 100,0 % en 2,94 |
| Crise de rire incontrôlée | psychiatrie | 1 | 10,6 % en 5,91 | 96,2 % en 2,34 | 100,0 % en 2,87 | 96,4 % en 2,50 | 100,0 % en 2,84 |
| Fracture ouverte | orthopedie | 2 | 0,0 % en 3,99 | 92,6 % en 2,44 | 93,0 % en 2,82 | 81,8 % en 2,71 | 88,7 % en 2,88 |
| Fracture fermée | orthopedie | 2 | 7,8 % en 4,23 | 98,3 % en 2,56 | 98,3 % en 2,82 | 98,4 % en 2,52 | 98,6 % en 2,79 |
| Entorse de la cheville | orthopedie | 3 | 2,4 % en 5,03 | 97,5 % en 2,69 | 98,8 % en 2,79 | 95,8 % en 2,87 | 99,3 % en 2,78 |
| Entorse du genou | orthopedie | 2 | 6,5 % en 4,32 | 90,4 % en 2,70 | 92,1 % en 2,87 | 92,3 % en 2,75 | 94,3 % en 2,88 |
| Luxation de l'épaule | orthopedie | 2 | 0,0 % en 3,64 | 83,5 % en 2,74 | 91,1 % en 2,81 | 86,5 % en 2,81 | 93,5 % en 2,70 |
| Lumbago | orthopedie | 3 | 4,7 % en 3,81 | 97,5 % en 2,51 | 96,3 % en 3,01 | 95,6 % en 2,60 | 99,4 % en 2,86 |
| Sciatique | orthopedie | 2 | 4,3 % en 3,65 | 93,8 % en 2,53 | 95,5 % en 2,86 | 93,6 % en 2,61 | 94,3 % en 2,84 |
| Hernie discale | orthopedie | 1 | 7,7 % en 3,46 | 91,4 % en 2,47 | 93,6 % en 3,00 | 92,5 % en 2,46 | 96,8 % en 2,82 |
| Fracture du poignet | orthopedie | 2 | 4,4 % en 3,57 | 93,7 % en 2,34 | 95,2 % en 2,74 | 93,5 % en 2,47 | 96,4 % en 2,70 |
| Rupture du ligament croisé | orthopedie | 1 | 3,4 % en 4,33 | 94,6 % en 2,57 | 98,2 % en 2,78 | 96,4 % en 2,42 | 96,8 % en 2,76 |
| Scoliose | orthopedie | 1 | 9,0 % en 5,48 | 100,0 % en 2,81 | 95,7 % en 3,17 | 98,4 % en 2,54 | 100,0 % en 2,84 |
| Arthrose du genou | orthopedie | 2 | 7,0 % en 4,21 | 97,3 % en 2,55 | 98,5 % en 2,93 | 98,2 % en 2,49 | 98,4 % en 2,84 |
| Syndrome du canal carpien | orthopedie | 2 | 6,0 % en 4,42 | 99,0 % en 2,45 | 99,1 % en 2,88 | 99,1 % en 2,52 | 99,3 % en 2,76 |
| Épaule gelée | orthopedie | 1 | 7,5 % en 5,08 | 96,0 % en 2,48 | 100,0 % en 2,95 | 94,0 % en 2,69 | 100,0 % en 2,79 |
| Hallux valgus | orthopedie | 2 | 5,3 % en 4,34 | 99,0 % en 2,41 | 95,5 % en 3,07 | 97,6 % en 2,56 | 100,0 % en 2,94 |
| Fracture du fémur | orthopedie | 1 | 0,0 % en 4,13 | 87,9 % en 2,62 | 90,8 % en 2,88 | 89,4 % en 2,74 | 98,2 % en 2,75 |
| Périostite tibiale | orthopedie | 2 | 6,2 % en 5,11 | 95,7 % en 2,88 | 97,8 % en 2,96 | 100,0 % en 2,84 | 98,3 % en 2,95 |
| Torticolis congénital | orthopedie | 1 | 6,7 % en 4,42 | 94,6 % en 2,45 | 98,4 % en 2,93 | 91,9 % en 2,89 | 98,5 % en 2,94 |
| Ostéoporose | orthopedie | 1 | 14,5 % en 4,60 | 92,9 % en 2,96 | 100,0 % en 2,86 | 98,4 % en 2,53 | 100,0 % en 2,70 |
| Contusion sévère | orthopedie | 2 | 4,3 % en 4,44 | 91,4 % en 2,81 | 90,5 % en 2,85 | 97,6 % en 2,67 | 94,4 % en 2,82 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 4,61 | 89,9 % en 2,69 | 99,3 % en 2,80 | 90,5 % en 2,85 | 95,0 % en 2,92 |
| Possession légère | paranormal | 1 | 0,0 % en 4,74 | 96,7 % en 2,78 | 96,2 % en 2,91 | 95,8 % en 2,86 | 100,0 % en 2,53 |
| Vampirisme aigu | paranormal | 1 | 6,6 % en 4,70 | 87,3 % en 2,65 | 91,3 % en 2,84 | 95,7 % en 2,39 | 98,5 % en 2,57 |
| Lycanthropie | paranormal | 1 | 2,8 % en 4,11 | 93,4 % en 2,67 | 87,7 % en 2,69 | 97,8 % en 2,72 | 87,1 % en 2,74 |
| Mauvais œil | paranormal | 2 | 0,0 % en 4,39 | 94,7 % en 2,96 | 89,0 % en 2,94 | 96,5 % en 2,60 | 95,9 % en 3,09 |
| Âme en double | paranormal | 1 | 10,8 % en 5,06 | 92,0 % en 2,38 | 94,7 % en 3,12 | 100,0 % en 2,36 | 98,1 % en 2,81 |
| Malédiction des miroirs | paranormal | 1 | 0,0 % en 4,56 | 96,0 % en 2,86 | 98,1 % en 2,77 | 95,1 % en 2,77 | 96,7 % en 2,80 |
| Fièvre des étoiles | paranormal | 1 | 7,5 % en 4,08 | 91,2 % en 2,58 | 96,2 % en 2,77 | 92,3 % en 2,85 | 97,4 % en 2,69 |
| Murmures dans la tête | paranormal | 2 | 0,0 % en 4,67 | 90,6 % en 2,97 | 91,8 % en 2,99 | 94,2 % en 2,69 | 98,2 % en 2,72 |
| Ombre qui suit | paranormal | 2 | 5,6 % en 4,22 | 92,6 % en 2,49 | 92,8 % en 2,76 | 94,9 % en 2,53 | 97,7 % en 2,77 |
| Pétrification partielle | paranormal | 1 | 2,3 % en 4,00 | 91,4 % en 2,57 | 91,2 % en 2,96 | 95,5 % en 2,55 | 92,9 % en 2,84 |
| Rire des cimetières | paranormal | 1 | 5,2 % en 5,16 | 98,2 % en 2,54 | 97,9 % en 3,17 | 98,6 % en 2,53 | 96,6 % en 2,76 |
| Main froide éternelle | paranormal | 2 | 12,0 % en 5,64 | 97,5 % en 2,73 | 97,8 % en 2,99 | 99,2 % en 2,46 | 99,3 % en 2,84 |
| Voix du passé | paranormal | 1 | 0,0 % en 5,27 | 95,8 % en 2,92 | 94,9 % en 2,90 | 94,2 % en 2,80 | 100,0 % en 2,82 |
| Malédiction du nombre 7 | paranormal | 1 | 0,0 % en 4,68 | 93,2 % en 2,66 | 90,5 % en 2,98 | 95,9 % en 2,80 | 97,0 % en 2,79 |
| Nez qui saigne de l'encre | paranormal | 1 | 1,5 % en 4,34 | 95,0 % en 2,37 | 94,5 % en 3,02 | 93,8 % en 2,50 | 94,9 % en 2,68 |
| Glissement temporel | paranormal | 1 | 8,2 % en 3,97 | 91,3 % en 2,37 | 94,9 % en 2,76 | 89,1 % en 2,55 | 98,4 % en 2,67 |
| Doigts qui grandissent | paranormal | 1 | 2,7 % en 4,63 | 96,8 % en 2,40 | 92,1 % en 2,86 | 92,9 % en 2,61 | 96,8 % en 2,71 |
| Malédiction du chat noir | paranormal | 1 | 0,0 % en 4,42 | 96,4 % en 2,75 | 95,4 % en 2,86 | 94,8 % en 2,74 | 98,3 % en 2,83 |
| Ombre vivante | paranormal | 1 | 7,7 % en 4,27 | 93,1 % en 2,47 | 92,2 % en 2,80 | 98,0 % en 2,47 | 95,6 % en 2,76 |
