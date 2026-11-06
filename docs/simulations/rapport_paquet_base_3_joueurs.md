# Rapport de simulation — CardHospital — paquet de base 2.0.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 3 joueurs à tour de rôle · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard · partage | Interne | 7,8 % | 92,2 % | 0 | 7,65 | 3,80 | 0,67 | -0,94 | -7,20 |
| seuil:70 · partage | Interne | 96,6 % | 3,4 % | 0 | 3,24 | 2,01 | 1,63 | 0,44 | 1,42 |
| couleur:70 · partage | Interne | 98,2 % | 1,8 % | 0 | 3,19 | 1,95 | 1,66 | 0,48 | 1,53 |
| hasard · privé | Interne | 8,1 % | 91,9 % | 0 | 7,64 | 3,83 | 0,67 | -0,94 | -7,19 |
| seuil:70 · privé | Interne | 96,6 % | 3,4 % | 0 | 3,38 | 2,15 | 1,60 | 0,44 | 1,50 |
| couleur:70 · privé | Interne | 97,4 % | 2,6 % | 0 | 3,34 | 2,10 | 1,62 | 0,46 | 1,55 |
| hasard · partage | Chirurgien | 5,6 % | 94,4 % | 0 | 5,28 | 2,63 | 1,26 | -1,59 | -8,40 |
| seuil:70 · partage | Chirurgien | 90,7 % | 9,3 % | 0 | 3,09 | 1,94 | 2,55 | 0,26 | 0,81 |
| couleur:70 · partage | Chirurgien | 92,8 % | 7,2 % | 0 | 3,04 | 1,87 | 2,59 | 0,33 | 1,00 |
| hasard · privé | Chirurgien | 5,6 % | 94,4 % | 0 | 5,27 | 2,63 | 1,26 | -1,59 | -8,38 |
| seuil:70 · privé | Chirurgien | 90,1 % | 9,9 % | 0 | 3,23 | 2,08 | 2,51 | 0,28 | 0,90 |
| couleur:70 · privé | Chirurgien | 91,8 % | 8,2 % | 0 | 3,19 | 2,02 | 2,54 | 0,32 | 1,02 |
| hasard · partage | Réanimation | 4,2 % | 95,8 % | 0 | 4,21 | 2,12 | 1,84 | -2,26 | -9,50 |
| seuil:70 · partage | Réanimation | 83,7 % | 16,3 % | 0 | 2,91 | 1,85 | 3,42 | 0,05 | 0,14 |
| couleur:70 · partage | Réanimation | 84,9 % | 15,1 % | 0 | 2,91 | 1,81 | 3,43 | 0,07 | 0,21 |
| hasard · privé | Réanimation | 4,3 % | 95,7 % | 0 | 4,17 | 2,09 | 1,83 | -2,29 | -9,54 |
| seuil:70 · privé | Réanimation | 84,1 % | 15,9 % | 0 | 3,04 | 1,98 | 3,40 | 0,12 | 0,36 |
| couleur:70 · privé | Réanimation | 85,8 % | 14,2 % | 0 | 3,05 | 1,96 | 3,43 | 0,15 | 0,44 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard · partage | Interne | -91 | -72 | -53 | -91 | -72 |
| seuil:70 · partage | Interne | 3 | 16 | 20 | -3 | 0 |
| couleur:70 · partage | Interne | 6 | 17 | 20 | -1 | 0 |
| hasard · privé | Interne | -92 | -72 | -52 | -92 | -72 |
| seuil:70 · privé | Interne | 5 | 17 | 20 | -2 | 0 |
| couleur:70 · privé | Interne | 6 | 17 | 20 | -2 | 0 |
| hasard · partage | Chirurgien | -107 | -83 | -64 | -107 | -83 |
| seuil:70 · partage | Chirurgien | -8 | 10 | 20 | -10 | 0 |
| couleur:70 · partage | Chirurgien | -6 | 12 | 20 | -8 | 0 |
| hasard · privé | Chirurgien | -106 | -84 | -64 | -106 | -84 |
| seuil:70 · privé | Chirurgien | -7 | 10 | 20 | -10 | 0 |
| couleur:70 · privé | Chirurgien | -6 | 12 | 20 | -9 | 0 |
| hasard · partage | Réanimation | -114 | -95 | -76 | -114 | -95 |
| seuil:70 · partage | Réanimation | -23 | 3 | 20 | -24 | -2 |
| couleur:70 · partage | Réanimation | -19 | 3 | 20 | -21 | -2 |
| hasard · privé | Réanimation | -116 | -95 | -77 | -116 | -95 |
| seuil:70 · privé | Réanimation | -17 | 4 | 20 | -19 | -1 |
| couleur:70 · privé | Réanimation | -17 | 6 | 20 | -18 | -1 |

