# WCS Mining AI — Single Source of Truth

**Document ID:** `wcs-mining-ai-single-source-spec`  
**Product:** World Class Scholars (WCS) — mobile-first mineral exploration intelligence  
**Status:** Canonical implementation spec  
**Last updated:** 2026-05-18

## Purpose {#purpose}

This document is the single source of truth for product, architecture, data model, API, and implementation guidance for the WCS mining AI target-ranking platform. It prevents duplicate planning files, fragmented implementation notes, and merge drift across Cursor-assisted coding and Xcode builds.

The product is a **lighter, field-ready alternative** to larger exploration AI systems. It combines public geoscience layers, tenement data, historic drilling, satellite products, and company-private datasets into an explainable prospectivity scoring workflow.

**Recommended product shape:** Apple-native SwiftUI (iPhone and iPad) backed by Supabase/Postgres as the operational system of record, with geospatial and machine-learning services running separately for ingestion, feature engineering, model training, and batch scoring.

## Document rules {#document-rules}

- This file is the **only** planning and implementation spec
- PDF output is a read-only distribution artifact generated from this Markdown (Pandoc-style)
- Architecture, schema, API, and screen-flow changes are made **here first**, then in code
- Cursor and Xcode tasks reference section IDs or headings — no competing `v2` specs

---

## Product goal {#product-goal}

The platform helps exploration teams answer three operational questions:

1. **Where** to explore next
2. **Why** a location ranks highly
3. **What evidence** supports the recommendation

This framing serves geologists, exploration managers, and junior mining companies that need decision support without deploying a large internal geoscience data-science stack.

**Initial commercial wedge:** gold and critical-mineral exploration in **Australia**, leveraging a strong public data ecosystem and Digital Earth Australia / Open Data Cube patterns for national-scale raster and satellite workflows.

---

## Scope {#scope}

### In scope {#in-scope}

- Mobile-first SwiftUI app (iPhone and iPad)
- Supabase/Postgres + PostGIS operational backend
- Geospatial and ML services (ingestion, features, training, batch scoring)
- Public data: tenements, occurrences, drillholes, geology, satellite-derived layers
- Tenant-private data imports with rescoring
- Explainable target ranking and field observations
- Offline field packs and background sync

### Out of scope for MVP {#out-of-scope-mvp}

- Full desktop geology modeling replacement
- Underground mine operations management
- Real-time fleet dispatch
- Advanced enterprise ERP integration
- Drone control software

---

## Product modules {#core-product-modules}

### 1. Map explorer {#map-explorer}

Display tenements, prospect boundaries, known mineral occurrences, drillholes, public geology, satellite-derived products, and AI-ranked target cells in one mobile-friendly interface.

**Requirements:** layer toggling, time-aware raster overlays where relevant, commodity filters, offline field packs, target selection, rapid evidence review.

### 2. Target ranking {#target-ranking}

Prioritized list of anomalies or target polygons with prospectivity score, confidence band, commodity, depth hypothesis, model version, and decision status. Scores generated at cell/polygon level from a **gridded feature architecture** (data-cube style).

### 3. Explainability {#explainability}

Evidence panel per target: feature contributions (structural proximity, geophysics, alteration, analog similarity, drill geochemistry trends). Supports geological reasoning — not a black-box heatmap.

### 4. Data room {#data-room}

Ingest company-private datasets: assay CSV, collar/survey tables, shapefiles/GeoJSON, mapped structures, legacy drilling exports. Tenant-isolated; scoring merges with public layers for organization-specific targets.

### 5. Field operations {#field-operations}

Download targets to device, inspect evidence in the field, capture observations, annotate outcrops, attach photos, sync when connectivity returns.

---

## User roles {#user-roles}

| Role | Main needs | Core permissions |
|------|------------|------------------|
| Geologist | Inspect targets, review evidence, capture field observations | Read maps, create field notes, upload photos |
| Exploration manager | Compare targets, approve work programs | Read all, change target status, assign programs |
| Data manager | Validate imports, maintain source quality | Manage layers, pipelines, schema mappings |
| Executive / investor | Portfolio heatmaps and campaign metrics | Read dashboards and summaries only |

**Tenancy:** each mining company has isolated projects, users, and private datasets. Supabase **row-level security** on all operational tables using `organization_id` and `project_id`.

---

## Reference architecture {#reference-architecture}

### Client layer {#client-layer}

| Capability | Technology |
|------------|------------|
| UI | SwiftUI iOS/iPadOS |
| Maps | MapKit + custom vector/raster overlays |
| Offline | Map/field packs, target summaries, observation queue |
| Auth | Supabase Auth (enterprise SSO later) |
| Field | Core Location, camera, CSV/GeoJSON import |
| Sync | Background upload when connectivity resumes |

### Backend layer {#backend-layer}

| Component | Technology |
|-----------|------------|
| Database | Supabase Postgres + **PostGIS** |
| Storage | Supabase Storage (rasters, drill files, reports) |
| Orchestration | Edge functions or Nest.js (imports, audit, signed jobs) |
| API | Tenant-scoped REST; async jobs for heavy work |

