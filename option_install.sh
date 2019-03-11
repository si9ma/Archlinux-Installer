#!/bin/env bash

## author: si9ma
## my blog: si9ma.com
##
## use this script to enable aur and mutillib 
##

. log.sh

# don't use run this script as root
. no_root.sh

HEADER="Archlinux Installer"
EXIT_MSG="You have left from Archlinux Installer!"

# get usrname
usrname=$(whoami)

echo "---------------------------------Archlinux Installer-------------------------------"
# restore profile
sudo mv /etc/profile.backup /etc/profile

# change the Authority for the script
sudo chmod -R 777 /home/$usrname/Archlinux-Installer

### Install application

## Basic app
# wget , git 
sudo pacman -S --noconfirm wget git curl

## AUR,just for x86_64 and i686
title="AUR And Yaourt"
msg="The Arch User Repository (AUR) is a community-driven repository for Arch users. It contains package descriptions (PKGBUILDs) that allow you to compile a package from source with makepkg and then install it via pacman. The AUR was created to organize and share new packages from the community and to help expedite popular packages' inclusion into the community repository.\n\nYaourt, stands for Yet AnOther User Repository Tool, is a package wrapper that can be used to easily install packages from AUR.\n\nWould you want to install it and use it?\n\nPlease confirm before typing the [ENTER], because you can't undo it."

dialog --ascii-lines --title "$title" --backtitle "$HEADER" --yesno "$msg" 18 70

retval=$?
echo

case $retval in 
	# 0)  Yes,install AUR
		0)

		title="AUR And Yaourt"
		msg="Please select the repositories suitable for you. More details, please see \"https://wiki.archlinux.org/index.php/unofficial_user_repositories\"\n\n[ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."


        wget https://wiki.archlinux.org/index.php/unofficial_user_repositories -O repositories >/dev/null 2>&1
        repositories_list=$(cat repositories | grep -A 1 -P "\[[a-zA-Z0-9]{2,}\]" | grep -B 1 -P "Server")

        # remove Server = 
        repositories_list=${repositories_list//"Server = "/}
        # remove [
        repositories_list=${repositories_list//\[/}
        # remove ]
        repositories_list=${repositories_list//\]/}
        # remove --
        repositories_list=${repositories_list//--/}
        # convert mutil rows into one row
        repositories_list=$(echo $repositories_list | xargs)

        # Reverse
        count=0
        for repositories in $repositories_list
        do
            count=$[ $count + 1 ]
            judge=$[ $count % 2 ]

            # repo
            if [ "$judge" = "1" ]
            then
                repo=$repositories
            else
                temp="${temp} $repo=$repositories"
            fi
        done
        repositories_list=$temp
        temp=

        # sort
        repositories_list=$(echo "$repositories_list" | tr -s ' ' '\n' | sort -u | xargs)
        for repositories in $repositories_list
        do
            repo=$(echo "$repositories" | cut -d "=" -f 1)
            temp="${temp} $repositories $repo"
        done
        repositories_list=$temp
        temp=

		dialog --no-cancel --ok-button "Select" --ascii-lines --title "$title" --backtitle "$HEADER" --menu "$msg" 18 75 18 $repositories_list  2>tempfile

		retval=$?
		choice=$(cat tempfile)
		echo

		# if ESC,exit
		case $retval in
			255) # ESC
				echo
				echo $EXIT_MSG
				exit 255;;
		esac

		repo=$(echo $choice | cut -d "=" -f 1)
		server=$(echo $choice | cut -d "=" -f 2)

		# configure /etc/pacman.conf
		echo | sudo tee -a /etc/pacman.conf >/dev/null
		echo "## Add by Archlinux Inataller" | sudo tee -a /etc/pacman.conf >/dev/null
		echo "[$repo]" | sudo tee -a /etc/pacman.conf >/dev/null
		echo "SigLevel=Never" | sudo tee -a /etc/pacman.conf >/dev/null
		echo "Server = $server" | sudo tee -a /etc/pacman.conf >/dev/null

		# install Yaourt
		sudo pacman --noconfirm -Syu yaourt
		yaourt -Syu
		;;

	# 255) ESC ,exit
		255)
		echo
		echo $EXIT_MSG
		exit 255
		;;
esac

## multilib

paltform=$(uname -m)

if [ "$paltform" = "x86_64" ]
then

title="Multilib"
msg="You are using the 64bit Archlinux. If you want to run a 32bit application on your computer, you must to enable the Multilib. The multilib repository is an official repository which allows the user to run and build 32-bit applications on 64-bit installations of Arch Linux. Would you want to install it and use it?\n\n[ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."

dialog --ascii-lines --title "$title" --backtitle "$HEADER" --yesno "$msg" 18 70

retval=$?
echo

case $retval in 
	0) # Yes ,
		echo | sudo tee -a /etc/pacman.conf >/dev/null
		echo "## Add by Archlinux Inataller" | sudo tee -a /etc/pacman.conf >/dev/null
		echo "[multilib]" | sudo tee -a /etc/pacman.conf >/dev/null
		echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null

		sudo pacman -Syu
		;;

	255) #ESC ,exit
		echo
		echo $EXIT_MSG
		exit 255
		;;
esac

fi

## whether install a desktop environment
title="Install Desktop Environment"
msg="Would you want to install a desktop environment? [Yes] to install desktop environment. [No] to exit installer."
dialog --ascii-lines --title "$title" --backtitle "$HEADER" --yesno "$msg" 8 45

retval=$?
echo

case $retval in 
	255) # ESC,exit
		echo
		echo $EXIT_MSG
		exit 255
		;;
	1) # No,exit
		title="Complete Installation"
		msg="Hey! You have completed installation. More details about Archlinux ,please see Official wiki."
		dialog --no-cancel --ascii-lines --title "$title" --backtitle "$HEADER" --msgbox "$msg" 10 60
		echo

		exit 0
		;;
esac

# continue to install desktop environment
bash /home/$usrname/Archlinux-Installer/desktop_install.sh
