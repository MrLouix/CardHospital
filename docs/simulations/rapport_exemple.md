# Rapport de simulation — CardHospital — exemple réduit 0.3.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, pris en charge à tour de rôle · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 26,9 % | 73,1 % | 0 | 6,54 | 3,26 | 0,76 | -0,76 | -4,95 |
| seuil:60 | Interne | 99,2 % | 0,8 % | 0 | 2,47 | 1,30 | 1,80 | 0,72 | 1,78 |
| seuil:80 | Interne | 99,6 % | 0,4 % | 0 | 2,57 | 1,49 | 1,80 | 0,73 | 1,88 |
| couleur:60 | Interne | 99,3 % | 0,7 % | 0 | 2,45 | 1,28 | 1,81 | 0,73 | 1,80 |
| couleur:80 | Interne | 99,8 % | 0,2 % | 0 | 2,52 | 1,45 | 1,82 | 0,76 | 1,91 |
| hasard | Chirurgien | 18,7 % | 81,3 % | 0 | 4,63 | 2,33 | 0,80 | -1,49 | -6,91 |
| seuil:60 | Chirurgien | 97,0 % | 3,0 % | 0 | 2,44 | 1,28 | 2,19 | 1,00 | 2,43 |
| seuil:80 | Chirurgien | 97,6 % | 2,4 % | 0 | 2,55 | 1,49 | 2,18 | 1,04 | 2,65 |
| couleur:60 | Chirurgien | 97,6 % | 2,4 % | 0 | 2,44 | 1,28 | 2,19 | 1,02 | 2,48 |
| couleur:80 | Chirurgien | 97,9 % | 2,1 % | 0 | 2,53 | 1,47 | 2,19 | 1,06 | 2,68 |
| hasard | Réanimation | 16,6 % | 83,4 % | 0 | 4,18 | 2,08 | 1,47 | -1,83 | -7,64 |
| seuil:60 | Réanimation | 94,5 % | 5,5 % | 0 | 2,40 | 1,27 | 3,11 | 1,29 | 3,10 |
| seuil:80 | Réanimation | 96,4 % | 3,6 % | 0 | 2,52 | 1,47 | 3,15 | 1,38 | 3,47 |
| couleur:60 | Réanimation | 95,6 % | 4,4 % | 0 | 2,39 | 1,27 | 3,14 | 1,36 | 3,24 |
| couleur:80 | Réanimation | 96,8 % | 3,3 % | 0 | 2,51 | 1,46 | 3,16 | 1,40 | 3,51 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -71 | -49 | -27 | -71 | -49 |
| seuil:60 | Interne | 12 | 19 | 20 | -1 | 0 |
| seuil:80 | Interne | 15 | 19 | 20 | -1 | 0 |
| couleur:60 | Interne | 12 | 19 | 20 | -1 | 0 |
| couleur:80 | Interne | 17 | 20 | 20 | -1 | 0 |
| hasard | Chirurgien | -92 | -69 | -44 | -92 | -70 |
| seuil:60 | Chirurgien | 14 | 27 | 30 | -5 | 0 |
| seuil:80 | Chirurgien | 17 | 28 | 30 | -3 | 0 |
| couleur:60 | Chirurgien | 14 | 27 | 30 | -3 | 0 |
| couleur:80 | Chirurgien | 18 | 28 | 30 | -2 | 0 |
| hasard | Réanimation | -102 | -78 | -46 | -102 | -78 |
| seuil:60 | Réanimation | 12 | 36 | 40 | -6 | 0 |
| seuil:80 | Réanimation | 18 | 38 | 40 | -4 | 0 |
| couleur:60 | Réanimation | 14 | 36 | 40 | -4 | 0 |
| couleur:80 | Réanimation | 22 | 38 | 40 | -4 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Fracture ouverte | orthopedie | 2 | 2,1 % en 6,55 | 99,7 % en 2,52 | 99,5 % en 2,64 | 99,7 % en 2,50 | 99,9 % en 2,51 |
| Fracture fermée | orthopedie | 2 | 25,3 % en 5,89 | 99,9 % en 2,38 | 100,0 % en 2,51 | 99,8 % en 2,37 | 100,0 % en 2,48 |
| Angine bactérienne | generale | 3 | 48,4 % en 7,59 | 99,2 % en 2,55 | 99,8 % en 2,57 | 99,6 % en 2,51 | 99,9 % en 2,54 |
| Maux de tête | generale | 3 | 40,9 % en 6,28 | 98,2 % en 2,50 | 99,2 % en 2,60 | 98,4 % en 2,49 | 99,4 % en 2,55 |
| Phobie des blouses blanches | psychiatrie | 2 | 18,0 % en 6,69 | 100,0 % en 2,36 | 99,9 % en 2,53 | 100,0 % en 2,38 | 100,0 % en 2,51 |
| Hypocondrie aiguë | psychiatrie | 2 | 8,8 % en 5,92 | 98,6 % en 2,45 | 99,4 % en 2,56 | 98,8 % en 2,41 | 99,9 % en 2,52 |
