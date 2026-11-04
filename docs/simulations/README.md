# Rapports de simulation

Rapports produits par le simulateur du moteur (`packages/moteur/bin/simuler.dart`). Ils sont reproductibles : la même graine, le même paquet et les mêmes options donnent exactement le même rapport.

| Rapport | Paquet | Commande (depuis `packages/moteur`) |
|---|---|---|
| [rapport_exemple.md](rapport_exemple.md) | `docs/exemples/jeu.exemple.json` 0.1.0 | `dart run bin/simuler.dart --graine 1 --parties 1000 -o ../../docs/simulations/rapport_exemple.md` |

Les constats tirés de ces rapports sont résumés dans le [plan de codage §5.4](../PLAN_DE_CODAGE.md#54-premiers-constats-du-simulateur).
