set -g fish_greeting

# SSH Agent setup (gnome-keyring)
if test -n "$WAYLAND_DISPLAY"; or test -n "$SWAYSOCK"
    # Check if SSH socket already exists
    if test -S /run/user/(id -u)/gcr/ssh
        set -gx SSH_AUTH_SOCK /run/user/(id -u)/gcr/ssh
    else
        # Try to start gnome-keyring-daemon with SSH component
        for line in (gnome-keyring-daemon --start --components=ssh 2>/dev/null)
            if string match -q "*=*" $line
                set -l parts (string split '=' $line)
                set -gx $parts[1] $parts[2]
            end
        end
    end
end

# PATH
fish_add_path ~/.cargo/bin ~/.cabal/bin ~/.local/bin ~/bin ~/.ghcup/bin /usr/local/texlive/2025/bin/x86_64-linux

# Anthropic API key (local, not exported — only passed to nvim/vim via functions)
if test -f ~/.dotfiles/.claude_api_key
    set -g __anthropic_api_key (cat ~/.dotfiles/.claude_api_key)
end

# Editor
if command -q nvim
    set -gx EDITOR nvim
    function vim --wraps nvim; ANTHROPIC_API_KEY=$__anthropic_api_key command nvim $argv; end
    function vi --wraps nvim; ANTHROPIC_API_KEY=$__anthropic_api_key command nvim $argv; end
else if command -q vim
    set -gx EDITOR vim
    alias vi vim
else
    set -gx EDITOR vi
end

# Browser
if command -q zen-browser
    set -gx BROWSER zen-browser
else if command -q firefox-developer-edition
    set -gx BROWSER firefox-developer-edition
else if command -q firefox
    set -gx BROWSER firefox
end

set -gx TERM tmux-256color
set -gx CC gcc


# Tmux auto-attach via sesh
if not set -q TMUX; and command -q sesh; and test -n "$DISPLAY" -o -n "$WAYLAND_DISPLAY"
    exec sesh-picker
else if not set -q TMUX; and command -q tmux
    exec tmux
end

# Vi keybindings
fish_vi_key_bindings
bind -M insert jk 'set fish_bind_mode default; commandline -f repaint'

# !! support — sudo wrapper catches "sudo !!" at execution time
function sudo --wraps sudo
    if test "$argv[1]" = '!!'
        echo "sudo $history[1]"
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

# Aliases - general
alias c clear
alias e exit
alias q exit
alias ZZ exit
alias edit '$EDITOR'
alias svim sudoedit
alias r 'source ~/.config/fish/config.fish'
alias fishrc '$EDITOR ~/.config/fish/config.fish'

# Aliases - ls (eza > exa > ls)
if command -q eza
    alias ls 'eza -F --group-directories-first'
else if command -q exa
    alias ls 'exa -F --group-directories-first'
end
alias l 'ls -lh'
alias ll 'ls -lh'
alias la 'ls -lAFh'
alias lt 'ls -ltFh'
alias sl ls

# Aliases - grep
alias grep 'grep --color'
alias sgrep 'grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'
alias pg 'ps -ef | grep --color'

# Aliases - misc
alias less 'less -R'
alias t 'tail -f'
alias h history
alias p 'ps -ef'
alias dud 'du --max-depth=1 -h'
alias duf 'du -sh *'
alias info 'info --vi-keys'
function mutt --wraps neomutt; env TERM=xterm-direct neomutt $argv; end
function claude; CLAUDE_CONFIG_DIR=~/.claude-personal CLAUDE_ACCOUNT=personal command claude $argv; end
function claude-work; CLAUDE_CONFIG_DIR=~/.claude-work CLAUDE_ACCOUNT=work command claude $argv; end

# Abbreviations - pacman (Arch)
abbr -a pacupg 'sudo pacman -Syu'
abbr -a pacreps 'pacman -Ss'
abbr -a pacre 'sudo pacman -R'
abbr -a pacrem 'sudo pacman -Rns'
abbr -a pacremc 'sudo pacman -Rnsc'
abbr -a pacloc 'pacman -Qi'
abbr -a paclocs 'pacman -Qs'
abbr -a pacfile 'pacman -Ql'
abbr -a paclo 'pacman -Qdt'
abbr -a pacc 'sudo pacman -Sc'
abbr -a pacin 'sudo pacman -S'

