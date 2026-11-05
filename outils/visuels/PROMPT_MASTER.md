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

### Salle standard (rectangle 140 × 100 mm → 1654 × 1181 px, bandeau #455A64)

```
{{BLOC_COMMUN}} Top-down view of a hospital room interior filling a 140x100 mm
landscape rectangle: {{SUJET}} (salle de consultation, bloc opératoire,
radiologie, réanimation, salle expérimentale...), clean modern medical
equipment, calm lighting, no people, centered in the middle ~60x30 mm area,
accent #455A64, specialty color {{COULEUR_SPECIALITE}} on furniture details.
Leave the top 22 mm band and both 40 mm side strips visually calm for
overlays. Seed: {{SEED}}.
```

### Bloc / grande salle (rectangle 150 × 160 mm → 1772 × 1890 px)

```
{{BLOC_COMMUN}} Top-down view of a large hospital room (operating block)
filling a 150x160 mm rectangle: {{SUJET}}, clean modern surgical equipment,
calm lighting, no people, centered around a calm central 61x86 mm zone, top
22 mm band and 40 mm side strips visually calm for overlays, accent #455A64,
specialty color {{COULEUR_SPECIALITE}}. Seed: {{SEED}}.
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
   (objet), 1654 × 1181 px (salle standard), 1772 × 1890 px (bloc), + fond
   perdu 3 mm.
2. Liséré / bandeau titre de la couleur du type (si le modèle a dévié).
3. Pastille de spécialité (couleur + icône emoji, police Noto Color Emoji).
4. Titre de la tuile (police fixe du projet, contraste vérifié).
5. QR code (20 × 20 mm, correction Q, marge 4 modules ; 15 mm mini pour les
   objets) — généré par `outils/planche_qr`, jamais par l'IA. Salle : QR en
   haut à droite du bandeau de 22 mm.
6. Découpe des logements des salles (sous-épaisseur 2 mm dans carton 3 mm) —
   gabarit carton + cutter :
   - salle standard 140 × 100 : encoches latérales 60,5 × 40 mm (gauche =
     médecin, droite = patient), encoche interne carrée 46 × 46 mm en haut
     au centre ;
   - bloc 150 × 160 : encoche centrale 61 × 86 mm (patient), deux encoches
     latérales 60,5 × 40 mm (médecins), encoche interne carrée 46 × 46 mm.
7. Export CMJN + PDF d'impression (A4/A3 standard, finition mate).
