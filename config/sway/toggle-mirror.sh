#!/bin/bash
# Toggle mirroring eDP-1 onto the external display using wl-mirror.

LAPTOP="eDP-1"

if pgrep -x wl-mirror > /dev/null; then
    pkill -x wl-mirror
else
    # Find the first active output that isn't the laptop
    EXTERNAL=$(swaymsg -t get_outputs -r | jq -r '.[] | select(.active and .name != "'"$LAPTOP"'") | .name' | head -1)
    if [ -z "$EXTERNAL" ]; then
        notify-send "Mirror" "No external display found"
        exit 1
    fi
    wl-mirror --fullscreen-output "$EXTERNAL" --scaling fit "$LAPTOP" &
fi
