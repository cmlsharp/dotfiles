#!/bin/bash

# Check if btop window exists
if swaymsg -t get_tree | grep -q "floating-btop"; then
    # Window exists, check if it's visible
    if swaymsg -t get_tree | jq -r '.. | select(.name? == "floating-btop") | .visible' | grep -q "true"; then
        # Window is visible, kill it
        swaymsg '[title="^floating-btop$"]' kill
    else
        # Window exists but not visible, focus it
        swaymsg '[title="^floating-btop$"]' focus
    fi
else
    # Window doesn't exist, create it
    foot --title="floating-btop" btop
fi
