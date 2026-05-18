#!/usr/bin/env python3
"""Generate 10-page WCS Mining AI investor PDF with embedded report images."""

from pathlib import Path

from fpdf import FPDF

ROOT = Path(__file__).resolve().parents[1]
IMG = ROOT / "docs" / "investor-report" / "images"
OUT_REPO = ROOT / "docs" / "investor-report" / "WCS-Mining-AI-Investor-Report-10pp.pdf"
OUT_DESKTOP = Path.home() / "Desktop" / "WCS-Mining-AI-Launch-Package" / "WCS-Mining-AI-Investor-Report-10pp.pdf"

GOLD = (218, 165, 32)
DIAMOND = (220, 235, 255)
OBSIDIAN = (18, 18, 22)
WHITE = (245, 245, 250)

PAGES = [
    {
        "title": "Executive Summary",
        "image": "report-01-gold-diamonds-vision.png",
        "body": (
            "WCS Mining AI is a mobile-first exploration intelligence platform for World Class Scholars. "
            "It helps teams decide where to explore, why targets rank highly, and what evidence supports each recommendation. "
            "The product combines public Australian geoscience, tenement data, drilling, satellite layers, and tenant-private imports "
            "into explainable prospectivity scoring - delivered through a premium SwiftUI experience with sparkling gold and diamond branding."
        ),
    },
    {
        "title": "Problem & Market Opportunity",
        "image": "report-02-mobile-platform.png",
        "body": (
            "Junior and mid-tier explorers lack affordable, field-ready AI that geologists can trust. "
            "Desktop suites are powerful but slow in the field; black-box heatmaps fail board and field scrutiny. "
            "Australia offers a strong wedge: rich public data, Digital Earth Australia rasters, and active gold/critical-minerals campaigns."
        ),
    },
    {
        "title": "Map Explorer Module",
        "image": "report-01-gold-diamonds-vision.png",
        "body": (
            "The map explorer unifies tenements, geology, occurrences, drillholes, raster overlays, and AI-ranked targets. "
            "Users toggle layers, filter by commodity, download offline packs, and open target evidence from the map. "
            "MapKit provides the base map; custom vector and raster overlays connect to PostGIS-backed project layers."
        ),
    },
    {
        "title": "Target Ranking Module",
        "image": "report-03-ai-targeting.png",
        "body": (
            "Targets are ranked cells or merged polygons with prospectivity score, confidence band, commodity, depth hypothesis, "
            "model version, and decision status. Scoring uses a gridded feature architecture (data-cube pattern) with batch regional runs "
            "and on-demand rescoring after private imports."
        ),
    },
    {
        "title": "Explainability Module",
        "image": "report-03-ai-targeting.png",
        "body": (
            "Each target exposes top-five feature drivers, analog deposit similarity, data completeness, last rescore date, and a geological narrative. "
            "Evidence is tagged Public, Private, or Blended so teams know which inputs are company-confidential. "
            "Gradient-boosted trees and random forests prioritize interpretability over opaque deep models in early releases."
        ),
    },
    {
        "title": "Data Room & Private Fusion",
        "image": "report-02-mobile-platform.png",
        "body": (
            "The data room ingests assay CSV, collar surveys, GeoJSON structures, and legacy exports. "
            "Imports run as asynchronous jobs with provenance and validation reports. "
            "Tenant isolation via Supabase RLS ensures private drilling and assays never leak across organizations."
        ),
    },
    {
        "title": "Field Operations",
        "image": "report-04-field-operations.png",
        "body": (
            "Geologists download targets, review evidence offline, capture observations, annotate outcrops, and attach photos. "
            "Core Location anchors observations; offline UUIDs enable conflict-safe sync. "
            "Background upload resumes when connectivity returns - critical for remote Australian exploration."
        ),
    },
    {
        "title": "Architecture & Security",
        "image": "report-03-ai-targeting.png",
        "body": (
            "SwiftUI client; Supabase Postgres + PostGIS; Supabase Storage; Python ML pipelines; edge/Nest orchestration. "
            "API surface: projects, map-layers, targets, observations, imports, rescore, model summary. "
            "Roles: geologist, exploration manager, data manager, executive viewer - with audited imports and rescoring."
        ),
    },
    {
        "title": "Roadmap & Commercial Model",
        "image": "report-05-investor-growth.png",
        "body": (
            "Phase 1: Australia gold MVP with public layers and map/target viewer. "
            "Phase 2: private imports, explainability, field photos. "
            "Phase 3: multi-commodity, uncertainty, analyst dashboards. "
            "Phase 4: enterprise approvals and GIS integrations. SaaS per organization with private-data and rescoring upsell."
        ),
    },
    {
        "title": "Investment Highlights",
        "image": "report-05-investor-growth.png",
        "body": (
            "WCS differentiation: explainable targeting, iPad-first field workflow, and education/simulation mode for training partnerships. "
            "Premium brand identity (sparkling gold & diamonds) supports App Store and investor materials. "
            "CI/CD on GitHub ensures repeatable iOS builds. MVP acceptance criteria are defined and tracked in the canonical product spec."
        ),
    },
]


class InvestorPDF(FPDF):
    def header(self):
        self.set_fill_color(*OBSIDIAN)
        self.rect(0, 0, 210, 20, style="F")
        self.set_text_color(*GOLD)
        self.set_font("Helvetica", "B", 11)
        self.set_xy(10, 6)
        self.cell(0, 8, "WCS Mining AI  |  World Class Scholars", ln=True)

    def footer(self):
        self.set_y(-12)
        self.set_font("Helvetica", "", 9)
        self.set_text_color(*DIAMOND)
        self.cell(0, 8, f"Investor Report  |  Page {self.page_no()}/10", align="C")


def add_page(pdf: InvestorPDF, page: dict, page_num: int) -> None:
    pdf.add_page()
    pdf.set_fill_color(*OBSIDIAN)
    pdf.rect(0, 20, 210, 277, style="F")

    img_path = IMG / page["image"]
    if img_path.exists():
        pdf.image(str(img_path), x=10, y=26, w=190, h=85)

    pdf.set_xy(10, 118)
    pdf.set_text_color(*GOLD)
    pdf.set_font("Helvetica", "B", 16)
    pdf.multi_cell(190, 9, f"{page_num}. {page['title']}")

    pdf.set_xy(10, 135)
    pdf.set_text_color(*WHITE)
    pdf.set_font("Helvetica", "", 11)
    pdf.multi_cell(190, 6, page["body"])

    pdf.set_xy(10, 255)
    pdf.set_draw_color(*GOLD)
    pdf.line(10, 255, 200, 255)
    pdf.set_font("Helvetica", "I", 9)
    pdf.set_text_color(*DIAMOND)
    pdf.cell(190, 6, "Sparkling gold and diamonds brand  |  Apple production assets included", ln=True)


def main() -> None:
    pdf = InvestorPDF(orientation="P", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=False)
    pdf.set_margins(10, 22, 10)

    for index, page in enumerate(PAGES, start=1):
        add_page(pdf, page, index)

    OUT_REPO.parent.mkdir(parents=True, exist_ok=True)
    OUT_DESKTOP.parent.mkdir(parents=True, exist_ok=True)
    pdf.output(str(OUT_REPO))
    pdf.output(str(OUT_DESKTOP))
    print(f"Wrote {OUT_REPO}")
    print(f"Wrote {OUT_DESKTOP}")


if __name__ == "__main__":
    main()
