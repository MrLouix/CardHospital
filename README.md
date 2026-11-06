# CardHospital

Jeu de société simulant la vie d'un hôpital, assisté par une application mobile.

Les joueurs incarnent des médecins. Des patients arrivent, atteints d'une maladie cachée tirée au hasard : les médecins doivent la diagnostiquer, sur la base de diagnostics probabilistes parfois trompeurs, puis la soigner avant que l'état du patient n'empire. Chaque carte du jeu (médecin, patient, salle, objet, diplôme) porte un **QR code** : l'application lit les cartes, reconnaît la combinaison et calcule le résultat de l'action selon un paquet de règles JSON.

Les joueurs jouent **à tour de rôle**, même si plusieurs smartphones sont disponibles : l'application n'impose aucun ordre de jeu et ne bloque pas deux actions simultanées : c'est aux joueurs de jouer chacun leur tour. Chaque joueur peut partager ses résultats de diagnostic avec les autres ou les garder pour lui.

Le suivi global de la partie (tours, points de victoire, cumul des pièces et de la réputation, achats et constructions) reste **manuel**, hors application : l'appli n'est pas intrusive, elle gère les maladies et calcule le résultat des actions. Si la réputation de l'hôpital devient strictement inférieure au seuil de fermeture, l'hôpital ferme et **tous les joueurs ont perdu**.

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
- [Modèle de jeu](docs/MODELE_DE_JEU.md) et [règles de table](docs/REGLES_DE_TABLE.md)
- [Paquets de jeu et moteur d'effets](docs/MOTEUR_EFFETS.md), avec le [JSON Schema](docs/schema/jeu.schema.json) et un [exemple](docs/exemples/jeu.exemple.json)
- [Feuille de route](docs/FEUILLE_DE_ROUTE.md) et [plan de codage](docs/PLAN_DE_CODAGE.md)
- [Glossaire](docs/GLOSSAIRE.md)
- [Paquet de base](contenu/paquet_base.json) et [rapports de simulation](docs/simulations/README.md)
- [Revue de cohérence des règles](docs/REVUE_COHERENCE.md), avec le suivi des corrections

## Licence

[MIT](LICENSE)
