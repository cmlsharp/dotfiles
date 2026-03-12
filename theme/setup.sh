#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

# Stow config files
stow -d "$PKG_DIR" -t "$HOME" stow

# ── Fetch theme backgrounds from omarchy ─────────────────────────
BG_DIR="$HOME/.config/theme/backgrounds"
OMARCHY_REPO="https://github.com/basecamp/omarchy.git"

if [ -d "$BG_DIR/catppuccin-mocha" ] && [ "$(find "$BG_DIR" -type f -name '*.png' -o -name '*.jpg' -o -name '*.webp' 2>/dev/null | head -1)" ]; then
    bold "==> Theme backgrounds already present, skipping download"
else
    bold "==> Fetching theme backgrounds from omarchy..."
    tmpdir=$(mktemp -d)
    trap "rm -rf '$tmpdir'" EXIT

    git clone --depth 1 --filter=blob:none --sparse "$OMARCHY_REPO" "$tmpdir" 2>/dev/null
    cd "$tmpdir"
    git sparse-checkout set themes/*/backgrounds 2>/dev/null

    mkdir -p "$BG_DIR"
    for theme_dir in themes/*/backgrounds; do
        [ -d "$theme_dir" ] || continue
        theme=$(basename "$(dirname "$theme_dir")")
        target="$theme"
        # omarchy uses "catppuccin" for mocha
        [ "$theme" = "catppuccin" ] && target="catppuccin-mocha"
        mkdir -p "$BG_DIR/$target"
        cp -n "$theme_dir"/* "$BG_DIR/$target/" 2>/dev/null || true
    done

    cd "$DOTFILES_DIR"
    bold "==> Theme backgrounds downloaded"
fi

# ── Set initial theme if not already set ─────────────────────────
if [ ! -e "$HOME/.config/theme/current" ]; then
    bold "==> Setting initial theme to catppuccin-mocha..."
    theme-set catppuccin-mocha
fi
