# Citadels TTS — Improvements Changelog

**Date:** 2026-09-11 → 2026-09-13 (Workshop publish)  
**Source edited:** `scripts/lua_0.lua`  
**Deliverable:** `Global.lua` (copy of fixed script)

## Fixes applied

### HIGH — Host / blackmail chat commands gated behind TURN
- `onChat` previously returned immediately when `G.phase ~= 'TURN'`, so host `!reset` / `!skip` / `!state` never ran in SELECTION (dead `!skip` SELECTION branch). Blackmail `!flip` / `!pass` were also after that gate (and after the current-player check).
- Restructured: host commands first (any phase, `player.host`); then blackmail `!flip`/`!pass` (any phase, blackmailer-gated); then TURN + current-player gate for `!emperor` / `!beautify` only.

### HIGH — Spectator → bot takeover typo
- In `onPlayerChangeColor`, corrected `G.playersa` → `G.players`.
- Without this, leaving a seat to Grey (spectator) errored on `ipairs(nil)` and never called `botTakeover`.

### MEDIUM — Bot AI Tax Collector GUID case
- Replaced `GUID.taxCollector` with `GUID.taxcollector` at 4 bot-AI sites (bluff groups + score branches).
- Matches the GUID table key and the human/execute paths. Bots now classify/score Tax Collector correctly.

### LOW — Bug-report crown dump
- `onBtnBugReport` now reports `G.players[G.crownIndex]` instead of unset `G.crownColor`.

### HIGH — Main-chunk 200-local limit (`luac5.4 -p`)
- Late bot-AI helpers (`botBestBlackmailerTargets` … `botTakeover`, including `botDoTurn`) are wrapped in an IIFE `;(function() … end)()`.
- Note: a plain `do … end` does **not** help — locals still count toward the enclosing function’s 200-slot limit. A nested function scope is required.
- `botTakeover` is a global function (callable from `onPlayerChangeColor` / `onPlayerDisconnect`); internal bot helpers remain locals inside the IIFE.
- `luac5.4 -p Global.lua` exits 0.

### MEDIUM — Artist beautify picker (>8 districts)
- Added `refreshArtistPickButtons()` with simple pagination:
  - ≤8 unbeautified districts: same 8-button UI as before.
  - >8: page size 6 on buttons 1–6; buttons 7/8 are Prev/Next.
- Both Artist ability entry points use the helper; `handleRankPick` (`artist_beautify`) maps button index through `G.artistPickPage`.
- Chat fallback: `!beautify <n>` (1-based index into the sorted unbeautified list; lists names if invalid).

## Skipped / remaining

### MEDIUM — `onSave` / mid-game `onLoad` restore
- **Skipped** for this pass (per request): full serialize of `G` mid-game is large and risky (phase, gold, cast, warrants, museum piles, physical card sync).
- `onLoad` still only builds UI / captures reset homes.
- **Remaining work:** selective JSON save of critical `G` fields + careful restore if mid-game reload matters.

### LOW — Abbot income split UI capped at 0–7 gold
- Not in this fix list; left unchanged.

## Verification
- `luac5.4 -p Global.lua` → exit 0
- No remaining `G.playersa` or `GUID.taxCollector` in code

## Turn timer option (2026-09-12)
- New sidebar toggle: **⏱ Turn Timer** (off by default).
- Duration buttons: **30s / 60s / 90s / 2m** (default 60s).
- When enabled, humans get a countdown on:
  - character **selection**
  - their **turn**
- Countdown shown in `txtTurnTimer` (turns red at ≤10s; private nags at 10s and 5s).
- On expiry: selection auto-picks via `botDoSelection`; turns auto-end (same idea as `!skip`).
- Bots are not timed. Timer clears on confirm / end-turn / round boundaries.

## Timer gold + Workshop reload button (2026-09-12)
- Turn timer expiry on a **turn**: if the player has not gathered yet, auto-take **2 gold** (Gold Mine passive applies), then end the turn.
- End-game scoreboard: host button **↻ Reload Workshop Mod** — TTS cannot load Workshop by ID from Lua, so it broadcasts the Games → Workshop path for Citadels (Scripted setup) id `2186767639` and writes a Notebook tab.

## Spectator → bot takeover fix (2026-09-12)
- Root cause: `onPlayerChangeColor` used the wrong signature. TTS passes a single `player_color` string; the handler expected `(player_object, new_color)` and always returned early.
- Now correctly treats `"Grey"` as spectator/disconnect, diffs empty seats vs `G.players`, promotes them to bots, and resumes if that seat was mid-selection/turn.

## Human sits on bot color (2026-09-12)
- Choosing a bot seat now deactivates that bot (`humanTakeover`) and syncs both bot toggles off.
- Works in setup and mid-game; if that seat is mid selection/turn, control returns to the human (timer restarts if enabled).
- `botDoTurn` bails if the seat is no longer a bot (stops a queued bot action after claim).
- `onPlayerChangeColor` now handles non-Grey sits as well as Grey spectator/disconnect.

## Wizard return-to-hand fix (2026-09-12)
- Root cause: borrowed district cards were only returned when pressing Ability2 **Done**. End Turn, timer auto-end, and `advanceTurn` cleared `wizardBorrowed*` without moving cards back, leaving them on the table.
- Added shared `returnWizardCards()` (keeps any card already in the Wizard's hand; returns the rest to the target hand zone).
- Called from Done, `onBtnEnd`, `botEndTurn`, timer TURN expiry, and as a safety net at the start of `advanceTurn` (before `currentColor` flips).
- Tracks `G.wizardBorrower` so keep/return logic stays correct across turn advance.

## Reset Table restores setup assets (2026-09-12)
- Soft reset now: release hands → restore districts/uniques to home decks → reseat known character cards/tokens → return loose gold → second pass after settle.
- Captures home positions for crown, decks, bags, and setup board too.
- Note: TTS cannot resurrect objects that were truly `destruct()`'d; Workshop reload is still the factory-fresh path.

## Player feedback → GitHub Issues (2026-09-12)
- In-game **🐛 Bug** / **💡 Feature** buttons dump state to chat + Notebook tab `Citadels Feedback` and print the GitHub new-issue URL.
- Repo: https://github.com/naveedster/Citadels-TTS — templates + labels `needs-triage` / `approved` / `denied` / `player-report`.
- No API tokens in the script; filing happens in the player's browser.

## Notebook Feedback tab fix (2026-09-13)
- Root cause: used non-existent `Notes.setNotebookTabs` (pcall swallowed the error).
- Now uses `Notes.getNotebookTabs` + `editNotebookTab` / `addNotebookTab` via `upsertNotebookTab`.
- Same fix for the Reload Workshop notebook reminder.


## Workshop publish (2026-09-13)
- Updated Steam Workshop item **Citadels (Scripted setup)** id `2186767639` from a clean SETUP table.
- URL: https://steamcommunity.com/sharedfiles/filedetails/?id=2186767639
- Includes all fixes above through the Notebook Feedback tab fix.
