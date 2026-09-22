# AI agent instructions

This is an NYC Council project. Visual styling follows the Council design system.

- Colors, palettes, fonts, and chart/map styles come from `@nycc/design`
  (TS: `import { colors, palettes, fonts, categoricalColors, colorBin } from '@nycc/design'`;
  CSS: `@nycc/design/tokens.css`; Tailwind: `@nycc/design/tailwind.css`).
- Never hardcode hex colors or font names, and never use a chart library's or
  Tailwind's default colors. Max 7 colors per categorical scale or map.
- Headings and chart text: Georgia (`fonts.heading`). Body/UI: Open Sans (`fonts.body`).
- Claude Code: the `nycc-style` skill has the full rules
  (`/plugin marketplace add NewYorkCityCouncil/councildown`, then
  `/plugin install nycc-style@nycc`).
