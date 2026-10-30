# CardHospital

Jeu de société simulant la vie d'un hôpital, assisté par une application mobile.

Les joueurs incarnent des médecins. Des patients arrivent, atteints d'une maladie cachée tirée au hasard : les médecins doivent la diagnostiquer, sur la base de diagnostics probabilistes parfois trompeurs, puis la soigner avant que l'état du patient n'empire. Chaque carte du jeu (médecin, patient, salle, objet, diplôme) porte un **QR code** : l'application lit les cartes, reconnaît la combinaison et calcule le résultat de l'action selon un paquet de règles JSON.

Le suivi global de la partie (tours, points de victoire, cumul des pièces et de la réputation) reste **manuel**, hors application.

## Fonctionnement

- Le smartphone d'un joueur sert d'**hôte** : il embarque un serveur local et détient l'état de la partie.
- Les autres smartphones, sur le même Wi-Fi ou sur le point d'accès de l'hôte, rejoignent la partie en scannant un **QR code de connexion**.
- Un joueur scanne ses cartes (par exemple un médecin, un patient, une salle et un objet), appuie sur **« Valider la sélection »**, choisit l'action (diagnostiquer ou traiter), puis **confirme**. Le résultat s'affiche **uniquement sur son téléphone**.
- Le contenu du jeu (cartes, maladies, traitements, récompenses, actions) est décrit dans un **paquet** (`.zip` contenant un `jeu.json`), embarqué ou importé, pour modifier le jeu ou créer des extensions sans toucher au code.

## Stack

- **Flutter / Dart** (Android 8.0+, transposable iOS)
- `mobile_scanner` pour la détection multi-QR
- `shelf` + WebSocket pour le serveur embarqué et la synchronisation en temps réel

## Documentation

- [Spécification de l'application](docs/SPECIFICATION.md)
- [Modèle de jeu](docs/MODELE_DE_JEU.md)
- [Paquets de jeu et moteur d'effets](docs/MOTEUR_EFFETS.md), avec le [JSON Schema](docs/schema/jeu.schema.json) et un [exemple](docs/exemples/jeu.exemple.json)
- [Feuille de route](docs/FEUILLE_DE_ROUTE.md)
- [Glossaire](docs/GLOSSAIRE.md)

## Licence

[MIT](LICENSE)
