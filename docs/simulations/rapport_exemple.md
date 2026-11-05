# Rapport de simulation — CardHospital — exemple réduit 0.2.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 22,4 % | 77,6 % | 0 | 5,22 | 2,59 | 0,77 | -0,93 | -4,85 |
| seuil:60 | Interne | 97,5 % | 2,5 % | 0 | 2,43 | 1,27 | 1,80 | 0,69 | 1,68 |
| seuil:80 | Interne | 97,9 % | 2,1 % | 0 | 2,54 | 1,47 | 1,80 | 0,70 | 1,78 |
| couleur:60 | Interne | 97,5 % | 2,5 % | 0 | 2,45 | 1,29 | 1,79 | 0,68 | 1,67 |
| couleur:80 | Interne | 98,0 % | 2,0 % | 0 | 2,53 | 1,46 | 1,80 | 0,71 | 1,78 |
| hasard | Chirurgien | 13,8 % | 86,2 % | 0 | 3,34 | 1,66 | 0,81 | -1,96 | -6,53 |
| seuil:60 | Chirurgien | 86,0 % | 14,0 % | 0 | 2,23 | 1,21 | 2,14 | 0,70 | 1,56 |
| seuil:80 | Chirurgien | 89,9 % | 10,1 % | 0 | 2,40 | 1,42 | 2,15 | 0,84 | 2,02 |
| couleur:60 | Chirurgien | 86,1 % | 13,9 % | 0 | 2,24 | 1,21 | 2,15 | 0,71 | 1,59 |
| couleur:80 | Chirurgien | 91,4 % | 8,6 % | 0 | 2,38 | 1,40 | 2,18 | 0,91 | 2,17 |
| hasard | Réanimation | 12,0 % | 88,0 % | 0 | 2,99 | 1,48 | 1,47 | -2,45 | -7,33 |
| seuil:60 | Réanimation | 85,6 % | 14,4 % | 0 | 2,18 | 1,16 | 3,10 | 1,02 | 2,22 |
| seuil:80 | Réanimation | 89,6 % | 10,3 % | 0 | 2,37 | 1,40 | 3,13 | 1,18 | 2,80 |
| couleur:60 | Réanimation | 85,8 % | 14,2 % | 0 | 2,19 | 1,16 | 3,10 | 1,03 | 2,25 |
| couleur:80 | Réanimation | 90,0 % | 10,0 % | 0 | 2,36 | 1,39 | 3,14 | 1,20 | 2,84 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -69 | -49 | -28 | -69 | -49 |
| seuil:60 | Interne | 10 | 18 | 20 | -2 | 0 |
| seuil:80 | Interne | 12 | 19 | 20 | -2 | 0 |
| couleur:60 | Interne | 9 | 18 | 20 | -2 | 0 |
| couleur:80 | Interne | 12 | 19 | 20 | -1 | 0 |
| hasard | Chirurgien | -84 | -66 | -44 | -84 | -67 |
| seuil:60 | Chirurgien | -3 | 20 | 30 | -14 | 0 |
| seuil:80 | Chirurgien | 2 | 20 | 30 | -8 | 0 |
| couleur:60 | Chirurgien | -1 | 20 | 30 | -13 | 0 |
| couleur:80 | Chirurgien | 4 | 22 | 30 | -7 | 0 |
| hasard | Réanimation | -94 | -74 | -48 | -94 | -74 |
| seuil:60 | Réanimation | 0 | 26 | 40 | -14 | 0 |
| seuil:80 | Réanimation | 6 | 28 | 40 | -10 | 0 |
| couleur:60 | Réanimation | 2 | 28 | 40 | -14 | 0 |
| couleur:80 | Réanimation | 6 | 28 | 40 | -10 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Fracture ouverte | orthopedie | 2 | 0,9 % en 4,16 | 95,4 % en 2,44 | 95,4 % en 2,47 | 94,5 % en 2,47 | 94,5 % en 2,52 |
| Fracture fermée | orthopedie | 2 | 20,2 % en 4,22 | 98,4 % en 2,37 | 98,6 % en 2,53 | 98,6 % en 2,37 | 99,0 % en 2,51 |
| Angine bactérienne | generale | 3 | 42,7 % en 6,82 | 98,4 % en 2,47 | 99,1 % en 2,59 | 98,6 % en 2,51 | 99,4 % en 2,59 |
| Maux de tête | generale | 3 | 34,4 % en 5,46 | 95,7 % en 2,46 | 96,8 % en 2,55 | 96,2 % en 2,44 | 97,1 % en 2,50 |
| Phobie des blouses blanches | psychiatrie | 2 | 12,4 % en 4,75 | 98,3 % en 2,36 | 98,7 % en 2,51 | 98,7 % en 2,41 | 98,9 % en 2,49 |
| Hypocondrie aiguë | psychiatrie | 2 | 7,5 % en 4,98 | 99,3 % en 2,42 | 98,8 % en 2,54 | 98,5 % en 2,44 | 98,7 % en 2,53 |
