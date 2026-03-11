#!/bin/bash
# Handle lid close: lock+suspend if no external monitor, clamshell mode if external monitor

LAPTOP_SCREEN="eDP-1"
OUTPUT_COUNT=$(hyprctl monitors -j | grep -c '"name"')

if [[ "$OUTPUT_COUNT" -eq 1 ]]; then
    # Only laptop screen - lock and suspend
    hyprlock --no-fade-in --immediate-render &
    sleep 1
    # Verify hyprlock is running before suspending
    pidof hyprlock && systemctl suspend
else
    # External monitor connected - clamshell mode
    notify-send "Clamshell mode" "Laptop screen off"
    hyprctl keyword monitor "$LAPTOP_SCREEN, disable"
fi