### ML and geospatial layer {#ml-layer}

| Capability | Approach |
|------------|----------|
| ETL / rasters | Python geospatial services |
| Features / training / scoring | Python batch pipelines |
| Rescoring | Scheduled regional runs + on-demand after private imports |
| Explainability | Feature importance + rule extraction |

### External data layer {#external-data-layer}

- Government tenement, geology, occurrence, drillhole portals
- Digital Earth Australia / Open Data Cube derivatives
- Optional licensed geophysics, hyperspectral, advanced remote sensing

### Architecture principles {#architecture-principles}

- iOS client: experience, field workflow, offline cache, map interaction
- Heavy geospatial/ML processing **outside** the mobile app
- Postgres/PostGIS = authoritative operational state
- Markdown spec sections = implementation anchors

---

## Data model {#data-model}

Schema separates operational data, spatial layers, model outputs, and field feedback.

### Main tables {#main-tables}

| Table | Purpose | Key fields |
|-------|---------|------------|
| `organizations` | Mining-company tenant | `id`, `name`, `plan_tier` |
| `users` | Auth-linked identity | `id`, `organization_id`, `role` |
| `projects` | Exploration asset | `id`, `organization_id`, `commodity`, `region` |
| `tenements` | Licences and boundaries | `id`, `project_id`, `status`, `geom` |
| `occurrences` | Deposits / prospects / showings | `id`, `commodity`, `source`, `geom` |
| `drillholes` | Collar and metadata | `id`, `project_id`, `hole_id`, `depth_m`, `geom` |
| `samples` | Intervals / field samples | `id`, `drillhole_id`, `from_m`, `to_m`, `sample_type` |
| `assays` | Analytical results | `id`, `sample_id`, `element_code`, `value`, `unit` |
| `geology_units` | Lithology / stratigraphy | `id`, `source`, `unit_name`, `geom` |
| `geophysics_layers` | Mag / gravity / radiometric | `id`, `source`, `layer_type`, `raster_uri` |
| `satellite_layers` | DEA / RS derivatives | `id`, `source`, `index_name`, `raster_uri` |
| `feature_cells` | Gridded feature vectors | `id`, `grid_id`, `project_id`, `feature_json`, `geom` |
| `models` | Model registry | `id`, `commodity`, `deposit_style`, `version`, `metrics_json` |
| `targets` | Ranked targets | `id`, `model_id`, `project_id`, `score`, `confidence`, `depth_band`, `geom` |
| `target_explanations` | Evidence per target | `id`, `target_id`, `driver_json`, `narrative` |
| `field_observations` | Ground-truth feedback | `id`, `target_id`, `user_id`, `obs_type`, `note`, `geom` |
| `imports` | Dataset import jobs | `id`, `organization_id`, `source_type`, `status` |
| `scoring_runs` | Rescoring job tracking | `id`, `project_id`, `model_id`, `status`, `started_at` |

### Spatial conventions {#spatial-conventions}

- PostGIS geometry columns with explicit SRID strategy
- Consistent internal projection policy
- Coordinate validation at ingestion
- Rasters versioned in storage; metadata in transactional tables

---

## Geospatial and ML pipeline {#geospatial-ml-pipeline}

### Step 1: Ingestion {#pipeline-ingestion}

Staging → validation → provenance (source, version, timestamp, schema mapping). Schema checks, CRS validation, null handling, deduplication, lineage logging. Failed imports produce machine-readable error reports.

### Step 2: Standardization {#pipeline-standardization}

Harmonize to a common grid/tiling system so each cell carries a unified feature vector across geology, geophysics, structure, surface signatures, and occurrences.

### Step 3: Feature engineering {#pipeline-feature-engineering}

Early features:

- Distance to faults, contacts, intrusions, known occurrences
- Magnetic, gravity, radiometric, conductivity proxies
- Surface alteration / spectral proxies (satellite, hyperspectral where available)
- Drillhole density, mineralized intervals, anomalous assay frequency, pathfinders
- Tenement adjacency; distance to historical workings or deposits

### Step 4: Model training {#pipeline-training}

Batch-trained by commodity and deposit style using known occurrences and curated labels. Favor explainability and robustness: gradient-boosted trees, random forests, calibrated logistic ensembles.

### Step 5: Scoring and ranking {#pipeline-scoring}

Normalized prospectivity score, uncertainty estimate, evidence vector per cell/polygon. Group adjacent high-scoring cells into target zones; rank by commodity, jurisdiction, access, tenure.

### Step 6: Feedback loop {#pipeline-feedback}

Field observations, new drilling, rejected targets → training set for organizational learning.

---

## Explainability design {#explainability-specification}

### Quantitative (target card / detail) {#explainability-quantitative}

- Top 5 feature drivers
- Similarity to analogue deposits
- Confidence score
- Data completeness score
- Date of last rescore
- Model version
- Public vs private evidence provenance flags

### Narrative {#explainability-narrative}

