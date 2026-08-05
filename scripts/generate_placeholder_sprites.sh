#!/usr/bin/env bash
# Generates a small original walk-cycle placeholder sprite (NOT Pokémon artwork —
# swap these out with your own legally-obtained sprite sheet, see sprites/README.md).
#
# Requires ImageMagick (`brew install imagemagick` on macOS).
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../sprites" && pwd)"
SIZE=48
BODY="#e0554f"
OUTLINE="#1a1a1a"

magick_cmd() {
  if command -v magick >/dev/null 2>&1; then
    magick "$@"
  else
    convert "$@"
  fi
}

# 4-frame walk cycle: legs swing forward/back, arms swing opposite.
draw_frame() {
  local out="$1" leg_front="$2" leg_back="$3" arm_front="$4" arm_back="$5"
  magick_cmd -size "${SIZE}x${SIZE}" xc:none \
    -strokewidth 3 -stroke "$OUTLINE" -fill "$BODY" \
    -draw "circle 24,10 24,3" \
    -draw "roundrectangle 16,16 32,32 4,4" \
    -strokewidth 3 -stroke "$OUTLINE" -fill none \
    -draw "line 16,20 $arm_back" \
    -draw "line 32,20 $arm_front" \
    -draw "line 20,32 $leg_back" \
    -draw "line 28,32 $leg_front" \
    "$out"
}

draw_frame "$DIR/frame_1.png" "24,46" "16,44" "10,26" "38,26"
draw_frame "$DIR/frame_2.png" "20,45" "22,45" "16,24" "32,24"
draw_frame "$DIR/frame_3.png" "16,44" "24,46" "38,26" "10,26"
draw_frame "$DIR/frame_4.png" "22,45" "20,45" "32,24" "16,24"

echo "Wrote 4 placeholder frames to $DIR"
