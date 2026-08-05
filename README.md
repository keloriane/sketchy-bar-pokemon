# sketchybar-walker

A little character that randomly appears in your macOS menu bar
([SketchyBar](https://github.com/FelixKratz/SketchyBar)), walks across
cycling through sprite frames, and disappears again — repeat forever.

This is the macOS/SketchyBar port of a Waybar (Linux/Hyprland) experiment.
Waybar's `image` module can't do real animated sprites on 0.15 (breaks the
bar with `exec`, throws unhandled `Glib::Error` with `signal`), so that setup
fell back to Pango glyph tricks. SketchyBar has no such limitation —
`background.image=<path>` swaps a real bitmap cleanly — so this repo does
genuine pixel-art sprite animation instead of a glyph workaround.

## Quick start

Requires macOS + [Homebrew](https://brew.sh).

```sh
git clone <this-repo> ~/sketchybar-walker
cd ~/sketchybar-walker
./install.sh
```

`install.sh` installs SketchyBar if needed, symlinks this repo to
`~/.config/sketchybar` (the repo *is* the live config), and (re)starts the
`sketchybar` service.

Already run SketchyBar with your own config? Don't use `install.sh` or
`sketchybarrc` — instead copy `plugins/walker.sh` and `sprites/` into your
config directory, then source `items/walker.sh` from your own `sketchybarrc`
(it registers the item and launches the animation daemon).

## How it works

- `items/walker.sh` — registers a SketchyBar item (`walker`), initially
  hidden, and launches the background loop.
- `plugins/walker.sh` — the loop: sleep a random "hidden" interval, show the
  item and cycle through `sprites/frame_*.png` for a random "walking"
  duration, hide it again, repeat. Guards against duplicate instances across
  `sketchybar --reload` via a pidfile in `/tmp`.
- `sprites/` — the frames it cycles through. See `sprites/README.md` to use
  your own sprite sheet instead of the bundled placeholder.

## Customizing timing

Set these env vars before `sketchybar --reload` (e.g. export them at the top
of `sketchybarrc`, or in your shell profile):

| Var | Default | Meaning |
|---|---|---|
| `WALKER_HIDDEN_MIN` / `WALKER_HIDDEN_MAX` | 20 / 90 | seconds hidden between walks |
| `WALKER_WALK_MIN` / `WALKER_WALK_MAX` | 6 / 14 | seconds spent walking across |
| `WALKER_FRAME_DELAY` | 0.15 | seconds between sprite frames |

## Uninstall

```sh
brew services stop sketchybar
rm ~/.config/sketchybar   # only if it's the symlink install.sh created
```

## License

Code in this repo is MIT (see `LICENSE`). The bundled placeholder sprite is
original pixel art. If you swap in a sprite sheet extracted from a game you
own, that asset is not covered by this repo's license — don't redistribute it.
