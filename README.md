# dotfiles

Personal dotfiles for Arch Linux with Hyprland/Wayland, managed with [GNU Stow](https://www.gnu.org/software/stow/) using `--dotfiles` mode (`dot-` prefix maps to `.` when stowed).

## Stow packages

Each top-level directory is a stow package whose contents mirror `$HOME`.

| Package | Contents |
|---------|----------|
| `fish` | Fish shell config, Starship prompt |
| `gdb` | `.gdbinit` |
| `git` | Git config |
| `hyprland` | Hyprland, Waybar, SwayNC, kitty, rofi, walker, btop, menu system, theming engine, screen recording, scripts |
| `mutt` | Neomutt, mailcap, abook |
| `nvim` | Neovim config (lazy.nvim), zathura |
| `tmux` | tmux config, sesh-picker |
| `zsh` | Zsh config, Powerlevel10k |

Non-stow directories:
- `greetd/` — copied to `/etc/greetd/` with sudo (stow can't target `/etc`)
- `grub/` — GRUB theme, copied with sudo

## Installation

```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

The setup script installs packages (pacman + AUR), stows all dotfile packages, configures greetd, GTK/Qt theming, and sets up systemd user services.

## Usage

Stow a single package:
```bash
stow --dotfiles -d ~/.dotfiles/<package> -t ~ stow
```

Restow (repair symlinks):
```bash
stow --dotfiles -R -d ~/.dotfiles/<package> -t ~ stow
```

Unstow:
```bash
stow --dotfiles -D -d ~/.dotfiles/<package> -t ~ stow
```
