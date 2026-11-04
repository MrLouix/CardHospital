# Rapport de simulation — CardHospital — exemple réduit 0.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 23,7 % | 76,3 % | 0 | 4,39 | 2,20 | 0,75 | -0,90 | -3,96 |
| seuil:50 | Interne | 84,4 % | 15,6 % | 0 | 3,39 | 1,88 | 1,38 | 0,17 | 0,57 |
| seuil:70 | Interne | 78,0 % | 22,0 % | 0 | 4,23 | 2,99 | 1,31 | 0,02 | 0,10 |
| specialite | Interne | 100,0 % | 0,0 % | 0 | 3,07 | 1,99 | 1,62 | 0,65 | 1,99 |
| hasard | Chirurgien | 16,5 % | 83,5 % | 0 | 3,03 | 1,52 | 0,79 | -1,94 | -5,90 |
| seuil:50 | Chirurgien | 64,4 % | 35,6 % | 0 | 2,80 | 1,63 | 1,54 | -0,19 | -0,53 |
| seuil:70 | Chirurgien | 54,7 % | 45,3 % | 0 | 3,31 | 2,41 | 1,45 | -0,31 | -1,03 |
| specialite | Chirurgien | 99,4 % | 0,6 % | 0 | 3,08 | 2,01 | 1,85 | 0,95 | 2,94 |
| hasard | Réanimation | 14,7 % | 85,3 % | 0 | 2,61 | 1,30 | 1,44 | -2,52 | -6,56 |
| seuil:50 | Réanimation | 63,4 % | 36,6 % | 0 | 2,63 | 1,46 | 2,45 | -0,15 | -0,39 |
| seuil:70 | Réanimation | 50,9 % | 49,1 % | 0 | 3,17 | 2,31 | 2,38 | -0,43 | -1,36 |
| specialite | Réanimation | 93,6 % | 6,4 % | 0 | 3,00 | 2,00 | 2,80 | 1,12 | 3,35 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -56 | -39 | -22 | -57 | -40 |
| seuil:50 | Interne | -10 | 6 | 18 | -14 | -1 |
| seuil:70 | Interne | -16 | 2 | 14 | -18 | -4 |
| specialite | Interne | 19 | 20 | 20 | 0 | 0 |
| hasard | Chirurgien | -78 | -60 | -38 | -78 | -60 |
| seuil:50 | Chirurgien | -31 | -2 | 20 | -33 | -11 |
| seuil:70 | Chirurgien | -34 | -10 | 12 | -36 | -14 |
| specialite | Chirurgien | 22 | 30 | 30 | 0 | 0 |
| hasard | Réanimation | -86 | -68 | -40 | -86 | -68 |
| seuil:50 | Réanimation | -34 | -4 | 26 | -40 | -12 |
| seuil:70 | Réanimation | -44 | -14 | 16 | -46 | -18 |
| specialite | Réanimation | 20 | 40 | 40 | -6 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Type | Poids | hasard | seuil:50 | seuil:70 | specialite |
|---|---|---:|---:|---:|---:|---:|
| Appendicite | chirurgie | 2 | 2,4 % en 4,21 | 87,8 % en 2,71 | 78,7 % en 3,23 | 100,0 % en 3,31 |
| Fracture ouverte | chirurgie | 1 | 29,9 % en 3,17 | 88,0 % en 2,63 | 79,2 % en 3,18 | 100,0 % en 3,22 |
| Angine bactérienne | pharmacie | 3 | 33,8 % en 5,06 | 95,3 % en 2,76 | 92,0 % en 3,60 | 100,0 % en 3,32 |
| Allergie saisonnière | pharmacie | 3 | 29,4 % en 4,51 | 71,5 % en 4,99 | 67,1 % en 6,17 | 100,0 % en 3,33 |
| Phobie des blouses blanches | psychologie | 1 | 23,9 % en 4,30 | 90,5 % en 2,76 | 83,4 % en 3,47 | 100,0 % en 2,00 |
| Hypocondrie aiguë | psychologie | 1 | 11,9 % en 3,78 | 71,2 % en 3,40 | 59,0 % en 4,14 | 100,0 % en 2,04 |
