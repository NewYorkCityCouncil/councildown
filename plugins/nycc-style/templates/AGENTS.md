# AI agent instructions

This is an NYC Council project. Visual styling follows the Council design system.

**Before creating or changing any UI, chart, map, colors or fonts, read
`node_modules/@nycc/design/ai/nycc-style/SKILL.md`** and the files in its
`references/` folder that fit the task. They're the full rules and match the
installed version of `@nycc/design`. Tools that support Agent Skills can load
that folder as a skill.

Core rules, in case you can't read those files:

- Colors, palettes, fonts, and chart/map styles come from `@nycc/design`
  (TS: `import { colors, palettes, fonts, categoricalColors, colorBin } from '@nycc/design'`;
  CSS: `@nycc/design/tokens.css`; Tailwind: `@nycc/design/tailwind.css`).
- Never hardcode hex colors or font names, and never use a chart library's or
  Tailwind's default colors. Max 7 colors per categorical scale or map.
- Headings and chart text: Georgia (`fonts.heading`). Body/UI: Open Sans (`fonts.body`).
- Claude Code users can also install the `nycc-style` plugin
  (`/plugin marketplace add NewYorkCityCouncil/councildown`, then
  `/plugin install nycc-style@nycc`).
