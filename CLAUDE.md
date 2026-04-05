# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

screenshot-clip is a macOS-only shell utility that automatically copies screenshots to the clipboard using `fswatch` + `osascript`. Distributed via Homebrew.

## Architecture

Three shell scripts, no build step:

- **`bin/screenshot-clip`** — Main loop. Uses `fswatch` to watch a directory for new `.png` files, then copies each to the clipboard via `osascript`. Configured via `SCREENSHOT_CLIP_DIR` (default `~/Desktop`) and `SCREENSHOT_CLIP_DELAY` (default `0.1s`).
- **`bin/screenshot-clip-install`** — Generates and loads a macOS `launchd` plist (`~/Library/LaunchAgents/com.screenshotclip.agent.plist`) so the watcher runs at login. Accepts an optional directory argument.
- **`bin/screenshot-clip-uninstall`** — Unloads and removes the launchd plist.
- **`Formula/screenshot-clip.rb`** — Homebrew formula (tap: `TheLoneWulf-WA/tools`). Depends on `fswatch`. The `sha256` is currently empty (not yet released).

## Development

All scripts are zsh. No tests, no linter, no build system. To test locally:

```bash
# Run the watcher directly
SCREENSHOT_CLIP_DIR=~/Desktop ./bin/screenshot-clip

# Install/uninstall the launchd agent
./bin/screenshot-clip-install [optional-dir]
./bin/screenshot-clip-uninstall
```

Logs go to `/tmp/screenshot-clip.log`, errors to `/tmp/screenshot-clip.err`.

## Key Constraints

- macOS only — relies on `osascript`, `launchctl`, and `fswatch`
- Only handles `.png` files
- The Homebrew formula sha256 is a placeholder awaiting first release
