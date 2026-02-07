# crossroads1112's dotfiles

My personal dotfiles for Arch Linux with Sway/Wayland.

## What's included

- **Window Manager**: SwayFX (Sway with effects)
- **Terminal**: foot
- **Shells**: zsh, fish
- **Editor**: neovim
- **File Manager**: nnn
- **Display Manager**: greetd
- **Bar**: waybar
- **Notifications**: mako
- **Launcher**: wofi
- **Terminal Multiplexer**: tmux

## Installation

Clone this repository:
```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

Run the setup script:
```bash
./setup.sh
```

The script will:
1. Install all required packages (official repos + AUR)
2. Back up existing dotfiles to `~/.dotfiles_old`
3. Create symlinks from this repo to your home directory
4. Set up greetd configuration

## Manual steps after installation

1. Restart your shell: `source ~/.zshrc`
2. For fish shell: `fish`
3. Open neovim to install plugins
4. Initialize Rust: `rustup default stable`
5. Reboot to start using Sway with greetd

## Structure

```
~/.dotfiles/
├── config/          # XDG config directory dotfiles
│   ├── nvim/
│   ├── sway/
│   ├── waybar/
│   ├── mako/
│   ├── foot/
│   ├── fish/
│   ├── nnn/
│   ├── swaylock/
│   └── swayr/
├── greetd/          # Display manager config
├── zsh_plugins/     # Zsh plugin configurations
├── zshrc            # Zsh configuration
├── tmux.conf        # tmux configuration
├── muttrc           # Neomutt email configuration
└── setup.sh         # Installation script
```
