#!/bin/bash
# Script to configure laptop lid to lock screen and suspend via Sway

set -e

echo "Configuring systemd-logind to ignore lid switch..."

# Create logind config directory if it doesn't exist
mkdir -p /etc/systemd/logind.conf.d

# Configure logind to ignore lid switch (let Sway handle it)
cat > /etc/systemd/logind.conf.d/99-ignore-lid.conf << 'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

echo "Created /etc/systemd/logind.conf.d/99-ignore-lid.conf"

# Restart logind to apply changes
systemctl restart systemd-logind.service

echo ""
echo "✓ logind configured to ignore lid switch"
echo "✓ Sway will now handle lid close events"
echo ""
echo "Now add this to your Sway config (~/.config/sway/config):"
echo ""
echo "    bindswitch --reload --locked lid:on exec 'swaylock --indicator-caps-lock -f && systemctl suspend'"
echo ""
echo "Then reload Sway config with: swaymsg reload"
