# CardHospital — Feuille de route

Principe : **traiter les risques en premier**. Le démarrage concret (organisation du dépôt, tâches des phases 0 et 1) est détaillé dans le [plan de codage](PLAN_DE_CODAGE.md). Chaque phase se termine par des critères de sortie vérifiables ; une phase qui échoue remet en cause les suivantes avant que du code inutile soit écrit.

| Phase | Objet | Risque principal levé |
|---|---|---|
| 0 | Prototype de détection multi-QR | La caméra lit-elle 3 ou 4 cartes de façon fiable ? |
| 1 | Moteur d'effets, validateur, simulateur | Le modèle de jeu est-il cohérent et équilibrable ? |
| 2 | Appli solo, un seul téléphone | Le parcours sélection → confirmation → résultat est-il fluide ? |
| 3 | Mode hôte / clients | Le réseau local tient-il sur une vraie partie ? |
| 4 | Admin, debug, sauvegardes, annulation | La partie est-elle récupérable en cas d'incident ? |
| 5 | Paquets d'extension, contenu complet, équilibrage | Le jeu est-il complet et extensible ? |
| 6 | iOS (facultatif) | — |

## Phase 0 — Prototype de détection

**But** : valider `mobile_scanner` sur de vraies cartes imprimées, avant tout autre développement.

- Imprimer une planche de cartes de test : plusieurs tailles de QR (1,5 / 2 / 2,5 cm), niveaux de correction M et Q, finitions mate et brillante.
- Appli Flutter minimale : flux caméra, liste des QR détectés par image, horodatage.
- Mesurer sur au moins 3 téléphones Android, dont un d'entrée de gamme sous API 26–28 : taux de détection et temps pour 1 à 4 cartes, distance, angle, éclairage (jour, lampe, pénombre), cartes posées à plat ou tenues en main.
- Comparer la détection simultanée et la sélection cumulative ([SPECIFICATION.md §4.1](SPECIFICATION.md#41-sélection-cumulative)).

**Critères de sortie**

- 4 cartes sélectionnées en moins de 3 s dans au moins 95 % des essais en éclairage intérieur normal ;
- aucune fausse lecture (QR attribué à tort) sur 200 essais ;
- taille de QR, niveau de correction et finition arrêtés ; mode de sélection confirmé.

**Si échec** : agrandir les QR, passer en sélection carte par carte, ou étudier une autre technologie de marquage (NFC, par exemple).

## Phase 1 — Moteur d'effets, validateur et simulateur

**But** : un paquet Dart **pur** (sans Flutter, sans réseau), testable unitairement, qui servira tel quel à l'appli.

- Modèles typés du `jeu.json` (`json_serializable`).
- Validateur : JSON Schema ([schema/jeu.schema.json](schema/jeu.schema.json)) et contrôles sémantiques ([MOTEUR_EFFETS.md §7](MOTEUR_EFFETS.md#7-validation-à-limport)), messages en français.
- Moteur : reconnaissance des motifs, préconditions, évaluation des prédicats, effets, invariants, arrondis, diagnostic probabiliste, avec une graine aléatoire injectable.
- Instantanés de l'état (sérialisation et restauration).
- **Simulateur en ligne de commande** : joue des milliers de parties automatiques selon des stratégies simples (diagnostiquer jusqu'à X % de confiance puis traiter, traiter au hasard…). Il mesure le taux de guérison, la durée moyenne, les pièces par action et l'**évolution de la réputation**, ce qui permet de régler les paramètres du diagnostic et des récompenses, ainsi que la **valeur de départ et le seuil de fermeture de l'hôpital** pour chaque niveau de difficulté. Il **remplace en partie le prototype papier**.
- Rédaction d'un paquet de base intermédiaire (environ 20 maladies) pour les tests.

**Critères de sortie**

- couverture de tests du moteur ≥ 90 % ;
- l'exemple [exemples/jeu.exemple.json](exemples/jeu.exemple.json) est validé, et chaque règle de validation a un test négatif ;
- le simulateur produit un rapport d'équilibrage reproductible (même graine, même résultat).

## Phase 2 — Appli solo (un seul téléphone)

**But** : le parcours complet sur un téléphone, sans réseau. Ce mode reste disponible ensuite comme **mode de secours** quand le réseau pose problème.

- Écrans : accueil, sélection, confirmation, résultat ([SPECIFICATION.md §6.1](SPECIFICATION.md#61-écrans)).
- Moteur de la phase 1 appelé directement, derrière la même interface que celle qu'utilisera le client réseau, pour que la phase 3 ne remplace que le transport.
- Choix de la difficulté, sauvegarde automatique.

**Critères de sortie** : une partie complète de test (au moins 10 patients) jouée de bout en bout sans blocage ; retours de 2 ou 3 testeurs sur la lisibilité de l'aperçu et du résultat.

## Phase 3 — Mode hôte / clients

**But** : jouer à plusieurs téléphones.

- Serveur `shelf` + WebSocket, protocole de [SPECIFICATION.md §3.3](SPECIFICATION.md#33-protocole), jeton de session, version de protocole.
- QR de connexion `cardhospital://`, loopback pour l'hôte.
- Service de premier plan, verrou de veille, reprise après redémarrage, reconnexion automatique, renvoi du dernier résultat.
- Point d'accès de l'hôte et choix de l'interface réseau ; configuration du trafic en clair.
- Revalidation à la confirmation, règle « chaque scan compte ».

**Critères de sortie**

- partie de 2 h avec 8 téléphones sans perte d'action ;
- coupure Wi-Fi de 30 s et appel entrant sur l'hôte récupérés sans intervention ;
- latences conformes à [SPECIFICATION.md §9](SPECIFICATION.md#9-exigences-non-fonctionnelles) ;
- consommation de batterie de l'hôte mesurée.

## Phase 4 — Admin, debug, sauvegardes, annulation

- Page admin : démarrage, connexion, section debug repliée ([SPECIFICATION.md §7](SPECIFICATION.md#7-page-admin-hôte)).
- Informations cachées masquées par défaut.
- Annulation LIFO des 5 dernières actions, sauvegardes nommées, journal.

**Critères de sortie** : chaque cas d'erreur de [SPECIFICATION.md §6.2](SPECIFICATION.md#62-cas-derreur) est reproduit et correctement traité.

## Phase 5 — Paquets d'extension, contenu complet, équilibrage

- Import de `.zip` (système de fichiers, partage Android), rapport de validation, sélection du paquet actif.
- Contenu complet du paquet de base : 10 médecins, 30 patients, 30 objets et diplômes, 10 salles, **100 maladies**, réparties entre les spécialités.
- Équilibrage au simulateur, puis en parties réelles.
- Création des illustrations et impression des cartes selon les recommandations de la phase 0.

**Critères de sortie** : paquet de base complet et validé ; une extension d'exemple (nouvelles maladies) importée et jouée ; au moins 5 parties réelles jouées.

## Phase 6 — iOS (facultatif)

Portage Flutter. Points d'attention : permission « réseau local » d'iOS, serveur embarqué en arrière-plan (plus contraint que sur Android), lecture de QR via AVFoundation.
