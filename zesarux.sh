#!/bin/bash
clear
# set -x
###
#
#	ZEsarUX Installer 1.0.0
#
#	General installer & updater.
#	Compiles software from source and installs binaries and files to their expected locations.
#
#	For OS: Linux (Debian)
#	Tested With: Ubuntu flavours
#
#	Lead Author: Lee Hodson
#	Donate: https://paypal.me/vr51
#	Website: https://journalxtra.com/installers/zesarux
#	This Release: 25th Aug 2018
#	First Written: 25th June 2018
#	First Release: 25th June 2018
#
#	Copyright 2018 OneUP! <https://journalxtra.com>
#	License: GPL3
#
#	Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>
#
#	Use of this program is at your own risk
#
# INSTALLS OR UPDATES
#
#	ZEsarUX the ZX Spectrum, Amstrad and SAM Emulator.
#
#	TO RUN:
#
#	Ensure the script is executable.
#
#	Right-click > properties > Executable
#	OR
#	chmod u+x zesarux.sh
#
#	Launch by clicking the script file or by typing bash zesarux.sh at the command line.
#
#	ZEsarUX will be compiled in $HOME/src/zesarux/src
#
#	Files that exist in $HOME/src/zesarux will be overwritten or updated by this program.
#
#	LIMITATIONS
#
#	You will need game and arcade ROMs to use this emulator enjoyably.
#	Visit https://journalxtra.com/gaming/download-complete-sets-of-mess-and-mame-roms/ to find some.
#
###

## User Editable Options

srcloc='https://github.com/chernandezba/zesarux.git' # ZEsarUX Git directory
# install='/usr/games' # ZEsarUX installation path. Where should the compiled binary be installed to? Exact path. No trailing slash.

user=$(whoami) # Current User
group=$(id -g -n $user) # Current user's primary group

# Internal Settings - These do not usually need to be manually changed

declare -a conf
declare -a menu # Menu options are set within zesarux_prompt()
declare -a message # Index indicates related conf, mode or menu item
declare -a mode # Used for notices

conf[0]=0 # Essentials # Install build essential software. 0 = Not done, 1 = Done
conf[1]=2 # Clean Stale # Do no cleaning or run make clean or delete source files? 0/1/2. 0 = No, 1 = Soft, 2 = Hard.
conf[2]=0 # Parallel jobs to run during build # Number of CPU cores + 1 is safe. Can be as high as 2*CPU cores. More jobs can shorten build time but not always and risks system stability. 0 = Auto.
conf[3]=$(nproc) # Number of CPU cores the computer has.
conf[4]=$(zesarux -v | grep 'ZEsarUX Version:') # Installed ZEsarUX Version
conf[5]=$(curl -v --silent 'https://github.com/chernandezba/zesarux/commit/master' --stderr - | grep '<relative-time datetime' | sed -E 's#<relative-time datetime="(.+)">.+$#\1#g' | tr -d '[:space:]' | tr '[:alpha:]' ' ')


## END User Options

let safeproc=${conf[3]}+${conf[3]} # Safe number of parallel jobs, possibly.

# Other settings

bold=$(tput bold)
normal=$(tput sgr0)

# Locate Where We Are
filepath="$( echo $PWD )"
# A Little precaution
cd "$filepath"

# Make SRC directory if it does not already exist

if test ! -d "$HOME/src"; then
	mkdir "$HOME/src"
fi

# Functions

function zesarux_run() {
	# Check for terminal then run else just run program
	tty -s
	if test "$?" -ne 0 ; then
		zesarux_launch
	else
		zesarux_prompt "${menu[*]}"
	fi
	
}

