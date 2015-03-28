#!/bin/bash

FILES=;
#keeps the action information (install|remove)
ACTION="$1";
TARGET=$2;
#directory where the script will search for conf files to load
PACKAGE_LOCATION="./packages";
#extension of the conf files
EXT=".sh"

#this function load files, give execution
#permission for each one and execute the right action on it.
load(){
	if [ ! -d $PACKAGE_LOCATION ]; then
                echo "Packages directory does not exist.";
                exit 64;
        fi
        if [ -z $TARGET ] || [ "$TARGET" == "all" ]; then
                FILES=($( ls $PACKAGE_LOCATION/*$EXT));
        else
                if [ ! -e $PACKAGE_LOCATION/*$TARGET$EXT ]; then
                        echo "Configuration file for $TARGET not found";
                        exit 0;
                fi
                FILES=($( ls $PACKAGE_LOCATION/*$TARGET$EXT));
        fi
			
	for file in "${FILES[@]}" 
	do
		if [ -e $file ]; then
		
			if [ ! -x $file ]; then
				chmod +x $file
			fi
                        echo "$ACTION $(echo ${file%$EXT} | sed 's/^.*-//'): Action Started..."
                        sudo $file $ACTION		
			echo "$ACTION $(echo ${file%$EXT} | sed 's/^.*-//'): Action Finished."	
		fi
	done
}

#check if the script has super user permissions
if [ ! "$(id -u)" = "0" ]; then
        echo "You need super user privileges to run some of the scripts."
	exit 1
    fi

case "$1" in
install)
	load;      
;;
remove)
        load;
;;
*)
        echo "Usage: '$0' {install|remove} {all | <specific script>}"
        exit 64
;;
esac
