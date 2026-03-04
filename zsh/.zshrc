[[ $- != *i* ]] && return

# SSH Agent setup (gnome-keyring)
if [[ -n "$DESKTOP_SESSION" ]]; then
    eval $(gnome-keyring-daemon --start 2> /dev/null)
    export SSH_AUTH_SOCK
fi

# Tmux auto-attach
[[ $commands[tmux] ]] && [[ -z "$TMUX" ]] && exec tmux

# ZSH options
autoload -U compinit promptinit colors && colors
setopt completealiases auto_cd append_history share_history histignorealldups histignorespace extended_glob longlistjobs nonomatch notify hash_list_all completeinword nohup auto_pushd pushd_ignore_dups nobeep noglobdots noshwordsplit nohashdirs inc_append_history prompt_subst
promptinit
compinit -i

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

# Completion styles (mostly from grml-zsh-config)
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false
zstyle ':completion:*:history-words'   menu yes
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes
zstyle ':completion:*'                  matcher-list '' \
                                        'm:{a-z\-}={A-Z\_}' \
                                        'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
                                        'r:|?=** m:{a-z\-}={A-Z\_}'
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'
zstyle ':completion:*:options'         description 'yes'
zstyle ':completion:*:processes'       command 'ps -au$USER'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*'                 verbose true
zstyle ':completion:*:-command-:*:'    verbose false
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin
zstyle ':completion:*' special-dirs ..
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
zstyle ':completion:*' menu select

# PATH
export PATH="$HOME/.cabal/bin:$HOME/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:$HOME/bin:/usr/bin/core_perl:/usr/local/scripts:$HOME/.local/bin:/usr/local/texlive/2025/bin/x86_64-linux:$HOME/.ghcup/bin"
if [[ ! -L /bin ]]; then
    export PATH="/bin:/sbin:$PATH"
fi

# Anthropic API key (local, not exported — only passed to nvim/vim via functions)
if [[ -f ~/.dotfiles/.claude_api_key ]]; then
    __anthropic_api_key=$(cat ~/.dotfiles/.claude_api_key)
fi

# Editor
if type nvim &> /dev/null; then
    export EDITOR="nvim"
    vim()  { ANTHROPIC_API_KEY=$__anthropic_api_key command nvim "$@" }
    vi()   { ANTHROPIC_API_KEY=$__anthropic_api_key command nvim "$@" }
elif type vim &> /dev/null; then
    export EDITOR="vim"
    alias vi=vim
else
    export EDITOR="vi"
fi

# Browser
if type zen-browser &> /dev/null; then
    export BROWSER="zen-browser"
elif type firefox-developer-edition &> /dev/null; then
    export BROWSER="firefox-developer-edition"
elif type firefox &> /dev/null; then
    export BROWSER="firefox"
fi

export TERM=tmux-256color
export CC=gcc

# Vi keybindings
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^R' history-incremental-search-backward

# Aliases - general
alias c='clear'
alias e='exit'
alias q='exit'
alias ZZ='exit'
alias edit='$EDITOR'
alias svim='sudoedit'
alias z='source ~/.zshrc'
alias zshrc='$EDITOR ~/.zshrc'

# Aliases - ls (eza > exa > ls)
if type eza &> /dev/null; then
    alias ls='eza -F --group-directories-first'
elif type exa &> /dev/null; then
    alias ls='exa -F --group-directories-first'
fi
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lAFh'
alias lt='ls -ltFh'
alias sl='ls'

# Aliases - grep
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
alias pg='ps -ef | grep --color'

# Aliases - misc
alias less='less -R'
alias t='tail -f'
alias h='history'
alias p='ps -ef'
alias dud='du --max-depth=1 -h'
alias duf='du -sh *'
alias info='info --vi-keys'
[[ $commands[neomutt] ]] && alias mutt=neomutt

# Aliases - pacman (Arch)
alias pacupg='sudo pacman -Syu'
alias pacreps='pacman -Ss'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacremc='sudo pacman -Rnsc'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacfile='pacman -Ql'
alias paclo='pacman -Qdt'
alias pacc='sudo pacman -Sc'
alias pacin='sudo pacman -S'

