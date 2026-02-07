#!/bin/bash

entries="Lock\nLogout\nReboot\nShutdown"

selected=$(echo -e "$entries" | wofi --dmenu --style ~/.config/waybar/scripts/wofi-dark.css --width 200 --height 220 --prompt "Power")

case $selected in
    Lock)
        swaylock
        ;;
    Logout)
        swaymsg exit
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
