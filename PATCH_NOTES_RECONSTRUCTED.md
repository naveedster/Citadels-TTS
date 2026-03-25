# Reconstructed Patch Notes

This is a shorter, player-facing summary of how the current script has evolved from an early version.

It is reconstructed from the current project state, not from a preserved historical diff.

## Major Upgrades

- Expanded from a simpler script into a full Citadels rules engine for Tabletop Simulator.
- Added support for `2-8` players.
- Added scenario, random, and manual cast setup modes.
- Added support for all 30 unique districts.
- Added modern rank variants across all nine ranks.

## New Gameplay Support

- Implemented newer characters like `Witch`, `Magistrate`, `Spy`, `Blackmailer`, `Seer`, `Wizard`, `Emperor`, `Patrician`, `Abbot`, `Cardinal`, `Alchemist`, `Trader`, `Navigator`, `Scholar`, `Diplomat`, `Marshal`, `Artist`, and `Tax Collector`.
- Added full support for complex unique districts like `Framework`, `Theater`, `Museum`, `Armory`, `Necropolis`, `Monument`, `Map Room`, `Wishing Well`, `Imperial Treasury`, `Haunted Quarter`, and `Secret Vault`.
- Added endgame bonus scoring for uniques, completion bonuses, beautification, tucked cards, hand scoring, and gold scoring.

## User Experience Improvements

- Added a full setup UI for cast selection and unique district setup.
- Added a main in-game control panel for turns, resource actions, and abilities.
- Added debug logging and bug-report tools for testing.
- Added auto-end-turn support when no legal actions remain.
- Added a scoreboard panel and detailed endgame score breakdowns.

## Bot Improvements

- Added computer-player support for all seated colors.
- Added bot drafting, gathering, building, and character ability use.
- Added smarter bot logic for bluffing, target choice, and district evaluation.
- Added spectator/disconnect bot takeover.

## Table Automation Improvements

- Added physical handling for:
  - crown movement
  - gold bowl and tax plate management
  - district placement in city rows
  - district transfers, swaps, confiscations, and seizures
  - beautify coin attachment
  - museum tucked cards

## Recent Fixes

- Fixed Theater so swapped character cards move physically instead of only changing hidden ownership.
- Fixed duplicate end-turn and duplicate round-start transitions.
- Fixed city completion tracking when districts are replaced, destroyed, seized, or swapped.
- Fixed district placement so cards do not accidentally stack on top of other built districts.
- Fixed bot Tax Collector double-paying itself.
- Fixed bot Framework replacement builds leaving the new district in hand or failing to remove Framework properly.
- Fixed several district cost and tooltip mismatches, including `Observatory`, `Gold Mine`, and `Poor House`.
- Fixed corrupted Unicode UI text and Lua BOM parsing issues.

## Current State

The script now behaves more like a full-featured Citadels mod than a lightweight early automation script.
