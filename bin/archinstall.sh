#!/bin/bash
function pause(){
   read -p "$* Press [Enter] to continue"
}
echo "Let's start by installing a few packages we'll need later"
pause
pacman -S vim reflector 
echo "Now let's move on to making some partitions. WARNING: This could cause data loss"
pause

