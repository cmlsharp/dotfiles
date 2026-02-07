#!/bin/bash

# Get current connection
current=$(nmcli -t -f NAME connection show --active 2>/dev/null | head -1)

# Scan for available networks
nmcli device wifi rescan 2>/dev/null
networks=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list 2>/dev/null | \
    awk -F: 'seen[$1]++ == 0 && $1 != "" {
        lock = ($3 != "") ? " " : "";
        printf "%s  %s%% %s\n", $1, $2, lock
    }')

# Build menu
menu=""
if [ -n "$current" ]; then
    menu="disconnect  $current\n"
fi
menu="${menu}${networks}"

# Show wofi dropdown
chosen=$(echo -e "$menu" | wofi --dmenu --prompt "Network" --width 300 --height 400 --location 3 --yoffset 2 --xoffset -10 --style ~/.config/waybar/scripts/wofi-dark.css)

[ -z "$chosen" ] && exit 0

if echo "$chosen" | grep -q "^disconnect"; then
    nmcli connection down "$current"
else
    ssid=$(echo "$chosen" | sed 's/  [0-9]*% .*//')
    # Check if we have a saved connection
    if nmcli -t -f NAME connection show | grep -qx "$ssid"; then
        nmcli connection up "$ssid"
    else
        # New network - prompt for password if secured
        if echo "$chosen" | grep -q ""; then
            pass=$(wofi --dmenu --prompt "Password for $ssid" --password --width 300 --height 50 --location 3 --yoffset 2 --xoffset -10 --style ~/.config/waybar/scripts/wofi-dark.css)
            [ -z "$pass" ] && exit 0
            nmcli device wifi connect "$ssid" password "$pass"
        else
            nmcli device wifi connect "$ssid"
        fi
    fi
fi
