dir=~/.dotfiles # dotfiles directory
olddir=~/.dotfiles_old # old dotfiles backup directory
files="zshrc vimrc tmux.conf vimperatorrc zsh_plugins mailcap mutt muttrc" # list of files/folders to symlink in homedir
dotfilesrepo="crossroads1112/dotfiles"

bold(){
    echo "$(tput bold)$@$(tput sgr0)"
}

if [[ ! -d $dir || ! -d $dir/.git ]]; then
    bold "Either dotfiles directory does not exist or there is no git repo there. Moving to ${dir}.bak"
    mv $dir ${dir}.bak
    mkdir -p $dir
    cd $dir
    bold "Setting up git repo"
    git init
    git remote add origin-https https://github.com/$dotfilesrepo
    git remote add origin git@github.com:$dotfilesrepo 
    git pull origin-https master
fi
bold "Decrypting mutt passwords"
scrypt enc $dir/mypw.gpg.bfe > ~/.mypw.gpg

bold "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
bold "Done"

bold "Changing to the $dir directory ..."
cd $dir
bold "Done"

for file in $files; do
    bold "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir/
    bold "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
