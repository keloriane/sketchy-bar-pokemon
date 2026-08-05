#!/usr/bin/env bash
# Installs SketchyBar (if needed) and symlinks this repo as ~/.config/sketchybar,
# so the repo IS the live config. Re-run after editing to pick up chmod changes.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/sketchybar"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required: https://brew.sh" >&2
  exit 1
fi

if ! brew list sketchybar &>/dev/null; then
  brew install FelixKratz/formulae/sketchybar
fi

if [[ -e "$CONFIG_DIR" && ! -L "$CONFIG_DIR" ]]; then
  echo "Found an existing (non-symlink) $CONFIG_DIR — back it up or remove it, then re-run this script." >&2
  exit 1
fi

ln -sfn "$REPO_DIR" "$CONFIG_DIR"
chmod +x "$CONFIG_DIR/sketchybarrc" "$CONFIG_DIR"/plugins/*.sh "$CONFIG_DIR"/items/*.sh

brew services restart sketchybar

cat <<EOF

Installed. ~/.config/sketchybar -> $REPO_DIR

Customize via env vars in items/walker.sh or your shell profile before reload:
  WALKER_HIDDEN_MIN / WALKER_HIDDEN_MAX   seconds hidden between walks (default 20-90)
  WALKER_WALK_MIN   / WALKER_WALK_MAX     seconds spent walking across (default 6-14)
  WALKER_FRAME_DELAY                      seconds between sprite frames (default 0.15)

After editing: sketchybar --reload
Replace the placeholder sprite: see sprites/README.md
EOF
