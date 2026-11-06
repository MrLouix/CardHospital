# Rapport de simulation — CardHospital — paquet de base 2.0.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 1 joueur · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 7,8 % | 92,2 % | 0 | 7,65 | 3,80 | 0,67 | -0,94 | -7,20 |
| seuil:60 | Interne | 95,7 % | 4,3 % | 0 | 3,27 | 1,77 | 1,57 | 0,37 | 1,21 |
| seuil:80 | Interne | 95,5 % | 4,5 % | 0 | 3,51 | 2,50 | 1,60 | 0,39 | 1,38 |
| couleur:60 | Interne | 96,7 % | 3,3 % | 0 | 3,23 | 1,73 | 1,59 | 0,40 | 1,30 |
| couleur:80 | Interne | 97,4 % | 2,6 % | 0 | 3,39 | 2,34 | 1,64 | 0,45 | 1,54 |
| hasard | Chirurgien | 5,6 % | 94,4 % | 0 | 5,28 | 2,63 | 1,26 | -1,59 | -8,40 |
| seuil:60 | Chirurgien | 87,6 % | 12,4 % | 0 | 3,04 | 1,67 | 2,44 | 0,12 | 0,36 |
| seuil:80 | Chirurgien | 87,9 % | 12,1 % | 0 | 3,33 | 2,39 | 2,51 | 0,21 | 0,72 |
| couleur:60 | Chirurgien | 89,3 % | 10,7 % | 0 | 3,04 | 1,65 | 2,46 | 0,17 | 0,52 |
| couleur:80 | Chirurgien | 91,1 % | 8,9 % | 0 | 3,24 | 2,25 | 2,57 | 0,30 | 0,98 |
| hasard | Réanimation | 4,2 % | 95,8 % | 0 | 4,21 | 2,12 | 1,84 | -2,26 | -9,50 |
| seuil:60 | Réanimation | 79,9 % | 20,1 % | 0 | 2,82 | 1,56 | 3,28 | -0,16 | -0,45 |
| seuil:80 | Réanimation | 80,8 % | 19,2 % | 0 | 3,12 | 2,25 | 3,39 | 0,05 | 0,15 |
| couleur:60 | Réanimation | 82,2 % | 17,8 % | 0 | 2,82 | 1,56 | 3,33 | -0,09 | -0,24 |
| couleur:80 | Réanimation | 84,5 % | 15,5 % | 0 | 3,10 | 2,19 | 3,46 | 0,13 | 0,41 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -91 | -72 | -53 | -91 | -72 |
| seuil:60 | Interne | 0 | 13 | 20 | -5 | 0 |
| seuil:80 | Interne | 2 | 15 | 20 | -1 | 0 |
| couleur:60 | Interne | 2 | 15 | 20 | -4 | 0 |
| couleur:80 | Interne | 6 | 17 | 20 | -1 | 0 |
| hasard | Chirurgien | -107 | -83 | -64 | -107 | -83 |
| seuil:60 | Chirurgien | -16 | 4 | 18 | -18 | -2 |
| seuil:80 | Chirurgien | -10 | 8 | 20 | -12 | 0 |
| couleur:60 | Chirurgien | -14 | 7 | 20 | -17 | -2 |
| couleur:80 | Chirurgien | -4 | 12 | 20 | -8 | 0 |
| hasard | Réanimation | -114 | -95 | -76 | -114 | -95 |
| seuil:60 | Réanimation | -30 | -3 | 17 | -33 | -7 |
| seuil:80 | Réanimation | -17 | 3 | 17 | -18 | -1 |
| couleur:60 | Réanimation | -26 | 0 | 20 | -27 | -6 |
| couleur:80 | Réanimation | -15 | 6 | 20 | -17 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 2,0 % en 6,34 | 92,2 % en 3,29 | 93,3 % en 3,76 | 96,0 % en 3,53 | 97,1 % en 3,48 |
| Décalage horaire | generale | 2 | 3,0 % en 5,12 | 88,6 % en 3,50 | 92,2 % en 3,62 | 89,6 % en 3,27 | 95,4 % en 3,29 |
| Maux de tête | generale | 2 | 5,2 % en 6,77 | 96,6 % en 3,66 | 94,4 % en 3,75 | 98,3 % en 3,63 | 98,2 % en 3,73 |
| Rhume carabiné | generale | 2 | 4,6 % en 5,97 | 94,5 % en 3,34 | 92,5 % en 3,95 | 95,8 % en 3,27 | 97,9 % en 3,75 |
| Conjonctivite | generale | 2 | 1,0 % en 7,63 | 98,2 % en 3,52 | 97,4 % en 3,96 | 95,7 % en 3,77 | 99,0 % en 3,46 |
| Rage de dents | generale | 1 | 6,8 % en 7,78 | 86,8 % en 3,82 | 100,0 % en 3,87 | 94,2 % en 3,63 | 100,0 % en 3,74 |
| Laryngite | generale | 2 | 2,9 % en 6,94 | 94,8 % en 3,40 | 92,5 % en 3,73 | 99,0 % en 3,64 | 97,0 % en 3,87 |
| Torticolis | generale | 2 | 1,8 % en 6,54 | 91,5 % en 3,40 | 90,1 % en 3,75 | 88,2 % en 3,65 | 98,3 % en 3,51 |
| Carence en vitamine D | generale | 2 | 0,9 % en 7,44 | 95,3 % en 3,37 | 95,4 % en 3,52 | 96,5 % en 3,52 | 95,9 % en 3,46 |
| Fatigue chronique légère | generale | 2 | 4,3 % en 7,55 | 97,1 % en 3,30 | 94,0 % en 3,81 | 97,7 % en 3,59 | 98,1 % en 3,40 |
| Otite moyenne aiguë | generale | 2 | 4,7 % en 6,80 | 92,2 % en 3,52 | 92,3 % en 3,76 | 97,8 % en 3,57 | 93,9 % en 3,48 |
| Sinusite maxillaire | generale | 2 | 4,5 % en 7,29 | 97,1 % en 3,10 | 92,2 % en 3,49 | 97,4 % en 2,98 | 99,1 % en 3,34 |
| Piqûre de moustique infectée | generale | 1 | 7,1 % en 7,13 | 92,1 % en 3,29 | 77,6 % en 4,38 | 93,4 % en 3,30 | 95,5 % en 3,23 |
| Infection urinaire légère | generale | 2 | 5,0 % en 7,83 | 98,4 % en 3,36 | 98,3 % en 3,63 | 99,1 % en 3,12 | 100,0 % en 3,53 |
| Gale | generale | 1 | 6,5 % en 6,61 | 84,5 % en 3,94 | 95,1 % en 4,11 | 92,5 % en 3,28 | 88,7 % en 4,04 |
| Angine bactérienne | generale | 1 | 5,5 % en 7,00 | 92,5 % en 3,43 | 88,9 % en 4,17 | 93,7 % en 3,75 | 91,1 % en 3,71 |
| Bronchite aiguë | generale | 2 | 5,4 % en 7,34 | 93,9 % en 3,66 | 93,8 % en 3,75 | 94,3 % en 3,32 | 94,7 % en 3,52 |
| Gastro virale | generale | 1 | 1,8 % en 7,72 | 93,8 % en 3,95 | 98,3 % en 3,95 | 98,2 % en 3,29 | 94,3 % en 4,09 |
| Hypoglycémie légère | generale | 1 | 6,1 % en 7,31 | 96,5 % en 3,46 | 89,3 % en 4,39 | 93,5 % en 4,00 | 88,7 % en 4,40 |
| Intoxication alimentaire | generale | 1 | 4,4 % en 6,71 | 87,7 % en 3,60 | 86,5 % en 3,77 | 93,2 % en 3,39 | 88,4 % en 4,35 |
| Varicelle | generale | 1 | 3,7 % en 6,46 | 90,6 % en 3,55 | 90,9 % en 4,15 | 92,6 % en 4,06 | 98,4 % en 3,71 |
| Fièvre inexpliquée | generale | 1 | 2,1 % en 7,58 | 84,7 % en 3,83 | 90,0 % en 3,88 | 93,5 % en 3,52 | 95,5 % en 3,30 |
| Rougeole | generale | 1 | 15,6 % en 6,71 | 90,4 % en 3,73 | 91,9 % en 3,63 | 83,3 % en 3,61 | 92,2 % en 3,67 |
| Varices | cardiologie | 3 | 11,7 % en 7,08 | 97,6 % en 2,85 | 95,5 % en 3,47 | 96,1 % en 3,04 | 100,0 % en 3,10 |
| Extrasystoles | cardiologie | 2 | 1,5 % en 6,24 | 88,5 % en 3,06 | 91,9 % en 3,34 | 93,7 % en 2,96 | 95,5 % en 3,26 |
| Souffle au cœur | cardiologie | 3 | 12,4 % en 7,47 | 98,1 % en 3,08 | 99,4 % en 3,39 | 97,9 % en 3,09 | 99,4 % en 3,08 |
| Hypotension orthostatique | cardiologie | 2 | 2,5 % en 7,10 | 94,3 % en 2,83 | 99,0 % en 3,26 | 92,4 % en 3,07 | 98,0 % en 3,28 |
| Syndrome du cœur brisé | cardiologie | 2 | 3,9 % en 10,20 | 95,2 % en 3,32 | 98,2 % en 3,45 | 98,9 % en 3,03 | 100,0 % en 3,53 |
| Hypertension artérielle | cardiologie | 3 | 1,5 % en 7,74 | 95,7 % en 3,10 | 98,0 % en 3,10 | 98,2 % en 3,02 | 97,9 % en 3,10 |
| Bradycardie | cardiologie | 2 | 2,1 % en 8,56 | 96,0 % en 3,34 | 94,3 % en 3,42 | 95,7 % en 3,19 | 95,1 % en 3,23 |
| Tachycardie | cardiologie | 2 | 1,6 % en 7,87 | 91,5 % en 3,21 | 94,7 % en 3,47 | 96,5 % en 3,51 | 95,7 % en 3,48 |
| Phlébite | cardiologie | 2 | 12,4 % en 7,85 | 97,1 % en 3,14 | 94,0 % en 3,25 | 98,3 % en 3,05 | 97,0 % en 3,57 |
| Angor | cardiologie | 2 | 11,6 % en 6,82 | 93,3 % en 3,19 | 94,6 % en 3,57 | 92,5 % en 3,31 | 94,4 % en 3,34 |
| Péricardite | cardiologie | 2 | 12,1 % en 7,16 | 94,5 % en 3,14 | 95,5 % en 3,40 | 95,9 % en 3,27 | 97,5 % en 3,36 |
| Arythmie | cardiologie | 1 | 0,0 % en 8,59 | 96,8 % en 3,26 | 85,0 % en 4,18 | 98,3 % en 3,64 | 93,1 % en 3,36 |
| Fibrillation auriculaire | cardiologie | 2 | 2,6 % en 8,83 | 95,7 % en 3,16 | 100,0 % en 3,48 | 99,0 % en 3,24 | 99,1 % en 3,33 |
| Insuffisance cardiaque | cardiologie | 1 | 22,0 % en 7,06 | 97,4 % en 3,36 | 96,8 % en 3,58 | 93,4 % en 3,20 | 100,0 % en 3,58 |
| Endocardite | cardiologie | 2 | 11,1 % en 7,32 | 97,4 % en 3,22 | 96,5 % en 3,65 | 95,1 % en 3,07 | 97,3 % en 3,46 |
| Cardiomyopathie | cardiologie | 1 | 8,9 % en 7,91 | 93,5 % en 3,15 | 95,1 % en 3,88 | 98,5 % en 3,52 | 95,0 % en 3,72 |
| Rejet de greffe cardiaque | cardiologie | 1 | 17,8 % en 7,11 | 98,1 % en 3,32 | 87,0 % en 4,24 | 95,2 % en 3,37 | 98,2 % en 3,36 |
| Œdème aigu du poumon | cardiologie | 1 | 16,2 % en 6,93 | 100,0 % en 2,91 | 92,2 % en 3,90 | 96,4 % en 3,68 | 95,5 % en 3,64 |
| Infarctus du myocarde | cardiologie | 1 | 14,1 % en 7,41 | 96,7 % en 3,62 | 93,9 % en 3,67 | 92,3 % en 3,56 | 87,3 % en 3,69 |
| Embolie pulmonaire | cardiologie | 1 | 16,0 % en 6,98 | 100,0 % en 3,32 | 91,8 % en 3,67 | 94,3 % en 3,21 | 94,1 % en 3,84 |
| Tics nerveux | psychiatrie | 3 | 12,6 % en 6,74 | 96,4 % en 3,22 | 100,0 % en 3,18 | 97,3 % en 2,90 | 100,0 % en 2,89 |
| Phobie des escaliers | psychiatrie | 2 | 0,9 % en 6,12 | 95,5 % en 3,03 | 92,5 % en 3,50 | 95,2 % en 3,05 | 96,6 % en 3,53 |
| Dépendance à la caféine | psychiatrie | 3 | 2,9 % en 8,56 | 98,4 % en 2,92 | 99,4 % en 3,06 | 98,8 % en 3,13 | 98,8 % en 3,23 |
| Somnambulisme | psychiatrie | 2 | 4,1 % en 6,85 | 96,0 % en 3,53 | 100,0 % en 3,34 | 100,0 % en 3,28 | 98,5 % en 3,26 |
| Cauchemars répétés | psychiatrie | 2 | 0,0 % en 9,36 | 96,3 % en 3,64 | 99,1 % en 3,46 | 99,1 % en 3,12 | 100,0 % en 3,63 |
| Phobie des blouses blanches | psychiatrie | 3 | 15,8 % en 7,01 | 96,7 % en 3,24 | 97,5 % en 3,42 | 98,9 % en 2,87 | 98,2 % en 3,21 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 1,5 % en 7,65 | 94,8 % en 3,12 | 94,0 % en 3,20 | 98,2 % en 3,10 | 97,4 % en 3,23 |
| Hypocondrie aiguë | psychiatrie | 2 | 5,1 % en 7,47 | 95,9 % en 3,38 | 96,1 % en 3,66 | 98,4 % en 3,24 | 98,2 % en 3,16 |
| Agoraphobie | psychiatrie | 2 | 4,5 % en 7,88 | 94,6 % en 3,34 | 95,9 % en 3,30 | 96,5 % en 3,20 | 98,1 % en 3,06 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 4,1 % en 6,85 | 94,4 % en 3,04 | 94,8 % en 3,35 | 96,0 % en 3,19 | 98,3 % en 3,07 |
| Mutisme sélectif | psychiatrie | 2 | 17,8 % en 7,07 | 100,0 % en 3,03 | 95,7 % en 3,47 | 100,0 % en 2,99 | 97,2 % en 3,60 |
| Addiction aux écrans | psychiatrie | 1 | 3,0 % en 8,05 | 100,0 % en 3,17 | 86,7 % en 3,82 | 96,2 % en 3,54 | 95,5 % en 3,70 |
| Syndrome de Paris | psychiatrie | 2 | 13,5 % en 7,94 | 99,0 % en 2,98 | 98,4 % en 3,43 | 99,1 % en 3,20 | 98,6 % en 3,55 |
| Dépression légère | psychiatrie | 1 | 14,6 % en 7,56 | 97,9 % en 3,33 | 95,0 % en 3,33 | 98,0 % en 3,58 | 94,9 % en 3,85 |
| Trouble alimentaire léger | psychiatrie | 2 | 0,9 % en 8,28 | 99,2 % en 3,28 | 94,2 % en 3,69 | 98,5 % en 3,12 | 100,0 % en 3,16 |
| Insomnie chronique | psychiatrie | 1 | 6,0 % en 8,10 | 98,2 % en 3,78 | 91,9 % en 3,94 | 98,0 % en 3,78 | 89,8 % en 4,08 |
| Burn-out | psychiatrie | 1 | 10,3 % en 7,91 | 97,9 % en 3,36 | 100,0 % en 3,89 | 100,0 % en 3,43 | 96,7 % en 3,73 |
| Attaque de panique | psychiatrie | 1 | 10,9 % en 7,38 | 100,0 % en 3,49 | 90,0 % en 3,72 | 97,6 % en 3,51 | 96,7 % en 3,28 |
| Stress post-traumatique | psychiatrie | 1 | 19,1 % en 7,28 | 95,8 % en 3,50 | 96,5 % en 3,37 | 92,6 % en 3,70 | 97,8 % en 3,67 |
| Jalousie délirante | psychiatrie | 1 | 9,8 % en 7,33 | 89,7 % en 3,90 | 93,3 % en 3,78 | 91,8 % en 3,35 | 95,7 % en 3,33 |
| Hallux valgus | orthopedie | 3 | 15,0 % en 7,07 | 97,3 % en 2,97 | 98,8 % en 3,19 | 98,1 % en 2,96 | 99,4 % en 3,38 |
| Périostite tibiale | orthopedie | 2 | 11,4 % en 6,70 | 92,5 % en 2,99 | 98,0 % en 3,23 | 96,2 % en 3,02 | 99,1 % en 3,03 |
| Contusion sévère | orthopedie | 3 | 3,0 % en 10,01 | 97,6 % en 3,22 | 100,0 % en 3,28 | 96,9 % en 3,16 | 99,4 % en 3,16 |
| Entorse de la cheville | orthopedie | 2 | 2,5 % en 8,38 | 99,1 % en 3,29 | 98,3 % en 3,20 | 97,4 % en 3,34 | 99,1 % en 3,12 |
| Syndrome du canal carpien | orthopedie | 2 | 17,0 % en 9,60 | 99,1 % en 3,05 | 98,9 % en 3,81 | 99,1 % en 3,05 | 100,0 % en 3,16 |
| Lumbago | orthopedie | 3 | 14,8 % en 7,68 | 97,0 % en 3,10 | 96,4 % en 3,31 | 97,2 % en 2,97 | 96,9 % en 3,28 |
| Fêlure du coccyx | orthopedie | 2 | 13,0 % en 6,90 | 95,2 % en 3,24 | 95,2 % en 3,38 | 98,9 % en 2,97 | 98,0 % en 3,09 |
| Épaule gelée | orthopedie | 2 | 12,3 % en 8,33 | 99,2 % en 3,19 | 94,3 % en 3,47 | 100,0 % en 2,80 | 99,2 % en 3,41 |
| Entorse du genou | orthopedie | 2 | 1,8 % en 8,84 | 99,0 % en 3,12 | 98,1 % en 3,60 | 98,3 % en 3,26 | 98,2 % en 3,40 |
| Sciatique | orthopedie | 2 | 14,1 % en 7,06 | 93,8 % en 3,36 | 97,3 % en 3,19 | 96,2 % en 3,27 | 100,0 % en 3,19 |
| Scoliose | orthopedie | 2 | 9,6 % en 8,34 | 95,3 % en 3,24 | 96,2 % en 3,34 | 99,1 % en 2,92 | 96,6 % en 3,53 |
| Arthrose du genou | orthopedie | 1 | 15,8 % en 8,04 | 98,2 % en 3,71 | 94,2 % en 3,43 | 100,0 % en 3,82 | 96,4 % en 3,60 |
| Ostéoporose | orthopedie | 2 | 15,3 % en 9,05 | 99,2 % en 3,26 | 97,3 % en 3,54 | 98,4 % en 3,19 | 100,0 % en 3,23 |
| Fracture du poignet | orthopedie | 1 | 2,0 % en 8,86 | 95,8 % en 3,20 | 98,5 % en 3,52 | 100,0 % en 3,22 | 98,2 % en 3,68 |
| Fracture fermée | orthopedie | 2 | 4,9 % en 8,43 | 93,8 % en 3,22 | 94,1 % en 3,39 | 99,0 % en 2,90 | 97,3 % en 3,25 |
| Luxation de l'épaule | orthopedie | 1 | 1,9 % en 8,94 | 98,0 % en 3,33 | 95,3 % en 3,58 | 100,0 % en 3,46 | 96,3 % en 3,52 |
| Hernie discale | orthopedie | 1 | 0,0 % en 6,53 | 92,9 % en 3,30 | 84,9 % en 3,89 | 95,1 % en 3,02 | 94,9 % en 3,34 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,82 | 87,5 % en 3,42 | 87,7 % en 3,72 | 80,3 % en 3,44 | 97,0 % en 3,15 |
| Fracture ouverte | orthopedie | 1 | 0,0 % en 6,43 | 96,1 % en 3,12 | 91,9 % en 3,68 | 87,5 % en 3,55 | 93,9 % en 3,52 |
| Fracture du fémur | orthopedie | 1 | 0,0 % en 5,84 | 96,9 % en 3,05 | 91,7 % en 3,57 | 82,1 % en 3,45 | 90,2 % en 3,77 |
| Main froide éternelle | paranormal | 3 | 17,6 % en 7,55 | 97,7 % en 3,14 | 98,8 % en 3,24 | 96,7 % en 3,00 | 98,8 % en 3,26 |
| Rire des cimetières | paranormal | 2 | 12,4 % en 6,29 | 96,8 % en 3,10 | 93,6 % en 3,45 | 93,6 % en 3,23 | 96,7 % en 3,31 |
| Doigts qui grandissent | paranormal | 3 | 18,4 % en 8,67 | 98,1 % en 2,92 | 99,5 % en 3,22 | 98,9 % en 2,96 | 99,3 % en 3,26 |
| Malédiction du lundi | paranormal | 2 | 1,8 % en 8,02 | 93,9 % en 3,15 | 98,4 % en 3,28 | 97,2 % en 3,31 | 96,7 % en 3,33 |
| Nez qui saigne de l'encre | paranormal | 2 | 22,7 % en 8,94 | 98,0 % en 3,29 | 100,0 % en 3,38 | 98,0 % en 3,26 | 100,0 % en 3,32 |
| Mauvais œil | paranormal | 3 | 2,3 % en 7,77 | 96,0 % en 3,23 | 98,2 % en 3,11 | 98,8 % en 2,93 | 98,8 % en 3,12 |
| Malédiction des miroirs | paranormal | 2 | 0,9 % en 7,48 | 96,9 % en 3,02 | 93,6 % en 3,22 | 94,2 % en 3,09 | 97,0 % en 3,28 |
| Malédiction du chat noir | paranormal | 2 | 2,3 % en 8,94 | 96,9 % en 2,85 | 96,3 % en 3,55 | 100,0 % en 3,24 | 97,2 % en 3,44 |
| Malédiction du nombre 7 | paranormal | 2 | 1,8 % en 8,80 | 100,0 % en 3,17 | 99,0 % en 3,19 | 99,0 % en 3,05 | 99,2 % en 3,13 |
| Ombre qui suit | paranormal | 2 | 18,6 % en 7,12 | 95,4 % en 3,45 | 94,6 % en 3,31 | 98,3 % en 2,93 | 93,5 % en 3,64 |
| Brûlure lunaire | paranormal | 2 | 10,9 % en 7,73 | 97,1 % en 2,95 | 98,0 % en 3,27 | 99,0 % en 3,04 | 99,0 % en 3,24 |
| Âme en double | paranormal | 1 | 3,2 % en 9,03 | 93,5 % en 3,65 | 89,4 % en 4,00 | 93,2 % en 3,25 | 96,2 % en 3,92 |
| Voix du passé | paranormal | 2 | 1,9 % en 9,50 | 97,3 % en 3,51 | 98,9 % en 3,76 | 100,0 % en 3,05 | 98,1 % en 3,45 |
| Murmures dans la tête | paranormal | 1 | 3,9 % en 8,61 | 93,0 % en 4,02 | 90,5 % en 3,86 | 100,0 % en 2,98 | 98,4 % en 3,53 |
| Poltergeist domestique | paranormal | 2 | 21,0 % en 7,50 | 96,4 % en 3,38 | 98,3 % en 3,48 | 98,3 % en 3,35 | 99,1 % en 3,38 |
| Vampirisme aigu | paranormal | 1 | 10,6 % en 8,68 | 90,0 % en 3,70 | 89,1 % en 4,04 | 100,0 % en 3,71 | 94,4 % en 3,74 |
| Pétrification partielle | paranormal | 1 | 18,9 % en 8,51 | 92,3 % en 3,58 | 98,4 % en 3,18 | 100,0 % en 3,51 | 96,8 % en 3,45 |
| Possession légère | paranormal | 1 | 1,6 % en 8,72 | 96,4 % en 3,14 | 91,8 % en 3,67 | 98,3 % en 3,36 | 100,0 % en 3,19 |
| Lycanthropie | paranormal | 1 | 12,7 % en 7,75 | 96,7 % en 3,37 | 98,0 % en 3,37 | 100,0 % en 3,46 | 93,5 % en 3,76 |
| Glissement temporel | paranormal | 1 | 12,7 % en 7,71 | 88,6 % en 3,32 | 92,0 % en 4,22 | 94,4 % en 4,02 | 95,6 % en 3,98 |
