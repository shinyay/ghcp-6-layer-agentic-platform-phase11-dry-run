#!/usr/bin/env python3
"""Generate QR code SVG for the GitHub Pages site URL.

Usage: python3 scripts/gen-qr.py [URL] [OUTPUT]
Defaults: https://shinyay.github.io/ghcp-6-layer-agentic-platform/ -> site/qr.svg
"""
import sys
from pathlib import Path

import qrcode
from qrcode.constants import ERROR_CORRECT_H
from qrcode.image.svg import SvgPathImage

URL = sys.argv[1] if len(sys.argv) > 1 else "https://shinyay.github.io/ghcp-6-layer-agentic-platform/"
OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path(__file__).resolve().parent.parent / "site" / "qr.svg"

qr = qrcode.QRCode(
    version=None,
    error_correction=ERROR_CORRECT_H,
    box_size=20,
    border=2,
)
qr.add_data(URL)
qr.make(fit=True)

img = qr.make_image(image_factory=SvgPathImage)
OUT.parent.mkdir(parents=True, exist_ok=True)
img.save(str(OUT))

# Post-process: ensure black foreground & transparent background, add a viewBox-friendly attr
content = OUT.read_text()
# qrcode>=7 already emits <svg viewBox=...>. Ensure path fill is bright for dark backgrounds —
# we keep it black and let the <img> sit on a white card for contrast.
print(f"Wrote QR for {URL} -> {OUT}")
