#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/.dotfiles # dotfiles directory
olddir=~/.dotfiles_old # old dotfiles backup directory
files="zshrc vimrc tmux.conf vimperatorrc" # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/.dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
#Extra stuff
echo "Setting up mpd for user $(whoami)"
mkdir -p ~/.config/mpd/playlists
touch ~/.config/mpd/{database,log,pid,state,sticker,sql}
cp $dir/mpd.conf ~/.config/mpd/mpd.conf

echo "Do you want to install your previous packages?"
read answer
case $answer in 
    ""|[Yy]|[Yy][Ee][Ss]) sudo pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort $dir/pacman_pkgs))
        ;;
    [Nn]|[Nn][Oo]) exit 0
        ;;
    *) echo "Sorry, that's not an acceptable response"
        ;;
esac


echo "Do you want to install AUR packages as well? [y/N]"
case $answer in 
    [Yy]|[Yy][Ee][Ss]) yaourt -S --needed $(comm -13 <(pacman -Slq|sort) <(sort $dir/aur_pkgs))
        ;;
    ""|[Nn]|[Nn][Oo])  exit 0 
        ;;
    *) echo "Sorry, that's not an acceptable response"
        ;;
esac
