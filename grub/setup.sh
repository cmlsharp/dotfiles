#!/bin/bash
set -e

PKG_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

source "$DOTFILES_DIR/lib.sh"

# Copy grub theme (requires sudo, not stowable)
THEME_DIR="/boot/grub/themes/dotfiles"
bold "==> Installing grub theme to $THEME_DIR..."
sudo mkdir -p "$THEME_DIR"
sudo cp "$PKG_DIR/stow/theme.txt" "$THEME_DIR/theme.txt"
echo "  ✓ Theme installed"
echo "  NOTE: Set GRUB_THEME=\"$THEME_DIR/theme.txt\" in /etc/default/grub"
echo "  then run: sudo grub-mkconfig -o /boot/grub/grub.cfg"
