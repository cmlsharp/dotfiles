#!/bin/bash
# Dotfiles setup script - installs packages and creates symlinks

set -e  # Exit on error

DOTFILES_DIR="$HOME/.dotfiles"

# Package arrays
OFFICIAL_PKGS=(
    # Dotfile manager
    stow

    # Shells and terminal multiplexer
    zsh
    fish
    tmux

    # Editor
    neovim
    python
    python-pip

    # Sway/Wayland window manager
    greetd
    greetd-tuigreet
    greetd-regreet
    swaybg
    swayidle
    waybar
    swaync
    wofi
    foot
    kitty
    wlogout
    kanshi

    # Sway utilities (screenshots, clipboard, brightness, recording)
    grim
    slurp
    wl-clipboard
    brightnessctl
    cliphist
    playerctl
    wf-recorder
    wl-mirror
    libnotify

    # Audio
    pipewire-pulse
    pavucontrol

    # Network
    networkmanager
    nm-applet
    nm-connection-editor

    # Bluetooth
    bluez

    # File utilities
    git
    fzf
    ripgrep
    fd
    eza
    bat
    htop
    btop
    ncdu
    jq
    curl
    zoxide
    xdg-utils

    # Document viewer
    zathura
    zathura-pdf-mupdf

    # Email and utilities
    neomutt
    abook
    elinks
    urlscan
    mpv
    gdb

    # Shell prompt
    starship

    # Security
    gnome-keyring

    # Dev tools
    stylua

    # Fonts
    ttf-sourcecodepro-nerd
    noto-fonts-emoji

    # Themes
    papirus-icon-theme
    kvantum

    # Rust toolchain
    rustup
)

AUR_PKGS=(
    # Sway (fork with effects)
    swayfx
    swaylock-effects
    swayr
    wdisplays-persistent
    sesh-bin

    # Browser
    zen-browser-bin

    # Tmux
    tmux-mem-cpu-load

    # Themes
    catppuccin-mocha-dark-cursors
    catppuccin-gtk-theme-mocha
    papirus-folders-catppuccin-git

    # AUR helper
    paru
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

bold() {
    echo -e "${GREEN}$(tput bold)$@$(tput sgr0)${NC}"
}

warn() {
    echo -e "${YELLOW}$@${NC}"
}

error() {
    echo -e "${RED}$@${NC}"
}

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    error "This script is designed for Arch Linux."
    exit 1
fi

bold "==> Updating system..."
sudo pacman -Syu --noconfirm

# Install yay if not present
if ! command -v yay &> /dev/null; then
    bold "==> Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
fi

# Install official packages
if [ ${#OFFICIAL_PKGS[@]} -gt 0 ]; then
    bold "==> Installing official packages..."
    sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}" || warn "Some official packages failed to install"
fi

# Install AUR packages
if [ ${#AUR_PKGS[@]} -gt 0 ]; then
    bold "==> Installing AUR packages..."
    yay -S --needed --noconfirm "${AUR_PKGS[@]}" || warn "Some AUR packages failed to install"
fi

# Build and install custom packages
bold "==> Building and installing custom packages..."

# Create symlinks using GNU stow
bold "==> Stowing dotfile packages..."
STOW_PKGS=(zsh fish tmux nvim gdb mutt sway)
for pkg in "${STOW_PKGS[@]}"; do
    stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg" || warn "Failed to stow $pkg"
done

# Special handling for greetd (requires sudo)
if [ -d "$DOTFILES_DIR/greetd" ]; then
    bold "==> Setting up greetd configuration..."
    warn "This requires sudo to copy greetd config to /etc/greetd/"
    sudo mkdir -p /etc/greetd
    sudo cp -r "$DOTFILES_DIR/greetd/"* /etc/greetd/
    sudo systemctl enable greetd
    echo "  ✓ Copied greetd config to /etc/greetd/ and enabled service"

    # Configure PAM for automatic gnome-keyring unlocking with greetd
    PAM_FILE="/etc/pam.d/system-login"
    if ! grep -q "pam_gnome_keyring.so" "$PAM_FILE"; then
        bold "==> Configuring PAM for gnome-keyring..."
        sudo cp "$PAM_FILE" "$PAM_FILE.backup-$(date +%Y%m%d-%H%M%S)"
        sudo sed -i '/^auth.*include.*system-auth/a auth       optional   pam_gnome_keyring.so' "$PAM_FILE"
        sudo sed -i '/^password.*include.*system-auth/a password   optional   pam_gnome_keyring.so use_authtok' "$PAM_FILE"
        sudo sed -i '/^session.*required.*pam_env.so/a session    optional   pam_gnome_keyring.so auto_start' "$PAM_FILE"
        echo "  ✓ Configured gnome-keyring PAM module"
    fi
fi

# Firefox userChrome.css setup
if [ -f "$DOTFILES_DIR/firefox/userChrome.css" ]; then
    bold "==> Setting up Firefox userChrome.css..."
    # Find default Firefox profile (typically ends with .default-release or .default)
    FIREFOX_PROFILE=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default-release" -o -name "*.default" 2>/dev/null | head -1)

    if [ -n "$FIREFOX_PROFILE" ]; then
        mkdir -p "$FIREFOX_PROFILE/chrome"
        cp "$DOTFILES_DIR/firefox/userChrome.css" "$FIREFOX_PROFILE/chrome/userChrome.css"
        echo "  ✓ Copied userChrome.css to Firefox profile"
        echo "  Note: Enable 'toolkit.legacyUserProfileCustomizations.stylesheets' in about:config if not already enabled"
    else
        warn "  Firefox profile not found. Create a Firefox profile and re-run this script."
    fi
fi

# Systemd user services setup (stowed via desktop package)
bold "==> Enabling systemd user services..."
systemctl --user daemon-reload
systemctl --user enable --now battery-notify.timer || warn "battery-notify.timer failed to enable"
echo "  ✓ Systemd user services configured"

bold "==> Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. For fish shell setup, run: fish"
echo "  3. Open neovim to install plugins"
echo "  4. Initialize rustup: rustup default stable"
echo "  5. Reboot to start using Sway with greetd"
