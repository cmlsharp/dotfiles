#!/bin/bash

# Simple weather widget using wttr.in
# Format: condition icon + temperature
weather=$(curl -s 'wttr.in/?format=%c+%t' 2>/dev/null | sed 's/+//g' | xargs)

if [ -z "$weather" ] || echo "$weather" | grep -q "Unknown"; then
    echo ""
else
    echo "$weather"
fi
