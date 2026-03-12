#!/bin/bash

# Toggle hypridle (screen locking/dimming on idle)

if pgrep -x hypridle &>/dev/null; then
    killall hypridle 2>/dev/null
    notify-send -t 2000 "Idle Lock" "Disabled"
else
    setsid uwsm-app -- hypridle >/dev/null 2>&1 &
    disown
    notify-send -t 2000 "Idle Lock" "Enabled"
fi
