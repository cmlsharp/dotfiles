#!/usr/bin/env bash

# App launcher using a separate rofi theme.
# Usage: launch-drun.sh [style]
# Styles: translucent (default), glass, solid, bordered

STYLE="${1:-translucent}"
DIR="$(dirname "$(realpath "$0")")"
STYLE_FILE="$DIR/styles/${STYLE}.rasi"

if [[ ! -f "$STYLE_FILE" ]]; then
  echo "Unknown style: $STYLE (available: translucent, glass, solid, bordered)" >&2
  exit 1
fi

rofi -show drun -theme "$STYLE_FILE"
