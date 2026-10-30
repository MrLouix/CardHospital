# CardHospital — Glossaire

Termes utilisés dans l'ensemble de la documentation. En cas de doute, ce glossaire fait foi.

| Terme | Définition |
|---|---|
| **Carte** | Carte physique portant un QR code. Cinq types : `medecin`, `patient`, `salle`, `objet`, `diplome`. Une carte n'est qu'une **identité** (nom, image, spécialité, capacités) ; l'état de jeu vit dans l'appli hôte. |
| **Accessoire** | Carte de type `objet` ou `diplome`. Occupe la 4ᵉ place d'une combinaison standard. |
| **Maladie** | Pathologie **virtuelle** (aucune carte) tirée au hasard par l'hôte lors de l'admission d'un patient. Elle est cachée aux joueurs. |
| **Spécialité** | Catégorie médicale (`psychologie`, `chirurgie`, `pharmacie`, extensible). Chaque maladie a **un type** = une spécialité. Les médecins, salles et accessoires peuvent porter une spécialité. |
| **Capacité** | Bonus chiffré porté par une carte (ex. `precision` pour le diagnostic, `soin` pour les PV restaurés). Liste extensible dans le paquet. |
| **Sélection** | Ensemble des cartes détectées par la caméra et retenues à l'écran, avant appui sur « Valider la sélection ». |
| **Combinaison** | Sélection validée et reconnue comme conforme à un **motif** d'action. |
| **Combinaison standard** | 1 médecin + 1 patient + 1 salle + (0 ou 1 accessoire **ou** 1 second médecin). Soit 3 ou 4 cartes. |
| **Action** | Opération de jeu appliquée à un patient : `admettre`, `diagnostiquer`, `traiter`. Une action n'existe qu'après **confirmation**. |
| **Aperçu** | Phrase et images présentées avant confirmation, calculées par l'hôte. |
| **Confirmation** | Appui sur « Confirmer » : l'hôte applique l'action. Sans confirmation, rien n'est appliqué. |
| **Résultat** | Conséquences d'une action confirmée (PV, issue, pièces, réputation, diagnostic), affichées uniquement sur le téléphone de l'acteur. |
| **Admission** | Première action sur un patient : l'hôte tire sa maladie et initialise ses PV. |
| **Temps du patient** | Compteur propre à chaque patient, incrémenté de 1 à **chaque action confirmée** le concernant (hors admission). Un patient jamais sollicité n'avance pas dans le temps. |
| **Aggravation** | Perte de PV liée au temps du patient, appliquée à chaque action non curative. |
| **Attente dépassée** | Temps du patient supérieur au seuil d'attente de sa maladie : chaque action supplémentaire coûte de la réputation. |
| **Diagnostic** | Résultat probabiliste sur le **type** de maladie, et éventuellement sur son **nom**. Il peut être faux ; il est retiré à chaque diagnostic. |
| **Niveau de précision** | Entier calculé pour un diagnostic à partir de la salle et des capacités des cartes ; plus il est élevé, plus le diagnostic penche vers la vérité. |
| **Traitement adapté / partiel / inadapté** | Issue d'une action `traiter`, déterminée par les prédicats de traitement de la maladie. Adapté → patient soigné ; partiel → gain de PV ; inadapté → perte de PV et réputation. |
| **Soigné / mort / sorti** | Issues finales d'un patient. *Sorti* regroupe soigné et mort : la carte retourne dans la pioche et pourra être réadmise avec une nouvelle maladie. |
| **Pièces** | Monnaie gagnée par l'acteur. Il décide, hors appli, de la garder (achat d'objets/diplômes) ou d'en céder une partie à l'hôpital (achat de salles). |
| **Réputation** | Impact entier, positif ou négatif, sur la réputation de l'hôpital. Affiché par action ; le cumul est manuel. |
| **Hôte** | Smartphone unique par partie, qui héberge le serveur et l'état du jeu. C'est aussi le téléphone d'un joueur. |
| **Client** | Smartphone connecté à l'hôte, qui sert de scanner et affiche les résultats de ses propres actions. L'hôte est lui-même client via loopback. |
| **Paquet** | Archive `.zip` contenant un `jeu.json` (règles et contenu) et un dossier `images/` réservé. Le paquet de base est embarqué ; les extensions sont importées. |
| **Instantané** | Copie complète de l'état de la partie, prise avant chaque action pour permettre l'annulation. |
