# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

screenshot-clip is a macOS-only shell utility that automatically copies screenshots to the clipboard using `fswatch` + `osascript`. Distributed via Homebrew.

## Architecture

Three shell scripts, no build step:

- **`bin/screenshot-clip`** — Main loop. Uses `fswatch` to watch a directory for new `.png` files, then copies each to the clipboard via `osascript`. Skips hidden files (macOS creates temp `.Screenshot` files before renaming to the final name). Configured via `SCREENSHOT_CLIP_DIR` (default `~/Desktop`) and `SCREENSHOT_CLIP_DELAY` (default `0.3s`).
- **`bin/screenshot-clip-install`** — Generates and loads a macOS `launchd` plist (`~/Library/LaunchAgents/com.screenshotclip.agent.plist`) so the watcher runs at login. Accepts an optional directory argument. Sets PATH in the plist so `fswatch` is found by launchd.
- **`bin/screenshot-clip-uninstall`** — Unloads and removes the launchd plist.
- **`Formula/screenshot-clip.rb`** — Homebrew formula (tap: `TheLoneWulf-WA/tools`). Depends on `fswatch`.

## Distribution

Two repos work together:

- **`screenshot-clip`** — this repo, the source code
- **`homebrew-tools`** — the Homebrew tap repo (`TheLoneWulf-WA/homebrew-tools`) that holds the formula. Must be updated whenever a new release is cut.

### Release process

1. Push changes to `main`
2. Create a GitHub release with a new tag (e.g. `gh release create v1.0.3`)
3. Get the sha256 of the new tarball: `curl -sL https://github.com/TheLoneWulf-WA/screenshot-clip/archive/refs/tags/<tag>.tar.gz | shasum -a 256`
4. Update `Formula/screenshot-clip.rb` with the new tag URL and sha256 in both this repo and `homebrew-tools`
5. Push both repos

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
- Must skip hidden (dot) files — macOS writes screenshots as hidden temp files first, then renames
- `fswatch` must not use `--event Created` — the rename from temp file doesn't trigger a Created event
