# CardHospital — Prompt master

Prompt de référence à copier dans tout générateur d'images (API cloud ou
ComfyUI). Les blocs entre `{{...}}` sont à remplacer. Les règles de
[STYLE.md](STYLE.md) priment sur toute interprétation du modèle.

Rappel : les tuiles ne portent que **titre + QR + illustration** — aucun texte
de règles n'est imprimé.

## 1. Bloc commun (préfixe de TOUS les prompts)

```
Board game tile illustration for "CardHospital", a hospital-themed board game.
Flat vector cartoon style, clean 2-3px outlines, soft drop shadows, light from
top-left, plain very light background (#FAFAFA), pastel palette, professional
yet playful mood, no photorealism, no blood, no text, no letters, no numbers,
no QR code, no watermark. High quality, 300 dpi equivalent.
Negative prompt: text, letters, numbers, QR code, watermark, signature,
photorealistic, blurry, low quality, deformed hands, extra fingers, dark scary
atmosphere, gore.
```

## 2. Par type de tuile

Remplacer `{{SUJET}}`, `{{SPECIALITE}}`, `{{COULEUR_SPECIALITE}}` et fixer
`{{SEED}}` (entier unique et stable par tuile, ex. : hash de l'identifiant
`MED-001`).

### Médecin (60 × 85 mm portrait → 709 × 1004 px, bandeau #0D47A1)

```
{{BLOC_COMMUN}} Portrait of a doctor character, white coat and stethoscope,
friendly confident expression, centered in a 60x50 mm area, accent color
#0D47A1, specialty badge hint: {{SPECIALITE}} ({{COULEUR_SPECIALITE}}).
Subject: {{SUJET}}. Seed: {{SEED}}.
```

### Patient (60 × 85 mm portrait → 709 × 1004 px, bandeau #BF360C)

```
{{BLOC_COMMUN}} A calm patient sitting on a hospital bed or armchair, blanket,
neutral kind expression, simple hospital gown, centered in a 60x50 mm area,
accent color #BF360C. No illness shown graphically.
Subject: {{SUJET}}. Seed: {{SEED}}.
```

### Objet / Diplôme (45 × 45 mm carré → 531 × 531 px)

```
{{BLOC_COMMUN}} A single icon isolated on the light background, centered in a
25x17 mm area: {{SUJET}} (stethoscope, medicine bottle, syringe, diploma
scroll with seal), simple bold shape readable at small size, soft shadow,
accent color #8D6E63 (objet) or #C9A227 (diplôme). No text.
Seed: {{SEED}}.
```

### Salle (hexagone plat côté 70 mm → 1654 × 1429 px, contour #455A64)

```
{{BLOC_COMMUN}} Top-down / slightly isometric view of a hospital room interior
filling a hexagon (140x121 mm): {{SUJET}} (salle de consultation, bloc
opératoire, radiologie, réanimation, salle expérimentale...), clean modern medical
equipment, calm lighting, no people, centered composition, accent #455A64,
specialty color {{COULEUR_SPECIALITE}} on furniture details. Leave a clear
central band (~86x61 mm) and a centered bottom strip (~20 mm) visually calm
for overlays. Seed: {{SEED}}.
```

## 3. Consignes de cohérence à appliquer partout

- **Même seed + même prompt = même image** : ne changer le seed que pour une
  nouvelle tuile.
- **Image de référence** : joindre le visuel validé du type (médecin de
  référence, etc.) en *image prompt* / IP-Adapter (ComfyUI).
- **Gabarit** : en ComfyUI, template de mise en page en ControlNet + LoRA
  entraîné sur les visuels validés ; en API cloud, *image prompt* du template
  à forte pondération.
- **Batch** : générer d'abord 5 visuels de référence (un par type), valider,
  puis lancer le batch des 53 tuiles du paquet de base
  ([`contenu/paquet_base.json`](../../contenu/paquet_base.json)) avec le même
  bloc commun.

## 4. Post-traitement (obligatoire, hors IA)

Script (Pillow) sur chaque image générée, avant impression :

1. Recadrer aux gabarits : 709 × 1004 px (médecin/patient), 531 × 531 px
   (objet), hexagone 1654 × 1429 px (salle), + fond perdu 3 mm.
2. Liséré / bandeau titre de la couleur du type (si le modèle a dévié).
3. Pastille de spécialité (couleur + icône emoji, police Noto Color Emoji).
4. Titre de la tuile (police fixe du projet, contraste vérifié).
5. QR code (20 × 20 mm, correction Q, marge 4 modules ; 15 mm mini pour les
   objets) — généré par `outils/planche_qr`, jamais par l'IA. Salle : QR
   centré en bas de l'hexagone.
6. Découpe des logements des salles (sous-épaisseur 2 mm dans carton 3 mm) :
   encoche centrale 86 × 61 mm, encoches latérales 60,5 mm × 40 mm, encoche
   haute 45,5 mm × 25 mm — gabarit carton + cutter.
7. Export CMJN + PDF d'impression (A4/A3 standard, finition mate).
