# @nycc/design

NYC Council design system for the web. One source of truth for Council colors,
palettes, fonts and chart/map styling, shared with councildown (R). The palette
and scale helpers are ports of the councildown functions and are tested against
their R output.

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
| `scale_nycc(p)(n)`       | `rampPalette(p, n)`                    |
| `colorBin(...)`          | `colorBin(domain, { palette, bins })`  |
| `colorDiverging(...)`    | `colorDiverging(domain, { low, mid, high, colorLow, ... })` |
| `pretty(x, n)`           | `pretty(x, n)`                         |

`categoricalColors(n)` has no R equivalent. See "Known differences".

## Layout

```
tokens/             # SOURCE: edit these (W3C Design Tokens format)
build.mjs           # Style Dictionary: tokens -> generated/ and src/generated/
src/                # palette + scale helpers
test/               # unit tests + R parity tests (fixtures/r-reference.json)
scripts/            # R parity check and fixture generator
generated/          # GENERATED: css/, tailwind/, json/, r/
                    # also writes ../plugins/nycc-style/skills/nycc-style/references/tokens.md (committed)
dist/               # GENERATED: bundled JS + types
ai/                 # GENERATED: copy of plugins/nycc-style/skills/nycc-style/ for the package
```

## Develop

```sh
npm install
npm run build        # tokens + bundle
npm test             # unit + R parity tests
npm run typecheck
npm run check:r      # generated/r/tokens.R matches R/colors.R
npm run check:skill  # committed skill token reference is up to date
npm run fixtures:r   # regenerate R reference outputs (needs R + leaflet)
```

To change a color or palette, edit `tokens/`, then `npm run build` and commit
the regenerated skill reference in `plugins/nycc-style/`. Until
councildown reads `generated/r/tokens.R` directly, also update `R/colors.R` and
run `npm run check:r` and `npm run fixtures:r && npm test`.

## Known differences from R

- **Categorical colors.** R's discrete ggplot scales call `colorRampPalette`, so
  5 or 6 categories get blended colors that aren't in the palette (e.g.
  `#69778C` for `main`, n = 5). `rampPalette` reproduces that;
  `categoricalColors` takes the first n palette colors instead.
- Lab-space colors can differ from R by 1-2 per RGB channel (different Lab
  conversions). Tests allow that.
- Chart font sizes are in points (ggplot); map sizes are in px.
- `div2` from `R/colors.R` isn't in `nycc_palettes`, so it's not included.
