# @nycc/design

NYC Council design system for the web. One source of truth for Council colors,
palettes, fonts and chart/map styling, shared with councildown (R).

Web charts don't try to reproduce ggplot output exactly. What must match R is the
Council styling: colors and palettes, fonts, chart chrome and map defaults
(see the `nycc-style` skill for the rules). The helpers here are ordinary web
implementations that follow those rules.

## Use it on a new site

How the pieces fit: the **tokens** (`tokens/`) hold the Council styling copied
from councildown, **`@nycc/design`** carries them into React/TypeScript, and the
**`nycc-style` skill** (via `AGENTS.md`) tells AI tools to use the package
instead of making up colors and fonts.

1. **Install the package.** It isn't published yet, so pack it and install the file:

   ```sh
   cd councildown/design-tokens
   npm install && npm run build
   npm pack                                  # creates nycc-design-0.1.0.tgz
   cd path/to/your-site
   npm install path/to/nycc-design-0.1.0.tgz
   ```

2. **Add the AI rules.** Copy `AGENTS.md` and `CLAUDE.md` from
   `plugins/nycc-style/templates/` into the site's root. They point AI tools to
   the skill inside `node_modules/@nycc/design/ai/`. Claude Code users can also
   install the `nycc-style` plugin.

3. **Ask the AI for the site in plain terms** (e.g. "build a page with these
   three charts"). The rules tell it to import `@nycc/design/tokens.css` or the
   Tailwind theme, take chart colors from `palettes` / `categoricalColors` /
   `colorBin` / `colorDiverging`, and follow the Council chart and map styling.

4. **Get the plots onto the page**, one of two ways:
   - **Redraw them in React (recommended).** R or Python exports only the data
     (CSV, GeoJSON); the site draws the charts (e.g. Recharts, react-leaflet)
     with `@nycc/design`. Interactive, consistent with the rest of the site, and
     it doesn't matter whether R or Python made the data.
   - **Embed finished R output.** Save ggplot as PNG/SVG and leaflet as HTML,
     then show them with `<img>` / `<iframe>`. They're already styled by
     councildown. Plots drawn in Python can't be embedded this way yet, since
     there's no Python equivalent of councildown.

Not covered yet:

- **Page text sizes.** The tokens only have chart font sizes (from
  `theme_nycc()`). Body and page heading sizes aren't defined, since councildown
  doesn't define them.
- **Visuals drawn in Python** (Plotly, matplotlib, Dash or Folium output). No
  Python version of the tokens and no Python guidance in the skill; use
  `tokens.json` for the values. Python that only prepares data is fine (step 4).

## Use it

```ts
import { colors, fonts, palettes, categoricalColors, colorBin, colorDiverging } from '@nycc/design';

colors.nyccBlue;                  // "#2F56A6"
fonts.heading;                    // "Georgia, serif"
palettes.warm;                    // 7 colors, light -> dark

categoricalColors(3);             // first 3 of "main": one color per series (max 7)

const fill = colorBin(values, { palette: 'nycc_blue' }); // like councildown::colorBin()
fill(42);                         // hex color
fill.breaks; fill.colors;         // for legends

const div = colorDiverging(values);  // like councildown::colorDiverging(), centered on the median
div(12);
```

CSS variables:

```css
@import '@nycc/design/tokens.css';
h1 { font-family: var(--nycc-font-heading); color: var(--nycc-color-dark-blue); }
```

Tailwind v4:

```css
@import 'tailwindcss';
@import '@nycc/design/tailwind.css';
/* bg-nycc-maroon, text-nycc-dark-blue, fill-nycc-warm-3, font-heading, font-body */
```

Plain values: `@nycc/design/tokens.json`.

AI rules: the package includes the `nycc-style` skill at
`node_modules/@nycc/design/ai/nycc-style/` (`SKILL.md` + `references/`). Point
your AI tool at it; see `plugins/nycc-style/templates/AGENTS.md`.

## R ↔ TypeScript

| councildown (R)          | @nycc/design (TS)                      |
| ------------------------ | -------------------------------------- |
| `nycc_colors`            | `colors` (camelCase keys)              |
| `nycc_palettes`          | `palettes`, `paletteKinds`             |
| `pal_nycc(p, reverse)`   | `getPalette(p, { reverse })`           |
| `scale_color_nycc()` (discrete) | `categoricalColors(n)`          |
| `colorBin(...)`          | `colorBin(domain, { palette, bins })`  |
| `colorDiverging(...)`    | `colorDiverging(domain, { low, mid, high, colorLow, ... })` |

Same palettes, defaults and limits (max 7 colors / bins). The exact bin breaks
and in-between colors can differ from R; see "Differences from R".

## Layout

```
tokens/             # SOURCE: edit these (W3C Design Tokens format)
build.mjs           # Style Dictionary: tokens -> generated/ and src/generated/
src/                # palette + scale helpers
test/               # unit tests
scripts/            # check that tokens match R/colors.R
generated/          # GENERATED: css/, tailwind/, json/, r/
                    # also writes ../plugins/nycc-style/skills/nycc-style/references/tokens.md (committed)
dist/               # GENERATED: bundled JS + types
ai/                 # GENERATED: copy of plugins/nycc-style/skills/nycc-style/ for the package
```

## Develop

```sh
npm install
npm run build        # tokens + bundle
npm test             # unit tests
npm run typecheck
npm run check:r      # generated/r/tokens.R matches R/colors.R
npm run check:skill  # committed skill token reference is up to date
```

CI (`.github/workflows/design-tokens.yaml`) runs all of these, plus
`claude plugin validate`, on every PR that touches `design-tokens/`, `plugins/`,
`.claude-plugin/` or `R/`.

To change a color or palette, edit `tokens/`, then `npm run build` and commit
the regenerated skill reference in `plugins/nycc-style/`. Until
councildown reads `generated/r/tokens.R` directly, also update `R/colors.R` and
run `npm run check:r`.

## Differences from R

- **Categorical colors.** R's discrete ggplot scales call `colorRampPalette`, so
  5 or 6 categories get blended colors that aren't in the palette (e.g.
  `#69778C` for `main`, n = 5). `categoricalColors` always uses exact palette
  colors.
- **Binned maps.** `colorBin` uses exact palette steps (evenly spaced, light to
  dark); leaflet interpolates between them when there are fewer than 7 bins.
  Break points are rounded with d3 and can differ slightly from R's `pretty()`.
  Explicit 8 break points (7 bins) are allowed; R's `colorBin` rejects them.
- Chart font sizes are in points (ggplot); map sizes are in px.
- `div2` from `R/colors.R` isn't in `nycc_palettes`, so it's not included.
