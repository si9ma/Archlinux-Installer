#!/bin/env bash

## author: si9ma
## my blog: si9ma.com
##
## use this cript to install or config application
##

EXIT_MSG="You have left from Archlinux Installer!"
Config_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## window
title="Install Application"
msg="Please select the Application you want to install and configure. there are the Configuration for a few Application. You can change this script or add more script belong to you. [ESC] to exit the installer"

### Application Name and description
dialog --no-cancel --ok-label "Go" --ascii-lines --title "$title" --backtitle "$HEADER" --checklist "$msg" 18 75 18 \
	"Terminator" "Terminator is a terminal emulator which supports tabs and multiple resizable terminal panels in one window." "ON"\
	"Oh-my-zsh" "A delightful community-driven framework for managing your zsh configuration." "ON"\
	"Git" "Git" "ON"\
	"Vim" "Vim Editor" "ON"\
	"Shadowsocks" "Shadowsocks" "ON"\
	"Proxychains" "Proxychains" "ON"\
	"Hexo" "Hexo" "ON"\
	"Other" "Other" "ON"\
	2>tempfile ## add new application before this line

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

### define Configure for each application
function install_terminator
{
	sudo pacman --noconfirm -S terminator

	# powerline font
	mkdir -p ~/.fonts
	wget https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf -O ~/.fonts/Droid\ Sans\ Mono\ for\ Powerline.otf
	fc-cache -f -v

	# config file
	mkdir -p ~/.config/terminator
	cp $Config_DIR/config/terminator/config ~/.config/terminator/config
}

function install_oh_my_zsh
{
	# download zsh
	sudo pacman --noconfirm -S zsh

	# download oh-my-zsh install.sh as oh-my-zsh.sh
	curl -fsSL -o oh-my-zsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

	# don't go into zsh
	sed -i '/env zsh/d' oh-my-zsh.sh
	sh oh-my-zsh.sh

	# set zsh theme as agnoster
	sed -i 's/^ZSH_THEME.*/ZSH_THEME="agnoster"/' ~/.zshrc

	# plugins for zsh(autojump zsh-syntax-highlighting zsh-autosuggestions)
	sudo pacman --noconfirm -S autojump

	# autosuggestions
	rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

	# syntax-highlighting
	rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	sed -i 's/^plugins=.*/plugins=(git autojump zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

	# solarized powerline and zsh for tty
	curl -o ~/.tty-solarized-dark.sh https://raw.githubusercontent.com/joepvd/tty-solarized/master/tty-solarized-dark.sh 
	wget https://github.com/powerline/fonts/raw/master/Terminus/PSF/ter-powerline-v16n.psf.gz -O ~/.ter-powerline-v16n.psf.gz

	echo | cat - ~/.zshrc > temp && mv temp ~/.zshrc
	echo 'fi' | cat - ~/.zshrc > temp && mv temp ~/.zshrc
	echo '		sh .tty-solarized-dark.sh && setfont .ter-powerline-v16n.psf.gz' | cat - ~/.zshrc > temp && mv temp ~/.zshrc
	echo 'if [[ $(tty) == /dev/tty* ]] ; then' | cat - ~/.zshrc > temp && mv temp ~/.zshrc
	echo '## solarized for tty' | cat - ~/.zshrc > temp && mv temp ~/.zshrc
	echo '## Add by Archlinux installer' | cat - ~/.zshrc > temp && mv temp ~/.zshrc

	## for root
	sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh 
	sudo ln -s $HOME/.zshrc /root/.zshrc
	sudo ln -s $HOME/.dircolors /root/.dircolors
	sudo ln -s $HOME/.tty-solarized-dark.sh /root/.tty-solarized-dark.sh
	sudo ln -s $HOME/.ter-powerline-v16n.psf.gz /root/.ter-powerline-v16n.psf.gz

	# change shell for root
	sudo chsh -s /bin/zsh root

	## dircolors
	#curl -o ~/.dircolors https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark

	### myself
	cp $Config_DIR/config/zsh/.dircolors ~/.dircolors
	echo "eval \`dircolors ~/.dircolors\`" >>~/.zshrc

	### myself
	echo >>~/.zshrc
	echo "alias hexog=\"sh /home/beta/.hexo/script/generator.sh\"" >>~/.zshrc
	echo "alias cli=\"xclip -selection clipboard\"" >>~/.zshrc
	echo "alias addcate=\"sh /home/beta/.hexo/script/addcate.sh\"" >>~/.zshrc
	echo "alias addsite=\"sh /home/beta/.hexo/script/addsite.sh\"" >>~/.zshrc
	echo "alias addart=\"sh /home/beta/.hexo/script/addart.sh\"" >>~/.zshrc
	echo "alias zh=\"proxychains -q trans :zh\"" >>~/.zshrc
	echo "alias en=\"proxychains -q trans\"" >>~/.zshrc
	echo "alias cppman=\"proxychains -q cppman\"" >>~/.zshrc
	echo "alias gcd=\"gcc -Wl,-rpath=/home/beta/.local/lib/lib -Wl,--dynamic-linker=/home/beta/.local/lib/lib/ld-2.25.90.so -g\"" >>~/.zshrc
	echo >> ~/.zshrc
	echo "# vi mode" >>~/.zshrc
	echo "set -o vi" >>~/.zshrc

	# zsh history 
	cp $Config_DIR/config/zsh/.zsh_history ~/.zsh_history

	# autojump data
	mkdir -p ~/.local/share/autojump
	cp $Config_DIR/config/zsh/autojump.txt ~/.local/share/autojump/autojump.txt
}

