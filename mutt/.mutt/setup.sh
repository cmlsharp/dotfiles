#!/bin/bash
# Mutt first-time setup
# Run this once after setting up a new machine.
# Stores email App Passwords in the GNOME keyring via secret-tool.
#
# Before running:
#   Generate an App Password for each Google account at:
#   Google Account → Security → 2-Step Verification → App passwords

set -e

echo "=== Mutt keyring setup ==="
echo ""
echo "You will be prompted to enter an App Password for each account."
echo "App Passwords are 16-character codes from your Google account settings."
echo ""

mkdir -p ~/.mutt_cache/headers ~/.mutt_cache/messages /tmp/mutt

echo "--- chad.ml.sharp@gmail.com ---"
secret-tool store --label="Mutt chad.ml.sharp" service mutt username chad.ml.sharp@gmail.com

echo ""
echo "--- crossroads1112@gmail.com ---"
secret-tool store --label="Mutt crossroads1112" service mutt username crossroads1112@gmail.com

echo ""
echo "--- cmlsharp@umich.edu ---"
secret-tool store --label="Mutt cmlsharp@umich.edu" service mutt username cmlsharp@umich.edu

echo ""
echo "Done. Run 'neomutt' to start."
