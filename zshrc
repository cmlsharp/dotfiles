PROMPT="λ %~/ " 
#ZSH options
autoload -U compinit promptinit
promptinit
compinit -i
zstyle ':completion:*' menu select
setopt completealiases
setopt HIST_IGNORE_DUPS
bindkey -v
[[ -z "$TMUX" ]] && exec tmux
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl:/home/chad/.gem/ruby/2.1.0/bin:/home/chad/bin"
export EDITOR="vim"
export BROWSER="/home/chad/.local/share/firefox/firefox"

#Aliases
alias wftop='sudo iftop -i wlp3s0'
alias tc1='truecrypt --fs-options=users,uid=$(id -u),gid=$(id -g),fmask=0113,dmask=0002 --mount /home/chad/public/crypt.tc"" /home/chad/public/crypt'
alias utc='truecrypt -t -d'
alias wspeed='speedometer -r wlp3s0 -t wlp3s0' 
alias c='clear'
alias vimrc='vim /home/chad/.vimrc'
alias chkupd='checkupdates'
alias m="mpd ~/.config/mpd/mpd.conf"
alias n="ncmpcpp"
alias pacupg='sudo snp pacman -Syu'
alias yaupg='sudo snp yaourt -Syua'
alias rollback='sudo rollback'
alias snp='sudo snp'
alias nfs='sudo mount -t nfs mmfab-server:/mnt/MMFAB/ /mnt/NAS -o nolock -v'
alias unfs='sudo umount /mnt/NAS'
export MOUNT="/mnt/NAS/Chad"
alias dc='cd'
alias e='exit'
alias z='source ~/.zshrc'
alias pg='ps -ef | grep --color'
alias svim='sudo -E vim'
alias dfh='df -h'
alias /='cd /'
alias vi='vim'
alias ivm='vim'
alias q='exit'
alias ZZ='exit'

alias pacin='sudo pacman -S'
alias pacins='sudo pacman -U'
alias pacupd="sudo pacman -Sy && sudo abs"
alias pacinsd='sudo pacman -S --asdeps'
alias paclf='pacman -Ql'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacmir='sudo pacman -Syy'
alias paclo='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs (pacman -Qtdq)'
alias pacro="pacman -Qtdq > /dev/null && sudo pacman -Rns \$(pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"
alias pacunlock="sudo rm /var/lib/pacman/db.lck"
alias paclock="sudo touch /var/lib/pacman/db.lck"
alias pacupga='sudo pacman -Syu && sudo abs'
alias pacaur='pacman -Qm'
alias pacremc='sudo pacman -Rnsc'
alias pacc='sudo pacman -Sc'
alias paccc='sudo pacman -Scc'
alias pacdown='sudo pacman -Sw'

alias yaconf='yaourt -C'
alias yasu='yaourt --sucre'
alias yain='yaourt -S'
alias yains='yaourt -U'
alias yare='yaourt -R'
alias yarem='yaourt -Rns'
alias yarep='yaourt -Si'
alias yareps='yaourt -Ss'
alias yaloc='yaourt -Qi'
alias yalocs='yaourt -Qs'
alias yalst='yaourt -Qe'
alias yaorph='yaourt -Qtd'
alias yaupga='sudo yaourt -Syua && sudo abs'
alias yamir='yaourt -Syy'
alias yasug='yaourt -Syua  --sucre'
alias yaremc='yaourt -Rnsc'

alias ls='ls --color'
alias l='ls -lFh'  
alias la='ls -lAFh' 
alias lr='ls -tRFh'  
alias lt='ls -ltFh'   
alias ll='ls -l'      
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1FcArt'
alias lrt='ls -1Fcrt'

alias zshrc='vim ~/.zshrc'

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'


alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep --color'
alias -g L="| less"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias edit='vim'

