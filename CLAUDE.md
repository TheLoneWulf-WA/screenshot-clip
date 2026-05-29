# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

screenshot-clip is a macOS-only shell utility that automatically copies screenshots to the clipboard using `fswatch` + `osascript`. Distributed via Homebrew.

## Architecture

Three shell scripts, no build step:

- **`bin/screenshot-clip`.** Main loop. Uses `fswatch` to watch a directory for new `.png` files, then copies each to the clipboard via `osascript`. Skips hidden files (macOS creates temp `.Screenshot` files before renaming to the final name). Waits for the file to finish writing by polling `stat -f %z` every 50ms until the size is stable across two consecutive reads (capped by `SCREENSHOT_CLIP_DELAY`, default `2.0s`). Dedups multiple fswatch fires for the same screenshot by `filename + mtime` so a single screenshot only triggers one clipboard copy. Configured via `SCREENSHOT_CLIP_DIR` (default `~/Desktop`) and `SCREENSHOT_CLIP_DELAY` (max wait timeout).
- **`bin/screenshot-clip-install`.** Generates and loads a macOS `launchd` plist (`~/Library/LaunchAgents/com.screenshotclip.agent.plist`) so the watcher runs at login. Accepts an optional directory argument. Sets PATH in the plist so `fswatch` is found by launchd.
- **`bin/screenshot-clip-uninstall`.** Unloads and removes the launchd plist.
- **`Formula/screenshot-clip.rb`.** Homebrew formula (tap: `TheLoneWulf-WA/tools`). Depends on `fswatch`.

## Distribution

Two repos work together:

- **`screenshot-clip`.** This repo, the source code.
- **`homebrew-tools`.** The Homebrew tap repo (`TheLoneWulf-WA/homebrew-tools`) that holds the formula. Must be updated whenever a new release is cut.

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

- macOS only. Relies on `osascript`, `launchctl`, and `fswatch`.
- Only handles `.png` files.
- Must skip hidden (dot) files. macOS writes screenshots as hidden temp files first, then renames.
- `fswatch` must not use `--event Created`. The rename from temp file doesn't trigger a Created event.
- **macOS floating thumbnail delays disk write by ~5 seconds.** When the floating screenshot thumbnail is enabled (default in macOS Mojave+), the OS holds the screenshot in memory and only writes the file to disk after the thumbnail dismisses (timeout or user click). This is the dominant source of perceived latency. The script itself runs in ~100ms once the file lands. Users who want instant clipboard updates need to disable the thumbnail (`Cmd+Shift+5` → Options → uncheck "Show Floating Thumbnail") or click it to dismiss on demand. This is documented in the README under "Still feels slow?".

## Writing conventions

- **No em dashes** (the "—" character) in user-facing content: README, release notes, commit messages, posts, marketing copy, code comments. Use periods, colons, commas, semicolons, or parentheses instead. Em dashes are a widely recognized AI writing tell, and this project's voice avoids them. Hyphens in compound words (auto-copy, macOS, screenshot-clip) and en dashes in numeric ranges (~3–5 seconds) are fine and stay.
- Prefer short, conversational prose over marketing language. The existing README sets the tone.
