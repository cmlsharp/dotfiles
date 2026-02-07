#!/bin/bash
# Lock screen then suspend
# before-sleep is unreliable, so lock directly before suspend

# Only lock if not already locked
if ! pgrep -x swaylock > /dev/null; then
    swaylock --indicator-caps-lock -f
fi

# Give swaylock time to engage (per swayidle timeout patterns)
sleep 1

systemctl suspend
