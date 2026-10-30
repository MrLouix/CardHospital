# CardHospital — Spécification de l'application

## 1. Vision

CardHospital est un jeu de société physique simulant la vie d'un hôpital. Les joueurs incarnent des médecins, des patients arrivent, et les médecins doivent poser le bon diagnostic et soigner les patients avant que leur état n'empire.

L'application Android (extensible iOS) sert de **moteur d'actions** : elle lit les QR codes imprimés sur les cartes (médecins, objets/diplômes, patients) et exécute l'effet correspondant à la combinaison scannée.

**Hors périmètre de l'appli** : le suivi global de la partie (points de victoire, tour de jeu, réputation de l'hôpital, conditions de victoire) est géré manuellement par les joueurs, hors application.

## 2. Principes directeurs

1. **Scan multi-QR simultané** : plusieurs QR codes visibles à la caméra sont lus en même temps et combinés.
2. **Contenu du jeu externalisé** : la correspondance QR → effet in-game, ainsi que la gestion des patients (PV, état), vivent dans un fichier JSON chargeable et modifiable, permettant de modifier le jeu et de créer des extensions sans toucher au code.
3. **Architecture hôte/clients** : un smartphone héberge un serveur web local ; les autres smartphones du même réseau Wi-Fi s'y connectent comme scanners.
4. **Pas de dépendance Internet** : tout fonctionne en réseau local.

## 3. Architecture réseau

### 3.1 Rôles

- **Smartphone hôte (maître)** : démarre le serveur web embarqué, centralise tous les scans, applique les effets du JSON, affiche le résultat à l'écran.
- **Smartphones clients (scanners)** : se connectent au serveur de l'hôte et lui transmettent les QR codes qu'ils lisent.

Le smartphone hôte doit pouvoir se connecter à son propre serveur comme un client classique (via `localhost` / loopback), afin de ne pas dupliquer le code d'affichage et de traitement.

### 3.2 Connexion des clients

Au démarrage, l'hôte affiche un **QR code de connexion** contenant l'adresse du serveur (IP locale + port, ex. `http://192.168.1.42:8080`). Chaque client scanne ce QR pour rejoindre la partie. Aucune saisie manuelle d'IP.

### 3.3 Protocole

- Serveur HTTP embarqué dans l'appli hôte (Dart pur, ex. `shelf`), écoutant sur le réseau local Wi-Fi.
- **WebSocket** (`web_socket_channel`) pour la communication temps réel bidirectionnelle :
  - client → hôte : envoi d'un QR lu (`{ "qr": "PATIENT-012" }`)
  - hôte → clients : accusé de réception, résultat de la combinaison, état des patients mis à jour.
- Le client affiche le résultat de l'action sur son propre écran (résolution envoyée par le serveur), le traitement restant centralisé côté hôte.

### 3.4 Règle de dédoublonnage

**Chaque scan compte** : si deux smartphones scannent le même QR en même temps, l'action est appliquée deux fois. Pas de dédoublonnage automatique.

## 4. Scan multi-QR (caméra)

- Utilisation de la caméra avec détection de plusieurs QR codes simultanés (ex. `mobile_scanner` avec `DetectionSpeed`/multi-détection, basé sur ML Kit).
- Dès que l'ensemble des QR visibles forme une combinaison reconnue par le JSON, l'action est déclenchée automatiquement.
- Les QR non reconnus ou les combinaisons inconnues sont remontés à l'écran (mode debug) sans effet de jeu.

## 5. Fichier de configuration JSON

### 5.1 Contenu

Le JSON embarqué contient :

- la **table de correspondance QR → carte** (type de carte + identifiant) ;
- les **effets des combinaisons** (quelle combinaison de types de cartes déclenche quelle action) ;
- la **gestion des patients** : points de vie, états, évolution (empirer / soigner).

Il ne contient **pas** : réputation de l'hôpital, points de victoire, conditions de victoire, gestion des tours (hors appli).

### 5.2 Distribution

- Un JSON **par défaut embarqué** dans l'application (assets).
- Possibilité de **charger un JSON externe** (import via le système de fichiers / partage Android) pour les extensions et variantes de règles. Le JSON actif est sélectionnable dans l'écran admin.

### 5.3 Schéma (exemple)

```json
{
  "version": "1.0",
  "cards": {
    "MED-001": { "type": "medecin", "nom": "Dr House", "specialite": "diagnostiqueur" },
    "PAT-012": { "type": "patient", "nom": "M. Dupont", "maladie": "grippe", "pv": 10, "pv_max": 10 },
    "OBJ-004": { "type": "objet", "nom": "Stéthoscope", "diplome_requis": null }
  },
  "combinations": [
    {
      "id": "diagnostiquer",
      "cartes_requises": ["medecin", "patient"],
      "effet": {
        "action": "diagnostiquer",
        "cible": "patient",
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

## 6. Écran admin (hôte)

L'application hôte propose un écran d'administration permettant de :

- **annuler un scan** (révoquer la dernière action appliquée) ;
- **enregistrer / charger une partie** (sauvegarde de l'état des patients) ;
- **debug** : voir les QR lus, les combinaisons déclenchées, les requêtes reçues des clients, les logs serveur.

## 7. Stack technique

| Élément | Choix | Justification |
|---|---|---|
| Framework | **Flutter (Dart)** | Une base de code, transposable iOS, caméra multi-QR mature |
| Caméra / QR | `mobile_scanner` (ML Kit / AVFoundation) | Multi-détection simultanée |
| Serveur embarqué | `shelf` (HTTP) + `web_socket_channel` (WebSocket) | Dart pur, embarquable, temps réel |
| JSON | `dart:convert` + modèles générés (`json_serializable`) | Typé, validable |
| Stockage local | `shared_preferences` / `path_provider` + fichiers JSON | Sauvegardes de partie, import d'extensions |

Version Android minimale cible : à définir (proposition : Android 8.0 / API 26, couvrant la majorité du parc).

## 8. Hors périmètre (rappel)

- Suivi des points de victoire, réputation de l'hôpital, conditions de victoire : géré manuellement.
- Gestion du tour de chaque joueur : manuelle.
- Fonctionnement hors réseau local / via Internet : non prévu.

## 9. Questions ouvertes

1. Version Android minimale exacte (proposition : API 26).
2. Nombre maximal de clients scanners simultanés (proposition : illimité côté serveur, testé jusqu'à ~8).
3. Faut-il un mode « partie enregistrée » rejouable (log des scans) au-delà de la sauvegarde d'état ?
