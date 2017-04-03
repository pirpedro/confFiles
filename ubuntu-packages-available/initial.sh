#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
    if [ ! -f ~/.bashrc ]; then
        touch ~/.bashrc
    fi

    if [ ! -f ~/.bash_profile ]; then
        touch ~/.bash_profile
    fi

    [ -d ~/.bash ] || mkdir ~/.bash
    [ -f ~/.bash/my-config.sh ] || touch ~/.bash/my-config.sh
    [ -f ~/.bash/.bash_aliases ] || touch ~/.bash/.bash_aliases
    [ -f ~/.bash/.bash_path ] || touch ~/.bash/.bash_path
    chmod +x ~/.bash/my-config.sh
    chmod +x ~/.bash/.bash_aliases
    chmod +x ~/.bash/.bash_path

    echo "###############   my-config configuration script   ###############
if [ -d ~/.bash ]; then
   for i in ~/.bash/*.sh; do
      if [ -r \$i ]; then
         . \$i
      fi
   done
   unset i
fi
##################################################################" >> ~/.bash_profile

    echo "###############   my-config configuration script   ###############
if [ -d ~/.bash ]; then
   for i in ~/.bash/*.sh; do
      if [ -r \$i ]; then
         . \$i
      fi
   done
   unset i
fi
##################################################################" >> ~/.bashrc

#Ubuntu themes
#sudo apt-get install -y unity-tweak-tool
#sudo apt-add-repository ppa:tista/adapta -y
#sudo apt-get install adapta-gtk-theme

#sudo apt-add-repository ppa:numix/ppa -y
#sudo apt-get update
#sudo apt-get install numix-icon-theme-circle

;;
remove)
;;
esac
