# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static portfolio website for **Fireshark Tech**, showcasing mobile applications (iOS and Android). Hosted on GitHub Pages with the custom domain `fireshark.tech` (configured via `CNAME`).

## Project Structure

- `index.html` — Main portfolio landing page (dark theme, custom inline CSS — not Tailwind)
- `apps/<app-slug>/index.html` — Dedicated detail pages for individual apps (currently: `apps/sonlink/`)
- `image/app_icon/` — App icons used on the main portfolio cards
- `image/sonlink/` — Cropped iPhone screenshots for the SonLink detail page (sourced from App Store CDN, cropped tight to phone bezel via `sips`/PIL)
- `README.md` — Repo overview + links to published apps
- `app-ads.txt` — AdMob ads.txt for app monetization
- `CNAME` — Custom domain config for GitHub Pages

## Published Applications

Apps currently featured on the portfolio main page (`index.html`):

1. **Goodbus** — Hong Kong bus arrival time app
2. **SonLink: TV Remote** — Sony Bravia–only smart TV remote (has dedicated detail page at `apps/sonlink/`)
3. **SuperMote: TV Remote Control** — Universal Wi-Fi remote covering Samsung, LG, Sony BRAVIA, Google TV, TCL, Hisense, Philips, Xiaomi, NVIDIA SHIELD, Chromecast
4. **Pon Pon Math** — Educational math game for children (App Store only — Play Store link is intentionally commented out in the HTML)

> **SonLink vs SuperMote:** intentionally separate products despite brand overlap. SonLink is the dedicated Bravia-only experience; SuperMote is the universal app. Do not propose merging or removing either.

> Note: a previous "Remote for WebOS TV" card existed but was removed from the lineup.

## Conventions

### Adding a new app card to the main page

1. Add an icon to `image/app_icon/<name>_icon.png`
2. Add an `.app-card` block inside `<div class="apps-grid">` in `index.html`, mirroring an existing card
3. If the app warrants a dedicated detail page, create `apps/<slug>/index.html` and link from the card using the **clickable card pattern** (see SonLink card)

### Clickable card pattern (for cards with detail pages)

```html
<div class="app-card clickable">
    <a href="apps/<slug>/index.html" class="card-link-overlay" aria-label="Learn more about ...">... details</a>
    <!-- icon, h3, p, download-buttons, learn-more link -->
</div>
```

The `.card-link-overlay` is `position: absolute; inset: 0; z-index: 1` so the entire card is clickable. Download buttons use `z-index: 2` so they remain independently clickable. Always link to `<slug>/index.html` (explicit) so it works on `file://` previews and on GitHub Pages.

### App detail page template (apps/sonlink/ as reference)

Standard sections: top nav with back-to-main + CTA → hero (icon + eyebrow badge + title + lede + download buttons + phone screenshot) → "Why <app>" comparison → features grid → screenshots gallery → compatibility card → 3-step "How it works" → FAQ accordion → CTA → footer. Each detail page is fully self-contained (no shared CSS file).

### Screenshot processing

App Store screenshots come pre-framed with brand background and locale-specific captions. Strip both:
1. Pull from iTunes lookup API or scrape the App Store HTML for `PurpleSource*/zh_N.png`-style URLs
2. Crop tight to the phone bezel — for the iPhone 14 Pro–style App Store frame, `(184, 555, 1098, 2478)` of the 1284×2778 source works well
3. Resize to 600px wide for web (PNG, ~190KB each is acceptable)
4. Apply CSS `border-radius` (~32px on display) to mask any residual background slivers in the rounded phone corners

## Development Notes

- Pure static site — no build process, no package.json, no test suite
- Custom inline CSS in each HTML file (no shared stylesheet, no Tailwind, no framework)
- Dark theme with purple gradient (`#667eea` → `#764ba2`) as the brand accent; SonLink page also uses Sony Bravia blue (`#4a9eff`) as a secondary accent
- Responsive: desktop-first, single mobile breakpoint at 900px (and 600px for the SonLink detail page)
- All meta tags, OG tags, and favicon (inline SVG with brand gradient) live in each page's `<head>`
- Contact email: hello@fireshark.tech

## Deployment

GitHub Pages auto-deploys from `main` on push. Custom domain via `CNAME` (`fireshark.tech`). There is no PR workflow — direct commits to `main` are the established pattern. After pushing, GitHub Pages typically takes 1–2 minutes to propagate.
