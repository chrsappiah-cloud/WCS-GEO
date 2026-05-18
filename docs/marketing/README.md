# WCS Mining AI — Apple production assets

Sparkling **gold & diamonds** brand package for App Store and investor distribution.

## App icons

| File | Size | Usage |
|------|------|--------|
| `../../WCS-GEO/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` | 1024×1024 | App Store / universal |
| `AppIcon-1024-dark.png` | 1024×1024 | Dark appearance |
| `AppIcon-1024-tinted.png` | 1024×1024 | Tinted appearance |

## App Store marketing (`app-store/`)

| File | Suggested use |
|------|----------------|
| `marketing-launch-iphone-hero.png` | iPhone 6.7" hero / launch |
| `marketing-launch-ipad-hero.png` | iPad landscape hero |
| `marketing-launch-targets.png` | Targets feature screenshot |
| `marketing-launch-explainability.png` | Explainability feature screenshot |

Upload via [App Store Connect](https://appstoreconnect.apple.com) Screenshots and Preview sections. Resize with Apple's required dimensions if needed.

## Investor report

- Markdown: `../investor-report/WCS-Mining-AI-Investor-Report.md`
- PDF (10 pages): `../investor-report/WCS-Mining-AI-Investor-Report-10pp.pdf`
- Images: `../investor-report/images/report-01` … `report-05`

Regenerate PDF:

```bash
.venv-pdf/bin/python scripts/generate_investor_pdf.py
```

## Desktop delivery

Copies are synced to:

`~/Desktop/WCS-Mining-AI-Launch-Package/`

- `App-Icons/`
- `Marketing-Images/`
- `Investor-Report/` (5 PNGs + PDF)
