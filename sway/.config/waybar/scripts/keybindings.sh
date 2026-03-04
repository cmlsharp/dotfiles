#!/bin/bash

sway_config="$HOME/.config/sway/config"
actions_file=$(mktemp)
trap "rm -f $actions_file" EXIT

{
    section=""
    section_printed=false
    prev_comment=""

    while IFS= read -r line; do
        if [[ "$line" =~ ^###[[:space:]]*(.*) ]]; then
            section="${BASH_REMATCH[1]}"
            section="${section%:}"
            section_printed=false
            prev_comment=""
            continue
        fi

        if [[ "$line" =~ ^[[:space:]]*#[[:space:]]+(.*) ]]; then
            prev_comment="${BASH_REMATCH[1]}"
            continue
        fi

        if [[ "$line" =~ ^[[:space:]]*(bindsym)[[:space:]]+(--locked[[:space:]]+)?([^[:space:]]+)[[:space:]]+(.*) ]]; then
            if [[ "$section_printed" == false && -n "$section" ]]; then
                printf "\n── %s ──\n" "$section"
                section_printed=true
            fi

            key="${BASH_REMATCH[3]}"
            action="${BASH_REMATCH[4]}"

            key="${key//\$mod/Super}"
            key="${key//\$left/H}"
            key="${key//\$down/J}"
            key="${key//\$up/K}"
            key="${key//\$right/L}"
            key="${key//Shift+slash/?}"

            if [[ -n "$prev_comment" ]]; then
                label="$prev_comment"
            else
                # Clean up action for display: strip "exec" prefix
                label="${action#exec }"
            fi

            display_line=$(printf "%-28s %s" "$key" "$label")
            echo "$display_line"
            # Store mapping: display line -> sway command
            printf '%s\t%s\n' "$display_line" "$action" >> "$actions_file"
            prev_comment=""
            continue
        fi

        if [[ "$line" =~ ^mode[[:space:]]+\"(.*)\" ]]; then
            section="${BASH_REMATCH[1]} mode"
            section_printed=false
            prev_comment=""
            continue
        fi

        prev_comment=""
    done < "$sway_config"
} > /tmp/waybar-keybindings-menu

chosen=$(wofi --dmenu --prompt "Keybindings" --width 550 --height 600 \
    --location 0 --style ~/.config/waybar/scripts/wofi-dark.css < /tmp/waybar-keybindings-menu)
rm -f /tmp/waybar-keybindings-menu

[ -z "$chosen" ] && exit 0

# Look up the sway command for the selected line
cmd=$(grep -F "$chosen" "$actions_file" | head -1 | cut -f2)

[ -z "$cmd" ] && exit 0

swaymsg "$cmd"
