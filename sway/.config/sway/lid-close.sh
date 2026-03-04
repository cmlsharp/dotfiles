#!/bin/bash
# Handle lid close: lock+suspend if no external monitor, clamshell mode if external monitor

LAPTOP_SCREEN="eDP-1"
OUTPUT_COUNT=$(swaymsg -t get_outputs | grep "\"name\":" | wc -l)

if [[ "$OUTPUT_COUNT" -eq 1 ]]; then
    # Only laptop screen - lock and suspend
    swaylock --indicator-caps-lock -f
    sleep 2
    systemctl suspend
else
    # External monitor connected - clamshell mode
    notify-send "Clamshell mode" "Laptop screen off"
    swaymsg output "$LAPTOP_SCREEN" disable
fi
