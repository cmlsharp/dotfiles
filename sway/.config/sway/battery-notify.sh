#!/bin/bash
# Battery level notification script — runs via systemd timer
# Sends notifications through swaync (notify-send)

THRESHOLD_WARN=20
THRESHOLD_CRIT=10
THRESHOLD_SUSPEND=5
STATE_FILE="/tmp/battery-notify.id"

CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null) || exit 1
STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)

# Clear saved ID when charging/full
if [ "$STATUS" != "Discharging" ]; then
    rm -f "$STATE_FILE"
    exit 0
fi

# Build replace-id arg to update the previous notification instead of spamming
REPLACE=""
if [ -f "$STATE_FILE" ]; then
    PREV_ID=$(cat "$STATE_FILE")
    [ -n "$PREV_ID" ] && REPLACE="--replace-id=$PREV_ID"
fi

send_notify() {
    local urgency="$1" timeout="$2" title="$3" body="$4"
    notify-send --print-id $REPLACE -u "$urgency" -t "$timeout" "$title" "$body" \
        2>/dev/null > "$STATE_FILE" || true
}

if [ "$CAPACITY" -le "$THRESHOLD_SUSPEND" ]; then
    send_notify critical 0 "Battery Critical" \
        "Battery at ${CAPACITY}%. Suspending in 30 seconds..."
    sleep 30
    systemctl suspend
elif [ "$CAPACITY" -le "$THRESHOLD_CRIT" ]; then
    send_notify critical 0 "Battery Critical" \
        "Battery at ${CAPACITY}%. Plug in now!"
elif [ "$CAPACITY" -le "$THRESHOLD_WARN" ]; then
    send_notify normal 30000 "Battery Low" \
        "Battery at ${CAPACITY}%."
fi
