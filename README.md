# WCS Mining AI (WCS-GEO)

**World Class Scholars (WCS)** — mobile-first mineral exploration intelligence for junior and mid-tier explorers. A field-ready AI exploration copilot combining public geoscience, tenement data, drilling, satellite products, and tenant-private datasets into explainable target ranking.

## Single source of truth

All product, architecture, schema, API, and screen-flow guidance lives in one place:

**[docs/wcs-mining-ai-single-source-spec.md](docs/wcs-mining-ai-single-source-spec.md)**

Cursor and Xcode work should reference section headings from that document. Do not add competing architecture or planning files in the repo.

## Repository layout

| Path | Purpose |
|------|---------|
| `WCS-GEO/` | SwiftUI iOS/iPadOS client |
| `backend/api/` | API service (Supabase edge or Nest) |
| `backend/workers/` | Async jobs (imports, rescoring) |
| `ml/pipelines/` | Feature engineering and scoring |
| `ml/notebooks/` | Exploration and model development |
| `infra/sql/` | PostGIS schema and migrations |
| `infra/seeds/` | Dev/staging seed data |
| `docs/` | Canonical spec and distribution source |

## PDF distribution

Generate read-only PDFs from the Markdown spec (e.g. Pandoc) after major revisions; do not treat PDF as the editable source.

## CI/CD

[![iOS CI](https://github.com/chrsappiah-cloud/WCS-GEO/actions/workflows/ios-ci.yml/badge.svg)](https://github.com/chrsappiah-cloud/WCS-GEO/actions/workflows/ios-ci.yml)

Every push and pull request to `main` / `develop` runs:

- **Build (iOS Simulator)** — Xcode build with Swift Package resolution
- **Unit Tests** — `WCS-GEOTests`
- **Validate investor report assets** — images, PDF, marketing, app icon
- **CI Success** — aggregate gate (required for merge when branch protection is enabled)

Workflow: [`.github/workflows/ios-ci.yml`](.github/workflows/ios-ci.yml)
