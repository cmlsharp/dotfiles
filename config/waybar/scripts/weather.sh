#!/bin/bash

# Weather widget using wttr.in with monochromatic text-based icons

# Cache settings
CACHE_FILE="$HOME/.cache/waybar-weather.json"
CACHE_DURATION=900  # 15 minutes (matches waybar interval)

# Function to map weather conditions to icons
get_icon() {
    local condition="$1"
    case "$condition" in
        *[Cc]lear*|*[Ss]unny*)
            echo "☀"
            ;;
        *[Cc]loud*|*[Oo]vercast*)
            echo "☁"
            ;;
        *[Pp]artly*)
            echo "☀☁"
            ;;
        *[Rr]ain*|*[Dd]rizzle*|*[Ss]hower*)
            echo "🌧"
            ;;
        *[Tt]hunder*|*[Ss]torm*)
            echo "⛈"
            ;;
        *[Ss]snow*|*[Ss]leet*)
            echo "❄"
            ;;
        *[Ff]og*|*[Mm]ist*|*[Hh]aze*)
            echo "░"
            ;;
        *[Ww]ind*)
            echo "🌫"
            ;;
        *)
            echo "?"
            ;;
    esac
}

# Check if cache exists and is recent enough
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null)))
    if [ $cache_age -lt $CACHE_DURATION ]; then
        # Cache is fresh, use it
        weather_json=$(cat "$CACHE_FILE")
    else
        # Cache is stale, fetch new data
        weather_json=$(curl -s 'wttr.in/?format=j1' 2>/dev/null)
        if [ -n "$weather_json" ]; then
            mkdir -p "$(dirname "$CACHE_FILE")"
            echo "$weather_json" > "$CACHE_FILE"
        fi
    fi
else
    # No cache, fetch new data
    weather_json=$(curl -s 'wttr.in/?format=j1' 2>/dev/null)
    if [ -n "$weather_json" ]; then
        mkdir -p "$(dirname "$CACHE_FILE")"
        echo "$weather_json" > "$CACHE_FILE"
    fi
fi

if [ -z "$weather_json" ]; then
    echo '{"text":"?","tooltip":"Weather unavailable"}'
    exit 0
fi

# Extract current conditions
current_condition=$(echo "$weather_json" | jq -r '.current_condition[0].weatherDesc[0].value' 2>/dev/null)
current_temp_f=$(echo "$weather_json" | jq -r '.current_condition[0].temp_F' 2>/dev/null)
feels_like_f=$(echo "$weather_json" | jq -r '.current_condition[0].FeelsLikeF' 2>/dev/null)
wind=$(echo "$weather_json" | jq -r '.current_condition[0].windspeedMiles' 2>/dev/null)
wind_dir=$(echo "$weather_json" | jq -r '.current_condition[0].winddir16Point' 2>/dev/null)
humidity=$(echo "$weather_json" | jq -r '.current_condition[0].humidity' 2>/dev/null)
precip_mm=$(echo "$weather_json" | jq -r '.current_condition[0].precipMM' 2>/dev/null)
location=$(echo "$weather_json" | jq -r '.nearest_area[0].areaName[0].value' 2>/dev/null)

# Get icon for current weather
icon=$(get_icon "$current_condition")

# Build current conditions text
current="${location}\n${current_condition}\n${current_temp_f}°F (feels like ${feels_like_f}°F)\nWind: ${wind}mph ${wind_dir}\nHumidity: ${humidity}%\nPrecipitation: ${precip_mm}mm"

# Get 3-day forecast with dates and convert descriptions to icons
forecast=""
while IFS= read -r line; do
    date=$(echo "$line" | cut -d'|' -f1)
    high=$(echo "$line" | cut -d'|' -f2)
    low=$(echo "$line" | cut -d'|' -f3)
    desc=$(echo "$line" | cut -d'|' -f4)

    # Get icon for this forecast
    forecast_icon=$(get_icon "$desc")

    forecast="${forecast}${date}: ${forecast_icon} ${high}°F/${low}°F\n"
done < <(echo "$weather_json" | jq -r '.weather[0:3] | .[] | "\(.date)|\(.maxtempF)|\(.mintempF)|\(.hourly[4].weatherDesc[0].value)"' 2>/dev/null)

# Build tooltip
tooltip="${current}\n\n3-Day Forecast:\n${forecast}"

# Escape tooltip for JSON
tooltip_escaped=$(echo "$tooltip" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

# Output JSON format for waybar
echo "{\"text\":\"$icon ${current_temp_f}°F\",\"tooltip\":\"$tooltip_escaped\"}"
