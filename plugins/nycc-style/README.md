# nycc-style (Claude Code plugin)

Teaches Claude the NYC Council style rules: colors, palettes, fonts, chart and
map styling, for web (`@nycc/design`) and R (councildown).

## Install

In Claude Code:

```
/plugin marketplace add NewYorkCityCouncil/councildown
/plugin install nycc-style@nycc
```

To install it for everyone working in a repo, add this to the repo's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "nycc": { "source": { "source": "github", "repo": "NewYorkCityCouncil/councildown" } }
  },
  "enabledPlugins": { "nycc-style@nycc": true }
}
```

## Other AI tools

The same skill ships inside the `@nycc/design` npm package at
`node_modules/@nycc/design/ai/nycc-style/`, so every web repo that installs the
package has the full rules, matching its installed version, whatever AI tool
people use.

- Copy `templates/AGENTS.md` into the root of each web repo (Codex, Cursor,
  Copilot and most coding agents read it). It points agents to the packaged skill
  and repeats the core rules as a fallback.
- Copy `templates/CLAUDE.md` next to it. It imports `AGENTS.md` so Claude Code
  picks it up too.
- Tools that support the Agent Skills format can also load
  `node_modules/@nycc/design/ai/nycc-style/` as a skill directly. Check the
  tool's docs for which folder it reads skills from.

## Editing

- `skills/nycc-style/SKILL.md` and `references/*.md` except `tokens.md`: edit by hand.
- `references/tokens.md` is generated from `design-tokens/tokens/`. Run
  `npm run build` in `design-tokens/` after changing tokens, and commit the result.
- `design-tokens/ai/nycc-style/` is a build-time copy for the npm package. Don't
  edit it; it's gitignored and overwritten on every build.
- Bump `version` in `.claude-plugin/plugin.json` when you change the skill so
  installs pick up the update.