function install_git
{
	sudo pacman --noconfirm -S git
	git config --global user.email "b374@gmail.com"
	git config --global user.name "beta"
	git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
}

function install_vim
{
	#sudo pacman --noconfirm -S vim

	## myself
	sudo pacman --noconfirm -S gvim

	# config file
	if [ -d "~/.vim" ]
	then
		mv ~/.vim ~/.vim-backup
	fi

	cp $Config_DIR/config/vim/.vimrc ~/.vimrc
	cp $Config_DIR/config/vim/.vim ~/.vim -r

	# for root
	sudo ln -s $HOME/.vim /root/.vim
	sudo ln -s $HOME/.vimrc /root/.vimrc
}

function install_shadowsocks
{
	# install
	sudo pacman --noconfirm -S shadowsocks

	# config file
	if [ -d "/etc/shadowsocks" ]
	then
		echo "/etc/shadowsocks exists!"
	else
		sudo mkdir -p /etc/shadowsocks
	fi

	sudo cp $Config_DIR/config/shadowsocks/ss.json /etc/shadowsocks/ss.json

	# start
	sudo systemctl enable shadowsocks@ss
	sudo systemctl start shadowsocks@ss
}

function install_proxychains
{
	sudo pacman --noconfirm -S proxychains

	# config file
	sudo sed -i 's/^socks4.*/socks5	127.0.0.1 1080/' /etc/proxychains.conf
}

function install_hexo
{
	# install git and nodejs
	sudo pacman --noconfirm -S git nodejs npm

	# install hexo
	proxychains -q sudo npm install -g hexo-cli

	# if failure,try again
	if [ "$?" != "0" ]
	then
		echo
		echo
		echo "Install hexo failure, Trying again......."

		# change the owner of /usr/lib/node_modules
		sudo chown $USER:$(id -gn $USER) /usr/lib/node_modules
		proxychains -q npm install -g hexo-cli
		sudo chown root:root /usr/lib/node_modules
	fi

	# hexo init
	rm -rf ~/.hexo
	mkdir ~/.hexo
	cd ~/.hexo && hexo init

	# hexo config
	cp -r $Config_DIR/config/hexo/config/. ~/.hexo

	# install dependencies
	cd ~/.hexo
	dependencies=$(grep "hexo-" $Config_DIR/config/hexo/package.json | cut -d "\"" -f 2 | grep "hexo-")
	for dependency in $dependencies
	do
		npm install $dependency --save
	done

	# remove hello world post
	rm ~/.hexo/source/_posts/hello-world.md
}

