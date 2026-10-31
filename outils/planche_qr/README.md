# Planche de QR de test (phase 0)

Génère un PDF A4 de QR codes de test pour valider la détection multi-QR
(`mobile_scanner`) sur de vraies cartes imprimées.

## Contenu de la planche

- Contenus : `MED-001`, `PAT-001`, `SAL-001`, `OBJ-001`, `DIP-001`, `MED-002`, `PAT-002`, `SAL-002`, `OBJ-002`, `DIP-002`.
- Tailles : 1,5 cm, 2 cm, 2,5 cm.
- Niveaux de correction d'erreur : M et Q.
- Marge de 4 modules autour de chaque QR.
- Chaque QR est étiqueté (contenu, taille, niveau de correction).

## Génération

```bash
pip install qrcode reportlab
python3 planche_qr.py --sortie planche_qr.pdf
```

## Essais physiques

Imprimer la planche en **finition mate** et en **finition brillante**, puis
suivre le protocole de la [feuille de route](../../docs/FEUILLE_DE_ROUTE.md#phase-0--prototype-de-d%C3%A9tection)
sur au moins 3 téléphones Android (dont un d'entrée de gamme sous API 26–28).
