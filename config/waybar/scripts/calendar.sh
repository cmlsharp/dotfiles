#!/bin/bash

# Show a calendar popup using a floating foot terminal
foot --title floating-calendar \
    -W 28x10 \
    sh -c 'cal --color=always; echo; read -n1 -s -r -p "Press any key to close"'
