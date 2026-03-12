#!/bin/bash

# Toggle workspace layout between master and scrolling

ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
CURRENT_LAYOUT=$(hyprctl activeworkspace -j | jq -r '.tiledLayout')

case "$CURRENT_LAYOUT" in
    master) NEW_LAYOUT=scrolling ;;
    *) NEW_LAYOUT=master ;;
esac

hyprctl keyword workspace "$ACTIVE_WORKSPACE", layout:"$NEW_LAYOUT"
notify-send -t 2000 "Layout" "$NEW_LAYOUT"
