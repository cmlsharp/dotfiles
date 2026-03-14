#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

OFFICIAL_PKGS=(
    # Compositor & core
    hyprland
    hypridle
    hyprlock
    hyprshot
    hyprtoolkit
    hyprsunset
    swaybg
    gum

    # Bar, notifications, launcher
    waybar
    swaync
    rofi
    wlogout

    # Terminal
    kitty

    # Wayland utilities
    grim
    slurp
    hyprpicker
    satty
    wl-clipboard
    brightnessctl
    cliphist
    playerctl
    fzf
    imv
    libnotify
    xdg-utils
    udiskie

    # Audio
    pipewire-pulse
    pavucontrol

    # Network
    networkmanager

    # Bluetooth
    bluez
    bluetui

    # System monitor
    btop

    # File manager
    yazi

    # Screen sharing
    xwaylandvideobridge

    # CLI deps used by scripts
    curl
    jq

    # Fonts
    ttf-jetbrains-mono-nerd
    noto-fonts-emoji

    # Theming
    papirus-icon-theme
    kvantum
)

AUR_PKGS=(
    # Window switcher
    snappy-switcher

    # Display config
    nwg-displays

    # Screen recording
    gpu-screen-recorder

    # Browser
    zen-browser-bin

    yaru-icon-theme

    # Cursor & GTK themes
    catppuccin-gtk-theme-mocha


    # Bitwarden integration
    rofi-rbw-git
    rbw-pinentry-keyring

    # Launcher
    walker-bin
    elephant-bin
    elephant-bitwarden-bin
    elephant-calc-bin
    elephant-clipboard-bin
    elephant-desktopapplications-bin
    elephant-files-bin
    elephant-providerlist-bin
    elephant-symbols-bin
    elephant-websearch-bin

    # Audio
    wiremix
    wlctl
)

install_official "${OFFICIAL_PKGS[@]}"
install_aur "${AUR_PKGS[@]}"

# Pre-create directories so stow symlinks files, not directories
mkdir -p ~/.config/systemd/user

# Stow config files
stow --dotfiles -d "$PKG_DIR" -t "$HOME" stow

# Configure GTK/Qt theming
bold "==> Configuring GTK/Qt theming..."

GTK_THEME="catppuccin-mocha-mauve-standard+default"
ICON_THEME="Papirus-Dark"
CURSOR_THEME="catppuccin-mocha-dark-cursors"
CURSOR_SIZE=24
FONT="Adwaita Sans 11"

# GTK 2.0
cat > ~/.gtkrc-2.0 << EOF
gtk-theme-name="$GTK_THEME"
gtk-icon-theme-name="$ICON_THEME"
gtk-font-name="$FONT"
gtk-cursor-theme-name="$CURSOR_THEME"
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-toolbar-style=3
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintslight"
gtk-xft-rgba="rgb"
EOF

# GTK 3.0
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-font-name=$FONT
gtk-cursor-theme-name=$CURSOR_THEME
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-application-prefer-dark-theme=1
gtk-decoration-layout=icon:minimize,maximize,close
gtk-enable-animations=true
EOF

# GTK 4.0
mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << EOF
[Settings]
gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-font-name=$FONT
gtk-cursor-theme-name=$CURSOR_THEME
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-application-prefer-dark-theme=1
EOF

# GTK 4.0 theme symlinks
GTK4_THEME="/usr/share/themes/$GTK_THEME/gtk-4.0"
if [ -d "$GTK4_THEME" ]; then
    ln -sf "$GTK4_THEME/assets" ~/.config/gtk-4.0/assets
    ln -sf "$GTK4_THEME/gtk.css" ~/.config/gtk-4.0/gtk.css
    ln -sf "$GTK4_THEME/gtk-dark.css" ~/.config/gtk-4.0/gtk-dark.css
fi

# Kvantum (Qt theming)
mkdir -p ~/.config/Kvantum
cat > ~/.config/Kvantum/kvantum.kvconfig << EOF
[General]
theme=Catppuccin-Mocha-Mauve
EOF

# Enable systemd user services
bold "==> Enabling systemd user services..."
systemctl --user daemon-reload
systemctl --user enable --now battery-notify.timer || warn "battery-notify.timer failed to enable"
systemctl --user enable --now hypridle.service || warn "hypridle.service failed to enable"
systemctl --user enable --now elephant.service || warn "elephant.service failed to enable"

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
