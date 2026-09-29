#!/usr/bin/env python3
"""Arma traspasos.html (un solo archivo que funciona sin internet) a partir de src/traspasos.src.html.

Incrusta la librería SheetJS, el logotipo y el ícono para que la app abra con doble clic en PC o Mac.
Uso:  python3 tools/build.py
"""
import base64
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def data_uri(path, mime):
    return f"data:{mime};base64," + base64.b64encode((ROOT / path).read_bytes()).decode()


src = (ROOT / "src/traspasos.src.html").read_text(encoding="utf-8")
lib = (ROOT / "vendor/xlsx.full.min.js").read_text(encoding="utf-8")
assert "</script" not in lib.lower()

out = (src
       .replace("/*@@XLSX@@*/", "\n" + lib + "\n")
       .replace("@@LOGO@@", data_uri("img/logo-embebido.jpg", "image/jpeg"))
       .replace("@@FAVICON@@", data_uri("img/favicon-64.png", "image/png")))
assert "@@" not in out.replace("/*@@", "")
(ROOT / "traspasos.html").write_text(out, encoding="utf-8")
print(f"traspasos.html generado ({len(out.encode()) // 1024} KB)")
