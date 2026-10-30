# CardHospital

Jeu de société simulant la vie d'un hôpital, assisté par une application mobile.

Les joueurs incarnent des médecins. Des patients arrivent, les médecins doivent poser le bon diagnostic et les soigner avant que leur état n'empire. Chaque carte du jeu (médecin, objet/diplôme, patient) porte un **QR code** : l'application lit les QR codes, combine leurs effets selon un fichier de règles JSON, et applique l'action in-game.

Le suivi global de la partie (points de victoire, tour de jeu, réputation de l'hôpital) reste **manuel**, hors application.

## Fonctionnement

- Un smartphone **hôte** embarque un serveur web local et affiche les résultats.
- Les autres smartphones du même réseau Wi-Fi se connectent en scannant un **QR code de connexion** et servent de **scanners** : ils transmettent les QR lus à l'hôte.
- Plusieurs QR peuvent être lus **simultanément** ; leur combinaison déclenche l'action définie dans le JSON.
- Le contenu du jeu (correspondance QR → effet, gestion des patients : PV, état) est décrit dans un **fichier JSON** embarqué et remplaçable, pour modifier le jeu ou créer des extensions sans toucher au code.

## Stack

- **Flutter / Dart** (Android, transposable iOS)
- `mobile_scanner` pour la détection multi-QR
- `shelf` + WebSocket pour le serveur embarqué et la synchro temps réel

## Documentation

- [Spécification de l'application](docs/SPECIFICATION.md)

## Licence

[MIT](LICENSE)
