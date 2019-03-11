#!/bin/bash

## author: si9ma
## my blog: si9ma.com
##
## add your restore function here
## function restore_<your config name>
##
 
. log.sh

# install and config terminator 
function restore_terminator
{
	sudo pacman --noconfirm -S terminator

	# powerline font for ZSH agnoster  theme
	mkdir -p ~/.fonts
	wget https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf -O ~/.fonts/Droid\ Sans\ Mono\ for\ Powerline.otf
	fc-cache -f -v

	# config file
	mkdir -p ~/.config/terminator
	cp $Config_DIR/config/terminator/* ~/.config/terminator/ -r
}

function restore_oh-my-zsh
{
	# install zsh
	sudo pacman --noconfirm -S zsh

	# download oh-my-zsh install.sh as oh-my-zsh.sh
	curl -fsSL -o oh-my-zsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

	# don't go into zsh
	sed -i '/env zsh/d' oh-my-zsh.sh
	sh oh-my-zsh.sh

	# plugins for zsh(autojump zsh-syntax-highlighting zsh-autosuggestions)
	sudo pacman --noconfirm -S autojump

	# autosuggestions
	rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

	# syntax-highlighting
	rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

	# solarized powerline and zsh for tty
	curl -o ~/.tty-solarized-dark.sh https://raw.githubusercontent.com/joepvd/tty-solarized/master/tty-solarized-dark.sh
	wget https://github.com/powerline/fonts/raw/master/Terminus/PSF/ter-powerline-v16n.psf.gz -O ~/.ter-powerline-v16n.psf.gz

	# change shell for root
	sudo chsh -s /bin/zsh root

    #  zshrc
	cp $Config_DIR/config/zsh/.zshrc ~/.zshrc

	# dircolors
	cp $Config_DIR/config/zsh/.dircolors ~/.dircolors

	# zsh history
	cp $Config_DIR/config/zsh/.zsh_history ~/.zsh_history

	# autojump data
	mkdir -p ~/.local/share/autojump
	cp $Config_DIR/config/zsh/autojump.txt ~/.local/share/autojump/autojump.txt

	## for root user
	sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh
	sudo ln -s $HOME/.zshrc /root/.zshrc
	sudo ln -s $HOME/.dircolors /root/.dircolors
	sudo ln -s $HOME/.tty-solarized-dark.sh /root/.tty-solarized-dark.sh
	sudo ln -s $HOME/.ter-powerline-v16n.psf.gz /root/.ter-powerline-v16n.psf.gz
}

function restore_git
{
	sudo pacman --noconfirm -S git
    cp $Config_DIR/config/git/.gitconfig ~/
}

# after you install  vim ,you should use vundle to install plugins
function restore_vim
{
    # install vim
	sudo pacman --noconfirm -S gvim

    # restore .vimrc
	cp $Config_DIR/config/vim/.vimrc ~/.vimrc

    # install vundle plugin manager
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	# for root
	sudo ln -s $HOME/.vim /root/.vim
	sudo ln -s $HOME/.vimrc /root/.vimrc
}

function restore_shadowsocks
{
	# install shadowsocks
	sudo pacman --noconfirm -S shadowsocks

	# config file
	if [ -d "/etc/shadowsocks" ]
	then
		echo "/etc/shadowsocks exists!"
	else
		sudo mkdir -p /etc/shadowsocks
	fi

	sudo cp $Config_DIR/config/shadowsocks/shadowsocks.json /etc/shadowsocks/shadowsocks.json
}

function restore_proxychains
{
	sudo pacman --noconfirm -S proxychains

	# config file
	sudo sed -i 's/^socks4.*/socks5	127.0.0.1 1080/' /etc/proxychains.conf
}

function restore_gnome_settings
{
	dconf load / < $Config_DIR/config/gnome/gnome.config

	## desktop bakcground
	cp $Config_DIR/config/picture/*.png ~/
	gsettings set org.gnome.desktop.background picture-uri ~/background.png

	## locked screen
	gsettings set org.gnome.desktop.screensaver picture-uri ~/lock.png
}

function restore_firefox
{
	sudo pacman --noconfirm -S firefox
}

function restore_chrome
{
	sudo pacman --noconfirm -S google-chrome
}

function restore_ranger
{
	sudo  pacman --noconfirm -S ranger
	mkdir -p ~/.config/ranger
	cp $Config_DIR/config/ranger/* ~/.config/ranger -r
}

function restore_nautilus
{
	 sudo pacman --noconfirm -S nautilus
	mkdir -p ~/.config/nautilus
	 cp $Config_DIR/config/nautilus/* ~/.config/nautilus/
}

function restore_touchpad
{
		sudo cp $Config_DIR/config/touchpad/70-synaptics.conf /etc/X11/xorg.conf.d
}

function restore_uninstall
{
	sudo pacman --noconfirm -Rns gucharmap gnome-contacts gnome-dictionary gnome-terminal totem
}


function restore_synapse
{
	sudo pacman --noconfirm -S synapse
	mkdir -p ~/.config/synapse
	cp $Config_DIR/config/synapse/config.json ~/.config/synapse/config.json
	# auto start
	mkdir -p ~/.config/autostart
	cp $Config_DIR/config/synapse/synapse.desktop ~/.config/autostart/synapse.desktop
}

function restore_other
{
	sudo pacman --noconfirm -S bless cmake dconf-editor gimp meld netease-cloud-music gnome-tweak-tool htop

	## ssh
	sudo pacman --noconfirm -S openssh
	
	## disable nouveau
	echo "blacklist nouveau" | sudo tee -a /etc/modprobe.d/blacklist.conf >/dev/null

	## support for ntfs and exfat mount
	sudo pacman --noconfirm -S exfat-utils fuse ntfs-3g

	## create_ap for wifi
	sudo pacman --noconfirm -S create_ap

	#  smaller bar
	mkdir -p ~/.config/gtk-3.0
    cp $Config_DIR/config/gtk-3.0/* ~/.config/gtk-3.0/ -r
}

function restore_gitkraken
{
	yaourt --noconfirm -S gitkraken 
}

function restore_inkscape
{
	 yaourt --noconfirm -S inkscape-git 
}

function restore_libreoffice     
{
	sudo pacman --noconfirm -S libreoffice-fresh
}