Short geological narrative in exploration language, e.g. *ranks highly because it sits near a structural corridor, overlaps a magnetic anomaly, and lies in a favorable host sequence with nearby gold occurrences.*

---

## SwiftUI application structure {#swiftui-application-structure}

### Main screens {#primary-screens}

1. Sign in / organization selection
2. Portfolio dashboard
3. Project map
4. Ranked targets list
5. Target detail (explanation tabs)
6. Field observation form
7. Layer manager
8. Imports and sync status
9. Settings / offline packs

### Navigation model {#navigation-model}

**iPhone:** tab shell — Dashboard, Map, Targets, Field, Settings. Map uses **bottom sheet** for selected target with evidence tabs and nearby drillholes.

**iPad:** split view — project sidebar, map canvas, detail inspector pane.

### Key iOS capabilities {#ios-capabilities}

- Background sync for completed uploads
- File import (CSV, GeoJSON)
- Camera and photo attachments (field)
- Core Location for navigation and observations
- MapKit base map + custom overlays
- Offline-created UUIDs on observations for conflict-safe sync

### App architecture {#app-architecture}

- MVVM for screen state
- Repository layer for API and local cache
- Background sync manager
- Offline store for packs, targets, observations

### Repository layout {#ios-repo-layout}

```
WCS-GEO/                    # SwiftUI app (Xcode target)
  App/                      # Shell, tabs, iPad root
  Features/                 # Dashboard, Map, Targets, Field, Auth, Layers, Imports
  Core/                     # Config, Supabase, models
```

Canonical Xcode project: `WCS-GEO.xcodeproj` at repository root.

---

## API contracts {#api-contracts}

### Core endpoints {#core-endpoints}

| Method | Path | Purpose |
|--------|------|---------|
| `POST` | `/imports` | Create import job |
| `GET` | `/projects` | List projects |
| `GET` | `/projects/:id/map-layers` | Resolve visible layers |
| `GET` | `/projects/:id/targets` | List ranked targets (filters) |
| `GET` | `/targets/:id` | Full target detail + explanation |
| `POST` | `/targets/:id/observations` | Submit field evidence |
| `POST` | `/projects/:id/rescore` | Request rescoring |
| `GET` | `/models/:id/summary` | Model metadata and performance |

### Async jobs {#async-jobs}

Heavy imports, raster preprocessing, and rescoring run as **jobs** — not synchronous requests.

### API rules {#api-rules}

- Model output responses include `model_version` and `scoring_timestamp`
- All target endpoints tenant-scoped
- Observations accept offline UUIDs for idempotent sync

---

## Security and tenancy {#security-model}

Mining companies treat internal layers and drilling as commercially sensitive.

- Tenant isolation + RLS on every operational table
- Audited imports and rescoring
- Clear separation of public vs private feature provenance on each target
- Private data path is opt-in and traceable

---

## MVP roadmap {#mvp-roadmap}

### Phase 1: Foundation {#phase-1}

- Australia gold exploration MVP
- Public tenements, occurrences, drillholes, selected rasters
- Batch regional target ranking
- iPhone/iPad viewer: map + target cards

### Phase 2: Private data fusion {#phase-2}

- Company assay and drillhole import
- Project-level rescoring
- Explainability panel
- Field observations and photos

### Phase 3: Model maturity {#phase-3}

- Additional commodities and deposit styles
- Better uncertainty estimation
- Analyst dashboards and program planning
- Report text mining

### Phase 4: Enterprise expansion {#phase-4}

- Collaboration and approval trails
- Deeper GIS exports
- Integrations with geology / mine-planning platforms

---

## Commercial positioning {#commercial-positioning}

**Do not** position as a replacement for every desktop geology suite.

**Position as:** a mobile-first AI exploration copilot for junior and mid-tier explorers — faster target generation, clearer explanations, field-ready workflows.

**WCS differentiation:**

- Explainable targeting
- iPad-first field usage
- Parallel **education / simulation mode** for workforce training and university partnerships (aligned with WCS structure and scaling goals)

---

## Acceptance criteria {#acceptance-criteria}

- [ ] Tenant loads at least one project
- [ ] Map shows public layers and ranked targets
- [ ] Target detail explains ranking (quantitative + narrative)
- [ ] Geologist creates field observation offline and syncs later
- [ ] Manager triggers rescoring after private import
- [ ] Every scored target records model version and timestamp
- [ ] Evidence distinguishes public vs private inputs where applicable

---

## Repository structure {#repository-structure}

```
WCS-GEO/
  docs/wcs-mining-ai-single-source-spec.md
  WCS-GEO/                  # iOS app
  WCS-GEO.xcodeproj/
  backend/api/
  backend/workers/
  ml/notebooks/
  ml/pipelines/
  infra/sql/
  infra/seeds/
```

---

## Cursor and Xcode workflow {#cursor-xcode-workflow}

- Reference exact headings from this document
- One vertical slice at a time
- Update this file before broad refactors
- Dev/prod targets implement the same spec sections

---

## Change management {#change-management}

Significant changes update the relevant section here before or with code. Regenerate PDF after major revisions for investor, partner, and internal review.
