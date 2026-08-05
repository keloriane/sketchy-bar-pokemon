# Sprite frames

`walker.sh` plays every `frame_*.png` in this directory, in numeric order
(`frame_1.png`, `frame_2.png`, ... `frame_N.png`), looping for as long as the
current walk cycle lasts.

## Using your own sprite sheet

The four `frame_*.png` files here are an original placeholder (simple
generated pixel-art figure) — not Pokémon/Nintendo artwork, since that can't
be redistributed. To use a real walking-cycle sprite (e.g. a Pokémon
overworld sprite you've extracted yourself from a ROM you own):

1. Cut your sprite sheet into individual frames, transparent background,
   square PNGs (roughly 32-48px worked well for a 32-36px-tall bar).
2. Name them `frame_1.png`, `frame_2.png`, ... in walk-cycle order and drop
   them in this directory (replacing or alongside the placeholders — delete
   the placeholders if you don't want them mixed in).
3. Regenerate placeholders any time with
   `scripts/generate_placeholder_sprites.sh` if you want to get back to a
   clean baseline.
4. If your frames are a different size, adjust `background.image.scale` in
   `items/walker.sh` to fit the bar height.
