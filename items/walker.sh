#!/usr/bin/env bash
# Registers the "walker" item. Source this from sketchybarrc (already wired
# up in the standalone sketchybarrc in this repo). To integrate into an
# existing SketchyBar config instead, copy plugins/walker.sh + sprites/ into
# your config dir and source this file (adjusting CONFIG_DIR if needed).

CONFIG_DIR="${CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
PLUGIN_DIR="$CONFIG_DIR/plugins"
SPRITES_DIR="$CONFIG_DIR/sprites"

sketchybar --add item walker left \
           --set walker \
                 icon.drawing=off \
                 label.drawing=off \
                 background.drawing=off \
                 background.image.drawing=on \
                 background.image="$SPRITES_DIR/frame_1.png" \
                 background.image.scale=1.0 \
                 drawing=off \
                 update_freq=0

"$PLUGIN_DIR/walker.sh" walker &
disown
