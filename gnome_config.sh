#!/bin/env bash

## author: si9ma
## my blog: si9ma.com
##
## use this script to config gnome  
##

# there are a bug when use log in this script(can't use yay)
. log.sh

# don't run this script as root
. no_root.sh

# import yay functions
. yay.sh

HEADER="Archlinux Installer"
EXIT_MSG="You have left from Archlinux Installer!"

# get usrname
usrname=$(whoami)

function enable_extensions
{
	cur=$(gsettings get org.gnome.shell enabled-extensions)
	if [ "$cur" = "@as []" ]
	then
		new="['$1']"
	else
		cur=${cur/\]/,}
		new="${cur}'$1']"
	fi

	# set 
	gsettings set org.gnome.shell enabled-extensions "$new"
}


# configure Gnome Appearance
title="Gnome Appearance"
msg="Would you want to configure your Gnome appearance? [Yes] to configure. [No] to use default appearance. [ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."
dialog --ascii-lines --title "$title" --backtitle "$HEADER" --yesno "$msg" 11 45

## operating
retval=$?
echo

case $retval in
	255) # ESC,exit
		echo
		echo $EXIT_MSG
		exit 255
		;;
	1) # bash /home/$usrname/Archlinux-Installer/chinese_config.sh
		./chinese_config.sh
		;;
	0)
		## GTK+ theme
		title="Gnome Appearance - GTK+ Theme"
		msg="Please select a GTK+ theme.	[ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."
		dialog --no-cancel --ok-button "Select" --ascii-lines --title "$title" --backtitle "$HEADER" --menu "$msg" 18 75 18 "Adwaita" "Adwaita (local)" "Adwaita-dark" "Adwaita-dark (local)" "HighContrast" "HighContrast (local)" "OSX-Arc-White" "OSX-Arc-White (remote)" "OSX-Arc-Darker" "OSX-Arc-Darker (remote)" "OSX-Arc-Shadow" "OSX-Arc-Shadow (remote)" "OSX-Arc-Plus" "OSX-Arc-Plus (remote)" 2>tempfile

		retval=$?
		choice=$(cat tempfile)
		echo

		case $retval in
			255) # ESC,exit
				echo
				echo $EXIT_MSG
				exit 255
				;;
		esac

		# OSX-Arc-White
		if [ "$choice" = "OSX-Arc-White" ]
		then
			# download OSX-Arc-White
			val=$(check_yay)

			# have install yay
			if [ "$val" = "0" ]
			then
				yay --noconfirm -S osx-arc-white
			else
				install_yay
				yay --noconfirm  -S osx-arc-white
			fi

			white=1

		elif [ "$choice" = "OSX-Arc-Darker" ]
		then
			# Download OSX-Arc-Darker
			val=$(check_yay)

			# have install yay
			if [ "$val" = "0" ]
			then
				yay --noconfirm -S osx-arc-darker
			else
				install_yay
				yay --noconfirm -S osx-arc-darker
			fi

			darker=1

		elif [ "$choice" = "OSX-Arc-Shadow" ]
		then
			# Download OSX-Arc-Shadow
			val=$(check_yay)

			# have install yay
			if [ "$val" = "0" ]
			then
				yay --noconfirm -S osx-arc-shadow
			else
				install_yay
				yay --noconfirm -S osx-arc-shadow
			fi

			shadow=1

		elif [ "$choice" = "OSX-Arc-Plus" ]
		then
			# Download OSX-Arc-Plus
			val=$(check_yay)

			# have install yay
			if [ "$val" = "0" ]
			then
				yay --noconfirm -S osx-arc-plus
			else
				install_yay
				yay --noconfirm -S osx-arc-plus
			fi

			plus=1
		fi

		# set GTK+ themes
		gsettings set org.gnome.desktop.interface gtk-theme $choice


		## icons themes
		title="Gnome Appearance - Icons"
		msg="Please select a Icons theme.	[ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."
		dialog --no-cancel --ok-button "Select" --ascii-lines --title "$title" --backtitle "$HEADER" --menu "$msg" 18 75 18 "Adwaita" "Adwaita (local)" "hicolor" "hicolor (local)" "HighContrast" "HighContrast (local)" "macOS" "macOS (remote)" "Numix" "Numix (remote)" "Numix-Light" "Numix-Light (remote)" "Numix-Circle" "Numix-Circle (remote)" "Numix-Circle-Light" "Numix-Circle-Light (remote)" 2>tempfile

		retval=$?
		choice=$(cat tempfile)
		echo

		case $retval in
			255) # ESC,exit
				echo
				echo $EXIT_MSG
				exit 255
				;;
		esac

		if [ "$choice" = "Numix" ] || [ "$choice" = "Numix-Light" ]
		then
			# Download
			rm -rf ~/Numix
			git clone https://github.com/numixproject/numix-icon-theme.git ~/Numix
			mkdir -p ~/.icons
			rm -rf ~/.icons/Numix 
			rm -rf ~/.icons/Numix-Light
			mv ~/Numix/Numix ~/.icons/ 
			mv ~/Numix/Numix-Light ~/.icons/ 
		elif [ "$choice" = "Numix-Circle" ] || [ "$choice" = "Numix-Circle-Light" ]
		then
			# Download 
			rm -rf ~/Numix-Circle
			git clone https://github.com/numixproject/numix-icon-theme-circle.git ~/Numix-Circle
			mkdir -p ~/.icons
			rm -rf ~/.icons/Numix-Circle 
			rm -rf ~/.icons/Numix-Circle-Light 
			mv ~/Numix-Circle/Numix-Circle ~/.icons/ 
			mv ~/Numix-Circle/Numix-Circle-Light ~/.icons/ 
		elif [ "$choice" = "macOS" ]
		then
			val=$(check_yay)

			# have install yay
			if [ "$val" = "0" ]
			then
				yay --noconfirm -S macos-icon-theme
			else
				install_yay
				yay --noconfirm -S macos-icon-theme
			fi
		fi

		# set icons
		gsettings set org.gnome.desktop.interface icon-theme $choice

		## shell theme
		title="Gnome Appearance - Shell Theme"
		msg="Please select a Shell theme.	[ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."
		dialog --no-cancel --ok-button "Select" --ascii-lines --title "$title" --backtitle "$HEADER" --menu "$msg" 18 75 18 "Yosemite-Shell" "Yosemite-Shell (remote)" "OSX-Arc-White" "OSX-Arc-White (remote)" "OSX-Arc-Darker" "OSX-Arc-Darker (remote)" "OSX-Arc-Shadow" "OSX-Arc-Shadow (remote)" "OSX-Arc-Plus" "OSX-Arc-Plus (remote)" 2>tempfile

		retval=$?
		choice=$(cat tempfile)
		echo

		case $retval in
			255) # ESC,exit
				echo
				echo echo $EXIT_MSG
				exit 255
				;;
		esac

		# OSX-Arc-White
		if [ "$choice" = "OSX-Arc-White" ]
		then
			if [ "$white" != "1" ]
			then
				# download OSX-Arc-White
				val=$(check_yay)

				# have install yay
				if [ "$val" = "0" ]
				then
					yay --noconfirm -S osx-arc-white
				else
					install_yay
					yay --noconfirm -S osx-arc-white
				fi
			fi

		elif [ "$choice" = "OSX-Arc-Darker" ]
		then

			if [ "$darker" != "1" ]
			then
				# Download OSX-Arc-Darker
				val=$(check_yay)

				# have install yay
				if [ "$val" = "0" ]
				then
					yay --noconfirm -S osx-arc-darker
				else
					install_yay
					yay --noconfirm -S osx-arc-darker
				fi
			fi

		elif [ "$choice" = "OSX-Arc-Shadow" ]
		then
			if [ "$shadow" != "1" ]
			then
				# Download OSX-Arc-Shadow
				val=$(check_yay)

				# have install yay
				if [ "$val" = "0" ]
				then
					yay --noconfirm -S osx-arc-shadow
				else
					install_yay
					yay --noconfirm -S osx-arc-shadow
				fi
			fi

		elif [ "$choice" = "OSX-Arc-Plus" ]
		then
			if [ "$plus" != "1" ]
			then
				# Download OSX-Arc-Plus
				val=$(check_yay)

				# have install yay
				if [ "$val" = "0" ]
				then
					yay --noconfirm -S osx-arc-plus
				else
					install_yay
					yay --noconfirm -S osx-arc-plus
				fi
			fi
		elif [ "$choice" = "Yosemite-Shell" ]
		then
			# Install
			rm -rf ~/.themes/Yosemite-Shell
			git clone https://github.com/nicksniffer/Yosemite-Shell.git ~/.themes/Yosemite-Shell
		fi

		# set GTK+ themes
		# enable user shell
		enable_extensions user-theme@gnome-shell-extensions.gcampax.github.com
		gsettings set org.gnome.shell.extensions.user-theme name $choice

		## Gnome shell extensions

		# check the status of yay.
		val=$(check_yay)

		# have install yay
		if [ "$val" != "0" ]
		then
			install_yay
		fi

		# window
		title="Gnome Appearance"
		msg="Please select the Gnome shell extensions you want to enable.	[ESC] to exit the installer.\n\nPlease confirm before typing the [ENTER], because you can't undo it."
		dialog --ascii-lines --title "$title" --backtitle "$HEADER" --checklist "$msg" 18 77 18 \
			"Dash-to-dock" "A dock for the gnome shell" "OFF"\
			"Topicons-Plus" "This extension moves legacy tray icons" "OFF"\
			"System-monitor" "Display system information in gnome shell status bar,such as memory usage,cpu usage,network retes..." "OFF" 2>tempfile

			# "Launch-new-instance" "Always launch a new instance when clicking in the dash or the application view." "OFF"\
			# "Removable-drive-menu" "A status menu for accessing and unmounting Removable devices." "OFF"\
			# "Screenshot-tool" "Conveniently create,copy,store and uplosd screenshots" "OFF"\

		retval=$?
		choice=$(cat tempfile)
		echo

		case $retval in
			255)# ESC,exit
				echo
				echo $EXIT_MSG
				exit 255
				;;
		esac


		function install_dash_to_dock
		{
			yay --noconfirm -S gnome-shell-extension-dash-to-dock-git
			# enable
			enable_extensions dash-to-dock@micxgx.gmail.com
			# icons size
			gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 33
			# bottom
			gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
		}

		function install_topicons_plus
		{
			yay --noconfirm -S gnome-shell-extension-topicons-plus
			enable_extensions TopIcons@phocean.net
		}

		function install_system_monitor
		{
			yay --noconfirm -S gnome-shell-extension-system-monitor-git
			enable_extensions system-monitor@paradoxxx.zero.gmail.com
		}

		# install extensions 
		for extension in $choice
		do
			if [ "$extension" = "Dash-to-dock" ]
			then
				install_dash_to_dock
			elif [ "$extension" = "Topicons-Plus" ]
			then
				install_topicons_plus
			elif [ "$extension" = "System-monitor" ]
			then 
				install_system_monitor
			elif [ "$extension" = "Launch-new-instance" ]
			then
				enable_extensions launch-new-instance@gnome-shell-extensions.gcampax.github.com
			elif [ "$extension" = "Removable-drive-menu" ]
			then 
				enable_extensions drive-menu@gnome-shell-extensions.gcampax.github.com
			fi
		done

		## chinese configure
		bash /home/$usrname/Archlinux-Installer/chinese_config.sh

		;;
esac
