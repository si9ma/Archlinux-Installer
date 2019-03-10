#!/bin/env bash

## author: si9ma
## my blog: si9ma.me
##
## use this script to config chinese environment  
##


. log.sh

# don't run this script as root
. no_root.sh

# import yaourt function
. yaourt.sh

# get usrname
usrname=$(whoami)

EXIT_MSG="You have left from Archlinux Installer!"
Config_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 
title="Chinese Configure"
msg="Hey! Are you using chinese? Would you want to set your desktop environment locale to chinese?		[ESC] to exit the installer\n\nPlease confirm before typing the [ENTER], because you can't undo it."
dialog --no-cancel --ok-button "Select" --ascii-lines --title "$title" --backtitle "$HEADER" --menu "$msg" 18 75 18 \
	"(1)" "Yes" \
	"(2)" "Yes,but I just install chinese font and chinese input method."\
	"(3)" "No" 2>tempfile

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

# set chinese locale
if [ "$choice" = "(1)" ]
then
	# configure xprofile
	echo "export LANG=zh_CN.UTF-8" >>~/.xprofile
	echo "export LANGUAGE=zh_CN:en_US" >>~/.xprofile
	echo "export LC_CTYPE=en_US.UTF-8" >>~/.xprofile

	# install chinese font 
	sudo pacman --noconfirm -S wqy-microhei wqy-microhei-lite wqy-bitmapfont wqy-zenhei

	# fontconfig
	cp $Config_DIR/config/font/.fonts.conf ~/.fonts.conf

	# install chinese input method,just fcitx-sogoupinyin
	sudo pacman --noconfirm -S fcitx-im fcitx-configtool

	# configure xprofile
	echo "export GTK_IM_MODULE=fcitx" >>~/.xprofile
	echo "export QT_IM_MODULE=fcitx" >>~/.xprofile
	echo "export XMODIFIERS=\"@im=fcitx\"" >>~/.xprofile
	echo "gsettings set org.gnome.settings-daemon.plugins.xsettings overrides \"{'Gtk/IMModule':<'fcitx'>}\"">>~/.xprofile

	# 
	val=$(check_yaourt)

	# have install yaourt
	if [ "$val" = "0" ]
	then
		yaourt --noconfirm -S fcitx-sogoupinyin
	else
		install_yaourt
		yaourt --noconfirm -S fcitx-sogoupinyin
	fi

	# configure sougoupinyin
	# hide status bar
	#sed -i 's/^HideStatusBar.*/HideStatusBar=true/' ~/.config/SogouPY/sogouEnv.ini
	# chinese english switch key - nothing
	#sed -i 's/^SwitchCE_key.*/SwitchCE_key=Nothing/' ~/.config/SogouPY/sogouEnv.ini
	# appearance for sougoupinyin
	#sed -i 's/^CurtSogouSkinType.*/CurtSogouSkinType=Tickle Black Ver/' ~/.config/sogou-qimpanel/main.conf
	# fcitx triggerkey
	#sed -i 's/^TriggerKey.*/TriggerKey=SHIFT_SPACE/' ~/.config/fcitx/config
	# fcitx Enable Hotkey to scroll Between Input Method
	#sed -i 's/^.IMSwitchKey*/IMSwitchKey=False/' ~/.config/fcitx/config

	# fcitx
	cp $Config_DIR/config/fcitx ~/.config/ -r

	# sogoupinyin
	cp $Config_DIR/config/sogou/SogouPY ~/.config/ -r
	cp $Config_DIR/config/sogou/SogouPY.users ~/.config/ -r
	cp $Config_DIR/config/sogou/sogou-qimpanel ~/.config/ -r

elif [ "$choice" = "(2)" ] # just install chinese font and chinese input method
then
	# install chinese font 
	sudo pacman --noconfirm -S wqy-microhei wqy-microhei-lite wqy-bitmapfont wqy-zenhei

	# fontconfig
	cp $Config_DIR/config/font/.fonts.conf ~/.fonts.conf

	# install chinese input method,just fcitx-sogoupinyin
	sudo pacman --noconfirm -S fcitx-im fcitx-configtool

	# configure xprofile
	echo "export GTK_IM_MODULE=fcitx" >>~/.xprofile
	echo "export QT_IM_MODULE=fcitx" >>~/.xprofile
	echo "export XMODIFIERS=\"@im=fcitx\"" >>~/.xprofile
	echo "gsettings set org.gnome.settings-daemon.plugins.xsettings overrides \"{'Gtk/IMModule':<'fcitx'>}\"">>~/.xprofile

	# 
	val=$(check_yaourt)

	# have install yaourt
	if [ "$val" = "0" ]
	then
		yaourt --noconfirm -S fcitx-sogoupinyin
	else
		install_yaourt
		yaourt --noconfirm -S fcitx-sogoupinyin
	fi

	## myself
	# fcitx
	cp $Config_DIR/config/fcitx ~/.config/ -r

	# sogoupinyin
	cp $Config_DIR/config/sogou/SogouPY ~/.config/ -r
	cp $Config_DIR/config/sogou/SogouPY.users ~/.config/ -r
	cp $Config_DIR/config/sogou/sogou-qimpanel ~/.config/ -r
fi

## continue to install application
bash /home/$usrname/Archlinux-Installer/app.sh