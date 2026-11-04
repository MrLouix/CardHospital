# Rapport de simulation — CardHospital — exemple réduit 0.1.0

Graine 1 · 1000 parties de 10 patients par stratégie et par difficulté · abandon au-delà de 60 actions.

## Synthèse

| Stratégie | Difficulté | Guérison | Mort | Abandon | Actions / patient | Diagnostics / patient | Pièces / action | Réputation / action | Réputation / patient |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hasard | Interne | 23,4 % | 76,6 % | 0 | 4,39 | 2,20 | 0,75 | -0,90 | -3,95 |
| seuil:60 | Interne | 98,6 % | 1,4 % | 0 | 2,34 | 1,22 | 1,76 | 0,77 | 1,80 |
| seuil:80 | Interne | 99,2 % | 0,8 % | 0 | 2,37 | 1,32 | 1,78 | 0,80 | 1,90 |
| couleur:60 | Interne | 99,1 % | 0,9 % | 0 | 2,33 | 1,21 | 1,77 | 0,79 | 1,83 |
| couleur:80 | Interne | 99,4 % | 0,7 % | 0 | 2,38 | 1,32 | 1,78 | 0,80 | 1,91 |
| hasard | Chirurgien | 16,2 % | 83,8 % | 0 | 3,02 | 1,50 | 0,78 | -1,97 | -5,94 |
| seuil:60 | Chirurgien | 90,8 % | 9,2 % | 0 | 2,22 | 1,18 | 2,04 | 0,94 | 2,08 |
| seuil:80 | Chirurgien | 94,4 % | 5,6 % | 0 | 2,32 | 1,32 | 2,04 | 1,05 | 2,45 |
| couleur:60 | Chirurgien | 91,0 % | 9,0 % | 0 | 2,22 | 1,18 | 2,04 | 0,94 | 2,09 |
| couleur:80 | Chirurgien | 94,8 % | 5,2 % | 0 | 2,32 | 1,31 | 2,06 | 1,07 | 2,49 |
| hasard | Réanimation | 13,9 % | 86,1 % | 0 | 2,63 | 1,32 | 1,44 | -2,53 | -6,65 |
| seuil:60 | Réanimation | 89,9 % | 10,1 % | 0 | 2,17 | 1,13 | 3,02 | 1,28 | 2,78 |
| seuil:80 | Réanimation | 93,8 % | 6,2 % | 0 | 2,28 | 1,28 | 3,04 | 1,44 | 3,28 |
| couleur:60 | Réanimation | 90,8 % | 9,2 % | 0 | 2,16 | 1,12 | 3,03 | 1,33 | 2,88 |
| couleur:80 | Réanimation | 94,1 % | 5,9 % | 0 | 2,28 | 1,28 | 3,06 | 1,46 | 3,32 |

## Réputation sur une partie

Cumul des impacts sur une partie (départ à 0). « Minimum » est le point le plus bas atteint en cours de partie : pour qu'au plus 5 % des parties ferment, l'écart entre la valeur de départ et le seuil de fermeture doit dépasser l'opposé du 5ᵉ centile du minimum.

| Stratégie | Difficulté | Finale C5 | Finale C50 | Finale C95 | Minimum C5 | Minimum C50 |
|---|---|---:|---:|---:|---:|---:|
| hasard | Interne | -55 | -40 | -23 | -55 | -40 |
| seuil:60 | Interne | 12 | 19 | 20 | -1 | 0 |
| seuil:80 | Interne | 14 | 20 | 20 | -1 | 0 |
| couleur:60 | Interne | 13 | 19 | 20 | -1 | 0 |
| couleur:80 | Interne | 14 | 20 | 20 | 0 | 0 |
| hasard | Chirurgien | -78 | -60 | -38 | -78 | -61 |
| seuil:60 | Chirurgien | 0 | 20 | 30 | -8 | 0 |
| seuil:80 | Chirurgien | 10 | 30 | 30 | -5 | 0 |
| couleur:60 | Chirurgien | 1 | 20 | 30 | -9 | 0 |
| couleur:80 | Chirurgien | 10 | 30 | 30 | -6 | 0 |
| hasard | Réanimation | -86 | -68 | -42 | -86 | -68 |
| seuil:60 | Réanimation | 4 | 28 | 40 | -8 | 0 |
| seuil:80 | Réanimation | 16 | 40 | 40 | -8 | 0 |
| couleur:60 | Réanimation | 4 | 28 | 40 | -8 | 0 |
| couleur:80 | Réanimation | 16 | 40 | 40 | -8 | 0 |

## Par maladie

Taux de guérison et actions par patient, par stratégie, au niveau Interne.

| Maladie | Type | Poids | hasard | seuil:60 | seuil:80 | couleur:60 | couleur:80 |
|---|---|---:|---:|---:|---:|---:|---:|
| Appendicite | chirurgie | 2 | 2,4 % en 4,22 | 97,3 % en 2,36 | 97,8 % en 2,37 | 98,2 % en 2,33 | 98,5 % en 2,38 |
| Fracture ouverte | chirurgie | 1 | 29,1 % en 3,26 | 98,4 % en 2,23 | 98,5 % en 2,36 | 98,6 % en 2,25 | 98,8 % en 2,32 |
| Angine bactérienne | pharmacie | 3 | 33,9 % en 5,08 | 99,6 % en 2,35 | 99,8 % en 2,41 | 99,6 % en 2,35 | 99,8 % en 2,41 |
| Allergie saisonnière | pharmacie | 3 | 28,9 % en 4,44 | 98,4 % en 2,38 | 99,5 % en 2,38 | 99,2 % en 2,38 | 99,6 % en 2,39 |
| Phobie des blouses blanches | psychologie | 1 | 24,0 % en 4,29 | 99,2 % en 2,29 | 99,7 % en 2,31 | 99,3 % en 2,28 | 99,5 % en 2,36 |
| Hypocondrie aiguë | psychologie | 1 | 10,5 % en 3,72 | 98,5 % en 2,30 | 99,5 % en 2,32 | 99,1 % en 2,29 | 99,5 % en 2,31 |
