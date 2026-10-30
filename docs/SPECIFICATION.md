# CardHospital — Spécification de l'application

## 1. Vision

CardHospital est un jeu de société physique simulant la vie d'un hôpital. Les joueurs incarnent des médecins, des patients arrivent, et les médecins doivent poser le bon diagnostic et les soigner avant que leur état n'empire.

L'application Android (extensible iOS) sert de **moteur d'actions** : elle lit les QR codes imprimés sur les cartes (médecins, objets/diplômes, patients) et exécute l'effet correspondant à la combinaison scannée.

**Hors périmètre de l'appli** : le suivi global de la partie (points de victoire, tour de jeu, réputation de l'hôpital, conditions de victoire) est géré manuellement par les joueurs, hors application. Il n'y a pas de « joueur maître du jeu » dans l'appli.

## 2. Principes directeurs

1. **Scan multi-QR simultané** : plusieurs QR codes visibles à la caméra sont lus en même temps et combinés.
2. **Contenu du jeu externalisé** : la correspondance QR → effet in-game, ainsi que la gestion des patients (PV, état), vivent dans un fichier JSON chargeable et modifiable, permettant de modifier le jeu et de créer des extensions sans toucher au code.
3. **Architecture hôte/clients** : un seul smartphone hôte par partie héberge un serveur web local ; les autres smartphones du même réseau Wi-Fi s'y connectent comme scanners.
4. **Pas de dépendance Internet** : tout fonctionne en réseau local.
5. **Aucune identité de joueur dans l'appli** : un même smartphone peut être utilisé par plusieurs joueurs successivement ; rien n'est lié à un joueur en particulier.

## 3. Architecture réseau

### 3.1 Rôles

- **Smartphone hôte** (unique par partie) : démarre le serveur web embarqué, centralise tous les scans, applique les effets du JSON, conserve l'état des patients.
- **Smartphones clients** : se connectent au serveur de l'hôte, **scannent** les QR codes, transmettent les combinaisons lues à l'hôte pour traitement, et **visualisent le résultat** de l'action renvoyé par le serveur.

Le smartphone hôte peut aussi scanner directement : il se connecte à son propre serveur via loopback, afin de ne pas dupliquer le code de scan et d'affichage.

### 3.2 Connexion des clients

Au démarrage, l'hôte affiche un **QR code de connexion** contenant l'adresse du serveur (IP locale + port, ex. `http://192.168.1.42:8080`). Chaque client scanne ce QR pour rejoindre la partie. Aucune saisie manuelle d'IP.

Le QR code de connexion reste accessible **à tout moment** depuis la page admin (bouton dédié), pour qu'un joueur puisse rejoindre la partie en cours de jeu.

### 3.3 Protocole

- Serveur HTTP embarqué dans l'appli hôte (Dart pur, ex. `shelf`), écoutant sur le réseau local Wi-Fi.
- **WebSocket** pour la communication temps réel bidirectionnelle :
  - client → hôte : envoi des QR lus / de la combinaison détectée (`{ "qrs": ["MED-001", "OBJ-004", "PAT-012"] }`)
  - hôte → client : accusé de réception et **résultat de l'action demandée par ce client**, affiché uniquement sur le smartphone du joueur qui a réalisé l'action (voir §4.3).
- Le traitement et l'état du jeu restent centralisés côté hôte.

### 3.4 Règle de dédoublonnage

**Chaque scan compte** : si deux smartphones scannent le même QR en même temps, deux demandes de confirmation sont proposées et chaque confirmation applique son action. Pas de dédoublonnage automatique.

## 4. Déroulement d'une action (scan → résultat)

### 4.1 Scan multi-QR (caméra)

- Caméra avec détection de **plusieurs QR codes simultanés** (ex. `mobile_scanner`, basé sur ML Kit).
- Dès que les QR visibles forment une combinaison reconnue par le JSON, l'appli passe en **mode confirmation**. L'action n'est jamais appliquée automatiquement.
- Les QR non reconnus ou combinaisons inconnues sont remontés à l'écran (debug) sans effet de jeu.

### 4.2 Écran de confirmation

