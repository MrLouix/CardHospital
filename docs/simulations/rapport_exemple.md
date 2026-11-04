# Rapport de simulation — CardHospital — exemple réduit 0.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 23,7 % | 76,3 % | 0 | 4,41 | 2,21 | 0,75 | -0,89 | -3,92 |
| seuil:50 | Interne | 90,3 % | 9,7 % | 0 | 2,89 | 1,59 | 1,49 | 0,38 | 1,10 |
| seuil:70 | Interne | 84,1 % | 15,9 % | 0 | 3,65 | 2,58 | 1,39 | 0,21 | 0,75 |
| specialite | Interne | 100,0 % | 0,0 % | 0 | 2,31 | 1,24 | 1,82 | 0,86 | 1,99 |
| hasard | Chirurgien | 16,0 % | 84,0 % | 0 | 3,03 | 1,52 | 0,77 | -1,97 | -5,96 |
| seuil:50 | Chirurgien | 73,2 % | 26,9 % | 0 | 2,52 | 1,46 | 1,67 | 0,13 | 0,32 |
| seuil:70 | Chirurgien | 67,3 % | 32,7 % | 0 | 3,03 | 2,19 | 1,55 | 0,03 | 0,08 |
| specialite | Chirurgien | 99,0 % | 1,0 % | 0 | 2,30 | 1,25 | 2,13 | 1,26 | 2,91 |
| hasard | Réanimation | 14,5 % | 85,5 % | 0 | 2,62 | 1,32 | 1,44 | -2,52 | -6,59 |
| seuil:50 | Réanimation | 72,0 % | 28,1 % | 0 | 2,35 | 1,29 | 2,59 | 0,27 | 0,62 |
| seuil:70 | Réanimation | 63,6 % | 36,4 % | 0 | 2,90 | 2,09 | 2,49 | 0,01 | 0,04 |
| specialite | Réanimation | 98,4 % | 1,6 % | 0 | 2,29 | 1,24 | 3,13 | 1,67 | 3,82 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -55 | -39 | -22 | -55 | -40 |
| seuil:50 | Interne | -2 | 12 | 19 | -7 | 0 |
| seuil:70 | Interne | -7 | 8 | 19 | -11 | -1 |
| specialite | Interne | 19 | 20 | 20 | 0 | 0 |
| hasard | Chirurgien | -79 | -60 | -36 | -79 | -61 |
| seuil:50 | Chirurgien | -21 | 2 | 20 | -23 | -6 |
| seuil:70 | Chirurgien | -23 | 2 | 22 | -25 | -7 |
| specialite | Chirurgien | 22 | 30 | 30 | 0 | 0 |
| hasard | Réanimation | -86 | -68 | -42 | -86 | -68 |
| seuil:50 | Réanimation | -22 | 4 | 30 | -30 | -8 |
| seuil:70 | Réanimation | -28 | 0 | 30 | -32 | -8 |
| specialite | Réanimation | 30 | 40 | 40 | 0 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Type | Poids | hasard | seuil:50 | seuil:70 | specialite |
|---|---|---:|---:|---:|---:|---:|
| Appendicite | chirurgie | 2 | 2,3 % en 4,22 | 83,5 % en 2,86 | 73,8 % en 3,44 | 100,0 % en 2,33 |
| Fracture ouverte | chirurgie | 1 | 30,8 % en 3,22 | 87,8 % en 2,64 | 80,1 % en 3,19 | 99,9 % en 2,27 |
| Angine bactérienne | pharmacie | 3 | 33,9 % en 4,99 | 94,3 % en 3,00 | 89,8 % en 3,92 | 100,0 % en 2,38 |
| Allergie saisonnière | pharmacie | 3 | 29,7 % en 4,56 | 91,3 % en 2,96 | 86,0 % en 3,78 | 100,0 % en 2,35 |
| Phobie des blouses blanches | psychologie | 1 | 21,9 % en 4,35 | 92,9 % en 2,74 | 85,7 % en 3,41 | 100,0 % en 2,17 |
| Hypocondrie aiguë | psychologie | 1 | 11,4 % en 3,79 | 88,7 % en 2,80 | 84,1 % en 3,56 | 100,0 % en 2,19 |
