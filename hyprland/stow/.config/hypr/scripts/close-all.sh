#!/bin/bash

# Close all windows and return to workspace 1

hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
    hyprctl dispatch closewindow "address:$addr"
done

active=$(hyprctl activeworkspace -j | jq -r '.id')
[ "$active" != "1" ] && hyprctl dispatch workspace 1