1. Le joueur scanne les cartes sur **son propre téléphone**.
2. L'appli affiche un **écran visuel de la combinaison** : l'**image de chaque carte scannée** (les images sont celles imprimées sur les cartes physiques, embarquées dans l'appli) côte à côte, accompagnée d'un **texte explicatif** de l'action qui sera réalisée (phrase issue du JSON), ex. *« Le Dr House utilise le Stéthoscope pour diagnostiquer M. Dupont. »*
3. Deux boutons : **Confirmer** ou **Annuler**.
   - **Confirmer** : l'action est appliquée côté hôte (effet du JSON sur l'état des patients).
   - **Annuler** : rien n'est appliqué, retour au scan.

### 4.3 Écran de résultat

- Le **résultat n'apparaît que sur le smartphone du joueur qui a confirmé l'action** (envoyé par l'hôte à ce client uniquement).
- Le joueur communique le résultat aux autres **de vive voix ou en montrant son écran** : aucun bouton « révéler », aucun envoi automatique aux autres smartphones.
- Un bouton **« OK » / « Fin de l'action »** ferme l'écran de résultat et ramène à l'écran d'accueil (prêt pour un nouveau scan).

### 4.4 Contenu du résultat d'une action

Après chaque action (diagnostic ou tentative de traitement), l'appli affiche le résultat :

- **État du patient** : soit il **perd des PV** (détérioration par temps passé sans traitement, ou traitement non adapté), soit il **en gagne** (traitement efficace) ;
- **Issue du patient** : est-il **soigné** (traitement adapté — ne correspond pas nécessairement à ses PV max) ou **mort** (0 PV) ;
- **Paiement** : combien de **pièces** gagne le médecin/joueur auteur de l'action (paiement du patient pour le diagnostic ou le traitement) ;
- **Réputation de l'hôpital** : impact **positif** si le traitement est concluant, **négatif** si le traitement n'est pas concluant ou si le patient a trop attendu (trop longue succession de diagnostics / tentatives de traitement).

Note : pièces et réputation sont affichées à titre informatif dans l'appli ; leur cumul global reste géré manuellement hors appli.

## 5. Fichier de configuration JSON

### 5.1 Contenu

Le JSON contient :

- la **table de correspondance QR → carte** (type de carte, identifiant, nom, **image de la carte** embarquée dans l'appli — les extensions réutilisent ces mêmes images) ;
- les **effets des combinaisons** (quelle combinaison de types de cartes déclenche quelle action, avec la **phrase d'aperçu** affichée avant confirmation, ex. *« Le {medecin} utilise {objet} sur {patient}. »*) ;
- la **gestion des patients** : points de vie, états, évolution (empirer / soigner) ;
- les **3 niveaux de difficulté** (noms médicaux) et leurs modificateurs (détérioration PV, récompense en pièces, impact réputation) ;

Il ne contient **pas** : conditions de victoire, gestion des tours (hors appli). La réputation et les pièces sont des résultats affichés par action, dont le cumul reste manuel.

### 5.2 Distribution

- Un JSON **par défaut embarqué** dans l'application (assets).
- Possibilité de **charger un JSON externe** (import via le système de fichiers / partage Android) pour les extensions. Les extensions réutilisent les images des cartes embarquées. Le JSON actif est sélectionnable dans l'écran admin.

### 5.3 Schéma (exemple)

```json
{
  "version": "1.0",
  "difficultes": [
    { "id": "interne", "nom": "Interne", "pv_perdus_modifier": 1.0, "pieces_modifier": 1.0, "reputation_modifier": 1.0 },
    { "id": "chirurgien", "nom": "Chirurgien", "pv_perdus_modifier": 1.5, "pieces_modifier": 1.2, "reputation_modifier": 1.5 },
    { "id": "reanimation", "nom": "Réanimation", "pv_perdus_modifier": 2.0, "pieces_modifier": 1.5, "reputation_modifier": 2.0 }
  ],
  "cards": {
    "MED-001": { "type": "medecin", "nom": "Dr House", "specialite": "diagnostiqueur", "image": "assets/cartes/MED-001.png" },
    "PAT-012": { "type": "patient", "nom": "M. Dupont", "maladie": "grippe", "pv": 10, "pv_max": 10, "image": "assets/cartes/PAT-012.png" },
    "OBJ-004": { "type": "objet", "nom": "Stéthoscope", "diplome_requis": null, "image": "assets/cartes/OBJ-004.png" }
  },
  "combinations": [
    {
      "id": "diagnostiquer",
      "cartes_requises": ["medecin", "patient"],
      "effet": {
        "action": "diagnostiquer",
        "cible": "patient",
        "phrase": "Le {medecin} diagnostique {patient}.",
        "resultat": "Le médecin pose le diagnostic de la maladie du patient."
      }
    },
    {
      "id": "soigner",
      "cartes_requises": ["objet", "patient"],
      "effet": {
        "action": "soigner",
        "cible": "patient",
        "pv_restaures": 4,
        "condition": "diagnostic_pose"
      }
    },
    {
      "id": "empirer",
      "cartes_requises": ["patient"],
      "effet": {
        "action": "tick_patient",
        "cible": "patient",
        "pv_perdus": 2
      }
    }
  ]
}
```

Le schéma exact (champs, conditions, effets chaînés) sera affiné lors de la conception du moteur d'effets.

## 6. Page admin (hôte)

L'hôte ouvre la page admin, qui permet de :

### 6.1 Lancer une partie

- Choisir un **niveau de difficulté** parmi **3 niveaux nommés avec des termes médicaux**. Le niveau influe sur les conséquences des actions : effet détérioratif sur les PV plus ou moins élevé, récompense financière (pièces) plus ou moins forte, effet sur la réputation plus ou moins fort.
- Afficher le **QR code de connexion** (voir §3.2).

### 6.2 Suivi et debug (hors jeu)

- voir l'**état des patients** (PV, diagnostic, état) ;
- visualiser le **résultat des 5 dernières actions** (PV perdus/gagnés, guérison/mort, pièces gagnées, impact réputation) ;
- voir la **liste des 5 derniers scans** et pouvoir les **annuler un par un** ;
- **enregistrer / charger une partie** (sauvegarde de l'état des patients) ;
- voir les QR lus, combinaisons déclenchées, requêtes reçues des clients, logs serveur.

## 7. Stack technique

| Élément | Choix | Justification |
|---|---|---|
| Framework | **Flutter (Dart)** | Une base de code, transposable iOS, caméra multi-QR mature |
| Caméra / QR | `mobile_scanner` (ML Kit / AVFoundation) | Multi-détection simultanée |
| Serveur embarqué | `shelf` (HTTP) + `web_socket_channel` (WebSocket) | Dart pur, embarquable, temps réel |
| JSON | `dart:convert` + modèles générés (`json_serializable`) | Typé, validable |
| Stockage local | `shared_preferences` / `path_provider` + fichiers JSON | Sauvegardes de partie, import d'extensions |

Version Android minimale cible : **Android 8.0 (API 26)**.

## 8. Hors périmètre (rappel)

- Suivi des points de victoire, réputation de l'hôpital, conditions de victoire : géré manuellement.
- Gestion du tour de chaque joueur : manuelle.
- Identité de joueur dans l'appli : aucune.
- Fonctionnement hors réseau local / via Internet : non prévu.

## 9. Décisions entérinées

1. **Version Android minimale** : Android 8.0 (API 26).
2. **Clients scanners simultanés** : illimité côté serveur, testé jusqu'à ~8 clients.
3. **Partie rejouable** : non. L'écran admin se limite à la sauvegarde/restauration de l'état des patients et à l'annulation des 5 derniers scans, sans log rejouable.
4. **Confirmation obligatoire** : aucune action n'est appliquée sans confirmation (Confirmer/Annuler).
5. **Résultat privé** : affiché uniquement sur le smartphone de l'acteur, communiqué aux autres de vive voix ou en montrant l'écran ; le client visualise le résultat renvoyé par l'hôte pour son action.
6. **Un seul hôte par partie** ; les clients scannent et visualisent le résultat de leurs actions.
7. **Niveaux de difficulté** : 3 niveaux nommés par des termes médicaux, choisis au lancement depuis la page admin ; ils modulent détérioration PV, pièces et réputation.
8. **Résultat d'action** : PV perdus/gagnés, guérison ou mort (0 PV), pièces gagnées, impact réputation — affiché sur le téléphone de l'acteur et consultable pour les 5 dernières actions dans l'admin.
