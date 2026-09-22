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

Copy `templates/AGENTS.md` into the root of each web repo (Cursor, Copilot and
Codex read it), and `templates/CLAUDE.md` next to it (it imports `AGENTS.md`
so Claude Code picks it up too).

## Editing

- `skills/nycc-style/SKILL.md` and `references/*.md` except `tokens.md`: edit by hand.
- `references/tokens.md` is generated from `design-tokens/tokens/`. Run
  `npm run build` in `design-tokens/` after changing tokens, and commit the result.
- Bump `version` in `.claude-plugin/plugin.json` when you change the skill so
  installs pick up the update.
