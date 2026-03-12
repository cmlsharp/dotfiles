#!/bin/bash

# Cycle monitor scaling: 1x → 1.6x → 2x → 3x → 1x

MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
NAME=$(echo "$MONITOR" | jq -r '.name')
CURRENT=$(echo "$MONITOR" | jq -r '.scale')
WIDTH=$(echo "$MONITOR" | jq -r '.width')
HEIGHT=$(echo "$MONITOR" | jq -r '.height')

case "$CURRENT" in
    1|1.0*)   NEXT=1.6 ;;
    1.6*)     NEXT=2 ;;
    2|2.0*)   NEXT=3 ;;
    *)        NEXT=1 ;;
esac

hyprctl keyword monitor "$NAME, ${WIDTH}x${HEIGHT}, auto, $NEXT"
notify-send -t 2000 "Scale" "${NEXT}x on $NAME"
