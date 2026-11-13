# CardHospital — Style guide visuel des tuiles et du matériel

Référence unique pour la génération des visuels (API cloud ou ComfyUI).
Toute image produite pour le jeu doit respecter ce document. En cas de doute,
se référer aux visuels de référence validés (dossier `references/`).

Le jeu se joue en **tuiles cartonnées**, pas en cartes. Chaque tuile ne porte
que **trois éléments imprimés** : le titre, le QR code et une illustration.
Aucun texte de règles n'est imprimé (les règles vivent dans le paquet JSON).

## 1. Formats des tuiles

| Élément | Forme | Dimensions | Équivalent 300 dpi | Tuiles / feuille A4 |
|---|---|---|---|---|
| Médecin | rectangle | **60 × 85 mm** | 709 × 1004 px | 9 |
| Patient | rectangle | **60 × 85 mm** (même gabarit) | 709 × 1004 px | 9 |
| Objet / Diplôme | carré | **45 × 45 mm** | 531 × 531 px | 24 |
| Salle standard | rectangle portrait | **100 × 122 mm** | 1181 × 1441 px | 4 (8 en A3) |
| Bloc (grande salle, ex. chirurgie) | rectangle paysage | **168 × 122 mm** | 1984 × 1441 px | 2 (4 en A3) |

- **Quantités par feuille** : calculées à la cote de coupe. Avec 3 mm de fond
  perdu autour de chaque tuile : salle 2 (6 en A3), bloc 2 (4 en A3).
- **Résolution** : 300 dpi minimum. Prévoir 3 mm de fond perdu sur les
  rectangles/carrés (canvas + ~35 px de chaque côté).
- **Coins** : rectangles et carrés à coins arrondis, rayon 3 mm (≈ 35 px).
- **Fond perdu** : 3 mm ; aucun élément essentiel (QR, titre) dans les 5 mm
  extérieurs du canvas, comptés depuis le bord du fond perdu (soit 2 mm après
  la coupe).
- **Couleur d'impression** : CMJN ; valeurs hexadécimales en sRGB de travail.

## 2. Codes couleur

### 2.1 Par type de tuile (liseré et bandeau titre)

| Type | ID JSON | Hex |
|---|---|---|
| Médecin | `medecin` | `#0D47A1` |
| Patient | `patient` | `#BF360C` |
| Salle | `salle` | `#455A64` |
| Objet | `objet` | `#8D6E63` |
| Diplôme | `diplome` | `#C9A227` |

### 2.2 Par spécialité (pastille, couleurs officielles du paquet de base)

Couleurs et icônes reprises de [`contenu/paquet_base.json`](../../contenu/paquet_base.json) :

| Spécialité | Hex | Icône |
|---|---|---|
| `generale` | `#1565C0` | 🩺 |
| `cardiologie` | `#C62828` | ❤️ |
| `psychiatrie` | `#7B4FBF` | 🧠 |
| `orthopedie` | `#EF6C00` | 🦴 |
| `paranormal` | `#37474F` | 👻 |

Le liséré reste celui du type (aucune couleur de type ne reprend celle d'une
spécialité) ; la spécialité n'apparaît que dans la pastille.

## 3. Mise en page des tuiles

### 3.1 Médecin / Patient (60 × 85 mm) — portrait

1. **Bandeau titre** (haut, ~10 mm) : couleur du type, titre en capitales.
2. **Illustration** (centre, ~60 × 50 mm).
3. **QR** (20 × 20 mm, coin inférieur droit) + pastille de spécialité à côté.

### 3.2 Objet / Diplôme (45 × 45 mm) — carré

1. **Bandeau titre** (haut, ~8 mm) : titre court, ~10–12 caractères max.
2. **Illustration** (centre, ~25 × 17 mm) : icône simple, lisible en flat.
3. **QR** (20 × 20 mm, coin inférieur droit). Si l'espace manque, le QR peut
   descendre à **15 mm** (taille testée en phase 0), jamais en dessous. Les
   gabarits utilisent 15 mm : à 20 mm, le QR chevaucherait l'illustration.

### 3.3 Salle standard (rectangle 100 × 122 mm, portrait)

Géométrie des logements (sous-épaisseur, voir §4) ; médecin et patient sont
toujours en portrait, 7 mm séparent les logements :

- **Bandeau haut, 22 mm** : nom de la salle à gauche, **QR 20 × 20 mm à
  droite**.
- **Encoche latérale gauche partielle** : médecin, ouverture **86 mm**,
  profondeur **20 mm** — la tuile de 60 mm dépasse de 40 mm (deux tiers).
