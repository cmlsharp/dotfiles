#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/lib.sh"

OFFICIAL_PKGS=(
    greetd
    greetd-regreet
)

AUR_PKGS=(
    catppuccin-mocha-dark-cursors
)

install_official "${OFFICIAL_PKGS[@]}"
install_aur "${AUR_PKGS[@]}"

# Copy greetd config to /etc (requires sudo, not stowable)
bold "==> Copying greetd config to /etc/greetd/..."
sudo mkdir -p /etc/greetd
sudo cp -r "$PKG_DIR/stow/"* /etc/greetd/
sudo systemctl enable greetd

# Configure PAM for automatic gnome-keyring unlocking with greetd
PAM_FILE="/etc/pam.d/system-login"
if ! grep -q "pam_gnome_keyring.so" "$PAM_FILE"; then
    bold "==> Configuring PAM for gnome-keyring..."
    sudo cp "$PAM_FILE" "$PAM_FILE.backup-$(date +%Y%m%d-%H%M%S)"
    sudo sed -i '/^auth.*include.*system-auth/a auth       optional   pam_gnome_keyring.so' "$PAM_FILE"
    sudo sed -i '/^password.*include.*system-auth/a password   optional   pam_gnome_keyring.so use_authtok' "$PAM_FILE"
    sudo sed -i '/^session.*required.*pam_env.so/a session    optional   pam_gnome_keyring.so auto_start' "$PAM_FILE"
    systemctl --user enable --now gcr-ssh-agent.socket
    echo "  ✓ Configured gnome-keyring PAM module"
fi
