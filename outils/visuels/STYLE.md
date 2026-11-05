# CardHospital — Style guide visuel des cartes et du matériel

Référence unique pour la génération des visuels (API cloud ou ComfyUI).
Toute image produite pour le jeu doit respecter ce document. En cas de doute,
se référer aux visuels de référence validés (dossier `references/`).

## 1. Format physique des cartes

- **Taille** : 63 × 88 mm (format poker standard), ratio ~ 1 : 1,4.
- **Résolution** : 300 dpi minimum → **746 × 1039 px** (prévoir 3 mm de fond perdu :
  canvas de **781 × 1074 px**, zone imprimable au centre).
- **Coins** : arrondis, rayon 3 mm (≈ 35 px à 300 dpi).
- **Fond perdu** : 3 mm sur tous les côtés ; aucun élément essentiel (QR, texte,
  icône) dans les 5 mm extérieurs.
- **Couleur d'impression** : CMJN ; les valeurs ci-dessous sont données en
  hexadécimal (sRGB de travail).

## 2. Codes couleur

### 2.1 Par type de carte (liseré de la carte et bandeau supérieur)

| Type | ID JSON | Couleur | Hex |
|---|---|---|---|
| Médecin | `medecin` | bleu hôpital | `#1565C0` |
| Patient | `patient` | orange doux | `#EF6C00` |
| Salle | `salle` | gris ardoise | `#455A64` |
| Objet | `objet` | brun clair | `#8D6E63` |
| Diplôme | `diplome` | or | `#C9A227` |

### 2.2 Par spécialité (pastille et icône, repris du paquet de base)

| Spécialité | Hex | Icône |
|---|---|---|
| `psychologie` | `#7B4FBF` | 🧠 |
| `chirurgie` | `#C62828` | ✂️ |
| `pharmacie` | `#2E7D32` | 💊 |
| `generaliste` | `#607D8B` | ➕ |
| `recherche` (salles uniquement) | `#00838F` | 🔬 |

La couleur de spécialité n'écrase jamais celle du type de carte : le liséré
reste celui du type, la spécialité n'apparaît que dans la pastille.

## 3. Mise en page type (gabarit commun)

Toutes les cartes partagent la même grille, générée **une seule fois** puis
réutilisée (template) :

1. **Bandeau supérieur** (hauteur ~ 12 % de la carte) : couleur du type de
   carte, icône du type à gauche, nom de la carte en capitales lisibles.
2. **Zone d'illustration** (hauteur ~ 55 %) : illustration centrée, fond uni
   très clair (`#FAFAFA`) ou dégradé pastel de la couleur du type.
3. **Bande inférieure** (hauteur ~ 20 %) : fond blanc, icône(s) de spécialité
   et capacités à gauche.
4. **Zone QR** : carré réservé de **20 × 20 mm minimum** (phase 0 : tester
   1,5 / 2 / 2,5 cm), fond blanc pur, marge de 4 modules, **toujours ajouté en
   post-traitement** (voir §6), jamais généré par l'IA. Position : coin
   inférieur droit de la bande inférieure.

Le nom de la carte et les valeurs sont aussi ajoutés en post-traitement.

## 4. Style d'illustration

- **Style** : illustration vectorielle flat / cartoon médical, contours nets
  (2–3 px), ombres portées douces, **pas de photoréalisme**.
- **Palette** : pastel dominant + la couleur du type de carte en accent ;
  arrière-plan uni ou très légèrement texturé.
- **Personnages** : silhouettes identifiables (blouse blanche, stéthoscope
  pour les médecins ; lit/brancard pour les patients ; équipement médical pour
  les salles, objets et diplômes). Visages simples, expressifs, inclusifs.
- **Ambiance** : sobre et professionnelle, légèrement ludique (jeu de société),
  jamais anxiogène (pas de sang, pas de patient en détresse graphique).
- **Cohérence** : même traitement de la lumière (source en haut à gauche),
  mêmes proportions de personnages, même épaisseur de contour sur toutes les
  cartes.

## 5. Autres éléments du matériel

- **Dos de carte** : unique pour toutes les cartes, motif géométrique discret
  (croix médicale stylisée) dans les bleus hôpital (`#1565C0` sur
  `#E3F2FD`), sans texte ni QR.
- **Plateau (salles de l'hôpital)** : même grille de couleurs que les cartes
  salle ; chaque salle du plateau reprend la couleur de sa spécialité et son
  icône, fond `#ECEFF1`.
- **Pions / jetons** (pièces, réputation, PV) : ronds, couleurs :
  pièces `#C9A227`, réputation `#C62828`, PV `#2E7D32`.
- **Boîte** : fond `#1565C0`, logo croix médicale blanche, illustration
  d'équipe médicale dans le style des cartes.

## 6. Règles absolues (anti-dérive)

1. **L'IA ne génère jamais de texte ni de QR code.** Noms, valeurs, QR sont
   composités en post-traitement (Pillow / SVG), police fixe du projet.
2. **Un seed fixe par carte** : la même carte regénérée avec le même prompt +
   le même seed doit donner la même image.
3. **Le template de mise en page est fixe** : seule la zone d'illustration
   varie d'une carte à l'autre (ControlNet / img2img fort sur le gabarit).
4. **Toute image passe par relecture humaine** avant impression : check-list
   lisibilité du QR (test d'impression phase 0), contraste du nom, cohérence
   de la pastille de spécialité.
5. Ne jamais mélanger les styles (ex. : une carte photoréaliste parmi des
   cartes flat).
