# screenshot-clip

Auto-copy screenshots to your clipboard. Instantly.

Take a screenshot, paste it anywhere. No extra steps.

## The problem

You screenshot something — a design on Dribbble, a bug on a live site, a UI pattern, an error message. On macOS, that screenshot lands as a file on your Desktop. To actually use it, you need to find the file, click on it, `Cmd + C` to copy, then `Cmd + V` to paste where you need it. It's not hard — but it's extra steps, and when you're screenshotting dozens of times a day, those steps add up.

screenshot-clip eliminates the middle. The moment a screenshot is taken, it's on your clipboard. Just paste.

This friction compounds depending on how you work:

**With AI agents:** You're screenshotting reference material to feed into Claude Code, Cursor, or Copilot. A design you want replicated, an error you want debugged, a UI you want built. The screenshot-find-copy-paste loop happens constantly. Tools like Playwright and Chrome DevTools MCP can already see what's in your editor or browser — but when you want to show the agent something from *another* screen, a different app, or a physical reference, you need to screenshot it and bring it in yourself. That's where this comes in.

**With clipboard managers like Raycast:** This is where the workflow gets powerful. Take several screenshots in a row — a design, some reference text, an error — knowing each one is automatically copied to your clipboard. They all stack up in your clipboard history. Then pull them out one by one, pasting each exactly where it's needed. No file hunting, no interruption, just screenshot and keep moving.

**Across Apple ecosystem:** macOS screenshots land on your Desktop as files. With screenshot-clip, they also land on your clipboard instantly. Paste into iMessage, AirDrop context to your iPhone, drop it into Notes — the image is ready the moment you capture it.

screenshot-clip removes the middle steps. Screenshot, paste. That's it.

## Install

```bash
brew tap TheLoneWulf-WA/tools
brew install screenshot-clip
```

Then activate it:

```bash
screenshot-clip-install
```

Done. It runs in the background and starts automatically on login.

## Usage

Just screenshot normally with `Cmd + Shift + 4` (or `Cmd + Shift + 3`). The image is on your clipboard within a fraction of a second. From there:

- **Paste on your Mac** — `Cmd + V` into Claude Code, Slack, Figma, a browser chat, Notes, wherever.
- **Paste on your iPhone/iPad** — Apple's Universal Clipboard means your Mac clipboard is available on your other devices. Screenshot on your Mac, paste on your iPhone. No AirDrop, no file sharing.
- **Stack screenshots with a clipboard manager** — if you use Raycast or similar, each screenshot automatically enters your clipboard history. Take several in a row, then pull them out one by one wherever you need them.

### Custom screenshot folder

By default it watches `~/Desktop`. If your screenshots save elsewhere:

```bash
screenshot-clip-install ~/Pictures/Screenshots
```

### Stop it

```bash
screenshot-clip-uninstall
```

### Check logs

```bash
cat /tmp/screenshot-clip.log
```

## How it works

A background process on your Mac watches your Desktop folder. Every time a new PNG file appears (which is what happens when you take a screenshot), it automatically copies that image to your clipboard. Three components, all lightweight:

1. **fswatch** — an open-source tool that monitors your screenshot folder for new files in real time. This is what makes it fast (faster than macOS Automator Folder Actions).
2. **screenshot-clip** — a shell script that detects new `.png` files and copies them to your clipboard using macOS native `osascript`.
3. **A launchd agent** — a plist configuration file that tells macOS "run this script automatically when I log in, and keep it running." This is how macOS handles background services for your user account, similar to a startup item.

No Electron. No Swift app. No daemon eating your RAM. A few lines of shell doing one thing well.

## Configuration

| Environment variable | Default | Description |
|---|---|---|
| `SCREENSHOT_CLIP_DIR` | `~/Desktop` | Folder to watch |
| `SCREENSHOT_CLIP_DELAY` | `0.3` | Seconds to wait before copying (lets file finish writing) |

## Why not just use Cmd + Ctrl + Shift + 4?

That shortcut copies your screenshot to the clipboard, but it doesn't save the file. You get the paste, but lose the artifact. screenshot-clip gives you both: the file saves to your Desktop as usual, and it's immediately on your clipboard. No compromise.

## Requirements

- macOS
- [Homebrew](https://brew.sh)
- fswatch (installed automatically as a dependency)

## License

MIT
