#!/bin/bash

# Toggle between current gaps and zero gaps (distraction-free mode)

current=$(hyprctl getoption general:gaps_in -j | jq '.custom' | grep -oE '[0-9]+' | head -1)

if (( current == 0 )); then
    hyprctl keyword general:gaps_in 5
    hyprctl keyword general:gaps_out 10
    hyprctl keyword decoration:rounding 0
else
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword decoration:rounding 0
fi