- **Encoche latérale droite partielle** : patient, idem (86 × 20 mm).
- **Encoche interne carrée** : objet/diplôme, **46 × 46 mm**, en haut au centre
  entre les deux encoches latérales.
- **Illustration** : au centre, ~60 × 50 mm sous l'encoche carrée.

Encombrement sur la table, tuiles en place : 180 mm de large.

### 3.4 Bloc / grande salle (rectangle 168 × 122 mm, ex. bloc de chirurgie)

Même hauteur et mêmes encoches que la salle standard, avec le logement du
patient en plus (20 + 7 + 61 + 7 + 46 + 7 + 20 = 168 mm) :

- **Bandeau haut, 22 mm** : nom à gauche, **QR 20 × 20 mm à droite**.
- **Encoche centrale** : patient en portrait, logement **61 × 86 mm**, entre
  l'encoche gauche et l'encoche carrée.
- **Deux encoches latérales partielles** : médecins en portrait, 86 × 20 mm
  chacune.
- **Encoche interne carrée** : objet/diplôme, **46 × 46 mm**, en haut à droite
  du logement patient, sous le bandeau.
- **Illustration** : ~60 × 50 mm sous l'encoche carrée.

Encombrement sur la table, tuiles en place : 248 mm de large.

### 3.5 Gabarits VectorCraft

Les gabarits de chaque format sont dans [`gabarits/`](gabarits/) (`.vctemplate`,
un par type de tuile). Leurs calques séparent le fond, l'illustration, le
liseré, le bandeau, le titre, le QR, les logements et la pastille ; le calque
« Repères » (coupe, zone sûre, cotes) n'est ni imprimé ni exporté.
[`generer_gabarits.ps1`](generer_gabarits.ps1) les regénère (PowerShell 7,
VectorCraft, polices Inter et Segoe UI Emoji) : toute cote modifiée ici doit
l'être aussi dans ce script.

## 4. Matériau et sous-épaisseurs

- **Tuiles médecin / patient / objet** : carton gris **2 mm** (ou print 300 g
  collé sur carton 1,5 mm) → épaisseur finie ≈ 2 mm.
- **Tuiles salle** : carton gris **3 mm** ; logements découpés à **2 mm de
  profondeur** dans la couche supérieure (cutter + gabarit carton), les tuiles
  de 2 mm s'y insèrent avec ~1 mm de marge et tiennent par friction.
- Variante plus rigide : carton plume 5 mm + couche découpée de 2 mm collée
  dessus (colle vinylique).

## 5. Style d'illustration

- **Style** : vectoriel flat / cartoon médical, contours nets (2–3 px), ombres
  portées douces, **pas de photoréalisme**.
- **Palette** : pastel dominant + couleur du type en accent ; fond uni très
  clair (`#FAFAFA`).
- **Sujets** : médecins en blouse avec stéthoscope ; patients calmes sur lit ou
  fauteuil ; salles = intérieur médical épuré ; objets = icône isolée ; diplômes
  = parchemin à sceau. Visages simples, inclusifs.
- **Ambiance** : sobre, professionnelle, légèrement ludique ; jamais
  anxiogène (pas de sang, pas de détresse graphique).
- **Cohérence** : lumière en haut à gauche, mêmes proportions de personnages,
  même épaisseur de contour partout.

## 6. Autres éléments du matériel

- **Plateau** : dalles rectangulaires aux mêmes cotes que les salles
  (100 × 122 mm), en laissant 40 mm de chaque côté pour les tuiles qui
  dépassent, fond `#ECEFF1`, chaque salle reprend la couleur de sa spécialité.
- **Pions** (pièces `#C9A227`, réputation `#C62828`, PV `#2E7D32`) : ronds.
- **Boîte** : fond `#0D47A1`, croix médicale blanche, illustration d'équipe
  dans le style des tuiles.

## 7. Règles absolues (anti-dérive)

1. **L'IA ne génère jamais de texte ni de QR code.** Titres et QR sont
   composés en post-traitement (Pillow / SVG), police fixe du projet.
2. **Un seed fixe par tuile** : même prompt + même seed = même image.
3. **Le gabarit est fixe** : seule la zone d'illustration varie (ControlNet /
   img2img fort sur le template).
4. **Relecture humaine obligatoire** avant impression : lisibilité du QR (test
   d'impression phase 0, finition **mate**), contraste du titre, cohérence de
   la pastille de spécialité.
5. Ne jamais mélanger les styles (ex. : une tuile photoréaliste parmi des
   tuiles flat).
