dir=~/.dotfiles # dotfiles directory
olddir=~/.dotfiles_old # old dotfiles backup directory
lnfiles="zshrc vimrc tmux.conf vimperatorrc zsh_plugins mailcap mutt muttrc" # list of files/folders to symlink in homedir
mvfiles="vim"
bold(){
    echo "$(tput bold)$@$(tput sgr0)"
}

bold "Decrypting mutt passwords"
scrypt enc $dir/mypw.gpg.bfe > ~/.mypw.gpg

bold "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
bold "Done"

bold "Changing to the $dir directory ..."
cd $dir
bold "Done"

for lnfile in $lnfiles; do
    bold "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$lnfile $olddir/
    bold "Creating symlink to $lnfile in home directory."
    ln -s $dir/$lnfile ~/.$lnfile
done
for mvfile in $mvfiles; do
    bold "Moving $mvfile from $dir/$mvfile to ~/.$mvfile"
    mv "$dir/mvfile" "~/.$mvfile"
done
