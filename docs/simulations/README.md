# Rapports de simulation

Rapports produits par le simulateur du moteur (`packages/moteur/bin/simuler.dart`). Ils sont reproductibles : la même graine, le même paquet et les mêmes options donnent exactement le même rapport.

| Rapport | Paquet | Commande (depuis `packages/moteur`) |
|---|---|---|
| [rapport_exemple.md](rapport_exemple.md) | `docs/exemples/jeu.exemple.json` 0.3.0 | `dart run bin/simuler.dart --graine 1 --parties 1000 -o ../../docs/simulations/rapport_exemple.md` |
| [rapport_paquet_base.md](rapport_paquet_base.md) | `contenu/paquet_base.json` 1.2.0 | `dart run bin/simuler.dart -p ../../contenu/paquet_base.json --graine 1 --parties 1000 -o ../../docs/simulations/rapport_paquet_base.md` |

Par défaut, 3 patients sont en jeu à la fois sur une horloge commune (option `--en-jeu`) ; l'exemple n'ayant que 2 cartes patient, il en joue 2.

Les constats tirés de ces rapports sont résumés dans le [plan de codage §5.4](../PLAN_DE_CODAGE.md#54-premiers-constats-du-simulateur).
