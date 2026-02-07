#!/bin/bash
# Toggle screen recording with wf-recorder

PIDFILE="/tmp/wf-recorder.pid"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    # Stop recording
    kill -INT "$(cat "$PIDFILE")"
    rm -f "$PIDFILE"
    notify-send "Screen Recording" "Recording saved to ~/Videos/"
else
    # Start recording
    mkdir -p ~/Videos
    FILENAME=~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4
    GEOMETRY=$(slurp 2>/dev/null)
    if [ -n "$GEOMETRY" ]; then
        wf-recorder -g "$GEOMETRY" -f "$FILENAME" &
    else
        wf-recorder -f "$FILENAME" &
    fi
    echo $! > "$PIDFILE"
    notify-send "Screen Recording" "Recording started..."
fi
