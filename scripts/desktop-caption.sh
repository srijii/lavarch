#!/usr/bin/env bash

set -euo pipefail

CAPTION_TEXT="${CAPTION_TEXT:-Text goes here}"
WALLPAPER_PATH="${1:-$HOME/.wallpapers/hollow-knight-white.jpg}"
OUTPUT_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lavarch"
OUTPUT_KEY="$(printf '%s\0%s' "$WALLPAPER_PATH" "$CAPTION_TEXT" | sha256sum | awk '{print $1}')"
OUTPUT_PATH="$OUTPUT_DIR/desktop-caption-$OUTPUT_KEY.png"
MONITOR="${HYPR_WALLPAPER_MONITOR:-eDP-1}"
MAX_RETRIES=20
RETRY_DELAY=0.2

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

for ((i = 0; i < MAX_RETRIES; i++)); do
    if hyprctl hyprpaper listloaded >/dev/null 2>&1; then
        break
    fi
    sleep "$RETRY_DELAY"
done

if ! hyprctl hyprpaper listloaded >/dev/null 2>&1; then
    echo "hyprpaper is not running." >&2
    exit 1
fi

hyprctl hyprpaper preload "$OUTPUT_PATH"
hyprctl hyprpaper wallpaper "$MONITOR,$OUTPUT_PATH"

mapfile -t LOADED_WALLPAPERS < <(hyprctl hyprpaper listloaded 2>/dev/null || true)
for LOADED_WALLPAPER in "${LOADED_WALLPAPERS[@]}"; do
    if [ "$LOADED_WALLPAPER" != "$OUTPUT_PATH" ]; then
        hyprctl hyprpaper unload "$LOADED_WALLPAPER"
    fi
done

find "$OUTPUT_DIR" -maxdepth 1 -type f -name 'desktop-caption-*.png' \
    ! -name "$(basename "$OUTPUT_PATH")" -delete
