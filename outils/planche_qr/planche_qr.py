#!/usr/bin/env python3
"""Génère une planche de QR de test (PDF A4) pour la phase 0 de CardHospital.

Usage :
    python3 planche_qr.py [--sortie planche_qr.pdf]

La planche contient des QR de 1,5, 2 et 2,5 cm, aux niveaux de correction M et Q,
avec une marge de 4 modules et le contenu MED-001, PAT-001, SAL-001, OBJ-001,
DIP-001, MED-002, PAT-002... Chaque QR est étiqueté par sa taille et son niveau
de correction, pour être imprimé en finition mate et brillante.
"""

import argparse

import qrcode
from qrcode.constants import ERROR_CORRECT_M, ERROR_CORRECT_Q
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.pdfgen import canvas

TAILLES_CM = (1.5, 2.0, 2.5)
NIVEAUX = (("M", ERROR_CORRECT_M), ("Q", ERROR_CORRECT_Q))
CONTENUS = (
    "MED-001", "PAT-001", "SAL-001", "OBJ-001", "DIP-001",
    "MED-002", "PAT-002", "SAL-002", "OBJ-002", "DIP-002",
)
MARGE_MODULES = 4


def qr_image(contenu: str, taille_cm: float, correction) -> qrcode.QRCode:
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
    x = marge
    y = hauteur - marge

    c.setFont("Helvetica-Bold", 16)
    c.drawString(marge, hauteur - 1.2 * cm, "CardHospital - Planche de QR de test (phase 0)")
    c.setFont("Helvetica", 9)
    c.drawString(
        marge,
        hauteur - 1.8 * cm,
        "Imprimer en finition mate ET brillante. Chaque QR est etiquete par sa taille et son niveau de correction.",
    )
    y = hauteur - 2.6 * cm

    for contenu in CONTENUS:
        for taille_cm in TAILLES_CM:
            for nom_niveau, correction in NIVEAUX:
                qr = qr_image(contenu, taille_cm, correction)
                taille_pt = taille_cm * cm
                hauteur_cellule = taille_pt + 1.0 * cm
                if x + taille_pt > largeur - marge:
                    x = marge
                    y -= hauteur_cellule + 0.4 * cm
                if y - hauteur_cellule < marge:
                    c.showPage()
                    x = marge
                    y = hauteur - marge
                img = qr.make_image(fill_color="black", back_color="white")
                chemin = f"/tmp/qr_{contenu}_{taille_cm}_{nom_niveau}.png"
                img.save(chemin)
                c.drawImage(chemin, x, y - taille_pt, width=taille_pt, height=taille_pt)
                c.setFont("Helvetica", 7)
                c.drawCentredString(
                    x + taille_pt / 2,
                    y - taille_pt - 0.3 * cm,
                    f"{contenu} - {taille_cm} cm - correction {nom_niveau}",
                )
                x += taille_pt + 0.6 * cm
    c.save()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sortie", default="planche_qr.pdf")
    args = parser.parse_args()
    dessiner_planche(args.sortie)
    print(f"Planche generee : {args.sortie}")


if __name__ == "__main__":
    main()
