#!/bin/bash

BASH_PROFILE=$HOME/.profile

#format the script name for a user firendly package name
__format_script_name(){
        echo ${1%.*} | sed 's/^.*-//'
}

__verbosity(){
   if [ "$1" == "on" ]; then
        export MY_CONFIG_VERBOSE=1;
    else
        export MY_CONFIG_VERBOSE=0;
   fi
}

__log(){
  if [ "$MY_CONFIG_VERBOSE" == "1" ]; then
      echo "$1"
  fi
}

 __load_config_file(){
    local configfile=$1
    local configfile_secured='/tmp/$(__random).cfg'

    # check if the file contais something we don't want
    if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
      echo "Config file is unclean, cleaning it..." >&2
      egrep '^#|^[^ ]*=[^;&]*'  "configfile" > "configfile_secured"
      configfile="$configfile_secured"
    fi

    source "$configfile"
}

#useful which will give you the full directory name of the script no matter where it is being called
#from including any combination of aliases, source, bash -c, symlinks, etc..
__current_location(){
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}

#generate a random value
__random(){
	echo $(cat /dev/urandom | base64 | tr -dc A-Za-z0-9_ | head -c8)
}

#exit script
__abort(){
  echo "$1"
  exit 1
}

__exit(){
  echo "$1"
  exit 0
}

__is_mac(){
   if [[ "$OSTYPE" == "darwin"* ]]; then
     echo 1;
   else
     echo 0;
   fi
}

__is_linux(){
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
    		echo 1;
	else
		echo 0;
	fi
}

__exists(){
	type -P $1 &>/dev/null && echo 1 || echo 0;

}

__my_env(){

	if [ $(__is_mac) == "1" ]; then
		if [ ! -e /etc/launchd.conf ]; then
			touch /etc/launchd.conf
		fi

		if [ $(__exists launchctl) == "1"  ]; then
			launchctl setenv $1 $2
		fi

		echo setenv $1 $2 >> /etc/launchd.conf
	fi

	if [ ! -e $BASH_PROFILE ]; then
		touch $BASH_PROFILE
	fi

	export $1=$2
	echo export $1=$2 >> $BASH_PROFILE

}

__my_path_remove(){
	local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

__my_path(){
        myPathRemove $1 $2
	local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
	myEnv PATH $PATH
}