## Joueurs

« Par un autre » : part des guérisons faites par un joueur qui n'avait pas diagnostiqué le patient, alors qu'un autre l'avait fait. « Écart de pièces » : écart moyen, en fin de partie, entre le joueur le plus riche et le plus pauvre.

| Stratégie | Difficulté | Informations | Guérison | Réputation / patient | Par un autre | Écart de pièces |
|---|---|---|---:|---:|---:|---:|
| hasard · partage | Interne | partagées | 7,8 % | -7,20 | 5,6 % | 4,8 |
| seuil:70 · partage | Interne | partagées | 96,6 % | 1,42 | 73,6 % | 6,2 |
| couleur:70 · partage | Interne | partagées | 98,2 % | 1,53 | 73,2 % | 6,3 |
| hasard · privé | Interne | privées | 8,1 % | -7,19 | 5,5 % | 4,7 |
| seuil:70 · privé | Interne | privées | 96,6 % | 1,50 | 0,0 % | 5,4 |
| couleur:70 · privé | Interne | privées | 97,4 % | 1,55 | 0,0 % | 5,3 |
| hasard · partage | Chirurgien | partagées | 5,6 % | -8,40 | 4,1 % | 7,1 |
| seuil:70 · partage | Chirurgien | partagées | 90,7 % | 0,81 | 76,9 % | 6,8 |
| couleur:70 · partage | Chirurgien | partagées | 92,8 % | 1,00 | 76,1 % | 6,8 |
| hasard · privé | Chirurgien | privées | 5,6 % | -8,38 | 5,3 % | 7,2 |
| seuil:70 · privé | Chirurgien | privées | 90,1 % | 0,90 | 0,0 % | 6,6 |
| couleur:70 · privé | Chirurgien | privées | 91,8 % | 1,02 | 0,0 % | 6,6 |
| hasard · partage | Réanimation | partagées | 4,2 % | -9,50 | 5,4 % | 9,0 |
| seuil:70 · partage | Réanimation | partagées | 83,7 % | 0,14 | 80,5 % | 8,0 |
| couleur:70 · partage | Réanimation | partagées | 84,9 % | 0,21 | 79,7 % | 7,8 |
| hasard · privé | Réanimation | privées | 4,3 % | -9,54 | 6,1 % | 9,1 |
| seuil:70 · privé | Réanimation | privées | 84,1 % | 0,36 | 0,0 % | 8,4 |
| couleur:70 · privé | Réanimation | privées | 85,8 % | 0,44 | 0,0 % | 8,1 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard · partage | seuil:70 · partage | couleur:70 · partage | hasard · privé | seuil:70 · privé | couleur:70 · privé |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| Hoquet persistant | generale | 2 | 2,0 % en 6,34 | 94,4 % en 3,19 | 95,4 % en 3,19 | 4,9 % en 6,35 | 96,2 % en 3,37 | 96,2 % en 3,50 |
| Décalage horaire | generale | 2 | 3,0 % en 5,12 | 95,7 % en 3,10 | 95,5 % en 3,20 | 1,7 % en 5,35 | 87,6 % en 3,59 | 92,5 % en 3,40 |
| Maux de tête | generale | 2 | 5,2 % en 6,77 | 98,5 % en 3,23 | 94,9 % en 3,56 | 5,0 % en 7,75 | 98,9 % en 3,20 | 96,2 % en 3,67 |
| Rhume carabiné | generale | 2 | 4,6 % en 5,97 | 94,9 % en 3,30 | 96,9 % en 3,32 | 6,5 % en 5,82 | 93,8 % en 3,60 | 96,9 % en 3,34 |
| Conjonctivite | generale | 2 | 1,0 % en 7,63 | 98,5 % en 3,44 | 100,0 % en 3,57 | 5,6 % en 7,88 | 100,0 % en 3,56 | 100,0 % en 3,56 |
| Rage de dents | generale | 1 | 6,8 % en 7,78 | 98,0 % en 3,60 | 97,0 % en 3,55 | 3,1 % en 7,39 | 96,5 % en 4,00 | 91,9 % en 3,63 |
| Laryngite | generale | 2 | 2,9 % en 6,94 | 89,3 % en 3,65 | 98,4 % en 3,18 | 2,7 % en 6,88 | 94,9 % en 3,62 | 97,6 % en 3,52 |
| Torticolis | generale | 2 | 1,8 % en 6,54 | 91,8 % en 3,38 | 95,8 % en 3,66 | 4,2 % en 7,04 | 92,9 % en 3,69 | 96,8 % en 3,43 |
| Carence en vitamine D | generale | 2 | 0,9 % en 7,44 | 95,3 % en 3,68 | 96,2 % en 3,21 | 2,6 % en 7,47 | 97,5 % en 3,61 | 94,4 % en 3,58 |
| Fatigue chronique légère | generale | 2 | 4,3 % en 7,55 | 95,8 % en 3,45 | 97,7 % en 3,32 | 2,4 % en 7,57 | 95,9 % en 3,81 | 97,6 % en 3,53 |
| Otite moyenne aiguë | generale | 2 | 4,7 % en 6,80 | 95,9 % en 3,20 | 96,8 % en 3,55 | 4,9 % en 6,70 | 94,8 % en 3,44 | 93,9 % en 3,46 |
| Sinusite maxillaire | generale | 2 | 4,5 % en 7,29 | 100,0 % en 3,17 | 98,1 % en 3,19 | 3,7 % en 7,46 | 98,3 % en 3,52 | 95,8 % en 3,32 |
| Piqûre de moustique infectée | generale | 1 | 7,1 % en 7,13 | 91,7 % en 3,73 | 87,5 % en 3,88 | 7,7 % en 7,51 | 95,0 % en 4,07 | 96,1 % en 3,90 |
| Infection urinaire légère | generale | 2 | 5,0 % en 7,83 | 99,0 % en 3,29 | 99,0 % en 3,47 | 5,7 % en 7,90 | 97,1 % en 3,61 | 100,0 % en 3,66 |
| Gale | generale | 1 | 6,5 % en 6,61 | 98,0 % en 3,12 | 96,4 % en 3,71 | 7,3 % en 6,35 | 91,9 % en 3,84 | 89,7 % en 3,85 |
| Angine bactérienne | generale | 1 | 5,5 % en 7,00 | 89,2 % en 4,02 | 100,0 % en 3,28 | 1,6 % en 7,05 | 90,4 % en 3,88 | 96,2 % en 3,98 |
| Bronchite aiguë | generale | 2 | 5,4 % en 7,34 | 97,4 % en 3,46 | 97,3 % en 3,33 | 0,9 % en 7,75 | 93,4 % en 3,52 | 97,3 % en 3,36 |
| Gastro virale | generale | 1 | 1,8 % en 7,72 | 98,0 % en 4,06 | 92,7 % en 4,05 | 1,9 % en 7,94 | 98,1 % en 3,56 | 94,2 % en 4,12 |
| Hypoglycémie légère | generale | 1 | 6,1 % en 7,31 | 89,2 % en 3,68 | 96,2 % en 4,17 | 1,4 % en 8,24 | 93,9 % en 4,06 | 95,1 % en 3,61 |
| Intoxication alimentaire | generale | 1 | 4,4 % en 6,71 | 87,2 % en 4,28 | 98,0 % en 3,47 | 3,6 % en 7,14 | 94,5 % en 4,04 | 96,3 % en 3,31 |
| Varicelle | generale | 1 | 3,7 % en 6,46 | 87,5 % en 3,17 | 89,8 % en 3,63 | 12,9 % en 6,40 | 93,1 % en 3,91 | 93,7 % en 3,59 |
| Fièvre inexpliquée | generale | 1 | 2,1 % en 7,58 | 90,2 % en 3,85 | 98,4 % en 3,49 | 0,0 % en 7,76 | 98,0 % en 3,55 | 93,1 % en 3,71 |
| Rougeole | generale | 1 | 15,6 % en 6,71 | 94,4 % en 3,33 | 97,9 % en 3,47 | 12,0 % en 6,44 | 86,7 % en 3,95 | 91,1 % en 3,48 |
| Varices | cardiologie | 3 | 11,7 % en 7,08 | 99,4 % en 3,04 | 98,8 % en 2,91 | 9,2 % en 7,19 | 98,1 % en 2,90 | 97,7 % en 3,09 |
| Extrasystoles | cardiologie | 2 | 1,5 % en 6,24 | 95,1 % en 2,97 | 95,5 % en 2,83 | 3,8 % en 5,81 | 96,4 % en 3,30 | 97,4 % en 3,43 |
| Souffle au cœur | cardiologie | 3 | 12,4 % en 7,47 | 98,8 % en 3,03 | 100,0 % en 2,99 | 19,0 % en 7,52 | 97,6 % en 3,43 | 100,0 % en 3,14 |
| Hypotension orthostatique | cardiologie | 2 | 2,5 % en 7,10 | 97,2 % en 3,35 | 95,2 % en 2,81 | 4,3 % en 7,38 | 95,3 % en 3,12 | 96,4 % en 3,25 |
| Syndrome du cœur brisé | cardiologie | 2 | 3,9 % en 10,20 | 99,3 % en 3,38 | 100,0 % en 3,32 | 7,3 % en 8,90 | 98,2 % en 3,26 | 100,0 % en 3,15 |
| Hypertension artérielle | cardiologie | 3 | 1,5 % en 7,74 | 98,8 % en 3,14 | 98,3 % en 3,00 | 7,6 % en 7,70 | 96,9 % en 3,37 | 99,4 % en 3,15 |
| Bradycardie | cardiologie | 2 | 2,1 % en 8,56 | 95,9 % en 3,15 | 100,0 % en 3,13 | 1,1 % en 7,67 | 96,9 % en 3,27 | 99,2 % en 3,06 |
| Tachycardie | cardiologie | 2 | 1,6 % en 7,87 | 97,1 % en 3,17 | 100,0 % en 3,22 | 4,0 % en 8,29 | 97,3 % en 3,50 | 99,1 % en 3,46 |
| Phlébite | cardiologie | 2 | 12,4 % en 7,85 | 98,0 % en 3,11 | 97,2 % en 3,01 | 20,4 % en 6,95 | 99,2 % en 2,92 | 99,0 % en 3,39 |
| Angor | cardiologie | 2 | 11,6 % en 6,82 | 95,0 % en 3,02 | 98,3 % en 2,84 | 11,4 % en 6,96 | 98,5 % en 3,11 | 94,0 % en 3,31 |
| Péricardite | cardiologie | 2 | 12,1 % en 7,16 | 95,5 % en 3,41 | 99,1 % en 3,17 | 18,5 % en 7,46 | 97,4 % en 3,22 | 95,7 % en 3,20 |
| Arythmie | cardiologie | 1 | 0,0 % en 8,59 | 93,8 % en 3,26 | 98,6 % en 3,01 | 3,7 % en 8,80 | 100,0 % en 3,41 | 100,0 % en 3,21 |
| Fibrillation auriculaire | cardiologie | 2 | 2,6 % en 8,83 | 100,0 % en 2,97 | 98,1 % en 3,53 | 0,9 % en 9,07 | 97,2 % en 3,20 | 98,2 % en 3,14 |
| Insuffisance cardiaque | cardiologie | 1 | 22,0 % en 7,06 | 94,9 % en 3,66 | 98,5 % en 3,15 | 12,7 % en 7,60 | 91,8 % en 3,66 | 98,2 % en 3,47 |
| Endocardite | cardiologie | 2 | 11,1 % en 7,32 | 97,5 % en 3,03 | 96,7 % en 2,88 | 15,6 % en 7,72 | 97,4 % en 3,31 | 100,0 % en 3,20 |
| Cardiomyopathie | cardiologie | 1 | 8,9 % en 7,91 | 94,3 % en 3,21 | 96,0 % en 3,30 | 10,2 % en 7,47 | 92,2 % en 4,18 | 97,9 % en 3,17 |
| Rejet de greffe cardiaque | cardiologie | 1 | 17,8 % en 7,11 | 96,1 % en 3,98 | 98,2 % en 3,23 | 7,3 % en 7,82 | 96,7 % en 3,49 | 92,3 % en 3,58 |
| Œdème aigu du poumon | cardiologie | 1 | 16,2 % en 6,93 | 92,2 % en 3,34 | 93,9 % en 3,76 | 17,9 % en 7,02 | 96,5 % en 3,39 | 96,8 % en 3,46 |
| Infarctus du myocarde | cardiologie | 1 | 14,1 % en 7,41 | 98,0 % en 3,35 | 100,0 % en 3,94 | 13,9 % en 7,81 | 93,1 % en 3,62 | 91,1 % en 3,98 |
| Embolie pulmonaire | cardiologie | 1 | 16,0 % en 6,98 | 93,8 % en 3,46 | 97,1 % en 3,40 | 8,5 % en 7,15 | 92,1 % en 3,62 | 94,4 % en 3,56 |
| Tics nerveux | psychiatrie | 3 | 12,6 % en 6,74 | 99,0 % en 3,12 | 98,1 % en 3,01 | 14,2 % en 6,76 | 98,9 % en 3,33 | 95,3 % en 3,10 |
| Phobie des escaliers | psychiatrie | 2 | 0,9 % en 6,12 | 94,0 % en 2,81 | 96,9 % en 3,05 | 0,0 % en 6,35 | 99,2 % en 3,08 | 96,2 % en 3,34 |
| Dépendance à la caféine | psychiatrie | 3 | 2,9 % en 8,56 | 97,8 % en 3,23 | 99,4 % en 3,07 | 3,3 % en 8,33 | 99,4 % en 3,10 | 98,9 % en 3,14 |
| Somnambulisme | psychiatrie | 2 | 4,1 % en 6,85 | 97,1 % en 3,02 | 97,9 % en 3,07 | 0,0 % en 7,23 | 95,8 % en 3,47 | 94,6 % en 3,41 |
| Cauchemars répétés | psychiatrie | 2 | 0,0 % en 9,36 | 100,0 % en 3,08 | 100,0 % en 3,26 | 0,0 % en 9,07 | 100,0 % en 3,09 | 99,1 % en 3,28 |
| Phobie des blouses blanches | psychiatrie | 3 | 15,8 % en 7,01 | 96,2 % en 3,09 | 100,0 % en 2,95 | 15,1 % en 6,74 | 96,3 % en 3,29 | 98,1 % en 3,04 |
| Trouble obsessionnel compulsif léger | psychiatrie | 2 | 1,5 % en 7,65 | 94,8 % en 3,34 | 100,0 % en 3,23 | 1,9 % en 7,41 | 96,4 % en 3,28 | 99,1 % en 3,30 |
| Hypocondrie aiguë | psychiatrie | 2 | 5,1 % en 7,47 | 97,6 % en 3,27 | 100,0 % en 3,04 | 2,9 % en 8,02 | 100,0 % en 2,91 | 97,9 % en 3,19 |
| Agoraphobie | psychiatrie | 2 | 4,5 % en 7,88 | 94,4 % en 3,22 | 98,3 % en 3,09 | 2,6 % en 7,83 | 97,5 % en 3,45 | 99,0 % en 3,41 |
| Hyperactivité de l'adulte | psychiatrie | 2 | 4,1 % en 6,85 | 96,9 % en 2,92 | 98,3 % en 2,98 | 6,7 % en 7,10 | 91,8 % en 3,59 | 98,4 % en 3,40 |
| Mutisme sélectif | psychiatrie | 2 | 17,8 % en 7,07 | 95,4 % en 3,22 | 98,0 % en 2,86 | 17,2 % en 7,29 | 93,6 % en 3,81 | 98,0 % en 3,42 |
| Addiction aux écrans | psychiatrie | 1 | 3,0 % en 8,05 | 93,0 % en 3,61 | 98,1 % en 4,10 | 1,8 % en 8,42 | 96,8 % en 3,17 | 93,9 % en 3,33 |
| Syndrome de Paris | psychiatrie | 2 | 13,5 % en 7,94 | 100,0 % en 3,06 | 100,0 % en 3,13 | 13,9 % en 8,09 | 97,2 % en 3,47 | 99,0 % en 3,40 |
| Dépression légère | psychiatrie | 1 | 14,6 % en 7,56 | 94,8 % en 3,40 | 98,4 % en 3,43 | 6,7 % en 6,98 | 100,0 % en 2,98 | 96,2 % en 3,64 |
| Trouble alimentaire léger | psychiatrie | 2 | 0,9 % en 8,28 | 96,8 % en 3,22 | 100,0 % en 2,99 | 2,0 % en 8,15 | 97,0 % en 3,44 | 99,2 % en 3,11 |
| Insomnie chronique | psychiatrie | 1 | 6,0 % en 8,10 | 98,2 % en 3,67 | 100,0 % en 3,12 | 0,0 % en 8,64 | 96,5 % en 4,02 | 98,3 % en 3,53 |
| Burn-out | psychiatrie | 1 | 10,3 % en 7,91 | 98,0 % en 3,49 | 98,0 % en 3,33 | 10,3 % en 7,48 | 95,3 % en 3,73 | 95,5 % en 3,75 |
| Attaque de panique | psychiatrie | 1 | 10,9 % en 7,38 | 100,0 % en 3,02 | 94,4 % en 3,35 | 26,1 % en 7,13 | 96,1 % en 3,59 | 98,5 % en 3,06 |
| Stress post-traumatique | psychiatrie | 1 | 19,1 % en 7,28 | 88,9 % en 3,69 | 98,2 % en 3,43 | 28,8 % en 6,88 | 98,3 % en 3,54 | 96,5 % en 3,61 |
| Jalousie délirante | psychiatrie | 1 | 9,8 % en 7,33 | 92,3 % en 3,81 | 97,8 % en 3,28 | 12,7 % en 7,32 | 98,0 % en 3,24 | 98,1 % en 3,32 |
| Hallux valgus | orthopedie | 3 | 15,0 % en 7,07 | 98,6 % en 3,01 | 99,3 % en 2,84 | 16,4 % en 7,34 | 98,8 % en 3,10 | 98,0 % en 3,23 |
| Périostite tibiale | orthopedie | 2 | 11,4 % en 6,70 | 94,0 % en 3,10 | 99,1 % en 2,75 | 10,4 % en 5,98 | 92,2 % en 3,34 | 96,9 % en 3,02 |
| Contusion sévère | orthopedie | 3 | 3,0 % en 10,01 | 99,3 % en 3,24 | 99,4 % en 3,21 | 5,0 % en 9,97 | 97,3 % en 3,23 | 99,4 % en 3,06 |
| Entorse de la cheville | orthopedie | 2 | 2,5 % en 8,38 | 96,6 % en 3,19 | 99,0 % en 3,01 | 3,3 % en 7,44 | 93,6 % en 3,53 | 97,2 % en 3,36 |
| Syndrome du canal carpien | orthopedie | 2 | 17,0 % en 9,60 | 99,0 % en 3,03 | 100,0 % en 3,03 | 21,0 % en 9,05 | 98,2 % en 3,34 | 99,2 % en 3,46 |
| Lumbago | orthopedie | 3 | 14,8 % en 7,68 | 96,9 % en 3,20 | 98,9 % en 2,94 | 12,6 % en 7,69 | 97,5 % en 3,26 | 100,0 % en 2,75 |
| Fêlure du coccyx | orthopedie | 2 | 13,0 % en 6,90 | 99,1 % en 2,95 | 100,0 % en 2,88 | 14,8 % en 7,60 | 97,1 % en 3,51 | 98,3 % en 3,19 |
| Épaule gelée | orthopedie | 2 | 12,3 % en 8,33 | 98,0 % en 3,14 | 99,2 % en 3,09 | 16,8 % en 8,39 | 96,3 % en 3,41 | 99,0 % en 3,46 |
| Entorse du genou | orthopedie | 2 | 1,8 % en 8,84 | 99,1 % en 3,01 | 98,3 % en 3,30 | 0,9 % en 8,79 | 99,2 % en 3,22 | 97,2 % en 3,30 |
| Sciatique | orthopedie | 2 | 14,1 % en 7,06 | 96,4 % en 3,14 | 100,0 % en 2,83 | 9,4 % en 7,33 | 98,0 % en 3,12 | 96,8 % en 2,98 |
| Scoliose | orthopedie | 2 | 9,6 % en 8,34 | 98,3 % en 3,05 | 99,2 % en 3,27 | 15,7 % en 7,63 | 96,0 % en 3,30 | 95,8 % en 3,20 |
| Arthrose du genou | orthopedie | 1 | 15,8 % en 8,04 | 96,1 % en 3,35 | 96,7 % en 3,53 | 15,9 % en 7,71 | 98,2 % en 3,59 | 98,1 % en 3,89 |
| Ostéoporose | orthopedie | 2 | 15,3 % en 9,05 | 100,0 % en 3,12 | 100,0 % en 2,92 | 16,5 % en 8,48 | 99,1 % en 3,27 | 98,4 % en 3,52 |
| Fracture du poignet | orthopedie | 1 | 2,0 % en 8,86 | 96,2 % en 3,35 | 100,0 % en 3,56 | 0,0 % en 9,18 | 95,7 % en 3,40 | 95,9 % en 3,80 |
| Fracture fermée | orthopedie | 2 | 4,9 % en 8,43 | 99,0 % en 3,32 | 100,0 % en 3,07 | 0,9 % en 8,51 | 97,3 % en 3,03 | 99,1 % en 3,30 |
| Luxation de l'épaule | orthopedie | 1 | 1,9 % en 8,94 | 98,0 % en 3,27 | 95,4 % en 3,66 | 3,6 % en 8,56 | 96,2 % en 3,73 | 95,3 % en 4,35 |
| Hernie discale | orthopedie | 1 | 0,0 % en 6,53 | 98,4 % en 3,15 | 94,5 % en 3,18 | 1,8 % en 6,66 | 90,9 % en 3,65 | 91,2 % en 3,66 |
| Rupture du ligament croisé | orthopedie | 1 | 0,0 % en 5,82 | 90,8 % en 3,29 | 93,8 % en 3,55 | 0,0 % en 5,72 | 92,3 % en 3,37 | 93,5 % en 3,34 |
| Fracture ouverte | orthopedie | 1 | 0,0 % en 6,43 | 92,9 % en 3,41 | 91,4 % en 3,53 | 0,0 % en 6,27 | 87,5 % en 3,77 | 89,8 % en 3,71 |
| Fracture du fémur | orthopedie | 1 | 0,0 % en 5,84 | 88,3 % en 3,58 | 98,6 % en 3,29 | 0,0 % en 5,80 | 98,0 % en 2,92 | 90,7 % en 3,59 |
| Main froide éternelle | paranormal | 3 | 17,6 % en 7,55 | 98,8 % en 2,84 | 99,4 % en 2,99 | 14,4 % en 7,25 | 98,2 % en 2,91 | 98,4 % en 3,10 |
| Rire des cimetières | paranormal | 2 | 12,4 % en 6,29 | 94,5 % en 3,06 | 99,0 % en 2,90 | 11,9 % en 6,15 | 98,2 % en 3,06 | 96,7 % en 2,92 |
| Doigts qui grandissent | paranormal | 3 | 18,4 % en 8,67 | 98,8 % en 2,94 | 100,0 % en 3,11 | 22,0 % en 8,31 | 97,1 % en 3,29 | 100,0 % en 3,09 |
| Malédiction du lundi | paranormal | 2 | 1,8 % en 8,02 | 97,0 % en 3,26 | 97,1 % en 3,26 | 3,6 % en 7,96 | 94,9 % en 3,22 | 98,9 % en 3,24 |
| Nez qui saigne de l'encre | paranormal | 2 | 22,7 % en 8,94 | 99,1 % en 3,20 | 99,1 % en 3,10 | 19,5 % en 8,55 | 99,1 % en 2,93 | 99,2 % en 3,53 |
| Mauvais œil | paranormal | 3 | 2,3 % en 7,77 | 97,4 % en 3,08 | 100,0 % en 2,83 | 1,9 % en 8,08 | 98,7 % en 2,97 | 99,4 % en 3,04 |
| Malédiction des miroirs | paranormal | 2 | 0,9 % en 7,48 | 98,3 % en 2,96 | 100,0 % en 3,09 | 0,9 % en 8,11 | 97,8 % en 3,27 | 99,0 % en 3,19 |
| Malédiction du chat noir | paranormal | 2 | 2,3 % en 8,94 | 99,1 % en 3,36 | 97,2 % en 3,11 | 1,6 % en 8,85 | 97,5 % en 3,27 | 100,0 % en 2,83 |
| Malédiction du nombre 7 | paranormal | 2 | 1,8 % en 8,80 | 99,1 % en 2,78 | 100,0 % en 3,08 | 0,9 % en 9,09 | 97,3 % en 3,43 | 100,0 % en 3,34 |
| Ombre qui suit | paranormal | 2 | 18,6 % en 7,12 | 99,0 % en 3,35 | 97,4 % en 3,42 | 14,0 % en 7,31 | 95,7 % en 3,52 | 98,0 % en 3,05 |
| Brûlure lunaire | paranormal | 2 | 10,9 % en 7,73 | 95,2 % en 3,13 | 98,2 % en 3,38 | 16,2 % en 7,75 | 100,0 % en 3,36 | 96,6 % en 3,44 |
| Âme en double | paranormal | 1 | 3,2 % en 9,03 | 93,5 % en 3,55 | 100,0 % en 3,27 | 3,2 % en 8,63 | 100,0 % en 3,67 | 96,0 % en 3,80 |
| Voix du passé | paranormal | 2 | 1,9 % en 9,50 | 96,8 % en 3,65 | 100,0 % en 3,10 | 1,6 % en 9,49 | 96,9 % en 3,31 | 98,0 % en 3,52 |
| Murmures dans la tête | paranormal | 1 | 3,9 % en 8,61 | 94,3 % en 3,40 | 100,0 % en 3,48 | 5,5 % en 8,52 | 100,0 % en 3,49 | 100,0 % en 3,21 |
| Poltergeist domestique | paranormal | 2 | 21,0 % en 7,50 | 96,3 % en 3,36 | 96,1 % en 3,24 | 14,2 % en 7,47 | 99,1 % en 3,03 | 100,0 % en 3,21 |
| Vampirisme aigu | paranormal | 1 | 10,6 % en 8,68 | 92,2 % en 3,63 | 100,0 % en 3,30 | 14,3 % en 8,26 | 95,3 % en 3,70 | 94,2 % en 4,12 |
| Pétrification partielle | paranormal | 1 | 18,9 % en 8,51 | 98,1 % en 3,06 | 98,2 % en 3,48 | 13,1 % en 8,21 | 98,0 % en 3,44 | 100,0 % en 3,48 |
| Possession légère | paranormal | 1 | 1,6 % en 8,72 | 94,1 % en 3,06 | 95,3 % en 3,30 | 1,5 % en 8,15 | 93,5 % en 3,89 | 94,4 % en 3,76 |
| Lycanthropie | paranormal | 1 | 12,7 % en 7,75 | 93,9 % en 3,50 | 96,5 % en 3,60 | 17,6 % en 8,50 | 94,4 % en 3,54 | 96,4 % en 4,22 |
| Glissement temporel | paranormal | 1 | 12,7 % en 7,71 | 98,0 % en 3,57 | 98,3 % en 3,54 | 20,4 % en 6,83 | 92,6 % en 3,61 | 93,1 % en 3,43 |
