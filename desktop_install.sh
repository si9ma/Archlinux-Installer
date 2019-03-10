#!/bin/env bash

## author: si9ma
## my blog: si9ma.me
##
## use this script to install desktop environment
##


. log.sh

# don't run this script as root
. no_root.sh

EXIT_MSG="You have left from Archlinux Installer!"
HEADER="Archlinux Installer"

# get usrname
usrname=$(whoami)

### 1.install drivers
## install video driver,now just support intel card
card=$(lspci | grep -e VGA -e 3D)
title="Install Driver"
msg="Your video card infomation:\n$card\n\nPlease select the video card driver suitable for your computer.	[ESC] to exit installer\n\nPlease confirm before typing the [ENTER], because you can't undo it."
driver_list=$(pacman -Ss xf86-video | grep "/xf" | cut -d "/" -f 2 | cut -d " " -f 1) 

# duplicate
for driver in $driver_list
do
	if [ "$driver" != "xf86-video-vmware" ]
	then
		desc=$(echo $driver | cut -d "-" -f 3)
		temp="${temp} ${driver} $desc"
	fi
done

driver_list=$temp
temp=
driver_list="VirtualBox Driver-for-VirtualBox VMware Driver-for-VMware ${driver_list}"

dialog --ascii-lines --no-cancel --ok-button "Select" --title "$title" --backtitle "$HEADER" --menu "$msg" 18 75 18 $driver_list 2>tempfile

retval=$?
choice=$(cat tempfile)
echo

case $retval in
	255) # ESC
		echo $EXIT_MSG
		exit 255;;
esac

# for VirtualBox
echo
if [ "$choice" = "VirtualBox" ]
then
	sudo pacman --noconfirm -S virtualbox-guest-modules-arch

elif [ "$choice" = "VMware" ] # for VMware
then
	sudo pacman --noconfirm -S open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa-libgl lib32-mesa-libgl
else   # for others
	sudo pacman --noconfirm -S $choice
fi

# install libinput ,for hadel device
sudo pacman -S --noconfirm libinput

# install xorg
sudo pacman -S --noconfirm xorg-server

### 2.install desktop environment 

# Selector
title="Install Desktop Environment"
msg="Now, You need select your favorite desktop environment.		[ESC] to exit installer\n\nPlease confirm before typing the [ENTER], because you can't undo it."

dialog --ascii-lines --no-cancel --ok-button "Select" --title "$title" --backtitle "$HEADER" --menu "$msg" 18 75 18 "Gnome" "A desktop environment that aims to be simple and easy to use" "KDE" "KDE Plasma Desktop" "Xfce" "A lightweight and modular Desktop environment currently based on GTK+2" 2>tempfile

retval=$?
choice=$(cat tempfile)
echo

case $retval in
	255) # ESC
		echo $EXIT_MSG
		exit 255;;
esac

function install_done
{
	## complete installation
	title="Complete Installation"
	msg="Hey!. You have completed installation. More details about Archlinux ,please see Official wiki."
	dialog --no-cancel --ascii-lines --title "$title" --backtitle "$HEADER" --msgbox "$msg" 10 60
}

# Gnome,Use gdm as Display Managers
if [ "$choice" = "Gnome" ]
then
	sudo pacman --noconfirm -S gnome
	#sudo pacman --noconfirm -S gdm
	sudo systemctl enable gdm

	# continue to configure gnome
	bash /home/$usrname/Archlinux-Installer/gnome_config.sh
fi

# KDE,Use sddm as Display Managers
if [ "$choice" = "KDE" ]
then
	sudo pacman --noconfirm -S plasma
	sudo pacman --noconfirm -S sddm
	sudo systemctl enable sddm
	install_done

	# reboot
	reboot
fi

# Xfce,Use lxdm as Display Managers
if [ "$choice" = "Xfce" ]
then
	sudo pacman --noconfirm -S xfce4
	sudo pacman --noconfirm -S lxdm 
	sudo systemctl enable lxdm
	install_done

	# reboot
	reboot
fi
