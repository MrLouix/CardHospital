# Rapport de simulation — CardHospital — exemple réduit 0.2.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 22,4 % | 77,6 % | 0 | 5,22 | 2,59 | 0,77 | -0,93 | -4,85 |
| seuil:60 | Interne | 98,6 % | 1,4 % | 0 | 2,32 | 1,20 | 1,87 | 0,77 | 1,79 |
| seuil:80 | Interne | 99,0 % | 1,0 % | 0 | 2,38 | 1,33 | 1,87 | 0,78 | 1,87 |
| couleur:60 | Interne | 98,9 % | 1,1 % | 0 | 2,33 | 1,21 | 1,85 | 0,77 | 1,79 |
| couleur:80 | Interne | 99,2 % | 0,8 % | 0 | 2,35 | 1,31 | 1,89 | 0,81 | 1,90 |
| hasard | Chirurgien | 13,8 % | 86,2 % | 0 | 3,34 | 1,66 | 0,81 | -1,96 | -6,53 |
| seuil:60 | Chirurgien | 89,7 % | 10,3 % | 0 | 2,18 | 1,16 | 2,25 | 0,90 | 1,96 |
| seuil:80 | Chirurgien | 93,7 % | 6,3 % | 0 | 2,28 | 1,29 | 2,27 | 1,04 | 2,38 |
| couleur:60 | Chirurgien | 89,8 % | 10,2 % | 0 | 2,17 | 1,15 | 2,25 | 0,90 | 1,96 |
| couleur:80 | Chirurgien | 94,0 % | 6,0 % | 0 | 2,29 | 1,29 | 2,27 | 1,05 | 2,41 |
| hasard | Réanimation | 12,0 % | 88,0 % | 0 | 2,99 | 1,48 | 1,47 | -2,45 | -7,33 |
| seuil:60 | Réanimation | 89,6 % | 10,4 % | 0 | 2,13 | 1,11 | 3,23 | 1,28 | 2,72 |
| seuil:80 | Réanimation | 93,2 % | 6,8 % | 0 | 2,27 | 1,28 | 3,24 | 1,41 | 3,19 |
| couleur:60 | Réanimation | 89,5 % | 10,4 % | 0 | 2,14 | 1,12 | 3,21 | 1,26 | 2,71 |
| couleur:80 | Réanimation | 93,6 % | 6,4 % | 0 | 2,27 | 1,28 | 3,26 | 1,43 | 3,24 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -69 | -49 | -28 | -69 | -49 |
| seuil:60 | Interne | 12 | 19 | 20 | -1 | 0 |
| seuil:80 | Interne | 13 | 20 | 20 | -1 | 0 |
| couleur:60 | Interne | 12 | 19 | 20 | -2 | 0 |
| couleur:80 | Interne | 14 | 20 | 20 | 0 | 0 |
| hasard | Chirurgien | -84 | -66 | -44 | -84 | -67 |
| seuil:60 | Chirurgien | 0 | 20 | 30 | -8 | 0 |
| seuil:80 | Chirurgien | 10 | 28 | 30 | -7 | 0 |
| couleur:60 | Chirurgien | 0 | 20 | 30 | -8 | 0 |
| couleur:80 | Chirurgien | 10 | 28 | 30 | -7 | 0 |
| hasard | Réanimation | -94 | -74 | -48 | -94 | -74 |
| seuil:60 | Réanimation | 4 | 28 | 40 | -10 | 0 |
| seuil:80 | Réanimation | 14 | 30 | 40 | -8 | 0 |
| couleur:60 | Réanimation | 4 | 28 | 40 | -12 | 0 |
| couleur:80 | Réanimation | 16 | 38 | 40 | -8 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Fracture ouverte | orthopedie | 2 | 0,9 % en 4,16 | 97,3 % en 2,32 | 97,6 % en 2,37 | 96,9 % en 2,37 | 98,0 % en 2,35 |
| Fracture fermée | orthopedie | 2 | 20,2 % en 4,22 | 98,6 % en 2,26 | 99,3 % en 2,39 | 99,6 % en 2,26 | 100,0 % en 2,32 |
| Angine bactérienne | generale | 3 | 42,7 % en 6,82 | 99,1 % en 2,34 | 99,8 % en 2,42 | 99,3 % en 2,37 | 99,8 % en 2,38 |
| Maux de tête | generale | 3 | 34,4 % en 5,46 | 98,0 % en 2,35 | 98,5 % en 2,38 | 98,3 % en 2,34 | 98,5 % en 2,36 |
| Phobie des blouses blanches | psychiatrie | 2 | 12,4 % en 4,75 | 99,2 % en 2,28 | 99,4 % en 2,34 | 99,5 % en 2,30 | 99,4 % en 2,34 |
| Hypocondrie aiguë | psychiatrie | 2 | 7,5 % en 4,98 | 99,4 % en 2,34 | 99,1 % en 2,38 | 99,5 % en 2,34 | 99,7 % en 2,34 |
