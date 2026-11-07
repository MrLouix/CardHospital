# Rapport de simulation — CardHospital — exemple réduit 0.6.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté, 3 patients en jeu à la fois, 1 joueur · abandon au-delà de 60 actions sur un patient.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Analyses / patient | Analyses justes | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 14,8 % | 85,2 % | 0 | 9,51 | 4,75 | 0,00 | — | 0,73 | -0,78 | -7,46 |
| seuil:60 | Interne | 99,8 % | 0,2 % | 0 | 2,55 | 1,34 | 0,00 | — | 1,92 | 0,72 | 1,84 |
| seuil:80 | Interne | 99,9 % | 0,1 % | 0 | 2,60 | 1,51 | 0,00 | — | 1,92 | 0,74 | 1,91 |
| couleur:60 | Interne | 99,9 % | 0,1 % | 0 | 2,55 | 1,34 | 0,00 | — | 1,92 | 0,73 | 1,86 |
| couleur:80 | Interne | 99,9 % | 0,1 % | 0 | 2,58 | 1,49 | 0,00 | — | 1,93 | 0,74 | 1,93 |
| hasard | Chirurgien | 10,7 % | 89,3 % | 0 | 6,64 | 3,33 | 0,00 | — | 1,40 | -1,31 | -8,73 |
| seuil:60 | Chirurgien | 98,6 % | 1,4 % | 0 | 2,52 | 1,33 | 0,00 | — | 2,87 | 0,66 | 1,66 |
| seuil:80 | Chirurgien | 98,9 % | 1,1 % | 0 | 2,62 | 1,52 | 0,00 | — | 2,88 | 0,68 | 1,79 |
| couleur:60 | Chirurgien | 99,0 % | 1,0 % | 0 | 2,51 | 1,32 | 0,00 | — | 2,88 | 0,68 | 1,71 |
| couleur:80 | Chirurgien | 99,2 % | 0,8 % | 0 | 2,57 | 1,48 | 0,00 | — | 2,91 | 0,71 | 1,82 |
| hasard | Réanimation | 8,3 % | 91,7 % | 0 | 5,35 | 2,68 | 0,00 | — | 2,03 | -1,88 | -10,04 |
| seuil:60 | Réanimation | 97,2 % | 2,8 % | 0 | 2,49 | 1,31 | 0,00 | — | 3,82 | 0,59 | 1,47 |
| seuil:80 | Réanimation | 97,4 % | 2,6 % | 0 | 2,56 | 1,49 | 0,00 | — | 3,86 | 0,64 | 1,64 |
| couleur:60 | Réanimation | 98,0 % | 2,1 % | 0 | 2,49 | 1,31 | 0,00 | — | 3,84 | 0,61 | 1,51 |
| couleur:80 | Réanimation | 98,1 % | 1,9 % | 0 | 2,55 | 1,47 | 0,00 | — | 3,88 | 0,67 | 1,70 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0), tous les jetons étant reportés sur la piste de l'hôpital. « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale moyenne | Finale C5 | Finale C50 | Finale C95 | Minimum moyen | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | -74,6 | -104 | -74 | -48 | -74,8 | -104 | -74 |
| seuil:60 | Interne | 18,4 | 14 | 19 | 20 | -0,1 | -1 | 0 |
| seuil:80 | Interne | 19,1 | 16 | 20 | 20 | -0,1 | 0 | 0 |
| couleur:60 | Interne | 18,6 | 15 | 19 | 20 | -0,1 | -1 | 0 |
| couleur:80 | Interne | 19,3 | 17 | 20 | 20 | -0,1 | -1 | 0 |
| hasard | Chirurgien | -87,3 | -117 | -86 | -62 | -87,4 | -117 | -86 |
| seuil:60 | Chirurgien | 16,6 | 6 | 18 | 20 | -0,4 | -3 | 0 |
| seuil:80 | Chirurgien | 17,9 | 10 | 20 | 20 | -0,2 | -2 | 0 |
| couleur:60 | Chirurgien | 17,1 | 8 | 18 | 20 | -0,5 | -3 | 0 |
| couleur:80 | Chirurgien | 18,2 | 10 | 20 | 20 | -0,2 | -2 | 0 |
| hasard | Réanimation | -100,4 | -128 | -99 | -75 | -100,5 | -128 | -99 |
| seuil:60 | Réanimation | 14,7 | 3 | 17 | 20 | -1,0 | -6 | 0 |
| seuil:80 | Réanimation | 16,4 | 4 | 20 | 20 | -0,6 | -4 | 0 |
| couleur:60 | Réanimation | 15,1 | 3 | 17 | 20 | -0,9 | -6 | 0 |
| couleur:80 | Réanimation | 17,0 | 7 | 20 | 20 | -0,4 | -4 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Spécialité | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Fracture ouverte | orthopedie | 1 | 6,4 % en 7,36 | 99,4 % en 2,71 | 99,5 % en 2,71 | 99,9 % en 2,62 | 99,5 % en 2,68 |
| Fracture fermée | orthopedie | 2 | 11,6 % en 13,56 | 99,8 % en 2,57 | 99,9 % en 2,56 | 100,0 % en 2,56 | 99,9 % en 2,57 |
| Angine bactérienne | generale | 1 | 17,0 % en 9,79 | 99,9 % en 2,66 | 99,4 % en 2,83 | 99,9 % en 2,76 | 99,9 % en 2,74 |
| Maux de tête | generale | 2 | 19,8 % en 10,91 | 99,8 % en 2,53 | 99,9 % en 2,62 | 99,9 % en 2,53 | 99,9 % en 2,57 |
| Phobie des blouses blanches | psychiatrie | 3 | 20,1 % en 7,23 | 99,9 % en 2,48 | 99,9 % en 2,54 | 99,9 % en 2,45 | 100,0 % en 2,52 |
| Hypocondrie aiguë | psychiatrie | 2 | 8,5 % en 8,47 | 99,9 % en 2,54 | 99,9 % en 2,58 | 100,0 % en 2,58 | 100,0 % en 2,59 |
