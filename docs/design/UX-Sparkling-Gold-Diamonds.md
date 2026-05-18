# UX: Sparkling Gold & Diamonds

**Spec reference:** `docs/wcs-mining-ai-single-source-spec.md`  
**Implementation:** `WCS-GEO/Core/Design/WCSTheme.swift`

## Brand intent

WCS Mining AI should feel **premium, trustworthy, and exploration-focused**—like high-grade gold and cut diamonds, not generic SaaS blue. The UI supports investor-grade demos and App Store production.

## Color system

| Token | Role |
|-------|------|
| Gold light → gold → gold deep | Primary actions, titles, tab tint |
| Diamond / diamond accent | Secondary text, sparkle particles |
| Obsidian / charcoal | Backgrounds, cards, tab bar |

## Motion & texture

- `SparkleOverlay`: subtle gold/diamond particle field on auth and screen backgrounds
- Gold gradient titles on sign-in and key headers
- Dark mode enforced for contrast and luxury feel

## Screen patterns

| Screen | UX pattern |
|--------|----------------|
| Sign in | Hero card, diamond emblem, gold CTA |
| Organization | Gold icons, charcoal list rows |
| iPhone tabs | Obsidian tab bar, gold selected state |
| Map | Bottom sheet target detail, layer manager link |
| Targets | Decision status, score row, tabbed detail |
| Field | Observation type picker, offline save affordance |

## iPad

`iPadRootView`: three-column split (projects/targets | map | detail) per spec §ipad-navigation.

## Accessibility

- Minimum 4.5:1 contrast for body text on charcoal (diamond/white copy)
- Gold buttons use dark label/icon on gold fills where applicable
