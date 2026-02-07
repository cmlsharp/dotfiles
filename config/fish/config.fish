if not status is-interactive
    return
end

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

# Editor
if command -q nvim
    set -gx EDITOR nvim
    alias vim nvim
    alias vi nvim
else if command -q vim
    set -gx EDITOR vim
    alias vi vim
else
    set -gx EDITOR vi
end

# Browser
if command -q firefox-developer-edition
    set -gx BROWSER firefox-developer-edition
else if command -q firefox
    set -gx BROWSER firefox
end

set -gx TERM tmux-256color
set -gx CC gcc

# Tmux auto-attach
if command -q tmux; and not set -q TMUX
    exec tmux
end

# Vi keybindings
fish_vi_key_bindings
bind -M insert jk 'set fish_bind_mode default; commandline -f repaint'

# Aliases - general
alias c clear
alias e exit
alias q exit
alias ZZ exit
alias edit '$EDITOR'
alias svim sudoedit
alias z 'source ~/.config/fish/config.fish'
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
command -q neomutt; and alias mutt neomutt

# Abbreviations - git (expand inline so you can edit before running)
abbr -a g git
abbr -a ga 'git add'
abbr -a gp 'git push'
abbr -a gpl 'git pull'
abbr -a gc 'git commit -v'
abbr -a gm 'git commit -vm'
abbr -a gs 'git status'
abbr -a gd 'git diff'
abbr -a gch 'git checkout'
abbr -a gb 'git branch'
abbr -a gl "git log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Abbreviations - pacman (Arch)
abbr -a pacupg 'sudo pacman -Syu'
abbr -a pacreps 'pacman -Ss'
abbr -a pacloc 'pacman -Qi'
abbr -a paclocs 'pacman -Qs'
abbr -a pacfile 'pacman -Ql'
abbr -a paclo 'pacman -Qdt'
abbr -a pacc 'sudo pacman -Sc'
abbr -a pacin 'sudo pacman -S'
abbr -a chkupd checkupdates

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

# nnn file manager
if command -q nnn
    set -gx NNN_OPTS "deaA"
    set -gx NNN_FCOLORS "c1e2272e006033f7c6d6abc4"
    set -gx NNN_PLUG "p:preview-tui;o:organize;d:diffs;r:renamer;n:nuke;g:gitroot;f:finder;c:chksum"
    set -gx NNN_ARCHIVE '\\.(7z|bz2|gz|tar|tgz|xz|zip|zst)$'
    set -gx NNN_BMS "d:$HOME/Documents;D:$HOME/Downloads;p:$HOME/Pictures;c:$HOME/.config;r:/"
    set -gx NNN_FIFO "/tmp/nnn.fifo."(echo %self)

    # quitcd: cd to last dir on quit (Ctrl-G)
    if test -f /usr/share/nnn/quitcd/quitcd.fish
        source /usr/share/nnn/quitcd/quitcd.fish

        # Override n function: auto-preview only if terminal is wide enough
        function n --wraps nnn --description 'nnn with conditional auto-preview'
            if test -n "$NNNLVL" -a "$NNNLVL" -ge 1
                echo "nnn is already running"
                return
            end
            if test -n "$XDG_CONFIG_HOME"
                set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
            else
                set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
            end

            # Check terminal width - only auto-preview if >= 120 columns
            set cols (tput cols)
            if test $cols -ge 120
                # Terminal wide enough for split preview
                command nnn -P p $argv
            else
                # Terminal too narrow, skip preview
                command nnn $argv
            end

            if test -e $NNN_TMPFILE
                source $NNN_TMPFILE
                rm -- $NNN_TMPFILE
            end
        end
    end
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

