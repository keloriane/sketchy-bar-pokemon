#!/usr/bin/env bash
# Background daemon: makes a SketchyBar item randomly appear, walk across the
# bar cycling sprite frames, then disappear again — repeat forever.
#
# Launched once from sketchybarrc (see items/walker.sh). Guards against
# duplicate instances so a `sketchybar --reload` doesn't spawn a second loop.

set -uo pipefail

ITEM="${1:-walker}"
SPRITES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../sprites" && pwd)"
PIDFILE="/tmp/sketchybar-walker-${ITEM}.pid"

FRAME_DELAY="${WALKER_FRAME_DELAY:-0.15}"
HIDDEN_MIN="${WALKER_HIDDEN_MIN:-20}"
HIDDEN_MAX="${WALKER_HIDDEN_MAX:-90}"
WALK_MIN="${WALKER_WALK_MIN:-6}"
WALK_MAX="${WALKER_WALK_MAX:-14}"

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null; then
  exit 0
fi
echo $$ > "$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT

mapfile -t FRAMES < <(ls "$SPRITES_DIR"/frame_*.png 2>/dev/null | sort -V)
if [[ ${#FRAMES[@]} -eq 0 ]]; then
  echo "walker.sh: no sprite frames found in $SPRITES_DIR (expected frame_1.png, frame_2.png, ...)" >&2
  exit 1
fi

random_between() {
  local min="$1" max="$2"
  echo $(( min + RANDOM % (max - min + 1) ))
}

sketchybar --set "$ITEM" drawing=off

while true; do
  sleep "$(random_between "$HIDDEN_MIN" "$HIDDEN_MAX")"

  walk_seconds=$(random_between "$WALK_MIN" "$WALK_MAX")
  end=$(( SECONDS + walk_seconds ))
  i=0
  sketchybar --set "$ITEM" drawing=on background.image="${FRAMES[0]}"
  while (( SECONDS < end )); do
    frame="${FRAMES[$(( i % ${#FRAMES[@]} ))]}"
    sketchybar --set "$ITEM" background.image="$frame"
    i=$((i + 1))
    sleep "$FRAME_DELAY"
  done

  sketchybar --set "$ITEM" drawing=off
done