# Functions
up() {
    local dest=".."
    local limit=${1:-1}
    for ((i=2 ; i <= limit ; i++)); do
         dest=$dest/..
    done
    if [[ -t 1 ]]; then
        cd "$dest"
    elif type realpath &> /dev/null; then
        realpath "$dest"
    else
        echo "$dest"
    fi
}

open() {
    if (($# > 0)); then
        for arg in $@; do
            if [[ -e "$arg" ]]; then
                xdg-open "$arg" &> /dev/null
            else
                echo "Argument '$arg' does not exist"
            fi
        done
    else
        echo "At least one argument required"
        return 1
    fi
}

function extract() {
    if (( $# == 0 )); then
        echo "Usage: extract [file ...]"
        return 1
    fi
    for file in "$@"; do
        if [[ ! -f "$file" ]]; then
            echo "extract: '$file' is not a valid file"
            continue
        fi
        case "$file" in
            (*.tar.gz|*.tgz) tar xvzf "$file" ;;
            (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$file" ;;
            (*.tar.xz|*.txz) tar --xz -xvf "$file" ;;
            (*.tar.zst) tar -I zstd -xvf "$file" ;;
            (*.tar) tar xvf "$file" ;;
            (*.gz) gunzip "$file" ;;
            (*.bz2) bunzip2 "$file" ;;
            (*.xz) unxz "$file" ;;
            (*.zip|*.war|*.jar) unzip "$file" ;;
            (*.rar) unrar x -ad "$file" ;;
            (*.7z) 7za x "$file" ;;
            (*) echo "extract: '$file' cannot be extracted" ;;
        esac
    done
}
alias x=extract

ips() {
    echo "LAN: $(ip route get 8.8.8.8 | awk -F'src ' '!/cache/{print $2}' | awk '{print $1}')"
    echo "WAN: $(curl -s ipv4.icanhazip.com)"
}

# Rust
type rustup &> /dev/null && export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Cursor theme
export XCURSOR_THEME=catppuccin-mocha-dark-cursors
export XCURSOR_SIZE=24

# Fix swaymsg inside tmux when Sway gets restarted
if [[ -v TMUX ]]; then
    swaymsg(){
        export SWAYSOCK=$XDG_RUNTIME_DIR/sway-ipc.$UID.$(pgrep -x sway).sock
        command swaymsg "$@"
    }
fi

# Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Plugins (loaded in turbo mode for fast startup)
zinit light-mode wait lucid for \
    atinit"ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'" \
        zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-completions

# opam (OCaml)
[[ ! -r '/home/chad/.opam/opam-init/init.zsh' ]] || source '/home/chad/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

# Prompt - detect TTY mode and starship availability
if [[ "$TERM" == "linux" ]] || [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" ]]; then
    autoload -U colors && colors
    setopt prompt_subst
    PROMPT='%{$fg[cyan]%}%n@%m%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%}
%{$fg[green]%}%(!.#.$)%{$reset_color%} '
    RPROMPT='%{$fg[red]%}%(?..[%?])%{$reset_color%}'
    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]]; then
            PROMPT='%{$fg[cyan]%}%n@%m%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%}
%{$fg[blue]%}<<%{$reset_color%} '
        else
            PROMPT='%{$fg[cyan]%}%n@%m%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%}
%{$fg[green]%}%(!.#.$)%{$reset_color%} '
        fi
        zle reset-prompt
    }
    zle -N zle-keymap-select
elif ! command -v starship &> /dev/null; then
    autoload -U colors && colors
    setopt prompt_subst
    PROMPT='%{$fg[cyan]%}%n@%m%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%} %{$fg[green]%}>%{$reset_color%} '
    RPROMPT='%{$fg[red]%}%(?..[%?])%{$reset_color%}'
else
    function zle-keymap-select { zle reset-prompt }
    zle -N zle-keymap-select
    eval "$(starship init zsh)"
fi

# zoxide
if type zoxide &> /dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi
