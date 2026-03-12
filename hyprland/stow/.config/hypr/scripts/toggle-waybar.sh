#!/bin/bash

# Toggle waybar visibility

if pgrep -x waybar &>/dev/null; then
    killall waybar 2>/dev/null
else
    setsid uwsm-app -- waybar >/dev/null 2>&1 &
    disown
fi
