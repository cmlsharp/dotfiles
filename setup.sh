#!/bin/bash
# Dotfiles setup script - installs packages and creates symlinks

set -e  # Exit on error

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_old"

# Package arrays
OFFICIAL_PKGS=(
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
    wlogout

    # Sway utilities (screenshots, clipboard, brightness)
    grim
    slurp
    wl-clipboard
    brightnessctl
    cliphist
    playerctl

    # Audio
    pipewire-pulse

    # Network
    networkmanager
    nm-applet

    # File utilities
    git
    fzf
    ripgrep
    fd
    eza
    bat
    htop
    ncdu

    # Email and utilities
    neomutt
    abook
    gdb

    # Fonts
    ttf-sourcecodepro-nerd
    noto-fonts-emoji

    # Themes
    papirus-icon-theme

    # Rust toolchain
    rustup
)

AUR_PKGS=(
    # Sway (fork with effects)
    swayfx
    swaylock-effects
    swayr

    # Themes
    catppuccin-mocha-dark-cursors
    catppuccin-gtk-theme-mocha
    papirus-folders-catppuccin-git

    # AUR helper
    yay
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

# Build nnn-restorepreview
if [ -d "$DOTFILES_DIR/nnn-restorepreview" ]; then
    cd "$DOTFILES_DIR/nnn-restorepreview"
    makepkg -si --noconfirm --skipinteg || warn "nnn-restorepreview installation failed"
    cd "$DOTFILES_DIR"
else
    warn "nnn-restorepreview directory not found, skipping"
fi


# Create backup directory
bold "==> Creating backup directory at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Function to safely create symlink
create_symlink() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            echo "  ✓ $dest already linked correctly"
            return
        fi
        warn "  Backing up existing $dest"
        mv "$dest" "$BACKUP_DIR/"
    fi

    ln -s "$src" "$dest"
    echo "  ✓ Linked $dest -> $src"
}

# Create symlinks for root-level dotfiles
bold "==> Creating symlinks for root-level dotfiles..."
create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/gdbinit" "$HOME/.gdbinit"
create_symlink "$DOTFILES_DIR/abookrc" "$HOME/.abookrc"
create_symlink "$DOTFILES_DIR/muttrc" "$HOME/.muttrc"
create_symlink "$DOTFILES_DIR/mailcap" "$HOME/.mailcap"
create_symlink "$DOTFILES_DIR/gpg.conf" "$HOME/.gpg.conf"

# Create symlink for mutt directory if it exists
if [ -d "$DOTFILES_DIR/mutt" ]; then
    create_symlink "$DOTFILES_DIR/mutt" "$HOME/.mutt"
fi

# Create symlinks for zsh_plugins if it exists
if [ -d "$DOTFILES_DIR/zsh_plugins" ]; then
    create_symlink "$DOTFILES_DIR/zsh_plugins" "$HOME/.zsh_plugins"
fi

# Create symlinks for .config directories
bold "==> Creating symlinks for .config directories..."
mkdir -p "$HOME/.config"

for config_dir in nvim sway waybar swaync wlogout foot fish nnn swaylock swayr bat btop git environment.d; do
    if [ -d "$DOTFILES_DIR/config/$config_dir" ]; then
        create_symlink "$DOTFILES_DIR/config/$config_dir" "$HOME/.config/$config_dir"
    fi
done

# Special handling for greetd (requires sudo)
if [ -d "$DOTFILES_DIR/greetd" ]; then
    bold "==> Setting up greetd configuration..."
    warn "This requires sudo to copy greetd config to /etc/greetd/"
    sudo mkdir -p /etc/greetd
    sudo cp -r "$DOTFILES_DIR/greetd/"* /etc/greetd/
    sudo systemctl enable greetd
    echo "  ✓ Copied greetd config to /etc/greetd/ and enabled service"
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

# Systemd user services setup
bold "==> Setting up systemd user services..."
mkdir -p "$HOME/.config/systemd/user"

if [ -d "$DOTFILES_DIR/systemd/user" ]; then
    for unit_file in "$DOTFILES_DIR/systemd/user"/*.service "$DOTFILES_DIR/systemd/user"/*.timer; do
        if [ -f "$unit_file" ]; then
            unit_name=$(basename "$unit_file")
            create_symlink "$unit_file" "$HOME/.config/systemd/user/$unit_name"
        fi
    done
    systemctl --user daemon-reload
    systemctl --user enable --now battery-notify.timer || warn "battery-notify.timer failed to enable"
    echo "  ✓ Systemd user services configured"
fi

bold "==> Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. For fish shell setup, run: fish"
echo "  3. Open neovim to install plugins"
echo "  4. Initialize rustup: rustup default stable"
echo "  5. Reboot to start using Sway with greetd"
echo ""
echo "Backups of replaced files are in: $BACKUP_DIR"
