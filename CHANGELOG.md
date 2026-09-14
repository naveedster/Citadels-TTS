# Changelog — Citadels (Scripted setup)

Steam Workshop: [Citadels (Scripted setup)](https://steamcommunity.com/sharedfiles/filedetails/?id=2186767639) (`2186767639`)

## 2026-09-13 — Workshop update

Published the scripted improvements below to the Workshop item from a clean SETUP table.

### Fixes & features in this release

- **Turn timer** — optional countdown for human selection/turns (30s–2m); on turn expiry auto-takes 2g if needed then ends turn; selection auto-picks.
- **Spectator → bot** — `onPlayerChangeColor` uses the correct single-color signature; empty seats promote to bots and resume mid-action.
- **Human claims bot seat** — sitting on a bot color deactivates that bot and returns control.
- **Wizard** — borrowed hand cards return on Done, End Turn, timer expiry, and turn advance (not only Done).
- **Reset Table** — releases hands, restores districts/uniques to home decks, reseats characters/tokens, returns loose gold (two passes). Truly destroyed objects still need Workshop reload.
- **Feedback** — in-game Bug / Feature buttons draft to Notebook + chat with GitHub Issues links ([naveedster/Citadels-TTS](https://github.com/naveedster/Citadels-TTS)).
- **Notebook tabs** — use `addNotebookTab` / `editNotebookTab` (fixed non-existent `setNotebookTabs`).
- **Reload Workshop** host button + Notebook guide for a factory-fresh load.
- Earlier static fixes: `!skip`/`!state` outside TURN, Tax Collector GUID case, Artist pagination, 200-local IIFE for bot AI, crown dump in bug report.

### Triage labels on GitHub Issues

`needs-triage` → `approved` / `denied` (+ `player-report`)

### Detailed engineering notes

See [CHANGELOG_IMPROVEMENTS.md](CHANGELOG_IMPROVEMENTS.md).
