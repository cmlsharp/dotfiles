#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

OFFICIAL_PKGS=(
    zsh

    # Navigation & search
    fzf
    zoxide
    fd
    ripgrep

    # CLI utilities
    eza
    bat
    git
    curl
    jq
    htop
    ncdu

    # Clipboard (Wayland)
    wl-clipboard

    # Security
    gnome-keyring
)

AUR_PKGS=(
    zsh-theme-powerlevel10k
)

install_official "${OFFICIAL_PKGS[@]}"
install_aur "${AUR_PKGS[@]}"

stow --dotfiles -d "$PKG_DIR" -t "$HOME" stow
