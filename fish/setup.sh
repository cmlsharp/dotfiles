#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

OFFICIAL_PKGS=(
    # Shell & multiplexer
    fish
    tmux

    # Prompt
    starship

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
    # Session manager
    sesh-bin

    # Tmux status bar
    tmux-mem-cpu-load
)

install_official "${OFFICIAL_PKGS[@]}"
install_aur "${AUR_PKGS[@]}"

# Pre-create directory so stow symlinks files, not directories
mkdir -p ~/.config/fish

stow --dotfiles -d "$PKG_DIR" -t "$HOME" stow
