# Git Cheat Sheet

This project now uses:

- Local repo: `C:\Users\navee\Documents\Citadels VS Code script TTS`
- Branch: `main`
- GitHub remote: `origin`

## Normal workflow

Check what changed:

```powershell
git status
git diff
```

Save your work:

```powershell
git add .
git commit -m "Describe the change"
git push
```

## Good commit message examples

```powershell
git commit -m "Fix warlord targeting only built city districts"
git commit -m "Add git cheat sheet"
git commit -m "Adjust reset button behavior"
```

## Before risky changes

Make a branch:

```powershell
git checkout -b fix-reset-button
```

Push that branch:

```powershell
git push -u origin fix-reset-button
```

Return to `main` later:

```powershell
git checkout main
```

## See history

```powershell
git log --oneline
```

See what changed in the last commit:

```powershell
git show
```

## If you want to undo something

Discard changes in one file that are not committed yet:

```powershell
git restore .tts/objects/Global.lua
```

Discard all uncommitted changes:

```powershell
git restore .
```

Unstage files after `git add .`:

```powershell
git restore --staged .
```

## Save a checkpoint

Make a tag for an important version:

```powershell
git tag stable-reset-attempt
git push origin stable-reset-attempt
```

## Get the latest from GitHub

```powershell
git pull
```

## Current GitHub repo

```powershell
git remote -v
```

Expected remote:

```text
origin  https://github.com/naveedster/Citadels-TTS.git
```

## Simple routine for this project

1. Run `git status`
2. Test the mod
3. Run `git add .`
4. Run `git commit -m "Short message"`
5. Run `git push`

## Safety note

Avoid destructive commands like:

```powershell
git reset --hard
```

Use `git restore` unless you are very sure.
