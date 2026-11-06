# CardHospital — Glossaire

Termes utilisés dans l'ensemble de la documentation. En cas de doute, ce glossaire fait foi.

| Terme | Définition |
|---|---|
| **Carte** | Carte physique portant un QR code. Cinq types de carte : `medecin`, `patient`, `salle`, `objet`, `diplome`. Une carte n'est qu'une **identité** (nom, image, spécialité, capacités) ; l'état de jeu vit dans l'appli hôte. |
| **Accessoire** | Carte de type `objet` ou `diplome`. Occupe la 4ᵉ place d'une combinaison standard ou d'une combinaison de recherche. |
| **Diplôme** | Accessoire portant éventuellement une spécialité. Un diplôme de spécialité X compte comme un médecin de spécialité X dans les prédicats qui demandent un médecin **de cette spécialité** (voir l'encadré « Diplôme » du [modèle de jeu §2.2](MODELE_DE_JEU.md#22-cartes)). |
| **Maladie** | Pathologie **virtuelle** (aucune carte) tirée au hasard par l'hôte lors de l'admission d'un patient. Elle est cachée aux joueurs. |
| **Spécialité** | Catégorie médicale déclarée dans le paquet : `generale` (médecine générale), `cardiologie`, `psychiatrie`, `orthopedie`, `paranormal` dans le paquet de base, extensible. Chaque maladie a **une spécialité**. Les médecins, salles et accessoires peuvent porter une spécialité. |
| **Médecine générale** | Spécialité `generale`, avec sa couleur et son icône (🩺), comme les autres : elle compte dans les spécialités de la combinaison. Ne pas confondre avec *polyvalent*. |
| **Polyvalent (sans spécialité)** | Valeur réservée `polyvalent` : la carte n'a **aucune** spécialité et n'oriente pas le diagnostic (Dr Moreau, radiologie, réanimation…). Une carte sans champ `specialite` est aussi polyvalente. `generaliste` est l'ancien nom de cette valeur, encore accepté avec un avertissement. |
| **Capacité** | Bonus chiffré porté par une carte : `precision` (niveau de précision du diagnostic) et `stabilisation` (PV supplémentaires rendus par un traitement partiel) dans le paquet de base. Liste extensible dans le paquet. |
| **Sélection** | Ensemble des cartes détectées par la caméra et retenues à l'écran, avant appui sur « Valider la sélection ». |
| **Combinaison** | Sélection validée et reconnue comme conforme à au moins un **motif** d'action. |
| **Combinaison standard** | 1 médecin + 1 patient + 1 salle + (0 ou 1 accessoire **ou** 1 second médecin). Soit 3 ou 4 cartes. |
| **Action** | Opération de jeu appliquée à un patient : `admettre`, `diagnostiquer`, `traiter`, `analyser`. Une action n'existe qu'après **confirmation**. |
| **Aperçu** | Phrase et images présentées avant confirmation, calculées par l'hôte. |
| **Confirmation** | Appui sur « Confirmer » : l'hôte applique l'action. Sans confirmation, rien n'est appliqué. |
| **Résultat** | Conséquences d'une action confirmée (PV, issue, pièces, réputation, diagnostic), affichées uniquement sur le téléphone de l'acteur. |
| **Admission** | Action qui fait entrer en jeu un patient hors jeu : l'hôte tire sa maladie et initialise ses PV. |
| **Hors jeu / en jeu / sorti** | Un patient est *en jeu* entre son admission et sa sortie. Il est *hors jeu* sinon : jamais admis, ou *sorti* (guéri ou mort). |
| **Temps du patient** | Compteur propre à chaque patient, incrémenté de 1 à **chaque action confirmée** le concernant (hors admission). Un patient jamais sollicité n'avance pas dans le temps. |
| **Aggravation** | Perte de PV liée au temps du patient, appliquée après un diagnostic, une analyse ou un échec de traitement. Ni la guérison ni le traitement partiel n'aggravent le patient. |
| **Attente dépassée** | Le temps du patient a dépassé l'attente maximale de sa maladie : à partir de la (`attente_max` + 1)ᵉ action sur lui, chaque action, même celle qui le guérit, coûte de la réputation. |
| **Diagnostic** | Liste des 5 maladies les plus suspectes, chacune avec son indice de suspicion, la couleur et l'icône de sa spécialité. Il peut être faux ; chaque diagnostic fait un **nouveau tirage**. |
| **Indice de suspicion** | Nombre de 0 à 99 affiché pour chaque maladie d'un diagnostic. Plus il est haut, plus la maladie est suspecte ; ce n'est **pas** une probabilité (une maladie à 60 n'est juste qu'environ une fois sur dix). Il s'affiche sans signe « % ». |
| **Couleur dominante** | La couleur la plus présente dans la liste d'un diagnostic (« 3 bleus sur 5 ») ; en cas d'égalité, la mieux classée. C'est la piste que la liste suggère de confirmer par un diagnostic avec cette spécialité. |
| **Niveau de précision** | Entier de 0 à `precision_max` (4 dans le paquet de base), calculé pour un diagnostic à partir des capacités `precision` des cartes ; plus il est élevé, plus le diagnostic penche vers la vérité. |
| **Traitement adapté / partiel / échec** | Issue d'une action `traiter`, déterminée par les prédicats de traitement de la maladie. Adapté → patient guéri ; partiel → gain de PV, sans aggravation ; échec → perte de PV et de réputation. |
| **Laboratoire de recherche** | Salle de spécialité `recherche` (valeur réservée aux salles, jamais spécialité de maladie). Il ne sert qu'à l'action `analyser` ; les autres salles ne permettent pas d'analyser. |
| **Maladies suspectées** | Maladies qui ont figuré dans les listes des diagnostics d'un patient. Mémorisées par l'hôte, remises à zéro à chaque admission. |
| **Analyse / passage** | Action `analyser` (motif `recherche`) : un passage en laboratoire sur une maladie suspectée choisie par le joueur. Certaines maladies exigent plusieurs passages. |
| **Recette** | Description des cartes requises par le traitement adapté d'une maladie, révélée quand les passages de l'analyse sont terminés. |
| **Guéri / mort / sorti** | Issues finales d'un patient. *Sorti* regroupe guéri et mort. La carte d'un patient guéri retourne dans la pioche et pourra être réadmise avec une nouvelle maladie ; celle d'un patient mort est défaussée et sort de la partie. |
| **Pièces** | Monnaie gagnée par l'acteur. Il décide, hors appli, de la garder (réserve personnelle, qui paie les objets permanents), de la donner au budget de l'hôpital, ou de la verser à une construction de salle ou à un réapprovisionnement de consommables. Chaque lot de 3 pièces gagnées rapporte 1 point de victoire. |
| **Réputation** | Jauge collective de l'hôpital, tenue à la main par les joueurs. L'appli affiche l'impact entier (positif ou négatif) de chaque action ; le cumul est manuel. Un gain peut être gardé par l'acteur (réputation personnelle) ou laissé à l'hôpital. |
| **Réputation personnelle** | Réputation gagnée qu'un joueur garde pour son médecin au lieu de la laisser à l'hôpital. Chaque point rapporte 1 point de victoire. |
| **Points de victoire** | Score d'un joueur : 1 par point de réputation personnelle, 1 par lot de 3 pièces gagnées. Le premier médecin qui atteint le niveau cible gagne ([règles de table §3](REGLES_DE_TABLE.md#3-pièces-réputation-et-points-de-victoire)). |
| **Budget de l'hôpital** | Pièces données à l'hôpital par les joueurs. Il finance les constructions de salles et les réapprovisionnements, après accord à la majorité. |
| **Objet permanent** | Objet (livre, instrument…) acheté par un joueur sur sa réserve personnelle ; l'argent sort du jeu et l'objet lui appartient. |
| **Objet consommable** | Objet de l'hôpital (médicament, bistouri, plâtre…) stocké sur une tuile de stock, avec son prix de réapprovisionnement. |
| **Formation** | Action de table (médecin + salle de formation + objet de formation) qui fait avancer le pion du joueur sur la piste de diplôme ; elle occupe tout le tour. Après plusieurs formations, le joueur obtient un diplôme. À créer. |
| **Fermeture de l'hôpital** | Défaite collective : si la réputation devient strictement inférieure au seuil de fermeture, la partie s'arrête et tous les joueurs ont perdu. Règle de table, non gérée par l'appli. |
| **Hôte** | Smartphone unique par partie, qui héberge le serveur et l'état du jeu. C'est aussi le téléphone d'un joueur. |
| **Client** | Smartphone connecté à l'hôte, qui sert de scanner et affiche les résultats de ses propres actions. L'hôte est lui-même client via loopback. |
| **Paquet** | Archive `.zip` contenant un `jeu.json` (règles et contenu) et un dossier `images/` réservé. Le paquet de base est embarqué ; les extensions sont importées. |
| **Instantané** | Copie complète de l'état de la partie, prise avant chaque action pour permettre l'annulation, réservée aux erreurs de scan. |
| **Tour** | Tour d'un joueur : s'il y a moins de N patients en jeu, il pioche et admet un patient ; puis il achète un objet permanent **ou** réalise une action (diagnostic, traitement, recherche, formation). Règle de table, non suivie par l'appli. |
