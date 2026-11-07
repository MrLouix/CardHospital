# Rapports de simulation

Rapports produits par le simulateur du moteur (`packages/moteur/bin/simuler.dart`). Ils sont reproductibles : la même graine, le même paquet et les mêmes options donnent exactement le même rapport.

| Rapport | Paquet | Commande (depuis `packages/moteur`) |
|---|---|---|
| [rapport_exemple.md](rapport_exemple.md) | `docs/exemples/jeu.exemple.json` 0.6.0 | `dart run bin/simuler.dart --graine 1 --parties 1000 -o ../../docs/simulations/rapport_exemple.md` |
| [rapport_paquet_base.md](rapport_paquet_base.md) | `contenu/paquet_base.json` 2.2.0 | `dart run bin/simuler.dart -p ../../contenu/paquet_base.json --graine 1 --parties 1000 -s hasard,seuil:60,seuil:80,couleur:60,couleur:80,novice:70,novice+labo:70,novice+labo:80 -o ../../docs/simulations/rapport_paquet_base.md` |
| [rapport_paquet_base_3_joueurs.md](rapport_paquet_base_3_joueurs.md) | `contenu/paquet_base.json` 2.2.0, 3 joueurs | `dart run bin/simuler.dart -p ../../contenu/paquet_base.json --graine 1 --parties 1000 --joueurs 3 --strategies hasard,seuil:70,couleur:70,novice:70,novice+labo:70 -o ../../docs/simulations/rapport_paquet_base_3_joueurs.md` |
| [rapport_paquet_base_3_joueurs_cartes_personnelles.md](rapport_paquet_base_3_joueurs_cartes_personnelles.md) | `contenu/paquet_base.json` 2.2.0, 3 joueurs, un médecin chacun | `dart run bin/simuler.dart -p ../../contenu/paquet_base.json --graine 1 --parties 1000 --joueurs 3 --cartes personnelles --strategies hasard,seuil:70,couleur:70,novice:70,novice+labo:70 -o ../../docs/simulations/rapport_paquet_base_3_joueurs_cartes_personnelles.md` |

Par défaut, 3 patients sont en jeu à la fois sur une horloge commune (option `--en-jeu`) ; l'exemple n'ayant que 2 cartes patient, il en joue 2.

Avec `--cartes personnelles`, chaque joueur n'a que son médecin (plus un diplôme à 2 ou 3 joueurs), comme à la table ; sinon, chaque joueur dispose de toutes les cartes.

Les constats tirés de ces rapports sont résumés dans le [plan de codage §5.4](../PLAN_DE_CODAGE.md#54-premiers-constats-du-simulateur) et analysés dans l'[analyse de l'équilibre](../ANALYSE_EQUILIBRE.md).
