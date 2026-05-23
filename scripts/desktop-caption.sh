#!/usr/bin/env bash

set -euo pipefail

CAPTION_TEXT="${CAPTION_TEXT:-Text goes here}"
WALLPAPER_PATH="${1:-$HOME/.wallpapers/hollow-knight-white.jpg}"
OUTPUT_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lavarch"
OUTPUT_PATH="$OUTPUT_DIR/desktop-caption.png"
MONITOR="${HYPR_WALLPAPER_MONITOR:-eDP-1}"

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Wallpaper not found: $WALLPAPER_PATH" >&2
    exit 1
fi

if command -v magick >/dev/null 2>&1; then
    MAGICK_CMD=(magick)
elif command -v convert >/dev/null 2>&1; then
    MAGICK_CMD=(convert)
else
    echo "ImageMagick is required (magick/convert not found)." >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

"${MAGICK_CMD[@]}" "$WALLPAPER_PATH" \
    -gravity south \
    -pointsize 52 \
    -fill "#cdd6f4" \
    -stroke "#11111b" \
    -strokewidth 2 \
    -annotate +0+50 "$CAPTION_TEXT" \
    "$OUTPUT_PATH"

if ! hyprctl hyprpaper listloaded >/dev/null 2>&1; then
    echo "hyprpaper is not running." >&2
    exit 1
fi

hyprctl hyprpaper preload "$OUTPUT_PATH"
hyprctl hyprpaper wallpaper "$MONITOR,$OUTPUT_PATH"
