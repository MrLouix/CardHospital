# CardHospital — Spécification de l'application

| Document | Contenu |
|---|---|
| **SPECIFICATION.md** (ce document) | Application : architecture, réseau, parcours d'une action, écrans, page admin, exigences |
| [MODELE_DE_JEU.md](MODELE_DE_JEU.md) | Règles calculées : patients, maladies, diagnostic, traitement, horloge et aggravation, récompenses |
| [MOTEUR_EFFETS.md](MOTEUR_EFFETS.md) | Format des paquets (`.zip` + `jeu.json`), mini-langage d'effets, validation |
| [schema/jeu.schema.json](schema/jeu.schema.json) | JSON Schema du fichier `jeu.json` |
| [FEUILLE_DE_ROUTE.md](FEUILLE_DE_ROUTE.md) | Phases de développement, risques en premier |
| [PLAN_DE_CODAGE.md](PLAN_DE_CODAGE.md) | État de préparation, points à trancher, organisation du dépôt, démarrage des phases 0 et 1 |
| [REGLES_DE_TABLE.md](REGLES_DE_TABLE.md) | Règles hors appli : mise en place, tour, économie, victoire, formation |
| [GLOSSAIRE.md](GLOSSAIRE.md) | Définition des termes |

## 1. Objet et périmètre

CardHospital est un jeu de société physique simulant la vie d'un hôpital. Les joueurs incarnent des médecins : des patients arrivent, et les médecins doivent poser le bon diagnostic et les soigner avant que leur état n'empire.

L'application Android (transposable iOS) sert de **moteur d'actions**. Elle lit les QR codes imprimés sur les cartes (médecins, patients, salles, objets, diplômes), reconnaît la combinaison, calcule l'effet selon le paquet de jeu actif, puis affiche le résultat au joueur qui a agi.

**Hors périmètre de l'appli** (géré à la table par les joueurs) :

