#!/bin/bash

class="floating-tui"
title=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --class) class="$2"; shift 2 ;;
        --title) title="$2"; shift 2 ;;
        *) cmd="$1"; shift ;;
    esac
done

if [[ -z "$cmd" ]]; then
    echo "Usage: toggle-launch.sh [--class CLASS] [--title TITLE] CMD" >&2
    exit 1
fi

title="${title:-$cmd}"

pid=$(hyprctl clients -j | jq -r --arg title "$title" --arg class "$class" '.[] | select(.initialTitle == $title and .initialClass == $class) | .pid')

if [[ -n "$pid" ]]; then
    hyprctl dispatch closewindow "pid:$pid"
else
    kitty --title "$title" --class "$class" $cmd
fi
