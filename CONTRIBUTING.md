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
- Le contenu du jeu (cartes, maladies, traitements, récompenses, actions) va dans le **paquet de jeu** (`jeu.json`), pas dans le code Dart.
- Pas de secrets ni de données personnelles dans le code ou les commits.

## Modifier le jeu sans coder

Les extensions sont des paquets `.zip` contenant un `jeu.json`, importables depuis l'application. Le format, le mini-langage d'effets et les règles de validation sont décrits dans [docs/MOTEUR_EFFETS.md](docs/MOTEUR_EFFETS.md) ; le fichier peut être vérifié avec le [JSON Schema](docs/schema/jeu.schema.json), et un [exemple valide](docs/exemples/jeu.exemple.json) est fourni.

## Licence

Toute contribution est publiée sous licence [MIT](LICENSE).
