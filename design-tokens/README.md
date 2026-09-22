# NYC Council design tokens

Single source of truth for Council colors, palettes, fonts, and chart/map styling.
The same values feed councildown (R) and our React/TypeScript web projects.

## Layout

```
tokens/          # SOURCE — edit these (W3C Design Tokens format)
  color.json     # core colors (nycc_colors)
  palette.json   # named 7-step palettes (nycc_palettes)
  font.json      # typefaces
  chart.json     # chart rules (theme_nycc, scale_*_nycc)
  map.json       # leaflet map rules (addCouncilStyle, addSourceText, colorBin)
build.mjs        # Style Dictionary config + custom formats
dist/            # GENERATED — do not edit
  css/tokens.css # CSS custom properties, e.g. var(--nycc-color-nycc-blue)
  ts/tokens.ts   # colors, palettes, fonts, chart, map, paletteKinds
  json/tokens.json
  r/tokens.R     # nycc_colors, nycc_palettes, nycc_fonts, nycc_chart, nycc_map
```

## Usage

```sh
npm install
npm run build     # regenerate dist/
npm run check:r   # confirm dist/r/tokens.R matches R/colors.R
```

## Changing a color or palette

1. Edit the JSON in `tokens/`.
2. `npm run build`.
3. Until councildown reads `dist/r/tokens.R` directly, also update `R/colors.R`
   and run `npm run check:r` to confirm the two agree.

## Notes

- Palettes have at most 7 colors. Sequential palettes go light → dark; categorical
  palettes are listed in assignment order. `paletteKinds` says which is which.
- `div2` in `R/colors.R` isn't in `nycc_palettes`, so it's not included here.
- Chart font sizes are in points (ggplot); map sizes are in px.
