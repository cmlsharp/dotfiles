#!/bin/bash

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
RECORDING_FILE="/tmp/screenrecord-filename"

[[ ! -d $OUTPUT_DIR ]] && mkdir -p "$OUTPUT_DIR"

toggle_indicator() {
  pkill -RTMIN+8 waybar
}

trim_first_frame() {
  local latest
  latest=$(cat "$RECORDING_FILE" 2>/dev/null)
  if [[ -n $latest && -f $latest ]]; then
    local trimmed="${latest%.mp4}-trimmed.mp4"
    if ffmpeg -y -ss 0.1 -i "$latest" -c copy "$trimmed" -loglevel quiet 2>/dev/null; then
      mv "$trimmed" "$latest"
    else
      rm -f "$trimmed"
    fi
  fi
}

default_resolution() {
  local width height
  read -r width height < <(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.width) \(.height)"')
  if ((width > 3840 || height > 2160)); then
    echo "3840x2160"
  else
    echo "0x0"
  fi
}

start_recording() {
  local filename="$OUTPUT_DIR/screenrecording-$(date +'%Y-%m-%d_%H-%M-%S').mp4"
  local resolution
  resolution=$(default_resolution)

  gpu-screen-recorder -w portal -k auto -s "$resolution" -f 60 -fm cfr -fallback-cpu-encoding yes -o "$filename" -a "default_output" -ac aac &
  local pid=$!

  while kill -0 $pid 2>/dev/null && [[ ! -f $filename ]]; do
    sleep 0.2
  done

  if kill -0 $pid 2>/dev/null; then
    echo "$filename" >"$RECORDING_FILE"
    toggle_indicator
  fi
}

stop_recording() {
  pkill -SIGINT -f "^gpu-screen-recorder"

  local count=0
  while pgrep -f "^gpu-screen-recorder" >/dev/null && ((count < 50)); do
    sleep 0.1
    count=$((count + 1))
  done

  toggle_indicator

  if pgrep -f "^gpu-screen-recorder" >/dev/null; then
    pkill -9 -f "^gpu-screen-recorder"
    notify-send "Screen recording error" "Recording had to be force-killed." -u critical -t 5000
  else
    trim_first_frame
    notify-send "Screen recording saved to $OUTPUT_DIR" -t 2000
  fi

  rm -f "$RECORDING_FILE"
}

if pgrep -f "^gpu-screen-recorder" >/dev/null; then
  stop_recording
else
  start_recording
fi
