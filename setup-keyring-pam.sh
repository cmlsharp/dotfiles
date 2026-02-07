#!/bin/bash
# Script to configure PAM for automatic gnome-keyring unlocking with greetd
# Run with: sudo ./setup-keyring-pam.sh

set -e

PAM_FILE="/etc/pam.d/system-login"
BACKUP_FILE="/etc/pam.d/system-login.backup-$(date +%Y%m%d-%H%M%S)"

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)"
    exit 1
fi

# Create backup
echo "Creating backup at $BACKUP_FILE..."
cp "$PAM_FILE" "$BACKUP_FILE"

# Check if already configured
if grep -q "pam_gnome_keyring.so" "$PAM_FILE"; then
    echo "gnome-keyring PAM module already configured in $PAM_FILE"
    echo "Backup created at: $BACKUP_FILE"
    exit 0
fi

# Add gnome-keyring PAM lines
echo "Adding gnome-keyring PAM configuration..."

# Add after the auth include line
sed -i '/^auth.*include.*system-auth/a auth       optional   pam_gnome_keyring.so' "$PAM_FILE"

# Add after the password include line
sed -i '/^password.*include.*system-auth/a password   optional   pam_gnome_keyring.so use_authtok' "$PAM_FILE"

# Add after the session required pam_env.so line (at the end of session section)
sed -i '/^session.*required.*pam_env.so/a session    optional   pam_gnome_keyring.so auto_start' "$PAM_FILE"

echo "✓ Successfully configured gnome-keyring PAM module"
echo "✓ Backup saved at: $BACKUP_FILE"
echo ""
echo "The keyring will now automatically unlock when you log in via greetd."
echo "You may need to log out and log back in for changes to take effect."
