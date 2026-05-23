#!/usr/bin/env bash

set -euo pipefail

CAPTION_TEXT="${CAPTION_TEXT:-Text goes here}"
WALLPAPER_PATH="${1:-$HOME/.wallpapers/hollow-knight-white.jpg}"
OUTPUT_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lavarch"
MONITOR="${HYPR_WALLPAPER_MONITOR:-eDP-1}"
MAX_RETRIES="${MAX_RETRIES:-20}"
RETRY_DELAY="${RETRY_DELAY:-0.2}"
CAPTION_POINTSIZE="${CAPTION_POINTSIZE:-52}"
CAPTION_FILL="${CAPTION_FILL:-#cdd6f4}"
CAPTION_STROKE="${CAPTION_STROKE:-#11111b}"
CAPTION_STROKEWIDTH="${CAPTION_STROKEWIDTH:-2}"
CAPTION_OFFSET="${CAPTION_OFFSET:-+0+50}"
LOCK_FILE="$OUTPUT_DIR/desktop-caption.lock"

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Wallpaper not found: $WALLPAPER_PATH" >&2
    exit 1
fi

WALLPAPER_PATH="$(readlink -f "$WALLPAPER_PATH")"
OUTPUT_KEY="$(printf '%s\0%s\0%s\0%s\0%s\0%s\0%s' \
    "$WALLPAPER_PATH" \
    "$CAPTION_TEXT" \
    "$CAPTION_POINTSIZE" \
    "$CAPTION_FILL" \
    "$CAPTION_STROKE" \
    "$CAPTION_STROKEWIDTH" \
    "$CAPTION_OFFSET" | sha256sum | awk '{print $1}')"
OUTPUT_PATH="$OUTPUT_DIR/desktop-caption-$OUTPUT_KEY.png"

if command -v magick >/dev/null 2>&1; then
    MAGICK_CMD=(magick)
elif command -v convert >/dev/null 2>&1; then
    MAGICK_CMD=(convert)
else
    echo "ImageMagick is required (magick/convert not found)." >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

if command -v flock >/dev/null 2>&1; then
    exec 9>"$LOCK_FILE"
    flock -n 9 || exit 0
fi

"${MAGICK_CMD[@]}" "$WALLPAPER_PATH" \
    -gravity south \
    -pointsize "$CAPTION_POINTSIZE" \
    -fill "$CAPTION_FILL" \
    -stroke "$CAPTION_STROKE" \
    -strokewidth "$CAPTION_STROKEWIDTH" \
    -annotate "$CAPTION_OFFSET" "$CAPTION_TEXT" \
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

for ((i = 0; i < MAX_RETRIES; i++)); do
    if hyprctl hyprpaper listloaded 2>/dev/null | grep -Fxq "$OUTPUT_PATH"; then
        break
    fi
    sleep "$RETRY_DELAY"
done

mapfile -t LOADED_WALLPAPERS < <(hyprctl hyprpaper listloaded 2>/dev/null || true)
for LOADED_WALLPAPER in "${LOADED_WALLPAPERS[@]}"; do
    if [ "$LOADED_WALLPAPER" != "$OUTPUT_PATH" ]; then
        hyprctl hyprpaper unload "$LOADED_WALLPAPER"
    fi
done

find "$OUTPUT_DIR" -maxdepth 1 -type f -name 'desktop-caption-*.png' \
    ! -name "$(basename "$OUTPUT_PATH")" -delete
