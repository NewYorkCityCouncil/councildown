---
name: nycc-style
description: NYC Council (NYCC) styling rules — colors, palettes, fonts, chart and map styling — for anything the Council data team builds. Use whenever creating or editing a web page, React/TypeScript component, chart, map, dashboard, or data visualization for the NYC Council, whenever choosing colors or fonts in a repo that depends on @nycc/design or councildown, and when writing R plots or leaflet maps with councildown. Triggers include "council style", "NYCC colors", "council palette", "make a chart/map/page for the council", Recharts/D3/Leaflet/MapLibre work in Council repos, and ggplot/leaflet work that uses councildown.
---

# NYC Council style

Council visuals must share the same styling whether they come from R
(councildown) or the web (`@nycc/design`). Both read from one set of design
tokens. Your job is to use those tokens, never to recreate them.

Match the Council styling (colors and palettes, fonts, chart chrome, map
defaults), not ggplot pixel for pixel. Use each web library's normal layout and
interactions, as long as the rules below hold.

## Hard rules

1. **Never hardcode a Council hex code or font name.** Import it.
   - TypeScript: `import { colors, palettes, fonts } from '@nycc/design'`
   - CSS: `@import '@nycc/design/tokens.css'` then `var(--nycc-color-dark-blue)`
   - Tailwind v4: `@import '@nycc/design/tailwind.css'` then `bg-nycc-maroon`, `font-heading`
   - R: councildown (`pal_nycc()`, `scale_fill_nycc()`, `theme_nycc()`)
2. **Never invent colors or use library defaults.** No Tailwind `blue-500`, no
   `d3.schemeCategory10`, no Recharts/Plotly/MUI default colors. Only Council
   colors and palettes.
3. **At most 7 colors** in any categorical scale or binned map. With more
   categories, group the smallest into "Other" or use a different chart.
4. **Fonts:** Georgia (`fonts.heading`) for headings and all chart text; Open Sans
   (`fonts.body`) for body and UI text. Georgia is a system font; load Open Sans
   (e.g. Google Fonts) if the project doesn't already.
5. **If `@nycc/design` isn't a dependency** in a web project, stop and tell the
   user before styling anything. Don't paste hex values in as a workaround. If the
   user explicitly OKs a stopgap, copy the whole generated `tokens.css` into the
   project rather than individual values.

## Picking a palette

| Data | Use | TS | R |
| --- | --- | --- | --- |
| Categories / series (≤ 7) | `main` (or `mixed`) | `categoricalColors(n)` | `scale_color_nycc()` / `scale_fill_nycc("main")` |
| 1 series | first `main` color | `categoricalColors(1)` | `pal_nycc("single")` |
| Ordered magnitude | `nycc_blue` (default), `cool`, `warm`, others | `palettes.nycc_blue` | `scale_fill_nycc("nycc_blue", discrete = FALSE)` |
| Choropleth map | `nycc_blue`, ≤ 7 bins | `colorBin(values)` | `colorBin("nycc_blue", domain)` |
| Above/below a meaningful midpoint | maroon ↔ grey ↔ dark blue | `colorDiverging(values, { mid })` | `colorDiverging(values, mid = …)` |
| Missing values | white on maps, medium grey in charts | `map.naFill` / `chart.naFill` | defaults already set |

- Use `categoricalColors` for categories in TS. It returns exact palette colors.
- Sequential palettes run light → dark; darker means more.
- Don't use the light end of a sequential palette for text.
- Color must not be the only cue: add labels, patterns or a legend.

## Detailed guidance

Read the file that matches the task:

- `references/tokens.md`: every token with its TS, CSS, Tailwind and R name
  (generated from the tokens, always current).
- `references/web-charts.md`: chart styling and library examples (Recharts, D3, etc.).
- `references/web-maps.md`: Leaflet / MapLibre maps, choropleths, district outlines.
- `references/r.md`: councildown functions for ggplot, leaflet and R Markdown.

## Before you finish

- Search your changes for `#` hex literals and raw font names. Replace any Council
  values with token imports.
- Check every categorical scale has ≤ 7 colors, and every map ≤ 7 bins.
- Check charts and maps have a title, a source/caption and a legend where needed.
