# Prototype de détection (phase 0)

Appli Flutter **jetable** qui mesure la lecture des cartes de test par `mobile_scanner`, avant tout autre développement ([feuille de route, phase 0](../../docs/FEUILLE_DE_ROUTE.md#phase-0--prototype-de-détection)). Elle ne contient rien du jeu.

## Installer l'appli

- **Sur le téléphone, sans compte GitHub** : ouvrir la page [Prototype de détection (dernière version)](https://github.com/MrLouix/CardHospital/releases/tag/detection-latest) dans le navigateur. Télécharger `cardhospital-detection.apk`, l'ouvrir, et autoriser l'installation d'applications inconnues si Android le demande. Cette release est recréée par le workflow GitHub `detection` à chaque construction.
- **Artefact de la CI** : chaque exécution du workflow `detection` publie aussi un artefact `detection-apk` (onglet *Actions*, section *Artifacts*). Il faut être connecté à GitHub dans un navigateur ; l'appli mobile GitHub ne télécharge pas les artefacts. Il arrive en `.zip`, à décompresser pour en sortir `app-release.apk`.
- **Depuis les sources** (Flutter 3.47.9) :

  ```bash
  flutter build apk --release
  ```

  L'APK est dans `build/app/outputs/flutter-apk/app-release.apk`.

Mesurez toujours avec la version **release** : en mode debug, l'analyse des images est nettement plus lente.

Android 8.0 (API 26) minimum. L'appli demande l'accès à la caméra au premier essai.

## Préparer les cartes

1. Générer la planche : [`outils/planche_qr`](../../outils/planche_qr/README.md).
2. L'imprimer en finition **mate** et en finition **brillante**.
3. Découper des cartes d'une même taille et d'un même niveau de correction (l'étiquette sous chaque QR les indique).

La planche contient les contenus `MED-001` à `DIP-002`, chacun en 3 tailles et 2 niveaux de correction. L'appli ne peut donc pas savoir quelle taille elle lit : c'est le testeur qui la déclare.

## Faire un essai

1. **Conditions** : téléphone, mode de sélection, finition, taille, correction, éclairage, cartes à plat ou en main, résolution de la caméra, angle et distance.
2. **Cartes posées** : de 1 à 4 contenus parmi ceux de la planche. Toute autre lecture est comptée comme une **fausse lecture**.
3. **Démarrer l'essai**, viser ailleurs, appuyer sur **Top départ**, puis viser les cartes. Le chronomètre s'arrête et le téléphone vibre dès que toutes les cartes sont sélectionnées.
4. **Garder et faire l'essai suivant** (mêmes conditions), **Garder et revenir**, ou **Ne pas garder** un essai raté pour une raison extérieure (carte tombée…).

Au-delà de 10 s, l'essai est un échec. Le bouton **Échec** l'arrête plus tôt.

Les deux modes de [SPECIFICATION.md §4.1](../../docs/SPECIFICATION.md#41-sélection-cumulative) sont comparés :

| Mode | Réussite |
|---|---|
| **Cumulative** | Chaque carte entre dans la sélection quand elle est lue lors de deux détections successives, et y reste même si elle sort du champ. Un appui sur une vignette la retire ; « Vider la sélection » la remet à zéro. |
| **Simultanée** | Toutes les cartes doivent être lues dans une même image. |

**Limite connue** : `mobile_scanner` ne signale pas les images sans QR. « Deux images consécutives » est donc approché par « deux détections successives à moins de 300 ms d'écart » (champ `ecart_max_ms` de l'export). Le bilan de la phase 0 dira si cette règle convient.

Les essais sont enregistrés sur le téléphone après chaque essai gardé. Ils survivent à la fermeture de l'appli.

## Protocole

Celui de la [feuille de route](../../docs/FEUILLE_DE_ROUTE.md#phase-0--prototype-de-détection) :

- au moins **3 téléphones** Android, dont un d'entrée de gamme sous API 26 à 28 ;
- **1 à 4 cartes** ; distances, angles, éclairages (jour, lampe, pénombre), cartes à plat et en main ;
- les deux finitions, les trois tailles, les deux niveaux de correction ;
- les deux modes de sélection, et plusieurs résolutions de caméra (Android utilise 640 × 480 si on ne demande rien, ce qui pénalise les petits QR).

Critères de sortie, suivis en direct sur l'écran d'accueil :

- 4 cartes sélectionnées en moins de 3 s dans au moins **95 %** des essais en éclairage intérieur normal ;
- **aucune fausse lecture** sur 200 essais.

## Exporter les mesures

**Exporter en CSV** partage deux fichiers (messagerie, Drive…). Ils sont au format tableur français : séparateur `;`, décimales avec une virgule, UTF-8.

`essais_<date>.csv`, un essai par ligne :

| Colonne | Contenu |
|---|---|
| `numero`, `date` | Numéro et heure de début de l'essai |
| `telephone`, `mode`, `finition`, `taille_cm`, `correction`, `eclairage`, `support`, `distance_cm`, `angle_deg`, `resolution` | Conditions déclarées |
| `cartes_attendues`, `nb_cartes` | Cartes posées |
| `issue`, `temps_s`, `moins_de_3s` | `reussi` ou `echec`, temps jusqu'à la réussite (ou jusqu'à l'échec), 1 si réussi en moins de 3 s |
| `images` | Nombre d'images où au moins un QR a été lu |
| `fausses_lectures`, `fausses_dans_selection` | Contenus lus qui n'étaient pas posés, et ceux qui sont entrés dans la sélection |
| `selection_finale`, `ecart_max_ms` | Sélection à la fin, écart retenu pour « consécutif » |

`detections_<date>.csv`, une image par ligne : `numero_essai`, `t_ms` (depuis le top départ), `contenus`.

Pour l'analyse, par exemple avec pandas : `pd.read_csv(fichier, sep=';', decimal=',')`.

## Développement

```bash
flutter pub get
flutter analyze
flutter test
```

La logique (`lib/logique/`) ne dépend pas de la caméra et est testée sans téléphone. Les tests d'écran remplacent la caméra par une vue factice. La caméra elle-même ne se teste que sur un vrai téléphone.