alias dud='du --max-depth=1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias p='ps -ef'
alias sortnr='sort -n -r'
if [ ${ZSH_VERSION//\./} -ge 420 ]; then
  _browser_fts=(htm html de org net com at cx nl se dk dk php)
  for ft in $_browser_fts ; do alias -s $ft=$BROWSER ; done

  _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
  for ft in $_editor_fts ; do alias -s $ft=$EDITOR ; done

  _image_fts=(jpg jpeg png gif mng tiff tif xpm)
  for ft in $_image_fts ; do alias -s $ft=$XIVIEWER; done

  _media_fts=(ape avi flv mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
  for ft in $_media_fts ; do alias -s $ft=mplayer ; done

  alias -s pdf=acroread
  alias -s ps=gv
  alias -s dvi=xdvi
  alias -s chm=xchm
  alias -s djvu=djview

  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
  alias -s tar.gz="echo "
  alias -s ace="unace l"
fi

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
bindkey -M viins 'jj' vi-cmd-mode

#systemd
user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment)

sudo_commands=(
  start stop reload restart try-restart suspend isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done
alias sc-dr='sudo systemctl daemon-reload'
snapper_commands=(
rollback create delete undochange list
)
for i in $snapper_commands; do; alias snp-$i="sudo snapper $i"; done
#Web search
function web_search() {

  # get the open command
  local open_cmd
  if [[ $(uname -s) == 'Darwin' ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  # check whether the search engine is supported
  if [[ ! $1 =~ '(google|bing|yahoo|duckduckgo)' ]];
  then
    echo "Search engine $1 not supported."
    return 1
  fi

  local url="http://www.$1.com"

  # no keyword provided, simply open the search engine homepage
  if [[ $# -le 1 ]]; then
    $open_cmd "$url"
    return
  fi
  if [[ $1 == 'duckduckgo' ]]; then
  #slightly different search syntax for DDG
    url="${url}/?q="
  else
    url="${url}/search?q="
  fi
  shift   # shift out $1

  while [[ $# -gt 0 ]]; do
    url="${url}$1+"
    shift
  done

  url="${url%?}" # remove the last '+'
  
  $open_cmd "$url"
}


alias bing='web_search bing'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias youtube='web_search duckduckgo \!yt'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'
source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#Extract function

function extract() {
  local remove_archive
  local success
  local file_name
  local extract_dir

  if (( $# == 0 )); then
    echo "Usage: extract [-option] [file ...]"
    echo
    echo Options:
    echo "    -r, --remove    Remove archive."
    echo
  fi

  remove_archive=1
  if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
    remove_archive=0 
    shift
  fi

  while (( $# > 0 )); do
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" 1>&2
      shift
      continue
    fi

    success=0
    file_name="$( basename "$1" )"
    extract_dir="$( echo "$file_name" | sed "s/\.${1##*.}//g" )"
    case "$1" in
      (*.tar.gz|*.tgz) tar xvzf "$1" ;;
      (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
      (*.tar.xz|*.txz) tar --xz --help &> /dev/null \
        && tar --xz -xvf "$1" \
        || xzcat "$1" | tar xvf - ;;
      (*.tar.zma|*.tlz) tar --lzma --help &> /dev/null \
        && tar --lzma -xvf "$1" \
        || lzcat "$1" | tar xvf - ;;
      (*.tar) tar xvf "$1" ;;
      (*.gz) gunzip "$1" ;;
      (*.bz2) bunzip2 "$1" ;;
      (*.xz) unxz "$1" ;;
      (*.lzma) unlzma "$1" ;;
      (*.Z) uncompress "$1" ;;
      (*.zip|*.war|*.jar) unzip "$1" -d $extract_dir ;;
      (*.rar) unrar x -ad "$1" ;;
      (*.7z) 7za x "$1" ;;
      (*.deb)
        mkdir -p "$extract_dir/control"
        mkdir -p "$extract_dir/data"
        cd "$extract_dir"; ar vx "../${1}" > /dev/null
        cd control; tar xzvf ../control.tar.gz
        cd ../data; tar xzvf ../data.tar.gz
        cd ..; rm *.tar.gz debian-binary
        cd ..
      ;;
      (*) 
        echo "extract: '$1' cannot be extracted" 1>&2
        success=1 
      ;; 
    esac

    (( success = $success > 0 ? $success : $? ))
    (( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
    shift
  done
}

alias x=extract

#catimg

function catimg() {
  if [[ -x  `which convert` ]]; then
    zsh ~/.catimg/catimg.sh $@
  else
    echo "catimg need convert (ImageMagick) to work)"
  fi
}
function catsay(){
cat $1 | cowsay
}

function catthink(){
cat $1 | cowthink
}
