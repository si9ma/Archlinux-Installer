#!/bin/env bash

## author: si9ma
## my blog: www.coolcodes.me
##
## use this cript to install or configure application
##

# don't run this script as root
. log.sh
. no_root.sh

# source restore_script.sh
. restore_script.sh

EXIT_MSG="You have left from Archlinux Installer!"
Config_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## window
title="Install OR Configure Application"
msg="Please select the Application you want to install or configure. [ESC] to exit the installer"

# get all config from backup.conf
config_list=$(grep -P "^\s*[a-zA-Z0-9-]+\s*[a-zA-Z0-9-]*" backup.conf | xargs)
count=0
for item in $config_list
do
    count=$[ $count + 1 ]
    judge=$[ $count % 2 ]

    if [ "$judge" = "0" ]
    then
        temp="$temp $item ON"
    else
        temp="$temp $item"
    fi
done
config_list=$temp

### Application Name and description
dialog --no-cancel --ok-label "Go" --ascii-lines --title "$title" --backtitle "$HEADER" --checklist "$msg" 18 75 18 $config_list 2>tempfile

retval=$?
choice=$(cat tempfile)
echo

# ESC to exit
case $retval in 
	255) # ESC,exit
		echo 
		echo $EXIT_MSG
		exit 255
		;;
esac

### execute the configuration
for app in $choice
do
    restore_$app
    if [ "$?" = "0" ]
    then
        echo "Restore $app successfully!"
    else
        echo "No restore script for $app!"
    fi
done

## complete installation
title="Complete Installation"
msg="Hey! You have completed installation. More details about Archlinux, please see Official wiki."
dialog --no-cancel --ascii-lines --title "$title" --backtitle "$HEADER" --msgbox "$msg" 10 60

retval=$?
choice=$(cat tempfile)
echo

# ESC to exit
case $retval in 
	255) # ESC,exit
		echo 
		echo $EXIT_MSG
		exit 255
		;;
esac

# reboot
reboot
