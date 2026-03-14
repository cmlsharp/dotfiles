#!/bin/bash

# Start and stop a screenrecording, saved to ~/Videos.
# Override location via XDG_VIDEOS_DIR.
# Resolution is capped to 4K for monitors above 4K, native otherwise.
#
# Options:
#   --with-desktop-audio     Record system audio
#   --with-microphone-audio  Record microphone input
#   --with-webcam            Add webcam overlay
#   --webcam-device=DEV      Specify webcam device (auto-detects if omitted)
#   --resolution=WxH         Override recording resolution (0x0 for native)
#   --stop-recording         Stop current recording (no-op if not recording)

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
RECORDING_FILE="/tmp/screenrecord-filename"

[[ ! -d $OUTPUT_DIR ]] && mkdir -p "$OUTPUT_DIR"

DESKTOP_AUDIO="false"
MICROPHONE_AUDIO="false"
WEBCAM="false"
WEBCAM_DEVICE=""
RESOLUTION=""
STOP_RECORDING="false"

for arg in "$@"; do
  case "$arg" in
  --with-desktop-audio) DESKTOP_AUDIO="true" ;;
  --with-microphone-audio) MICROPHONE_AUDIO="true" ;;
  --with-webcam) WEBCAM="true" ;;
  --webcam-device=*) WEBCAM_DEVICE="${arg#*=}" ;;
  --resolution=*) RESOLUTION="${arg#*=}" ;;
  --stop-recording) STOP_RECORDING="true" ;;
  esac
done

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

start_webcam_overlay() {
  cleanup_webcam

  if [[ -z $WEBCAM_DEVICE ]]; then
    WEBCAM_DEVICE=$(v4l2-ctl --list-devices 2>/dev/null | grep -m1 "^[[:space:]]*/dev/video" | tr -d '\t')
    if [[ -z $WEBCAM_DEVICE ]]; then
      notify-send "No webcam devices found" -u critical -t 3000
      return 1
    fi
  fi

  local scale
  scale=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .scale')
  local target_width
  target_width=$(awk "BEGIN {printf \"%.0f\", 360 * $scale}")

  local preferred_resolutions=("640x360" "1280x720" "1920x1080")
  local video_size_arg=""
  local available_formats
  available_formats=$(v4l2-ctl --list-formats-ext -d "$WEBCAM_DEVICE" 2>/dev/null)

  for resolution in "${preferred_resolutions[@]}"; do
    if echo "$available_formats" | grep -q "$resolution"; then
      video_size_arg="-video_size $resolution"
      break
    fi
  done

  ffplay -f v4l2 $video_size_arg -framerate 30 "$WEBCAM_DEVICE" \
    -vf "scale=${target_width}:-1" \
    -window_title "WebcamOverlay" \
    -noborder \
    -fflags nobuffer -flags low_delay \
    -probesize 32 -analyzeduration 0 \
    -loglevel quiet &
  sleep 1
}

cleanup_webcam() {
  pkill -f "WebcamOverlay" 2>/dev/null
}

start_recording() {
  local filename="$OUTPUT_DIR/screenrecording-$(date +'%Y-%m-%d_%H-%M-%S').mp4"
  local audio_devices=""
  local audio_args=()

  [[ $DESKTOP_AUDIO == "true" ]] && audio_devices+="default_output"

  if [[ $MICROPHONE_AUDIO == "true" ]]; then
    [[ -n $audio_devices ]] && audio_devices+="|"
    audio_devices+="default_input"
  fi

  [[ -n $audio_devices ]] && audio_args+=(-a "$audio_devices" -ac aac)

  local resolution="${RESOLUTION:-$(default_resolution)}"

  gpu-screen-recorder -w portal -k auto -s "$resolution" -f 60 -fm cfr -fallback-cpu-encoding yes -o "$filename" "${audio_args[@]}" &
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
  cleanup_webcam

  if pgrep -f "^gpu-screen-recorder" >/dev/null; then
    pkill -9 -f "^gpu-screen-recorder"
    notify-send "Screen recording error" "Recording had to be force-killed." -u critical -t 5000
  else
    trim_first_frame
    local filename
    filename=$(cat "$RECORDING_FILE" 2>/dev/null)
    local preview="${filename%.mp4}-preview.png"

    ffmpeg -y -i "$filename" -ss 00:00:00.1 -vframes 1 -q:v 2 "$preview" -loglevel quiet 2>/dev/null

    (
      ACTION=$(notify-send "Screen recording saved" "Click to open" -t 10000 -i "${preview:-$filename}" -A "default=open")
      [[ $ACTION == "default" ]] && mpv "$filename"
      rm -f "$preview"
    ) &
  fi

  rm -f "$RECORDING_FILE"
}

recording_active() {
  pgrep -f "^gpu-screen-recorder" >/dev/null
}

if recording_active; then
  stop_recording
elif [[ $STOP_RECORDING == "true" ]]; then
  exit 1
else
  [[ $WEBCAM == "true" ]] && start_webcam_overlay

  start_recording || cleanup_webcam
fi
