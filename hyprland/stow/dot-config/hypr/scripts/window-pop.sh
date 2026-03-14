#!/bin/bash

# Toggle "pop" mode on focused window: float + resize + center + pin
# Un-popping returns it to tiled state.

WIDTH="${1:-1300}"
HEIGHT="${2:-900}"

WINDOW=$(hyprctl activewindow -j)
TAGS=$(echo "$WINDOW" | jq -r '.tags // [] | join(" ")')

if [[ "$TAGS" == *"pop"* ]]; then
    hyprctl dispatch tagwindow -- -pop
    hyprctl dispatch pin
    hyprctl dispatch togglefloating
else
    hyprctl dispatch togglefloating
    hyprctl dispatch resizeactive exact "$WIDTH" "$HEIGHT"
    hyprctl dispatch centerwindow
    hyprctl dispatch pin
    hyprctl dispatch alterzorder top
    hyprctl dispatch tagwindow +pop
fi