function zesarux_prompt() {

	while true; do

		# Set Menu Options

		case ${conf[1]} in
		
			0)
				message[1]='No cleaning'
				menu[1]='Update ZEsarUX'
				mode[1]='MODE: Update. Press 3 to change mode.'
			;;

			1)
				message[1]='Clean Compiler Cache'
				menu[1]='Update ZEsarUX'
				mode[1]='MODE: Update. Press 3 to change mode.'
			;;

			2)
				message[1]='Delete Source Files'
				menu[1]='Install ZEsarUX'
				mode[1]='MODE: Install. Press 3 to change mode.'
			;;

		esac

		menu[2]=''
		
		case "${conf[2]}" in
		
			0)
				menu[3]="Number of parallel jobs the installer should run. ${conf[3]} is Safe. $safeproc Max: Auto"
			;;
			
			*)
				menu[3]="Number of parallel jobs the installer should run ( Auto, Safe(${conf[3]}) or Max($safeproc) ): ${conf[2]}"
			;;
			
		esac
		
		menu[4]="Clean Level: ${message[1]}"
		menu[5]=''
		
		case "${conf[0]}" in
		
			0)
				menu[6]='Install Essential Build Packages'
				message[1]='\nIf installation fails Install Essential Build Packages then try again.'
			;;
			
		esac

		printf $bold
		printf "${mode[1]}\n"
		printf $normal
		
		printf "\nMENU\n\n"

		n=1
		for i in "${menu[@]}"; do
			if [ "$i" == '' ]; then
				printf "\n"
			else
				printf "$n) $i\n"
				let n=n+1
			fi
		done

		printf "\n0) Exit\n\n"

		# Notices

			printf $bold

			printf "${message[1]}"
			printf "\nIf the computer crashes during installation lower the number of parallel jobs used by the installer then try again.\n"

			printf "\nGENERAL INFO\n"
				
			printf $normal

			printf "\n System ZEsarUX: ${conf[4]}"
			printf "\n Latest git commit: ${conf[5]}\n"

		printf $bold
			printf "\nChoose Wisely: "
		printf $normal
		read REPLY

		case $REPLY in

		1) # Install / Update ZEsarUX

			printf "\nInstalling ZEsarUX. This could take between a few moments and a long time or even a very long time. Go get a coffee.\n"

			cd "$HOME/src"

			# Test the zesarux source files exist. Download them if not.
			if test -d "$HOME/src/zesarux" ; then
				# Make sure we own the source files
				sudo chown -R $user:$group "$HOME/src/zesarux"
				
				# Decide whether to update or install
				case ${conf[1]} in
				
					0) # Update - No spring clean. Update source files
						cd "$HOME/src/zesarux"
						git pull -p
					;;
				
					1) # Update - spring clean first. Update source files
						cd "$HOME/src/zesarux"
						make clean
						make distclean
						git pull -p
					;;
					
					2) # Clean install. Delete source files. Download fresh source files.
						rm -r -f "$HOME/src/zesarux"
						git clone --depth 1 "$srcloc"
						cd "$HOME/src/zesarux"
					;;
					
				esac

			else
				# Clean install necessary - Source files not present yet
				git clone --depth 1 "$srcloc"
				cd "$HOME/src/zesarux"

			fi

			case "${conf[2]}" in
				0)
					jobs=''
				;;
				
				*)
					jobs="-j${conf[2]}"
				;;
			esac
			
			# Build ZEsarUX
			cd "$HOME/src/zesarux/src"
			./configure
			make clean
			make $jobs

			# Install ZEsarUX
			if test -f "$HOME/src/zesarux/src/zesarux"; then
				chmod u+x "$HOME/src/zesarux/src/zesarux"
				sudo make install
				# sudo ln -s "$HOME/src/zesarux/src/zesarux" "$install/zesarux" # We were going to softlink to the executable but the program wouldn't run as a link

				# Add desktop file for application menu if it does not already exist
				if test ! -f "/usr/share/applications/zesarux.desktop"; then
					echo -e "[Desktop Entry]\nType=Application\nCategories=Game;Games\nName=ZEsarUX\nExec=zesarux\nIcon=preferences-desktop-color\n" > "$HOME/src/zesarux/src/zesarux.desktop"
					sudo mv "$HOME/src/zesarux/src/zesarux.desktop" "/usr/share/applications/zesarux.desktop"
				fi

				sudo ldconfig
				sudo updatedb
			
				conf[4]=$(zesarux -v | grep 'ZEsarUX Version:') # Newly installed zesarux version

				clear

				printf "\nZEsarUX is ready to use.\n"
				printf "\nRun by typing zesarux into a terminal or find zesarux in your applications manager.\n"

			else
				printf "\n\nZEsarUX installation failed. \n\n"
			fi

			printf "\nPress ANY key"
			read something

		;;

		2) # Parallel jobs to run during build
		
			case "${conf[2]}" in
			
				$safeproc)

					let conf[2]=0
					sed -i -E "0,/conf\[2\]=[0-9]{1,2}/s/conf\[2\]=[0-9]{1,2}/conf\[2\]=${conf[2]}/" "$0"

				;;

				*)

					let conf[2]=${conf[2]}+1
					sed -i -E "0,/conf\[2\]=[0-9]{1,2}/s/conf\[2\]=[0-9]{1,2}/conf\[2\]=${conf[2]}/" "$0"
					
				;;

			esac

			clear

		;;

		3) # Set update, install, clean flag
		
			case ${conf[1]} in
			
				0)
					sed -i -E "0,/conf\[1\]=0/s/conf\[1\]=0/conf\[1\]=1/" "$0"
					conf[1]=1
				;;

				1)
					sed -i -E "0,/conf\[1\]=1/s/conf\[1\]=1/conf\[1\]=2/" "$0"
					conf[1]=2
				;;

				2)
					sed -i -E "0,/conf\[1\]=2/s/conf\[1\]=2/conf\[1\]=0/" "$0"
					conf[1]=0
				;;

			esac

			clear
			
		;;

		4) # Install software packages necessary to build ZEsarUX

			sudo apt-get update
			packages=( build-essential gcc g++ libqtwebkit-dev libsdl2* sdllib libqt5* qt5* libssl libsndfile schedtool libpthread* curl )
			for i in "${packages[@]}"; do
				sudo apt-get build-dep -y -q $i
				sudo apt-get install -y -q --install-suggests $i
			done

			sed -i -E "0,/conf\[0\]=0/s/conf\[0\]=0/conf\[0\]=1/" "$0"
			conf[0]=1

			printf "\nPress any key to continue\n"
			read something
			clear

		;;

		0) # Exit

			exit 0

		;;

		*)

		esac

  done
  
}


## launch terminal

function zesarux_launch() {

	terminal=( konsole gnome-terminal x-terminal-emulator xdg-terminal terminator urxvt rxvt Eterm aterm roxterm xfce4-terminal termite lxterminal xterm )
	for i in ${terminal[@]}; do
		if command -v $i > /dev/null 2>&1; then
			exec $i -e "$0"
			# break
		else
			printf "\nUnable to automatically determine the correct terminal program to run e.g Console or Konsole. Please run this program from the command line.\n"
			read something
			exit 1
		fi
	done
}

## Boot

zesarux_run "$@"

# Exit is at end of zesarux_run()

# FOR DEBUGGING

# declare -p