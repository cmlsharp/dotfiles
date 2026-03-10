#!/bin/bash
rfkill unblock wifi 2>/dev/null
kitty --class floating-tui -e wlctl
