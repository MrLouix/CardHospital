#!/usr/bin/env python3
"""Génère une planche de QR de test (PDF A4) pour la phase 0 de CardHospital.

Usage :
    python3 planche_qr.py [--sortie planche_qr.pdf]

La planche contient des QR de 1,5, 2 et 2,5 cm (taille du QR seul, hors marge),
aux niveaux de correction M et Q, avec une marge de 4 modules et le contenu
MED-001, PAT-001, SAL-001, OBJ-001, DIP-001, MED-002, PAT-002... Chaque QR est
étiqueté par sa taille et son niveau de correction, pour être imprimé en
finition mate et brillante.
"""

import argparse

import qrcode
from qrcode.constants import ERROR_CORRECT_M, ERROR_CORRECT_Q
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.pdfgen import canvas

TAILLES_CM = (1.5, 2.0, 2.5)
NIVEAUX = (("M", ERROR_CORRECT_M), ("Q", ERROR_CORRECT_Q))
CONTENUS = (
    "MED-001", "PAT-001", "SAL-001", "OBJ-001", "DIP-001",
    "MED-002", "PAT-002", "SAL-002", "OBJ-002", "DIP-002",
)
MARGE_MODULES = 4
POLICE_ETIQUETTE = "Helvetica"
CORPS_ETIQUETTE = 7
INTERLIGNE_ETIQUETTE = 0.3 * cm
HAUTEUR_ETIQUETTE = 2 * INTERLIGNE_ETIQUETTE + 0.1 * cm
ESPACE_CELLULES = 0.3 * cm


def qr_image(contenu: str, correction) -> qrcode.QRCode:
    qr = qrcode.QRCode(
        version=None,
        error_correction=correction,
        box_size=10,
        border=MARGE_MODULES,
    )
    qr.add_data(contenu)
    qr.make(fit=True)
    return qr


def dessiner_planche(sortie: str) -> None:
    c = canvas.Canvas(sortie, pagesize=A4)
    largeur, hauteur = A4
    marge = 1.5 * cm

    c.setFont("Helvetica-Bold", 16)
    c.drawString(marge, hauteur - 1.2 * cm, "CardHospital - Planche de QR de test (phase 0)")
    c.setFont("Helvetica", 9)
    c.drawString(
        marge,
        hauteur - 1.8 * cm,
        "Imprimer en finition mate ET brillante. Tailles indiquees : QR seul, hors marge de 4 modules.",
    )
    x = marge
    y = hauteur - 2.6 * cm
    hauteur_ligne = 0

    for contenu in CONTENUS:
        for taille_cm in TAILLES_CM:
            for nom_niveau, correction in NIVEAUX:
                qr = qr_image(contenu, correction)
                # La taille demandée est celle du QR seul : l'image contient aussi la marge.
                modules = qr.modules_count
                cote_image = taille_cm * cm * (modules + 2 * MARGE_MODULES) / modules

                taille_affichee = str(taille_cm).replace(".", ",")
                etiquette = (contenu, f"{taille_affichee} cm - correction {nom_niveau}")
                largeur_cellule = max(
                    cote_image,
                    *(stringWidth(ligne, POLICE_ETIQUETTE, CORPS_ETIQUETTE) for ligne in etiquette),
                )
                hauteur_cellule = cote_image + HAUTEUR_ETIQUETTE

                if x + largeur_cellule > largeur - marge:
                    x = marge
                    y -= hauteur_ligne + ESPACE_CELLULES
                    hauteur_ligne = 0
                if y - hauteur_cellule < marge:
                    c.showPage()
                    x = marge
                    y = hauteur - marge
                    hauteur_ligne = 0

                centre = x + largeur_cellule / 2
                img = qr.make_image(fill_color="black", back_color="white")
                c.drawImage(
                    ImageReader(img.get_image()),
                    centre - cote_image / 2,
                    y - cote_image,
                    width=cote_image,
                    height=cote_image,
                )
                c.setFont(POLICE_ETIQUETTE, CORPS_ETIQUETTE)
                for numero, ligne in enumerate(etiquette, start=1):
                    c.drawCentredString(centre, y - cote_image - numero * INTERLIGNE_ETIQUETTE, ligne)

                x += largeur_cellule + ESPACE_CELLULES
                hauteur_ligne = max(hauteur_ligne, hauteur_cellule)
    c.save()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sortie", default="planche_qr.pdf")
    args = parser.parse_args()
    dessiner_planche(args.sortie)
    print(f"Planche generee : {args.sortie}")


if __name__ == "__main__":
    main()
