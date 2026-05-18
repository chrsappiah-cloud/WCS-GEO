# WCS Mining AI — Investor Report

**World Class Scholars (WCS)**  
**Product:** Mobile-first AI exploration intelligence  
**Date:** May 2026  
**Classification:** Investor briefing

---

## Page 1 — Executive summary

WCS Mining AI is a **sparkling-gold standard** mobile exploration platform that helps junior and mid-tier mining companies answer three questions: where to explore next, why a target ranks highly, and what evidence supports the recommendation.

Unlike desktop-only geology suites, WCS delivers an **iPhone and iPad-native** experience with explainable prospectivity scoring, public geoscience fusion, and tenant-private data imports—backed by Supabase/PostGIS and Python ML services.

**Initial market:** Australian gold and critical minerals, leveraging Digital Earth Australia and national drillhole/tenement datasets.

---

## Page 2 — Problem & opportunity

Exploration teams face rising data volumes, fragmented GIS workflows, and black-box AI heatmaps that geologists cannot defend in boardrooms or field programs.

**Opportunity:** A lighter, field-ready copilot that combines:

- Public tenements, occurrences, drillholes, and satellite layers
- Company-private assays and structures (tenant-isolated)
- Explainable rankings with geological narrative
- Offline field capture and background sync

---

## Page 3 — Product modules (1/2)

### Map explorer

Unified map for tenements, geology, occurrences, drillholes, rasters, and AI-ranked targets. Layer toggles, commodity filters, offline packs, and map-based evidence review.

### Target ranking

Prioritized anomalies with prospectivity score, confidence band, commodity, depth hypothesis, model version, and decision status—powered by a gridded data-cube feature architecture.

---

## Page 4 — Product modules (2/2)

### Explainability

Top feature drivers, analog deposit similarity, data completeness, and narrative geological summaries. Public vs private evidence provenance on every target.

### Data room & field operations

CSV/GeoJSON imports for assays, collars, and structures. Field notes, photos, Core Location capture, and offline UUID sync when connectivity returns.

---

## Page 5 — Technology architecture

| Layer | Stack |
|-------|--------|
| Client | SwiftUI, MapKit, offline cache |
| Backend | Supabase Postgres + PostGIS |
| Storage | Supabase Storage (rasters, exports) |
| ML | Python ETL, feature engineering, batch scoring |
| Orchestration | Edge functions / Nest.js jobs |

Heavy geospatial processing stays off-device; the iOS app focuses on experience and field workflow.

---

## Page 6 — Data model & pipeline

**Operational tables:** organizations, users, projects, tenements, occurrences, drillholes, samples, assays, geology_units, geophysics_layers, satellite_layers.

**ML outputs:** feature_cells, models, targets, target_explanations, scoring_runs, field_observations, imports.

**Pipeline:** ingestion → standardization → feature engineering → training → scoring → feedback loop from field and drilling outcomes.

---

## Page 7 — User roles & security

| Role | Capability |
|------|------------|
| Geologist | Maps, targets, field observations |
| Exploration manager | Status changes, program approval |
| Data manager | Imports, layers, QA |
| Executive | Read-only portfolio dashboards |

**Security:** Supabase row-level security, tenant isolation, audited imports/rescoring, traceable public/private feature provenance.

---

## Page 8 — API & roadmap

**Core API:** projects, map-layers, targets, observations, imports, rescore, model summary. Async jobs for heavy geospatial work.

| Phase | Deliverables |
|-------|----------------|
| 1 | Australia gold MVP, public layers, map + targets |
| 2 | Private imports, explainability, field photos |
| 3 | Multi-commodity, uncertainty, analyst dashboards |
| 4 | Enterprise approvals, GIS exports, integrations |

---

## Page 9 — WCS differentiation

1. **Explainable targeting** — geological narrative, not black-box heatmaps  
2. **iPad-first field usage** — split view, offline packs, background sync  
3. **Education / simulation mode** — workforce training and university partnerships  

**Positioning:** Mobile-first AI exploration copilot—not a replacement for every desktop geology suite.

---

## Page 10 — Investment highlights

- Strong Australian public data foundation (DEA, tenements, drillholes)  
- Recurring SaaS per organization with private-data upsell  
- Defensible workflow: field capture → rescoring → model improvement  
- Apple-native UX with premium **sparkling gold & diamond** brand identity  
- Clear MVP acceptance criteria and CI/CD delivery discipline  

**Contact:** World Class Scholars — WCS Mining AI product team

---

*This report accompanies five branded visuals: vision, mobile platform, AI targeting, field operations, and investor growth.*
