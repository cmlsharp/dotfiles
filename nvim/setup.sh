#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

OFFICIAL_PKGS=(
    neovim
    python
    python-pip

    # Formatter
    stylua

    # PDF viewer (used by vimtex)
    zathura
    zathura-pdf-mupdf

    # Rust toolchain (needed for rust-analyzer)
    rustup

    # Fonts
    ttf-jetbrains-mono-nerd
)

install_official "${OFFICIAL_PKGS[@]}"

# Pre-create directory so stow symlinks files, not directories
mkdir -p ~/.config/nvim

stow --dotfiles -d "$PKG_DIR" -t "$HOME" stow
