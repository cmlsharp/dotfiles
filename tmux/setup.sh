#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

OFFICIAL_PKGS=(
    tmux
)

AUR_PKGS=(
    sesh-bin
    tmux-mem-cpu-load
)
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
install_official "${OFFICIAL_PKGS[@]}"
install_aur "${AUR_PKGS[@]}"

stow --dotfiles -d "$PKG_DIR" -t "$HOME" stow
