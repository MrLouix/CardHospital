# CardHospital — Glossaire

Termes utilisés dans l'ensemble de la documentation. En cas de doute, ce glossaire fait foi.

| Terme | Définition |
|---|---|
| **Carte** | Carte physique portant un QR code. Cinq types de carte : `medecin`, `patient`, `salle`, `objet`, `diplome`. Une carte n'est qu'une **identité** (nom, image, spécialité, capacités) ; l'état de jeu vit dans l'appli hôte. |
| **Accessoire** | Carte de type `objet` ou `diplome`. Une combinaison en compte au plus un. |
| **Diplôme** | Accessoire portant éventuellement une spécialité. Un diplôme de spécialité X compte comme un médecin de spécialité X dans les prédicats qui demandent un médecin **de cette spécialité** (voir l'encadré « Diplôme » du [modèle de jeu §2.2](MODELE_DE_JEU.md#22-cartes)). |
| **Maladie** | Pathologie **virtuelle** (aucune carte) tirée au hasard par l'hôte lors de l'admission d'un patient. Elle est cachée aux joueurs. |
| **Spécialité** | Catégorie médicale déclarée dans le paquet : `generale` (médecine générale), `cardiologie`, `psychiatrie`, `orthopedie`, `paranormal` dans le paquet de base, extensible. Chaque maladie a **une spécialité**. Les médecins, salles et accessoires peuvent porter une spécialité. |
| **Médecine générale** | Spécialité `generale`, avec sa couleur et son icône (🩺), comme les autres : elle compte dans les spécialités de la combinaison. Ne pas confondre avec *polyvalent*. |
| **Polyvalent (sans spécialité)** | Valeur réservée `polyvalent` : la carte n'a **aucune** spécialité et n'oriente pas le diagnostic (Dr Moreau, radiologie, réanimation…). Une carte sans champ `specialite` est aussi polyvalente. `generaliste` est l'ancien nom de cette valeur, encore accepté avec un avertissement. |
| **Capacité** | Bonus chiffré porté par une carte : `precision` (niveau de précision du diagnostic), `stabilisation` (PV supplémentaires rendus par un traitement partiel) et `recherche` (passages de laboratoire supplémentaires) dans le paquet de base. Liste extensible dans le paquet. |
| **Sélection** | Ensemble des cartes détectées par la caméra et retenues à l'écran, avant appui sur « Valider la sélection ». |
| **Combinaison** | Sélection validée et reconnue comme conforme à au moins un **motif** d'action. |
| **Combinaison standard** | 1 médecin + 1 patient + 1 salle, plus au choix 0 ou 1 second médecin et 0 ou 1 accessoire. Soit 3 à 5 cartes, avec un seul accessoire. |
| **Action** | Opération de jeu appliquée à un patient : `admettre`, `diagnostiquer`, `traiter`, `analyser`. Une action n'existe qu'après **confirmation**. |
| **Aperçu** | Phrase et images présentées avant confirmation, calculées par l'hôte. |
| **Confirmation** | Appui sur « Confirmer » : l'hôte applique l'action. Sans confirmation, rien n'est appliqué. |
| **Résultat** | Conséquences d'une action confirmée (PV, issue, pièces, réputation, diagnostic), affichées uniquement sur le téléphone de l'acteur. |
| **Admission** | Action qui fait entrer en jeu un patient hors jeu : l'hôte tire sa maladie et initialise ses PV. |
| **Hors jeu / en jeu / sorti** | Un patient est *en jeu* entre son admission et sa sortie. Il est *hors jeu* sinon : jamais admis, ou *sorti* (guéri ou mort). |
| **Horloge / tick** | Horloge commune de l'hôpital, tenue par l'hôte : elle avance d'un **tick** à chaque diagnostic, traitement ou analyse confirmé, quel que soit le patient. L'admission ne fait pas avancer l'horloge. |
| **Durée de présence** | Nombre de ticks écoulés depuis l'admission d'un patient. Elle règle son aggravation et son attente. |
| **Palier d'aggravation** | Tranche de durée de présence, commune à toutes les maladies : stable de 0 à 4 ticks, puis paliers 1 à 4 à partir de 5, 11, 17 et 23 ticks. |
| **Aggravation** | Perte de PV propre à la maladie pour le palier de présence atteint, appliquée à chaque diagnostic, analyse ou échec de traitement sur le patient, sans rattrapage des ticks où personne n'a agi sur lui. Ni la guérison ni le traitement partiel n'aggravent le patient. |
| **Attente dépassée** | La durée de présence du patient a dépassé l'attente maximale de sa maladie, en ticks : chaque action sur lui, même celle qui le guérit, coûte de la réputation. |
| **Diagnostic** | Liste des 5 maladies les plus suspectes, chacune avec son indice de suspicion, la couleur et l'icône de sa spécialité. Il peut être faux ; chaque diagnostic fait un **nouveau tirage**. |
| **Indice de suspicion** | Nombre de 0 à 99 affiché pour chaque maladie d'un diagnostic. Plus il est haut, plus la maladie est suspecte ; ce n'est **pas** une probabilité (une maladie à 60 n'est juste qu'environ une fois sur dix). Il s'affiche sans signe « % ». |
| **Couleur dominante** | La couleur la plus présente dans la liste d'un diagnostic (« 3 bleus sur 5 ») ; en cas d'égalité, la mieux classée. C'est la piste que la liste suggère de confirmer par un diagnostic avec cette spécialité. |
| **Niveau de précision** | Entier de 0 à `precision_max` (4 dans le paquet de base), calculé pour un diagnostic à partir des capacités `precision` des cartes ; plus il est élevé, plus le diagnostic penche vers la vérité. |
| **Traitement adapté / partiel / échec** | Issue d'une action `traiter`, déterminée par les prédicats de traitement de la maladie. Adapté → patient guéri ; partiel → gain de PV, sans aggravation ; échec → perte de PV et de réputation. |
| **Laboratoire de recherche** | Salle de spécialité `recherche` (valeur réservée aux salles, jamais spécialité de maladie). Il ne sert qu'à l'action `analyser` ; les autres salles ne permettent pas d'analyser. |
| **Maladies suspectées** | Maladies qui ont figuré dans les listes des diagnostics d'un patient. Mémorisées par l'hôte, remises à zéro à chaque admission. |
| **Analyse / passage** | Action `analyser` (motif `recherche`) : un passage en laboratoire sur une maladie suspectée choisie par le joueur. Dans le paquet de base, une maladie exige 2 passages (paliers de gravité A et B), 3 (palier C) ou 4 (palier D) ; une analyse compte pour 1 passage, plus la capacité `recherche` des cartes, plus 1 si un médecin de la spécialité de la maladie (ou muni du diplôme) la fait. Les passages de tous les joueurs s'additionnent. |
| **Objet d'aide à la recherche** | Objet qui porte la capacité `recherche` : joué comme accessoire au laboratoire, il compte pour des passages de plus. Microscope et centrifugeuse (1), séquenceur d'ADN (2) dans le paquet de base. |
| **Recette** | Description des cartes requises par le traitement adapté d'une maladie, révélée quand les passages de l'analyse sont terminés (« L'antibiotique, dans la salle de consultation ou à la pharmacie. »). |
| **Guéri / mort / sorti** | Issues finales d'un patient. *Sorti* regroupe guéri et mort. La carte d'un patient guéri retourne dans la pioche et pourra être réadmise avec une nouvelle maladie ; celle d'un patient mort est défaussée et sort de la partie. |
| **Pièces** | Monnaie gagnée par l'acteur. Il décide, hors appli, de la garder (réserve personnelle, qui paie les objets permanents), de la donner au budget de l'hôpital, ou de la verser à une construction de salle ou à un réapprovisionnement de consommables. Chaque lot de 3 pièces gagnées rapporte 1 point de victoire. |
| **Réputation** | Jauge collective de l'hôpital, tenue à la main par les joueurs. L'appli affiche l'impact entier (positif ou négatif) de chaque action ; le cumul est manuel. Le joueur qui agit répartit les jetons +1 et −1 entre sa réputation personnelle et l'hôpital. |
| **Réputation personnelle** | Réputation qu'un joueur garde pour son médecin : les +1 qu'il garde au lieu de les laisser à l'hôpital, moins les −1 qu'il prend pour lui au lieu de les reporter sur la piste de l'hôpital. Chaque point rapporte 1 point de victoire. |
| **Points de victoire** | Score d'un joueur : 1 par point de réputation personnelle, 1 par lot de 3 pièces gagnées. Le premier médecin qui atteint le niveau cible gagne ([règles de table §3](REGLES_DE_TABLE.md#3-pièces-réputation-et-points-de-victoire)). |
| **Budget de l'hôpital** | Pièces données à l'hôpital par les joueurs. Il finance les constructions de salles et les réapprovisionnements, après accord à la majorité. |
| **Objet permanent** | Objet (livre, instrument…) acheté par un joueur sur sa réserve personnelle ; l'argent sort du jeu et l'objet lui appartient. |
| **Objet consommable** | Objet de l'hôpital (médicament, bistouri, plâtre…) stocké sur une tuile de stock, avec son prix de réapprovisionnement. |
| **Formation** | Action de table (médecin + salle de formation + objet de formation) qui fait avancer le pion du joueur sur la piste de diplôme ; elle occupe tout le tour. Après plusieurs formations, le joueur obtient un diplôme. À créer. |
| **Bonus de difficulté** | Entier que le niveau de difficulté ajoute aux pertes de PV, aux gains de pièces et aux pertes de réputation : +0 en Interne, +1 en Chirurgien, +2 en Réanimation. Les gains de réputation ne changent pas. |
| **Famille de traitements** | Groupe de maladies d'une même spécialité qui se soignent avec la même recette (un spécialiste dans une salle, un objet dans une salle, ou deux médecins). |
| **Fermeture de l'hôpital** | Défaite collective : si la réputation devient strictement inférieure au seuil de fermeture, la partie s'arrête et tous les joueurs ont perdu. Règle de table, non gérée par l'appli. |
| **Hôte** | Smartphone unique par partie, qui héberge le serveur et l'état du jeu. C'est aussi le téléphone d'un joueur. |
| **Client** | Smartphone connecté à l'hôte, qui sert de scanner et affiche les résultats de ses propres actions. L'hôte est lui-même client via loopback. |
| **Paquet** | Archive `.zip` contenant un `jeu.json` (règles et contenu) et un dossier `images/` réservé. Le paquet de base est embarqué ; les extensions sont importées. |
| **Instantané** | Copie complète de l'état de la partie, prise avant chaque action pour permettre l'annulation, réservée aux erreurs de scan. |
| **Tour** | Tour d'un joueur : s'il y a moins de N patients en jeu, il pioche et admet un patient ; puis il achète un objet permanent **ou** réalise une action (diagnostic, traitement, recherche, formation). Règle de table, non suivie par l'appli. |
