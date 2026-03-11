#!/bin/bash
# Shared helpers for per-package setup scripts

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

bold() {
    echo -e "${GREEN}$(tput bold)$@$(tput sgr0)${NC}"
}

warn() {
    echo -e "${YELLOW}$@${NC}"
}

error() {
    echo -e "${RED}$@${NC}"
}

ensure_arch() {
    if [ ! -f /etc/arch-release ]; then
        error "This script is designed for Arch Linux."
        exit 1
    fi
}

ensure_yay() {
    if ! command -v yay &> /dev/null; then
        bold "==> Installing yay (AUR helper)..."
        sudo pacman -S --needed --noconfirm git base-devel
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd -
    fi
}

install_official() {
    if [ $# -gt 0 ]; then
        bold "==> Installing official packages..."
        sudo pacman -S --needed --noconfirm "$@" || warn "Some official packages failed to install"
    fi
}

install_aur() {
    if [ $# -gt 0 ]; then
        ensure_yay
        bold "==> Installing AUR packages..."
        yay -S --needed --noconfirm "$@" || warn "Some AUR packages failed to install"
    fi
}
