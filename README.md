# dotfiles

Personal dotfiles for Arch Linux with Sway/Wayland, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stow packages

Each top-level directory is a stow package whose contents mirror `$HOME`.

| Package | Contents |
|---------|----------|
| `zsh` | `.zshrc` |
| `fish` | `.config/fish/` |
| `tmux` | `.tmux.conf` |
| `nvim` | `.config/nvim/`, `.config/zathura/` |
| `gdb` | `.gdbinit` |
| `mutt` | `.muttrc`, `.mailcap`, `.mutt/`, `.abookrc` |
| `sway` | `.config/sway/`, `.config/waybar/`, `.config/swaync/`, `.config/swaylock/`, `.config/swayr/`, `.config/wlogout/`, `.config/foot/`, `.config/kitty/`, `.config/btop/`, `.config/environment.d/`, `.config/mako/`, `.config/systemd/` |

Non-stow directories:
- `greetd/` — copied to `/etc/greetd/` with sudo (stow can't target `/etc`)
- `grub/` — GRUB configuration

## Installation

```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

The setup script installs packages (pacman + AUR), stows all dotfile packages, configures greetd, and sets up systemd user services.

## Usage

Stow a single package:
```bash
cd ~/.dotfiles
stow -t ~ <package>
```

Restow (repair symlinks):
```bash
stow -t ~ -R <package>
```

Unstow:
```bash
stow -t ~ -D <package>
```
