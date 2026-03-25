# Reconstructed Change Log

This document is a reconstructed high-level changelog for the current Citadels TTS script compared to an early minimal version from years ago.

It is not a literal historical diff.

There is no git history, archived first-version script, or prior release notes in this workspace, so the notes below are inferred from the current feature set and structure.

## Added

- Support for `2-8` players.
- Scenario-based cast setup from rulebook-style character packages.
- Random cast generation.
- Manual rank-by-rank cast selection with validation rules.
- Rank 9 support and player-count-specific cast handling.
- Full 2021-era character roster support across all nine ranks, including:
  - `Witch`, `Magistrate`, `Spy`, `Blackmailer`
  - `Seer`, `Wizard`, `Emperor`, `Patrician`
  - `Abbot`, `Cardinal`, `Alchemist`, `Trader`
  - `Navigator`, `Scholar`, `Diplomat`, `Marshal`
  - `Artist`, `Tax Collector`
- All 30 unique districts in one master lookup table.
- Unique district setup modes:
  - scenario package
  - custom selection
  - all 30 uniques
  - randomized unique package
- Full setup UI with:
  - bot toggles
  - mode buttons
  - scenario descriptions
  - manual cast controls
  - unique district toggles
- Main in-game UI with:
  - turn info
  - resource buttons
  - ability buttons
  - auto-end toggle
  - debug toggle
  - bug report button
- End-game scoreboard UI and private score breakdown logs.
- Bot support for seated colors.
- Automatic bot takeover for players who leave or go spectator.

## Changed

- Moved from a simpler card/table script into a centralized rules engine driven by `Global.lua`.
- Standardized district handling through a single `DISTRICT_DATA` table instead of scattered card-specific logic.
- Upgraded setup from static/default cast behavior to configurable setup modes.
- Expanded unique district handling from basic presence to full rules, scoring, and UI support.
- Expanded turn handling to support modern rank variants, multi-step abilities, interrupted turns, and resume flows.
- Expanded scoring from simple district totals to full endgame bonus accounting.
- Added public-info AI heuristics for bluffing, target selection, and district valuation.
- Added physical table-state synchronization so coin, crown, district, and token movements match script state.

## Implemented Character Systems

- Assassination, theft, bewitching, spying, blackmail, and warrant placement.
- Hand manipulation effects for `Magician`, `Seer`, and `Wizard`.
- Crown-transfer effects for `King`, `Emperor`, and `Patrician`.
- Religious, trade, military, and special-economy rank abilities.
- `Architect`, `Navigator`, and `Scholar` extra-draw / extra-build flows.
- District seizure and swap effects for `Diplomat` and `Marshal`.
- `Artist` beautify system with attached gold markers.
- `Tax Collector` tax plate and collection flow.

## Implemented Unique District Systems

- `Museum` tucked-card scoring and transfer handling.
- `Framework` replacement-build flow.
- `Theater` character exchange flow.
- `Armory` self-sacrifice destruction flow.
- `Necropolis` sacrifice-to-build flow.
- `Monument`, `Basilica`, `Map Room`, `Imperial Treasury`, `Wishing Well`, `Haunted Quarter`, `Secret Vault`, and other endgame-scoring uniques.
- `Poor House`, `Gold Mine`, `Treasury`, `Laboratory`, `Smithy`, and other per-turn/passive unique behaviors.

## Bot Improvements

- Bot draft participation.
- Bot gather/build/ability sequencing.
- Public-info target scoring for bluff and attack characters.
- Fair Theater targeting based on public information instead of hidden ownership.
- Bot handling for Witch resume turns, blackmail, warrants, and unique district abilities.
- Bot build heuristics that consider city state, cost, income, and timing.

## Reliability And Quality Improvements

- Debug logging mode for test sessions.
- Auto-end-turn support when no legal actions remain.
- Deck GUID recovery when the district deck is rebuilt or relocated.
- Score announcements and UI refresh helpers.
- Gold recount correction logic when physical coins and logged gold drift apart.
- Physical city-slot placement helpers for districts added, removed, swapped, seized, or confiscated.
- Recovery logic for district cards accidentally merged into stacks/decks near a city.
- Turn-advance and round-end guards to prevent duplicate end-turn or duplicate round-start transitions.

## Scoring And Endgame Improvements

- Full base district scoring.
- Completion bonuses for completed cities and first completed city.
- Bonus scoring for:
  - `Dragon Gate`
  - `Ivory Tower`
  - `Wishing Well`
  - `Imperial Treasury`
  - `Map Room`
  - `Museum`
  - `Monument`
  - `Statue`
  - `Capitol`
  - `Secret Vault`
  - `Basilica`
  - `Haunted Quarter`
  - `Artist` beautification
- Tie handling based on latest revealed character rank.

## Recent Fixes

- Fixed Theater so exchanged character cards physically move with the hidden ownership state.
- Fixed duplicate end-turn and duplicate round-start transitions caused by queued auto-end logic.
- Fixed city completion counting so state cannot claim a completed city when fewer visible districts are actually present.
- Fixed district transfer/build placement so moved or newly built cards do not stack on top of existing city cards by mistake.
- Fixed bot `Tax Collector` double-paying itself from both the tax plate and spawned bank gold.
- Fixed bot `Framework` replacement handling so the replacement district leaves the hand and the old `Framework` card is removed cleanly.
- Fixed several district cost mismatches in script/UI data, including `Observatory`, `Gold Mine`, and `Poor House`.
- Fixed corrupted Unicode UI text and removed Lua BOM issues that broke TTS parsing.

## Notes

- If you ever recover the original first-version script, this reconstructed file can be replaced with a true historical changelog.
- The current script is much closer to a full-featured mod rules engine than an early one-off automation script.