function config_other
{
	### vi mode
	echo "bind -v" >>~/.editrc
	echo "set editing-mode vi" >>~/.inputrc

	### gdb
	echo "layout split" >>~/.gdbinit
	echo "set disassembly-flavor intel" >>~/.gdbinit

	### touchpad soft key
	sudo cp $Config_DIR/config/touchpad/touchpad_toggle.sh /usr/local/bin/touchpad_toggle.sh
	## touchpad config
	sudo cp $Config_DIR/config/touchpad/70-synaptics.conf /etc/X11/xorg.conf.d/

	### uninstall unwanted application
	sudo pacman --noconfirm -Rns gucharmap gnome-contacts tracker gnome-dictionary empathy gnome-terminal totem

	### install more application
	sudo pacman --noconfirm -S bless cmake dconf-editor deluge gimp google-chrome meld netease-cloud-music ranger teamviewer gnome-tweak-tool

	## synapse
	sudo pacman --noconfirm -S synapse
	mkdir -p ~/.config/synapse
	cp $Config_DIR/config/synapse/config.json ~/.config/synapse/config.json
	# auto start
	mkdir -p ~/.config/autostart
	cp $Config_DIR/config/synapse/synapse.desktop ~/.config/autostart/synapse.desktop

	## ssh
	sudo pacman --noconfirm -S openssh

	## virtualbox
	sudo pacman --noconfirm -S virtualbox virtualbox-guest-modules-arch virtualbox-guest-iso virtualbox-guest-utils virtualbox-host-modules-arch virtualbox-ext-oracle
	
	## java
	yay --noconfirm -S jdk
	sudo archlinux-java set java-8-jdk

	## clipse for jee
	sudo pacman --noconfirm -S eclipse-jee

	## android-studio
	sudo pacmcan --noconfirm -S android-studio

	## mysql
	sudo pacman --noconfirm -S mariadb mysql-workbench
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	# start
	sudo systemctl start mariadb
	# config
	mysql_secure_installation
	# jdbc
	yay --noconfirm -S mariadb-jdbc
	sudo ln -s /usr/share/java/mariadb-jdbc/mariadb-java-client.jar /usr/lib/jvm/default-runtime/lib/ext/

	## gdm auto login
	sudo sed -i 's/^#WaylandEnable.*/WaylandEnable=false\nAutomaticLogin=beta\nAutomaticLoginEnable=True/' /etc/gdm/custom.conf

	## grub no wait
	sudo sed -i 's/^GRUB_TIMEOUT.*/GRUB_TIMEOUT=0/' /etc/default/grub
	# generate grub.cfg
	sudo grub-mkconfig -o /boot/grub/grub.cfg

	## disable nouveau
	echo "blacklist nouveau" | sudo tee -a /etc/modprobe.d/blacklist.conf >/dev/null

	## support for ntfs and exfat mount
	sudo pacman --noconfirm -S exfat-utils fuse ntfs-3g

	## gtk bookmarks
	mkdir -p ~/Windows
	mkdir -p ~/Workspace
	mkdir -p ~/Temp
	cp $Config_DIR/config/gtk-3.0/bookmarks ~/.config/gtk-3.0/bookmarks

	## xinput
	sudo pacman --noconfirm -S xorg-xinput

	## background
	cp $Config_DIR/config/picture/Yosemite-Color-Block.png ~/Pictures/

	## google trans
	sudo wget git.io/trans -O /usr/local/bin/trans
	sudo chmod +x /usr/local/bin/trans

	## gtk-engine-murrine,maybe for netease-cloud-music
	sudo pacman --noconfirm -S gtk-engine-murrine

	## create_ap for wifi
	sudo pacman --noconfirm -S create_ap

	### Gnome global settings
	dconf load /org/ < $Config_DIR/config/gnome/gnome.config
}

#### You can add new config after here


### execute the configure
for app in $choice
do
	if [ "$app" = "Terminator" ]
	then
		install_terminator
	elif [ "$app" = "Oh-my-zsh" ]
	then
		install_oh_my_zsh
	elif [ "$app" = "Git" ]
	then
		install_git
	elif [ "$app" = "Vim" ]
	then
		install_vim
	elif [ "$app" = "Shadowsocks" ]
	then
		install_shadowsocks
	elif [ "$app" = "Proxychains" ]
	then
		install_proxychains
	elif [ "$app" = "Hexo" ]
	then
		install_hexo
	elif [ "$app" = "Other" ]
	then
		config_other
	fi

#### You can add elif before here
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
