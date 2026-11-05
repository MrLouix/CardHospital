# Rapport de simulation — CardHospital — paquet de base 1.0.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 4,7 % | 95,3 % | 0 | 4,47 | 2,24 | 0,63 | -1,10 | -4,93 |
| seuil:60 | Interne | 94,1 % | 5,9 % | 0 | 2,54 | 1,35 | 1,67 | 0,58 | 1,46 |
| seuil:80 | Interne | 96,8 % | 3,2 % | 0 | 2,80 | 1,80 | 1,70 | 0,63 | 1,77 |
| couleur:60 | Interne | 95,3 % | 4,7 % | 0 | 2,54 | 1,34 | 1,69 | 0,60 | 1,53 |
| couleur:80 | Interne | 97,6 % | 2,4 % | 0 | 2,74 | 1,74 | 1,72 | 0,66 | 1,82 |
| hasard | Chirurgien | 3,1 % | 96,9 % | 0 | 2,95 | 1,47 | 0,64 | -2,43 | -7,16 |
| seuil:60 | Chirurgien | 82,5 % | 17,5 % | 0 | 2,28 | 1,24 | 2,02 | 0,54 | 1,23 |
| seuil:80 | Chirurgien | 87,9 % | 12,1 % | 0 | 2,62 | 1,71 | 2,01 | 0,76 | 1,98 |
| couleur:60 | Chirurgien | 82,8 % | 17,2 % | 0 | 2,28 | 1,24 | 2,03 | 0,56 | 1,27 |
| couleur:80 | Chirurgien | 89,8 % | 10,2 % | 0 | 2,59 | 1,67 | 2,04 | 0,83 | 2,14 |
| hasard | Réanimation | 2,8 % | 97,2 % | 0 | 2,63 | 1,32 | 1,26 | -2,99 | -7,87 |
| seuil:60 | Réanimation | 81,5 % | 18,5 % | 0 | 2,19 | 1,17 | 2,98 | 0,81 | 1,79 |
| seuil:80 | Réanimation | 84,0 % | 16,0 % | 0 | 2,55 | 1,69 | 2,99 | 0,93 | 2,36 |
| couleur:60 | Réanimation | 81,5 % | 18,5 % | 0 | 2,19 | 1,17 | 2,98 | 0,82 | 1,79 |
| couleur:80 | Réanimation | 86,6 % | 13,4 % | 0 | 2,53 | 1,64 | 3,03 | 1,03 | 2,62 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -58 | -50 | -39 | -58 | -50 |
| seuil:60 | Interne | 5 | 17 | 20 | -5 | 0 |
| seuil:80 | Interne | 11 | 19 | 20 | -2 | 0 |
| couleur:60 | Interne | 6 | 17 | 20 | -4 | 0 |
| couleur:80 | Interne | 13 | 20 | 20 | -1 | 0 |
| hasard | Chirurgien | -81 | -73 | -59 | -81 | -73 |
| seuil:60 | Chirurgien | -10 | 10 | 30 | -15 | -1 |
| seuil:80 | Chirurgien | 4 | 22 | 30 | -7 | 0 |
| couleur:60 | Chirurgien | -10 | 10 | 30 | -15 | -1 |
| couleur:80 | Chirurgien | 6 | 22 | 30 | -6 | 0 |
| hasard | Réanimation | -88 | -80 | -66 | -88 | -80 |
| seuil:60 | Réanimation | -8 | 16 | 40 | -18 | 0 |
| seuil:80 | Réanimation | 0 | 20 | 40 | -10 | 0 |
| couleur:60 | Réanimation | -8 | 16 | 40 | -16 | 0 |
| couleur:80 | Réanimation | 8 | 30 | 40 | -8 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Type | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Angine bactérienne | generale | 3 | 12,1 % en 5,17 | 93,3 % en 2,77 | 97,8 % en 3,01 | 93,3 % en 2,83 | 97,8 % en 3,07 |
| Rhume carabiné | generale | 3 | 4,5 % en 4,07 | 93,0 % en 2,59 | 94,4 % en 2,98 | 91,0 % en 2,51 | 96,7 % en 2,78 |
| Gastro virale | generale | 3 | 6,3 % en 4,68 | 96,9 % en 2,57 | 97,6 % en 2,87 | 97,5 % en 2,37 | 99,4 % en 2,89 |
| Otite moyenne aiguë | generale | 2 | 6,2 % en 4,93 | 95,3 % en 2,72 | 97,9 % en 2,95 | 97,4 % en 2,55 | 99,1 % en 3,04 |
| Infection urinaire légère | generale | 2 | 5,5 % en 4,85 | 96,0 % en 2,61 | 97,3 % en 2,90 | 95,2 % en 2,60 | 98,3 % en 2,70 |
| Conjonctivite | generale | 2 | 5,0 % en 4,75 | 97,4 % en 2,55 | 97,7 % en 2,85 | 96,2 % en 2,70 | 96,2 % en 2,80 |
| Bronchite aiguë | generale | 2 | 7,4 % en 3,98 | 86,9 % en 2,61 | 90,9 % en 2,99 | 86,6 % en 2,75 | 95,1 % en 2,88 |
| Sinusite maxillaire | generale | 2 | 5,7 % en 4,62 | 96,1 % en 2,50 | 98,0 % en 2,92 | 93,8 % en 2,78 | 100,0 % en 2,80 |
| Piqûre de moustique infectée | generale | 2 | 4,3 % en 4,07 | 91,2 % en 2,76 | 95,3 % en 2,90 | 92,7 % en 2,77 | 95,2 % en 2,74 |
| Intoxication alimentaire | generale | 2 | 3,3 % en 3,95 | 89,9 % en 2,63 | 93,6 % en 2,85 | 92,2 % en 2,51 | 92,1 % en 2,76 |
| Maux de tête | generale | 3 | 7,1 % en 4,20 | 87,7 % en 2,65 | 96,5 % en 2,69 | 89,9 % en 2,68 | 97,8 % en 2,87 |
| Maux de gorge | generale | 3 | 3,8 % en 4,87 | 92,8 % en 2,72 | 96,1 % en 3,03 | 97,9 % en 2,65 | 98,2 % en 2,95 |
| Torticolis | generale | 2 | 2,9 % en 4,18 | 95,1 % en 2,44 | 94,8 % en 3,00 | 96,1 % en 2,53 | 96,7 % en 2,79 |
| Fatigue chronique légère | generale | 1 | 5,7 % en 5,45 | 96,6 % en 2,61 | 98,4 % en 2,95 | 94,2 % en 2,74 | 98,0 % en 2,80 |
| Carence en vitamine D | generale | 1 | 4,6 % en 6,74 | 96,9 % en 2,68 | 100,0 % en 2,95 | 98,6 % en 2,74 | 100,0 % en 2,83 |
| Insomnie passagère | generale | 2 | 5,0 % en 4,52 | 91,2 % en 2,83 | 98,2 % en 3,04 | 98,2 % en 2,59 | 96,9 % en 2,77 |
| Migraine légère | generale | 2 | 4,6 % en 3,16 | 79,0 % en 2,40 | 86,3 % en 2,73 | 77,3 % en 2,43 | 85,9 % en 2,70 |
| Hoquet persistant | generale | 1 | 5,0 % en 4,82 | 92,9 % en 2,69 | 96,6 % en 2,79 | 96,4 % en 2,86 | 100,0 % en 3,14 |
| Hypoglycémie légère | generale | 2 | 6,5 % en 4,60 | 93,0 % en 2,68 | 99,2 % en 2,79 | 96,0 % en 2,83 | 99,2 % en 2,72 |
| Fièvre inexpliquée | generale | 1 | 4,2 % en 3,94 | 88,2 % en 2,65 | 83,1 % en 3,23 | 92,1 % en 2,62 | 93,3 % en 2,85 |
| Rougeole | generale | 2 | 0,0 % en 3,84 | 84,7 % en 2,78 | 90,8 % en 3,02 | 86,9 % en 2,82 | 89,0 % en 2,93 |
| Varicelle | generale | 3 | 1,8 % en 3,79 | 84,0 % en 2,74 | 96,0 % en 2,87 | 83,7 % en 2,72 | 91,5 % en 2,91 |
| Gale | generale | 1 | 5,3 % en 3,75 | 80,3 % en 2,95 | 90,5 % en 2,78 | 89,7 % en 2,59 | 98,5 % en 2,94 |
| Hypertension artérielle | cardiologie | 2 | 5,7 % en 4,98 | 95,8 % en 2,49 | 99,0 % en 2,66 | 99,1 % en 2,37 | 98,3 % en 2,71 |
| Arythmie | cardiologie | 2 | 0,0 % en 4,43 | 93,2 % en 2,62 | 92,4 % en 2,79 | 94,2 % en 2,73 | 97,5 % en 2,68 |
| Infarctus du myocarde | cardiologie | 1 | 0,0 % en 4,01 | 95,2 % en 2,60 | 98,6 % en 2,92 | 92,9 % en 2,57 | 96,7 % en 2,63 |
| Angor | cardiologie | 2 | 8,3 % en 4,08 | 98,3 % en 2,26 | 95,5 % en 2,76 | 98,4 % en 2,35 | 97,7 % en 2,60 |
| Insuffisance cardiaque | cardiologie | 1 | 5,7 % en 5,06 | 93,7 % en 2,46 | 98,5 % en 2,80 | 100,0 % en 2,51 | 100,0 % en 2,71 |
| Tachycardie | cardiologie | 2 | 0,0 % en 4,34 | 92,4 % en 2,54 | 92,6 % en 2,76 | 94,0 % en 2,68 | 96,1 % en 2,60 |
| Bradycardie | cardiologie | 1 | 0,0 % en 4,31 | 96,7 % en 2,62 | 96,4 % en 2,78 | 91,1 % en 2,91 | 94,1 % en 2,76 |
| Fibrillation auriculaire | cardiologie | 2 | 0,0 % en 4,93 | 89,0 % en 2,79 | 100,0 % en 2,63 | 98,3 % en 2,65 | 98,3 % en 2,82 |
| Péricardite | cardiologie | 1 | 2,0 % en 4,12 | 94,9 % en 2,39 | 97,5 % en 2,69 | 93,1 % en 2,36 | 96,1 % en 2,80 |
| Endocardite | cardiologie | 1 | 3,9 % en 3,96 | 88,9 % en 2,54 | 98,2 % en 2,54 | 98,5 % en 2,38 | 98,4 % en 2,84 |
| Syndrome du cœur brisé | cardiologie | 1 | 1,9 % en 5,91 | 100,0 % en 2,43 | 98,2 % en 2,72 | 98,1 % en 2,42 | 100,0 % en 2,46 |
| Hypotension orthostatique | cardiologie | 2 | 6,1 % en 4,96 | 97,4 % en 2,34 | 99,2 % en 2,80 | 98,3 % en 2,45 | 99,2 % en 2,76 |
| Varices | cardiologie | 2 | 6,5 % en 6,01 | 100,0 % en 2,54 | 100,0 % en 2,59 | 98,1 % en 2,50 | 100,0 % en 2,65 |
| Phlébite | cardiologie | 2 | 1,9 % en 4,20 | 91,1 % en 2,51 | 96,9 % en 2,81 | 98,1 % en 2,33 | 96,5 % en 2,76 |
| Embolie pulmonaire | cardiologie | 1 | 0,0 % en 4,12 | 93,3 % en 2,67 | 96,8 % en 2,89 | 93,5 % en 2,63 | 98,1 % en 3,07 |
| Souffle au cœur | cardiologie | 2 | 4,3 % en 5,35 | 96,6 % en 2,38 | 100,0 % en 2,90 | 98,5 % en 2,56 | 100,0 % en 2,54 |
| Œdème aigu du poumon | cardiologie | 1 | 0,0 % en 4,16 | 96,2 % en 2,53 | 95,5 % en 2,85 | 88,7 % en 2,97 | 93,6 % en 2,60 |
| Malaise cardiaque | cardiologie | 3 | 9,0 % en 4,87 | 95,4 % en 2,49 | 99,4 % en 2,82 | 96,1 % en 2,45 | 100,0 % en 2,58 |
| Cardiomyopathie | cardiologie | 1 | 5,5 % en 4,11 | 94,8 % en 2,55 | 97,6 % en 2,71 | 92,9 % en 2,55 | 98,1 % en 2,91 |
| Suivi de greffe cardiaque | cardiologie | 1 | 7,3 % en 4,36 | 96,5 % en 2,44 | 100,0 % en 2,74 | 97,7 % en 2,36 | 100,0 % en 2,65 |
| Phobie des blouses blanches | psychiatrie | 2 | 9,4 % en 4,64 | 98,3 % en 2,57 | 96,3 % en 2,84 | 97,5 % en 2,42 | 98,0 % en 2,65 |
| Hypocondrie aiguë | psychiatrie | 2 | 2,6 % en 4,65 | 95,4 % en 2,55 | 99,2 % en 2,77 | 99,1 % en 2,59 | 97,5 % en 2,77 |
| Crise d'angoisse | psychiatrie | 2 | 3,7 % en 3,93 | 97,2 % en 2,41 | 97,5 % en 2,74 | 97,6 % en 2,46 | 97,9 % en 2,77 |
| Dépression légère | psychiatrie | 2 | 6,2 % en 6,15 | 97,3 % en 2,59 | 100,0 % en 3,02 | 98,4 % en 2,43 | 100,0 % en 2,58 |
| Trouble du sommeil | psychiatrie | 2 | 5,6 % en 5,22 | 99,3 % en 2,32 | 100,0 % en 2,53 | 98,2 % en 2,42 | 100,0 % en 2,80 |
| Anxiété généralisée | psychiatrie | 2 | 6,7 % en 4,81 | 97,6 % en 2,39 | 96,9 % en 2,78 | 96,1 % en 2,51 | 99,3 % en 2,76 |
| Attaque de panique | psychiatrie | 2 | 3,4 % en 3,24 | 81,3 % en 2,24 | 90,5 % en 2,62 | 86,4 % en 2,24 | 88,9 % en 2,63 |
| Trouble obsessionnel compulsif léger | psychiatrie | 1 | 5,6 % en 6,00 | 96,7 % en 2,45 | 100,0 % en 3,13 | 100,0 % en 2,29 | 100,0 % en 2,63 |
| Phobie des escaliers | psychiatrie | 1 | 11,3 % en 4,59 | 100,0 % en 2,31 | 98,1 % en 2,81 | 96,8 % en 2,40 | 96,7 % en 2,75 |
| Syndrome de Paris | psychiatrie | 1 | 8,3 % en 5,37 | 95,8 % en 2,33 | 98,2 % en 2,96 | 100,0 % en 2,30 | 97,9 % en 2,67 |
| Burn-out | psychiatrie | 1 | 7,7 % en 4,73 | 96,7 % en 2,44 | 100,0 % en 2,58 | 100,0 % en 2,29 | 100,0 % en 2,48 |
| Addiction aux écrans | psychiatrie | 1 | 0,0 % en 4,86 | 87,8 % en 2,71 | 98,2 % en 2,88 | 96,9 % en 3,08 | 98,2 % en 2,96 |
| Cauchemars répétés | psychiatrie | 2 | 8,7 % en 5,35 | 99,1 % en 2,50 | 99,1 % en 2,80 | 97,4 % en 2,39 | 99,2 % en 2,77 |
| Mutisme sélectif | psychiatrie | 1 | 9,3 % en 5,97 | 98,6 % en 2,54 | 100,0 % en 2,81 | 96,7 % en 2,52 | 100,0 % en 2,78 |
| Trouble alimentaire léger | psychiatrie | 2 | 6,3 % en 3,86 | 92,5 % en 2,44 | 94,7 % en 2,73 | 96,7 % en 2,37 | 98,2 % en 2,67 |
| Stress post-traumatique | psychiatrie | 1 | 1,9 % en 4,85 | 100,0 % en 2,45 | 98,2 % en 2,42 | 100,0 % en 2,34 | 98,5 % en 2,68 |
| Jalousie délirante | psychiatrie | 1 | 3,5 % en 4,11 | 93,0 % en 2,28 | 92,6 % en 2,78 | 96,3 % en 2,43 | 100,0 % en 2,52 |
| Insomnie chronique | psychiatrie | 2 | 1,6 % en 4,15 | 95,5 % en 2,39 | 95,1 % en 2,80 | 98,4 % en 2,40 | 98,4 % en 2,63 |
| Dépendance à la caféine | psychiatrie | 1 | 3,6 % en 4,51 | 97,2 % en 2,39 | 96,6 % en 2,93 | 97,3 % en 2,34 | 100,0 % en 2,49 |
| Crise de rire incontrôlée | psychiatrie | 1 | 5,9 % en 5,43 | 100,0 % en 2,31 | 100,0 % en 2,80 | 100,0 % en 2,20 | 100,0 % en 2,54 |
| Fracture ouverte | orthopedie | 2 | 0,8 % en 3,91 | 91,6 % en 2,63 | 97,5 % en 2,65 | 95,5 % en 2,49 | 95,2 % en 2,70 |
| Fracture fermée | orthopedie | 2 | 7,1 % en 4,21 | 97,5 % en 2,55 | 100,0 % en 2,89 | 99,1 % en 2,45 | 99,2 % en 2,87 |
| Entorse de la cheville | orthopedie | 3 | 6,4 % en 4,82 | 95,8 % en 2,69 | 98,5 % en 2,71 | 98,4 % en 2,60 | 99,4 % en 2,74 |
| Entorse du genou | orthopedie | 2 | 5,9 % en 4,05 | 92,2 % en 2,59 | 98,2 % en 2,74 | 93,8 % en 2,62 | 97,7 % en 2,67 |
| Luxation de l'épaule | orthopedie | 2 | 0,0 % en 3,63 | 93,3 % en 2,46 | 92,7 % en 2,65 | 90,5 % en 2,64 | 99,2 % en 2,73 |
| Lumbago | orthopedie | 3 | 4,0 % en 3,89 | 95,2 % en 2,52 | 98,3 % en 2,69 | 95,6 % en 2,39 | 100,0 % en 2,72 |
| Sciatique | orthopedie | 2 | 3,9 % en 3,63 | 97,1 % en 2,46 | 95,6 % en 2,67 | 93,1 % en 2,55 | 97,6 % en 2,69 |
| Hernie discale | orthopedie | 1 | 7,7 % en 3,56 | 91,7 % en 2,78 | 96,6 % en 2,83 | 91,1 % en 2,48 | 97,7 % en 2,61 |
| Fracture du poignet | orthopedie | 2 | 1,6 % en 3,51 | 94,5 % en 2,57 | 97,0 % en 2,68 | 96,6 % en 2,50 | 97,3 % en 2,74 |
| Rupture du ligament croisé | orthopedie | 1 | 5,0 % en 4,20 | 98,1 % en 2,31 | 96,5 % en 3,02 | 98,2 % en 2,46 | 100,0 % en 2,81 |
| Scoliose | orthopedie | 1 | 7,7 % en 5,68 | 100,0 % en 2,62 | 100,0 % en 2,85 | 98,7 % en 2,43 | 100,0 % en 2,72 |
| Arthrose du genou | orthopedie | 2 | 5,4 % en 4,16 | 97,8 % en 2,47 | 94,7 % en 2,90 | 97,0 % en 2,49 | 97,8 % en 2,76 |
| Syndrome du canal carpien | orthopedie | 2 | 7,4 % en 4,47 | 95,7 % en 2,46 | 99,1 % en 2,86 | 98,4 % en 2,28 | 99,2 % en 2,59 |
| Épaule gelée | orthopedie | 1 | 4,5 % en 4,99 | 92,3 % en 2,46 | 100,0 % en 2,96 | 100,0 % en 2,71 | 100,0 % en 2,68 |
| Hallux valgus | orthopedie | 2 | 4,0 % en 4,62 | 95,0 % en 2,58 | 100,0 % en 2,71 | 97,4 % en 2,43 | 100,0 % en 2,66 |
| Fracture du fémur | orthopedie | 1 | 0,0 % en 4,00 | 94,3 % en 2,57 | 91,7 % en 2,73 | 93,2 % en 2,45 | 100,0 % en 2,57 |
| Périostite tibiale | orthopedie | 2 | 3,3 % en 4,75 | 97,6 % en 2,61 | 99,2 % en 2,63 | 100,0 % en 2,67 | 99,3 % en 2,60 |
| Torticolis congénital | orthopedie | 1 | 3,0 % en 4,46 | 95,0 % en 2,52 | 98,5 % en 2,89 | 96,9 % en 2,49 | 100,0 % en 3,02 |
| Ostéoporose | orthopedie | 1 | 12,2 % en 4,57 | 100,0 % en 2,51 | 100,0 % en 2,62 | 100,0 % en 2,57 | 100,0 % en 2,64 |
| Contusion sévère | orthopedie | 2 | 3,6 % en 4,07 | 93,1 % en 2,61 | 99,2 % en 2,57 | 97,4 % en 2,70 | 97,1 % en 2,66 |
| Malédiction du lundi | paranormal | 2 | 0,0 % en 4,16 | 91,4 % en 2,48 | 96,2 % en 2,83 | 91,3 % en 2,70 | 98,2 % en 2,65 |
| Possession légère | paranormal | 1 | 1,6 % en 3,90 | 98,2 % en 2,39 | 100,0 % en 2,48 | 90,4 % en 2,69 | 98,4 % en 2,44 |
| Vampirisme aigu | paranormal | 1 | 5,5 % en 4,15 | 96,4 % en 2,39 | 98,0 % en 2,67 | 96,0 % en 2,38 | 95,9 % en 2,67 |
| Lycanthropie | paranormal | 1 | 1,9 % en 3,91 | 92,3 % en 2,37 | 94,6 % en 2,64 | 94,5 % en 2,40 | 98,1 % en 2,62 |
| Mauvais œil | paranormal | 2 | 0,0 % en 4,05 | 93,0 % en 2,61 | 89,7 % en 2,79 | 95,0 % en 2,62 | 95,4 % en 2,75 |
| Âme en double | paranormal | 1 | 9,1 % en 4,48 | 95,1 % en 2,41 | 100,0 % en 2,83 | 98,0 % en 2,54 | 97,0 % en 3,00 |
| Malédiction des miroirs | paranormal | 1 | 0,0 % en 4,27 | 94,9 % en 2,46 | 93,8 % en 2,78 | 94,3 % en 2,64 | 96,4 % en 2,93 |
| Fièvre des étoiles | paranormal | 1 | 6,5 % en 4,33 | 89,8 % en 2,46 | 87,5 % en 2,70 | 98,4 % en 2,29 | 98,4 % en 2,64 |
| Murmures dans la tête | paranormal | 2 | 0,0 % en 4,13 | 94,0 % en 2,53 | 98,9 % en 2,84 | 93,5 % en 2,80 | 94,1 % en 2,74 |
| Ombre qui suit | paranormal | 2 | 8,0 % en 3,97 | 94,3 % en 2,43 | 98,4 % en 2,67 | 96,4 % en 2,36 | 95,9 % en 2,73 |
| Pétrification partielle | paranormal | 1 | 4,1 % en 3,84 | 98,1 % en 2,33 | 100,0 % en 2,70 | 97,2 % en 2,37 | 95,7 % en 2,74 |
| Rire des cimetières | paranormal | 1 | 14,0 % en 4,32 | 100,0 % en 2,46 | 100,0 % en 2,87 | 96,2 % en 2,49 | 100,0 % en 2,62 |
| Main froide éternelle | paranormal | 2 | 7,5 % en 5,23 | 99,2 % en 2,46 | 99,2 % en 2,75 | 99,2 % en 2,27 | 99,1 % en 2,77 |
| Voix du passé | paranormal | 1 | 0,0 % en 4,73 | 92,8 % en 2,83 | 94,2 % en 2,99 | 100,0 % en 2,73 | 98,5 % en 2,72 |
| Malédiction du nombre 7 | paranormal | 1 | 0,0 % en 3,96 | 96,2 % en 2,42 | 98,5 % en 2,39 | 92,3 % en 2,75 | 97,0 % en 2,59 |
| Nez qui saigne de l'encre | paranormal | 1 | 3,4 % en 4,16 | 93,3 % en 2,33 | 93,8 % en 2,81 | 98,1 % en 2,43 | 100,0 % en 2,77 |
| Glissement temporel | paranormal | 1 | 4,7 % en 3,81 | 91,2 % en 2,54 | 97,0 % en 2,62 | 95,5 % en 2,40 | 92,9 % en 2,50 |
| Doigts qui grandissent | paranormal | 1 | 9,9 % en 4,25 | 96,6 % en 2,40 | 96,9 % en 2,68 | 94,7 % en 2,56 | 94,8 % en 2,76 |
| Malédiction du chat noir | paranormal | 1 | 0,0 % en 4,12 | 95,4 % en 2,40 | 100,0 % en 2,59 | 96,4 % en 2,46 | 94,4 % en 2,93 |
| Ombre vivante | paranormal | 1 | 9,3 % en 4,04 | 98,3 % en 2,37 | 100,0 % en 2,75 | 95,5 % en 2,42 | 98,4 % en 2,59 |