- tour de jeu : les joueurs jouent **à tour de rôle**, même si plusieurs smartphones sont disponibles ; l'appli n'impose aucun ordre de jeu et ne bloque pas deux actions simultanées (§5.4) : c'est aux joueurs de jouer chacun leur tour ;
- partage ou non des résultats de diagnostic entre joueurs (les probabilités sont réglées pour que ne rien mettre en commun rende la défaite commune quasi inévitable, [MODELE_DE_JEU.md §8.6](MODELE_DE_JEU.md#86-partage-des-diagnostics-entre-joueurs)) ;
- points de victoire et conditions de victoire ou de défaite, dont la **fermeture de l'hôpital** quand la réputation devient strictement inférieure au seuil de fermeture (tous les joueurs perdent, [MODELE_DE_JEU.md §7.1](MODELE_DE_JEU.md#71-réputation-et-fermeture-de-lhôpital)) ;
- cumul des pièces et de la réputation, partage des gains entre le joueur et l'hôpital, achats, constructions, réapprovisionnements, formation ([règles de table](REGLES_DE_TABLE.md)) ;
- pioche des patients et nombre de patients en jeu ;
- identité des joueurs : l'appli n'en connaît aucune ;
- fonctionnement via Internet : tout se passe en réseau local.

## 2. Principes directeurs

1. **Sélection multi-QR puis validation** : la caméra détecte plusieurs QR à la fois et les cumule dans une sélection ; le joueur déclenche le traitement par le bouton **« Valider la sélection »**. Rien n'est déclenché automatiquement.
2. **Confirmation obligatoire** : aucune action n'est appliquée sans appui sur « Confirmer ».
3. **Résultat privé** : le résultat d'une action n'apparaît que sur le téléphone de l'acteur ; les joueurs choisissent de le partager aux autres (de vive voix ou en montrant leur écran) ou de le garder pour eux, [MODELE_DE_JEU.md §8.6](MODELE_DE_JEU.md#86-partage-des-diagnostics-entre-joueurs).
4. **Hôte autoritaire** : un seul téléphone (celui d'un joueur) détient l'état du jeu, calcule les aperçus et applique les effets. Les clients n'embarquent que les images des cartes.
5. **Contenu externalisé** : cartes, maladies, traitements, récompenses et actions vivent dans un paquet de jeu (`.zip` + `jeu.json`). Modifier le jeu ne demande aucun code.
6. **Hors ligne** : aucune dépendance à Internet.
7. **Aucune identité de joueur** : un téléphone peut servir successivement à plusieurs joueurs.
8. **Montants entiers** : PV, pièces et réputation sont toujours des entiers ; la difficulté leur ajoute des bonus entiers ([MODELE_DE_JEU.md §10](MODELE_DE_JEU.md#10-difficulté)).
9. **Appli non intrusive** : l'appli gère les maladies et calcule le résultat des actions ; elle ne suit ni les tours, ni les joueurs, ni l'économie, ni les scores, qui se jouent à la table ([règles de table](REGLES_DE_TABLE.md)).

## 3. Architecture

### 3.1 Rôles

- **Hôte** (un seul par partie) : c'est le téléphone d'un joueur. Il démarre le serveur embarqué, charge le paquet actif, conserve l'état des patients, calcule les aperçus et applique les actions. Son joueur scanne avec ce même téléphone, qui se connecte à son propre serveur en **loopback** : il n'y a qu'un seul code de scan et d'affichage.
- **Clients** : ils se connectent à l'hôte, scannent les cartes, transmettent la sélection, affichent l'aperçu puis le résultat de **leurs propres** actions.

### 3.2 Connexion des clients

- L'hôte affiche un **QR code de connexion** au format `cardhospital://rejoindre?hote=192.168.1.42&port=8080&jeton=<jeton>`. Le schéma `cardhospital://` ouvre directement l'appli si le QR est lu avec l'appareil photo du téléphone ; il évite aussi toute confusion avec un QR de carte.
- Le **jeton** est aléatoire (128 bits), généré à chaque nouvelle partie et exigé à l'ouverture de la connexion : un appareil du réseau qui n'a pas scanné le QR ne peut pas envoyer d'actions.
- Aucune saisie manuelle d'adresse.
- Le QR de connexion reste accessible **à tout moment** depuis la page admin, pour qu'un joueur rejoigne la partie en cours.

### 3.3 Protocole

Serveur HTTP embarqué (Dart, `shelf`) sur le réseau local et **WebSocket** pour les échanges. Tous les messages sont des objets JSON portant une clé `type`.

| Sens | `type` | Contenu | Rôle |
|---|---|---|---|
| C → H | `bonjour` | `jeton`, `version_protocole`, `id_client` (facultatif, en cas de reconnexion) | Ouverture de session |
| H → C | `bienvenue` | `id_client`, `paquet` (`id`, `version`) | Session acceptée |
| H → C | `rejet` | `raison` | Jeton invalide ou protocole incompatible |
| C → H | `valider` | `qrs` : liste des contenus QR sélectionnés | Appui sur « Valider la sélection » |
| H → C | `apercu` | `apercu_id`, `cartes` (identifiants), `actions` : liste de `{id, libelle, phrase}`, plus `maladies` (maladies suspectées du patient, `{id, nom, specialite}`) pour l'action `analyser` | Combinaison reconnue |
| H → C | `refus` | `raison` (message affichable) | Sélection non conforme, patient non admis… |
| C → H | `confirmer` | `apercu_id`, `action_id`, `maladie_id` (facultatif : maladie choisie pour l'action `analyser`) | Appui sur une action |
| C → H | `annuler` | `apercu_id` | Appui sur « Annuler » |
| H → C | `resultat` | voir [MODELE_DE_JEU.md §11.1](MODELE_DE_JEU.md#111-format-du-résultat) | Envoyé **au seul client** qui a confirmé |
| C ↔ H | `ping` / `pong` | — | Toutes les 5 s, pour détecter les coupures |

- `id_client` est un identifiant **technique d'appareil**, et non de joueur. Il sert à renvoyer le dernier résultat à un client qui s'est reconnecté entre sa confirmation et la réception du résultat.
- L'hôte conserve un aperçu tant que le client n'a pas confirmé, annulé ou envoyé une nouvelle sélection (expiration : 5 minutes).
- `version_protocole` est un entier. Une version différente de celle de l'hôte est rejetée avec un message invitant à mettre l'appli à jour.

### 3.4 Réseau

- **Wi-Fi local** ou **point d'accès de l'hôte** (partage de connexion Android). Le point d'accès est la solution de repli quand il n'y a pas de Wi-Fi, ou quand le Wi-Fi isole les appareils entre eux (fréquent dans les hôtels et les gîtes).
- L'hôte détecte ses adresses IPv4 locales. S'il y en a plusieurs (Wi-Fi et point d'accès), il prend l'interface Wi-Fi ou point d'accès par défaut, et la page admin permet d'en choisir une autre.
- Si un client ne parvient pas à joindre l'hôte dans les 10 s, l'appli suggère d'utiliser le point d'accès de l'hôte.
- Le trafic `http://` / `ws://` en clair doit être autorisé explicitement (`network_security_config`), car Android le bloque par défaut depuis Android 9. C'est acceptable en réseau local, avec le jeton de session.

### 3.5 Robustesse de l'hôte

- **Service de premier plan** (*foreground service*, avec notification permanente « Partie CardHospital en cours ») : il porte le serveur et l'état, et survit à un appel entrant ou à un changement d'application.
- **Verrou de veille partiel** pendant une partie : l'écran peut s'éteindre sans couper le serveur.
- **Sauvegarde automatique** de l'état après chaque action confirmée. L'écriture est atomique (fichier temporaire puis renommage).
- **Format de la sauvegarde** (code : `packages/moteur/lib/moteur/etat.dart` et `partie.dart`) : `{ "format_sauvegarde": 1, "etat": …, "historique": [ { "avant": …, "resultat": … } ] }`. L'état contient `format_etat` (3), l'identité du `paquet` (`id`, `version`, `empreinte` SHA-256 du `jeu.json`), la `difficulte`, le nombre d'`actions` confirmées, l'horloge de l'hôpital (`ticks`) et les `patients` déjà admis, par identifiant de carte : `statut` (`en_jeu` ou `sorti`), `maladie`, `pv`, `admission` (tick d'admission), `suspectees` (maladies apparues dans ses diagnostics, s'il y en a) et, pour un patient sorti, `issue` (`gueri` ou `mort`). Un patient jamais admis n'y figure pas. L'état contient aussi `recherche` : les passages en laboratoire comptés par maladie, communs à toute la partie. Une sauvegarde au format d'état 2, antérieur au laboratoire, est encore relue. L'historique garde les 5 dernières actions annulables, chacune avec l'instantané pris avant elle. L'état du générateur aléatoire n'est pas sauvegardé : une partie reprise continue avec un hasard neuf.
- **Reprise** : au redémarrage de l'appli hôte, si une partie est en cours, l'appli propose de la reprendre. Le jeton est conservé : les clients se reconnectent seuls si l'adresse IP n'a pas changé, et sinon ils doivent rescanner le QR de connexion.
- **Reconnexion des clients** : automatique, avec des délais croissants (1, 2, 4, 8 s, puis toutes les 10 s), et un bandeau « Connexion à l'hôte perdue… » tant qu'elle n'est pas rétablie.

## 4. Détection des cartes

### 4.1 Sélection cumulative

- La caméra détecte en continu les QR visibles (plusieurs à la fois).
- Un QR **entre dans la sélection** dès qu'il est détecté sur 2 images consécutives, ce qui filtre les fausses lectures. Il **y reste** même s'il sort du champ : toutes les cartes n'ont pas besoin d'être visibles au même instant.
- La sélection est affichée en bas de l'écran sous forme de vignettes (images embarquées des cartes). Un QR inconnu apparaît en grisé (« carte inconnue ») et ne sera pas transmis.
- Le joueur peut **retirer une carte** (appui sur sa vignette) ou **vider la sélection**.
- La sélection est vidée après la confirmation, l'annulation ou un refus.
- Le QR de connexion d'une partie n'est jamais ajouté à la sélection.

### 4.2 Recommandations d'impression des QR

Elles sont à valider en phase 0 de la [feuille de route](FEUILLE_DE_ROUTE.md) :

- contenu minimal : l'identifiant de la carte (`MED-001`), soit un QR version 1 (21 × 21 modules) ;
- taille imprimée d'au moins 2 cm, avec une marge blanche de 4 modules ;
- correction d'erreur de niveau M ou Q ;
- finition **mate** : les plastifications brillantes provoquent des reflets.

## 5. Parcours d'une action

### 5.1 Sélection

Le joueur pose ses cartes, les scanne avec **son propre téléphone** et vérifie les vignettes.

### 5.2 Validation

Le bouton **« Valider la sélection »** envoie la liste des QR à l'hôte (`valider`). L'hôte reconnaît le motif de la combinaison ([MODELE_DE_JEU.md §3](MODELE_DE_JEU.md#3-combinaisons)), évalue les préconditions des actions, puis répond :

- par un **aperçu** (une ou plusieurs actions possibles) ;
- ou par un **refus** avec un message explicite : « Il faut une carte salle », « Une seule carte patient par action », « M. Dupont n'est pas en jeu », « M. Dupont est déjà en jeu »… La sélection est conservée pour être corrigée.

### 5.3 Écran de confirmation

1. Les **images des cartes** de la combinaison, côte à côte.
2. Pour chaque action possible, un bouton (« Admettre », « Diagnostiquer », « Traiter », « Analyser » selon les motifs reconnus et les préconditions : le laboratoire ne propose qu'« Analyser ») accompagné de sa **phrase d'aperçu** calculée par l'hôte, par exemple : *« Tentative de soin de M. Dupont par le Dr Cassagne et le Dr Vasseur au bloc opératoire. »* Pour « Analyser », l'écran affiche aussi la liste des maladies suspectées du patient, avec la couleur et l'icône de leur spécialité : le joueur en choisit une avant de confirmer.
3. Un bouton **« Annuler »** : rien n'est appliqué et l'appli revient à la sélection.

L'aperçu ne révèle **aucune information cachée** (maladie, PV).

### 5.4 Règle de dédoublonnage

**Chaque scan compte.** Deux téléphones qui scannent les mêmes cartes obtiennent chacun un aperçu, et chaque confirmation applique son action : l'horloge de l'hôpital avance de deux ticks. Il n'y a pas de dédoublonnage automatique.

### 5.5 Confirmation et revalidation

À la réception de `confirmer`, l'hôte **réévalue la précondition** de l'action sur l'état courant, car celui-ci a pu changer depuis l'aperçu. Si elle n'est plus vérifiée (patient mort, sorti, ou déjà admis entre-temps), l'action n'est pas appliquée et le client reçoit un refus : « M. Dupont n'est plus en jeu — action non appliquée ». Pour une analyse, la maladie choisie doit figurer parmi les maladies suspectées du patient, sinon l'action est refusée de la même façon. Sinon, l'hôte prend un instantané, applique les effets, sauvegarde, puis envoie le résultat.

### 5.6 Écran de résultat

- Visible **uniquement** sur le téléphone de l'acteur. Il n'existe ni bouton « révéler », ni envoi aux autres téléphones.
- Contenu : PV avant → après, durée de présence du patient et éventuelle attente dépassée, diagnostic (liste des 5 maladies les plus suspectes, chacune avec son indice de suspicion, la couleur et l'icône de sa spécialité), issue (en jeu, guéri ou mort, avec la maladie révélée à la sortie), pièces gagnées, impact sur la réputation. Pour une **analyse** (laboratoire de recherche) s'ajoutent : la maladie choisie, et les passages restants ou la recette révélée (« L'antibiotique, dans la salle de consultation ou à la pharmacie. »). Le détail figure dans [MODELE_DE_JEU.md §11](MODELE_DE_JEU.md#11-contenu-dun-résultat).
- Deux rappels : « Pièces : à garder, à donner à l'hôpital ou à verser à une construction ou à un réapprovisionnement » et, si l'impact n'est pas nul, « Réputation : +4 à garder pour votre médecin ou à laisser à l'hôpital » pour un gain, « Réputation : −2 à reporter sur la piste de l'hôpital ou à prendre pour vous » pour une perte ([règles de table §3](REGLES_DE_TABLE.md#3-pièces-réputation-et-points-de-victoire)).
- À la mort d'un patient, un rappel : « Défaussez la carte de Mme Garnier ».
- Un bouton **« OK / Fin de l'action »** ramène à l'écran de sélection.

## 6. Écrans et cas d'erreur

### 6.1 Écrans

| Écran | Rôle |
|---|---|
| Accueil | « Héberger une partie », « Rejoindre une partie », « Paquets de jeu » |
| Admin (hôte) | Démarrage, QR de connexion, section debug repliée (§7) |
| Sélection | Caméra, vignettes de la sélection, « Vider », « Valider la sélection », bandeau de connexion |
| Confirmation | Images, une action par bouton avec sa phrase, « Annuler » |
| Résultat | Détail du résultat, « OK » |
| Paquets de jeu | Liste des paquets, import d'un `.zip`, rapport de validation (erreurs et avertissements) |

### 6.2 Cas d'erreur

| Situation | Comportement |
|---|---|
| Caméra refusée | Écran explicatif, lien vers les réglages |
| QR inconnu | Vignette grisée, non transmise |
| Sélection non conforme | Refus de l'hôte avec le premier écart ; la sélection est conservée |
| Précondition non vérifiée à la confirmation | Refus, rien n'est appliqué (§5.5) |
| Perte de connexion (client) | Bandeau, reconnexion automatique ; dernier résultat renvoyé à la reconnexion |
| Perte de l'hôte | Clients en attente de reconnexion ; reprise de la partie côté hôte (§3.5) |
| Jeton invalide, protocole incompatible | Rejet avec un message (« Rescannez le QR de connexion », « Mettez l'appli à jour ») |
| Paquet invalide | Import refusé, liste des erreurs avec leur chemin dans le JSON |
| Sauvegarde faite avec un autre paquet | Avertissement ; refus si des maladies référencées n'existent plus |

## 7. Page admin (hôte)

En jeu normal, la page admin ne sert **qu'au démarrage** et pour **connecter des téléphones en cours de partie**. Le reste est une section de debug, repliée par défaut et non consultée si tout va bien.

### 7.1 Démarrage

- Choisir le **paquet de jeu** actif (base ou extension importée).
- Choisir le **niveau de difficulté** parmi 3 niveaux aux noms médicaux (Interne, Chirurgien, Réanimation), qui modulent l'aggravation, les pièces et la réputation ([MODELE_DE_JEU.md §10](MODELE_DE_JEU.md#10-difficulté)).
- Lancer la partie, ce qui génère le jeton et démarre le serveur.

### 7.2 Connexion

- Afficher le **QR code de connexion** (accessible à tout moment par un bouton dédié).
- Voir le nombre de téléphones connectés et l'interface réseau utilisée (avec possibilité d'en changer).

### 7.3 Debug (repliée)

- **Informations cachées masquées par défaut** : l'hôte est un joueur. L'affichage de la maladie des patients demande une confirmation explicite (« Vous allez voir les maladies des patients ») et se remasque en quittant la page.
- Horloge de l'hôpital ; état des patients : en jeu ou sorti, PV, durée de présence (et maladie si elle est démasquée).
- **5 dernières actions** : résumé de chaque résultat.
- **Annuler la dernière action** : annulation strictement dans l'ordre inverse (LIFO), jusqu'à 5 actions, par restauration de l'instantané pris avant chacune. Annuler une action plus ancienne sans annuler les suivantes n'est pas possible, car cela casserait la cohérence de l'état. L'appli affiche alors les pièces et la réputation de l'action annulée, que les joueurs doivent **reporter en sens inverse** à la main. L'annulation est réservée aux **erreurs de scan** : ce n'est pas une action de jeu ([règles de table §10](REGLES_DE_TABLE.md#10-annulation)). Il n'est donc pas prévu de rejouer le même tirage après une annulation.
- Sauvegarder ou charger une partie dans un emplacement nommé (en plus de la sauvegarde automatique).
- Journal : sélections reçues, aperçus, refus, confirmations, connexions et déconnexions, erreurs serveur.
- Graine aléatoire fixable, pour reproduire un comportement (tests).

## 8. Contenu de jeu

Le contenu et les règles sont décrits par un **paquet de jeu** :

- le **paquet de base** est embarqué ; les **extensions** sont des `.zip` importés, contenant `jeu.json` et un dossier `images/` réservé ;
- en v1, les extensions **n'ajoutent ni ne modifient de cartes** : elles modifient les maladies, les traitements, les paramètres, les récompenses, les difficultés et les phrases ;
- **ce qui est imprimé** sur une carte : son image, son QR code, son type, son nom, sa spécialité (couleur et icône) et ses capacités ; c'est pourquoi une extension ne peut pas les changer ([MOTEUR_EFFETS.md §1.2](MOTEUR_EFFETS.md#12-ce-quune-extension-peut-faire-en-v1)) ;
- le **catalogue** du paquet de base compte 10 médecins, 12 patients, 24 objets et diplômes (dont 3 objets d'aide à la recherche), 11 salles dont le laboratoire de recherche, et 103 maladies ;
- chaque paquet est validé à l'import (JSON Schema et contrôles sémantiques) et versionné.

Le détail est dans [MOTEUR_EFFETS.md](MOTEUR_EFFETS.md).

## 9. Exigences non fonctionnelles

| Exigence | Cible |
|---|---|
| Version Android minimale | Android 8.0 (API 26) |
| Clients simultanés | Illimité côté serveur ; testé avec 3 téléphones (2 à 3 joueurs), et un essai à 5 pour la marge |
| Latence de « Valider » à l'aperçu | < 300 ms en réseau local |
| Latence de « Confirmer » au résultat | < 500 ms, sauvegarde automatique comprise |
| Détection de 4 cartes | < 3 s en éclairage intérieur normal (à valider en phase 0) |
| Validation du paquet de base (103 maladies, 2 650 combinaisons) | < 2 s |
| Autonomie de l'hôte | Mesurée en phase 3 sur une partie de 2 h |
| Langue | Français en v1 ; les textes d'interface sont externalisés (fichiers ARB) pour une traduction future |
| Accessibilité | Respect de la taille de police système ; contrastes suffisants ; la couleur d'une spécialité est toujours doublée de son icône et de son nom |
| Conformité daltonisme | Chaque couleur de spécialité a un contraste d'au moins 3:1 sur fond clair (`#FFFFFF`) et sur fond sombre (`#121212`). Deux couleurs de spécialité restent distinctes (écart ΔE CIE76 d'au moins 20) en vision normale, en **protanopie**, en **deutéranopie** et en **tritanopie** (simulation de Machado et al., 2009). Le validateur de paquet le vérifie ; la palette du paquet de base le respecte |

## 10. Stack technique

| Élément | Choix | Justification |
|---|---|---|
| Framework | **Flutter (Dart)** | Une base de code, transposable iOS |
| Caméra / QR | `mobile_scanner` (ML Kit / AVFoundation) | Multi-détection simultanée ; à valider en phase 0 |
| Serveur embarqué | `shelf` + `shelf_web_socket` | Dart pur, embarquable |
| Client WebSocket | `web_socket_channel` | Standard |
| Modèles JSON | `dart:convert` + `json_serializable` | Typé |
| Validation de paquet | JSON Schema (`json_schema`) + validateur sémantique maison | Messages d'erreur précis |
| Archives | `archive` | Lecture des `.zip` |
| Service de premier plan | `flutter_foreground_task` (ou équivalent) | Survie du serveur |
| Veille | `wakelock_plus` | Verrou de veille partiel pendant la partie |
| QR de connexion | `qr_flutter` | Génération du QR |
| Réseau | `network_info_plus` + `dart:io` `NetworkInterface` | Détection des adresses IP |
| Stockage | `path_provider` + fichiers JSON, `shared_preferences` | Sauvegardes, paquets importés, préférences |

Permissions Android : `CAMERA`, `INTERNET`, `ACCESS_WIFI_STATE`, `ACCESS_NETWORK_STATE`, `FOREGROUND_SERVICE` (avec le type de service exigé par Android 14, à déterminer), `POST_NOTIFICATIONS` (Android 13+) et `WAKE_LOCK`.

## 11. Registre des décisions

| # | Décision | Référence |
|---|---|---|
| D1 | Android 8.0 (API 26) minimum | §9 |
| D2 | Clients illimités, testé avec 3 téléphones, et 5 pour la marge | §9 |
| D3 | Pas de partie rejouable ni de journal rejouable ; instantanés limités aux 5 dernières actions ; annulation réservée aux erreurs de scan, sans rejouer le même tirage | §7.3 |
| D4 | Confirmation obligatoire | §5.3 |
| D5 | Résultat privé, sur le seul téléphone de l'acteur | §5.6 |
| D6 | Hôte unique, téléphone d'un joueur, qui scanne en loopback | §3.1 |
| D7 | 3 niveaux de difficulté aux noms médicaux | [Modèle §10](MODELE_DE_JEU.md#10-difficulté) |
| D8 | Montants entiers ; difficulté par bonus entiers (+0, +1, +2) sur les pertes de PV, les gains de pièces et les pertes de réputation ; aucune pièce si le patient meurt pendant l'action | [Modèle §7 et §10](MODELE_DE_JEU.md#10-difficulté) |
| D9 | Maladie tirée au hasard à l'admission, indépendante de la carte | [Modèle §4.1](MODELE_DE_JEU.md#41-admission) |
| D10 | Un patient entre en jeu quand sa carte est scannée seule pour la première fois | [Modèle §4.1](MODELE_DE_JEU.md#41-admission) |
| D11 | Diagnostic probabiliste, tiré à nouveau à chaque fois, pouvant être faux : liste des 5 maladies les plus suspectes, indices de suspicion indépendants (pas des probabilités), couleur et icône par spécialité, bruit corrigé selon le nombre de maladies par spécialité ; une spécialité concordante renforce sa couleur, une discordante la fait reculer ; seule une tête à 95 ou plus est presque toujours juste | [Modèle §8](MODELE_DE_JEU.md#8-diagnostic-probabiliste) |
| D12 | Traitements définis par maladie dans le JSON (carte précise, nombre de médecins par spécialité, salle) | [Modèle §6](MODELE_DE_JEU.md#6-traitement) |
| D13 | Horloge commune : un tick par diagnostic, traitement ou analyse confirmé ; aggravation selon la durée de présence du patient, par paliers communs, appliquée à chaque action sur lui, sans rattrapage ; attente maximale en ticks | [Modèle §5](MODELE_DE_JEU.md#5-horloge-et-aggravation) |
| D14 | Pièces et réputation gagnées par l'acteur, partagées hors appli entre lui et l'hôpital ; objets permanents payés par les joueurs, salles et consommables par l'hôpital | [Règles de table §3 à §6](REGLES_DE_TABLE.md) |
| D15 | Bouton « Valider la sélection » | §5.2 |
| D16 | Combinaison standard : médecin + patient + salle, plus un second médecin et un accessoire facultatifs (3 à 5 cartes, un seul accessoire) | [Modèle §3](MODELE_DE_JEU.md#3-combinaisons) |
| D17 | L'aperçu est calculé par l'hôte | §5.2 |
| D18 | Extensions au format `.zip` (JSON + images) | [Moteur §1](MOTEUR_EFFETS.md#1-paquet-de-jeu) |
| D19 | Les extensions n'ajoutent ni ne modifient de cartes en v1 (type, nom, spécialité et capacités sont imprimés) | [Moteur §1.2](MOTEUR_EFFETS.md#12-ce-quune-extension-peut-faire-en-v1) |
| D20 | Catalogue du paquet de base : 10 médecins, 12 patients, 24 objets/diplômes (dont 3 d'aide à la recherche), 11 salles dont le laboratoire, 103 maladies | §8 |
| D21 | La page admin sert au démarrage et à la connexion ; le reste est du debug | §7 |
| D22 | Réputation tenue à la main ; sous un seuil, l'hôpital ferme et tous les joueurs perdent (règle de table, l'appli ne tient pas le total) | [Modèle §7.1](MODELE_DE_JEU.md#71-réputation-et-fermeture-de-lhôpital) |
| D26 | L'appli n'est pas intrusive : elle gère les maladies et les résultats ; tours, économie, formation et victoire se jouent à la table | [Règles de table](REGLES_DE_TABLE.md) |
| D27 | Victoire individuelle : un médecin atteint un niveau cible de points de victoire (réputation personnelle + 1 point par lot de 3 pièces). Le joueur qui agit répartit tous les jetons, pertes de réputation comprises : il peut prendre un −1 pour lui | [Règles de table §3](REGLES_DE_TABLE.md#3-pièces-réputation-et-points-de-victoire) |
| D28 | Patients guéris remis dans la pioche, patients morts défaussés | [Modèle §4.2](MODELE_DE_JEU.md#42-sortie) |
| D29 | Traitements secrets : le livret ne donne pas la correspondance maladie – traitement | [Règles de table §9](REGLES_DE_TABLE.md#9-traitements-secrets) |
| D30 | Pas de bluff : on peut garder un résultat pour soi, pas mentir | [Règles de table §8](REGLES_DE_TABLE.md#8-partager-linformation) |
| D23 | Salle recherche : motif `recherche` (médecin + patient + salle + accessoire facultatif) ; les actions de tous les motifs reconnus sont réunies puis filtrées par précondition, si bien que le laboratoire ne sert qu'à analyser et qu'aucune autre salle ne permet d'analyser ; action `analyser` avec choix d'une maladie suspectée, révélation de la recette complète du traitement adapté après `recherche.passages` passages (global à la partie), coût = temps + aggravation, aucune pièce. Implémentée dans `schema_version` 1 (aucun paquet n'est encore publié) ; paquet de base : 2, 3 ou 4 passages selon le palier de gravité ; une analyse compte pour 1 passage, plus la capacité `recherche` des cartes (3 objets d'aide), plus 1 avec un médecin de la spécialité de la maladie | [Modèle §12](MODELE_DE_JEU.md#12-recherche-en-laboratoire) |
| D24 | Les joueurs jouent à tour de rôle, même avec plusieurs smartphones ; l'appli n'impose aucun ordre de jeu et ne bloque pas deux actions simultanées | §1, [Modèle §1](MODELE_DE_JEU.md#1-partage-des-responsabilités) |
| D25 | Les joueurs peuvent partager leurs diagnostics ou les garder pour eux ; les probabilités sont réglées pour que ne rien mettre en commun rende la défaite commune (réputation sous le seuil de fermeture) quasi inévitable | [Modèle §8.6](MODELE_DE_JEU.md#86-partage-des-diagnostics-entre-joueurs) |

## 12. Questions ouvertes

Les choix ci-dessous ont été pris par défaut dans cette version et restent à confirmer :

1. **La 4ᵉ carte est-elle facultative ?** Choix actuel : oui, une combinaison standard compte 3 ou 4 cartes.
2. **Sélection cumulative** (§4.1) : les cartes n'ont pas besoin d'être visibles simultanément. À confirmer après le prototype de détection.
3. **Choix de l'action** : une combinaison standard propose « Diagnostiquer » et « Traiter » sur l'écran de confirmation.
4. **Révélation de la maladie** à la sortie du patient (guéri ou mort) : choix actuel, oui.
5. **PV affichés à l'acteur** après chaque action : choix actuel, oui (les PV ne sont pas une information cachée).
6. **Valeur de départ et seuil de fermeture** de la réputation : différents selon le niveau de difficulté, à fixer par simulation (phase 1).
7. **Traitement partiel** (stabilisation : gain de PV sans guérison ni aggravation) : niveau intermédiaire introduit pour conserver « gagne des PV sans être guéri ». À garder ou à supprimer.
8. **Fin de partie** : un joueur gagne en atteignant le niveau cible ; tous perdent si l'hôpital ferme. Reste à décider ce qui se passe si la pioche se vide avant (les patients morts en sortent), et comment comptent les patients encore en jeu ([règles de table §11](REGLES_DE_TABLE.md#11-points-à-préciser)).
