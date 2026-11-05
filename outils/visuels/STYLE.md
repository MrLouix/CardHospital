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
| Salle standard | rectangle paysage | **140 × 100 mm** | 1654 × 1181 px | 2 (8 en A3) |
| Bloc (grande salle, ex. chirurgie) | rectangle | **150 × 160 mm** | 1772 × 1890 px | 1 (2 en A3) |

- **Résolution** : 300 dpi minimum. Prévoir 3 mm de fond perdu sur les
  rectangles/carrés (canvas + ~35 px de chaque côté).
- **Coins** : rectangles et carrés à coins arrondis, rayon 3 mm (≈ 35 px).
- **Fond perdu** : 3 mm ; aucun élément essentiel (QR, titre) dans les 5 mm
  extérieurs.
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
   descendre à **15 mm** (taille testée en phase 0), jamais en dessous.

### 3.3 Salle standard (rectangle 140 × 100 mm, paysage)

Géométrie des logements (sous-épaisseur, voir §4) :

- **Bandeau haut, 22 mm** : nom de la salle à gauche, **QR 20 × 20 mm à
  droite**.
- **Encoche latérale gauche partielle** : médecin, ouverture **60,5 mm**,
  profondeur **40 mm** — la tuile dépasse de moitié.
- **Encoche latérale droite partielle** : patient, idem (60,5 × 40 mm).
- **Encoche interne carrée** : objet/diplôme, **46 × 46 mm**, en haut au centre
  entre les deux encoches latérales.
- **Illustration** : au centre, ~60 × 30 mm sous l'encoche carrée.

### 3.4 Bloc / grande salle (rectangle 150 × 160 mm, ex. bloc de chirurgie)

- **Bandeau haut, 22 mm** : nom à gauche, **QR 20 × 20 mm à droite**.
- **Encoche centrale** : patient en portrait, logement **61 × 86 mm** au centre.
- **Deux encoches latérales partielles** : médecins, 60,5 × 40 mm chacune
  (40 + 61 + 40 = 141 mm ≤ 150 mm de large).
- **Encoche interne carrée** : objet/diplôme, **46 × 46 mm**, en haut à droite
  sous le bandeau.
- **Illustration** : dans l'espace restant (~52 mm de hauteur en bas et
  bandes latérales).

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
  (140 × 100 mm), fond `#ECEFF1`, chaque salle reprend la couleur de sa
  spécialité.
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
