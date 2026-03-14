#!/bin/bash
# Dotfiles setup script - runs per-package setup scripts
#
# Usage:
#   ./setup.sh          # Set up all packages
#   ./setup.sh fish nvim # Set up specific packages

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    error "This script is designed for Arch Linux."
    exit 1
fi

# Install stow (needed by all packages)
sudo pacman -S --needed --noconfirm stow

ALL_PKGS=()
for setup in "$DOTFILES_DIR"/*/setup.sh; do
    ALL_PKGS+=("$(basename "$(dirname "$setup")")")
done

if [ $# -gt 0 ]; then
    PKGS=("$@")
else
    PKGS=("${ALL_PKGS[@]}")
fi

for pkg in "${PKGS[@]}"; do
    if [ -f "$DOTFILES_DIR/$pkg/setup.sh" ]; then
        bold "==> Setting up $pkg..."
        bash "$DOTFILES_DIR/$pkg/setup.sh"
    else
        warn "No setup.sh found for $pkg, skipping"
    fi
done

bold "==> Setup complete!"
