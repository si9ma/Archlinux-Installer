#!/bin/bash

## author: si9ma
## my blog: www.coolcodes.me
##
## use this script to check if yaourt have installed
##

. log.sh

EXIT_MSG="You have left from Archlinux Installer!"
HEADER="Archlinux Installer"

# check whether yaourt are installed
function check_yaourt
{
	pacman -Qi yaourt >/dev/null 2>&1
	echo $?
}

function install_yaourt
{

		title="AUR And Yaourt"
		msg="In order to complete instation, you need to enable AUR and install yaourt. Please select the repositories suitable for you. More details, please see \"https://wiki.archlinux.org/index.php/unofficial_user_repositories\"\n\n[ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."

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
}
