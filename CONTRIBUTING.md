# Contribuer à CardHospital

Merci de votre intérêt pour le projet ! Voici comment contribuer.

## Signaler un bug ou proposer une idée

Ouvrez une [issue](../../issues/new/choose) en choisissant le modèle adapté (bug ou fonctionnalité).

## Proposer une modification

1. Forkez le dépôt et créez une branche dédiée : `git checkout -b vibe/ma-fonctionnalite`.
2. Faites des commits atomiques et messages explicites.
3. Ouvrez une **pull request** vers `main` en remplissant le modèle de PR.

## Règles de code

- Projet en **Flutter / Dart** : suivre les conventions `dart format` et `flutter analyze` (zéro warning visé).
- Le contenu du jeu (cartes, combinaisons, règles patients) va dans le **fichier JSON de configuration**, pas dans le code Dart.
- Pas de secrets ni de données personnelles dans le code ou les commits.

## Modifier le jeu sans coder

Les extensions se font via un fichier JSON chargeable depuis l'application (voir [docs/SPECIFICATION.md](docs/SPECIFICATION.md)). Un JSON d'exemple sera fourni dans `assets/`.

## Licence

Toute contribution est publiée sous licence [MIT](LICENSE).
