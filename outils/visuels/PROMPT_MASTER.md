# CardHospital — Prompt master

Prompt de référence à copier dans tout générateur d'images (API cloud ou
ComfyUI). Les blocs entre `{{...}}` sont à remplacer. Les règles de
[STYLE.md](STYLE.md) priment sur toute interprétation du modèle.

## 1. Bloc commun (préfixe de TOUS les prompts)

```
Board game card illustration for "CardHospital", a hospital-themed card game.
Flat vector cartoon style, clean 2-3px outlines, soft drop shadows, light from
top-left, plain very light background (#FAFAFA), pastel palette, professional
yet playful mood, no photorealism, no blood, no text, no letters, no numbers,
no QR code, no watermark. High quality, 746x1039 px, 300 dpi equivalent.
Negative prompt: text, letters, numbers, QR code, watermark, signature,
photorealistic, blurry, low quality, deformed hands, extra fingers, dark scary
atmosphere, gore.
```

## 2. Par type de carte

Remplacer `{{TYPE}}`, `{{COULEUR_TYPE}}`, `{{SUJET}}`, `{{SPECIALITE}}`,
`{{COULEUR_SPECIALITE}}` et fixer `{{SEED}}` (un entier unique et stable par
carte, ex. : hash de l'identifiant `MED-001`).

### Médecin (type `medecin`, bandeau #1565C0)

```
{{BLOC_COMMUN}} Portrait of a doctor character, white coat and stethoscope,
friendly confident expression, bust view centered in the illustration area,
accent color #1565C0. Specialty badge hint: {{SPECIALITE}} ({{COULEUR_SPECIALITE}}).
Style: {{SUJET}}. Seed: {{SEED}}.
```

### Patient (type `patient`, bandeau #EF6C00)

```
{{BLOC_COMMUN}} A patient character sitting or lying on a hospital bed or
armchair, blanket, calm neutral expression, simple hospital gown, bust/scene
view centered, accent color #EF6C00. No illness shown graphically.
Style: {{SUJET}}. Seed: {{SEED}}.
```

### Salle (type `salle`, bandeau #455A64)

```
{{BLOC_COMMUN}} Interior of a hospital room: {{SUJET}} (e.g. operating block,
psychiatry unit, consultation room), clean modern medical equipment, calm
lighting, no people, centered composition, accent color #455A64, specialty
color {{COULEUR_SPECIALITE}} on furniture details.
Seed: {{SEED}}.
```

### Objet (type `objet`, bandeau #8D6E63)

```
{{BLOC_COMMUN}} A single medical object isolated on the light background:
{{SUJET}} (e.g. stethoscope, medicine bottle, book, syringe), product-illustration
style, centered, soft shadow underneath, accent color #8D6E63.
Seed: {{SEED}}.
```

### Diplôme (type `diplome`, bandeau #C9A227)

```
{{BLOC_COMMUN}} A diploma / certificate scroll with ribbon and seal, medical
emblem (Rod of Asclepius style) embossed, elegant but simple, centered on the
light background, gold accents #C9A227, specialty color {{COULEUR_SPECIALITE}}
on the ribbon. No text on the diploma.
Seed: {{SEED}}.
```

### Dos de carte (unique)

```
{{BLOC_COMMUN}} Card back pattern: subtle geometric pattern with a stylized
medical cross at the center, colors #1565C0 on #E3F2FD, seamless, centered,
no text, no QR code. Seed: 42.
```

## 3. Consignes de cohérence à appliquer partout

- **Même seed + même prompt = même image** : ne changer le seed que pour
  une nouvelle carte, jamais pour « retoucher » une carte existante (on
  relance plutôt le prompt).
- **Image de référence** : joindre le visuel validé du type de carte
  (médecin de référence, etc.) en *image prompt* / IP-Adapter (ComfyUI) pour
  verrouiller le style.
- **Gabarit** : en ComfyUI, poser le template de mise en page en ControlNet
  (canny/segmentation) + LoRA entraîné sur les visuels validés ; en API cloud,
  utiliser l'*image prompt* du template avec forte pondération.
- **Batch** : générer d'abord les 5 visuels de référence (un par type), les
  valider, puis lancer le batch des ~100 cartes avec le même bloc commun.

## 4. Post-traitement (obligatoire, hors IA)

Script (Pillow) à exécuter sur chaque image générée, avant impression :

1. Recadrer au gabarit 746 × 1039 px (fond perdu 781 × 1074 px).
2. Coller le liséré/bandeau de la couleur du type (si le modèle a dévié).
3. Ajouter la pastille de spécialité (couleur + icône emoji en police
   Noto Color Emoji).
4. Composer le nom de la carte (police fixe du projet, contraste vérifié).
5. Générer et coller le QR code (20 × 20 mm min, correction Q, marge 4
   modules) en coin inférieur droit — cf. `outils/planche_qr`.
6. Export CMJN + PDF d'impression avec fonds perdus.