# Functions

function up -d "Go up N directories"
    set -l n (math max 1, "$argv[1]")
    set -l dest .
    for i in (seq $n)
        set dest "$dest/.."
    end
    cd $dest
end

function open -d "Open files with xdg-open"
    if test (count $argv) -eq 0
        echo "At least one argument required"
        return 1
    end
    for arg in $argv
        if test -e "$arg"
            xdg-open "$arg" &>/dev/null &
        else
            echo "Argument '$arg' does not exist"
        end
    end
end

function extract -d "Extract archives"
    if test (count $argv) -eq 0
        echo "Usage: extract [file ...]"
        return 1
    end
    for file in $argv
        if not test -f "$file"
            echo "extract: '$file' is not a valid file"
            continue
        end
        switch $file
            case '*.tar.gz' '*.tgz'
                tar xvzf $file
            case '*.tar.bz2' '*.tbz' '*.tbz2'
                tar xvjf $file
            case '*.tar.xz' '*.txz'
                tar --xz -xvf $file
            case '*.tar.zst'
                tar -I zstd -xvf $file
            case '*.tar'
                tar xvf $file
            case '*.gz'
                gunzip $file
            case '*.bz2'
                bunzip2 $file
            case '*.xz'
                unxz $file
            case '*.zip' '*.war' '*.jar'
                unzip $file
            case '*.rar'
                unrar x -ad $file
            case '*.7z'
                7za x $file
            case '*'
                echo "extract: '$file' cannot be extracted"
        end
    end
end
alias x extract

function ips -d "Show LAN and WAN IP"
    echo "LAN: "(ip route get 8.8.8.8 | string match -r 'src (\S+)' | tail -1)
    echo "WAN: "(curl -s ipv4.icanhazip.com)
end

# Rust
if command -q rustup
    set -gx RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src
end

# Cursor theme
set -gx XCURSOR_THEME catppuccin-mocha-dark-cursors
set -gx XCURSOR_SIZE 24

# Fix swaymsg inside tmux when Sway gets restarted
if set -q TMUX
    function swaymsg
        command swaymsg $argv
    end
end

# Prompt setup - detect TTY mode and starship availability
if test "$TERM" = "linux"; or test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY"
    # TTY fallback prompt - simple, no fancy characters
    function fish_prompt
        set -l last_status $status
        set_color cyan
        echo -n (whoami)@(hostname)
        set_color normal
        echo -n ' '
        set_color yellow
        echo -n (prompt_pwd)
        set_color normal
        echo
        if test $last_status -ne 0
            set_color red
            echo -n "[$last_status] "
            set_color normal
        end
        set_color green
        echo -n '$ '
        set_color normal
    end

    function fish_mode_prompt
        switch $fish_bind_mode
            case default
                set_color blue
                echo -n '<< '
            case insert
                # nothing
            case replace_one
                set_color yellow
                echo -n 'R '
            case visual
                set_color magenta
                echo -n 'V '
        end
        set_color normal
    end
else if command -q starship
    # Starship available - use it
    starship init fish | source
else
    # Starship not available fallback - simple colored prompt
    function fish_prompt
        set -l last_status $status
        set_color cyan
        echo -n (whoami)@(hostname)
        set_color normal
        echo -n ' '
        set_color yellow
        echo -n (prompt_pwd)
        set_color normal
        echo -n ' '
        if test $last_status -ne 0
            set_color red
            echo -n "[$last_status] "
        end
        set_color green
        echo -n '> '
        set_color normal
    end
end

# fzf integration (built-in, replaces patrickf1/fzf.fish plugin)
if command -q fzf
    set -gx FZF_DEFAULT_OPTS '--height 40% --border top'
    set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_OPTS '--preview "bat --color=always --style=numbers {}"'
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
    fzf --fish | source
    bind -M insert ctrl-e 'vim (fzf); and commandline -f repaint'
end

if command -q zoxide
    zoxide init --cmd cd fish | source
end


# I use tmux, and scacks.nvim can't tell this terminal supports graphics
export SNACKS_KITTY=true

eval (opam env) &> /dev/null
