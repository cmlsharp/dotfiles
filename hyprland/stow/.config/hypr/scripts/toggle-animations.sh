#!/bin/bash

on=$(hyprctl -j getoption animations:enabled | jq --raw-output '.int')

if [[ $on -eq 1 ]]; then
    hyprctl keyword animations:enabled 0
    notify-send -u low "⏸ Animations off"
else
    hyprctl keyword animations:enabled 1
    notify-send -u low "▶ Animations on"
fi
