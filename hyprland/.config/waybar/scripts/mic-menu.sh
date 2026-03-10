#!/bin/bash

# Get current mic status
vol=$(pactl get-source-volume @DEFAULT_SOURCE@ 2>/dev/null | grep -oP '\d+%' | head -1)
mute=$(pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | grep -oP '(yes|no)')

if [ "$mute" = "yes" ]; then
    status="Mic: muted"
else
    status="Mic: $vol"
fi

chosen=$(printf "%s\nToggle mute\nVolume up\nVolume down" "$status" | \
    wofi --dmenu --prompt "Microphone" --width 200 --height 200 \
    --location 3 --yoffset 2 --xoffset -10 \
    --style ~/.config/waybar/scripts/wofi-dark.css)

case "$chosen" in
    "Toggle mute") pactl set-source-mute @DEFAULT_SOURCE@ toggle ;;
    "Volume up") pactl set-source-volume @DEFAULT_SOURCE@ +5% ;;
    "Volume down") pactl set-source-volume @DEFAULT_SOURCE@ -5% ;;
esac
