#!/bin/bash

## author: si9ma
## my blog: www.coolcodes.me
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

	# start
	sudo systemctl enable shadowsocks@shadowsocks.service
	sudo systemctl start shadowsocks@shadowsocks.service
}

function restore_proxychains
{
	sudo pacman --noconfirm -S proxychains

	# config file
	sudo sed -i 's/^socks4.*/socks5	127.0.0.1 1080/' /etc/proxychains.conf
}

function restore_hexo
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
	cp -r $Config_DIR/config/hexo/.hexo. ~/.hexo

	# install dependencies
	cd ~/.hexo
	dependencies=$(grep "hexo-" $Config_DIR/config/hexo/.hexo/package.json | cut -d "\"" -f 2 | grep "hexo-")
	for dependency in $dependencies
	do
		npm install $dependency --save
	done

	# remove hello world post
	rm ~/.hexo/source/_posts/hello-world.md
}

function restore_gnome_settings
{
	dconf load / < $Config_DIR/config/gnome/gnome.config

	## desktop bakcground
	cp $Config_DIR/config/picture/background.jpg ~/
	gsettings set org.gnome.desktop.background picture-uri ~/background.jpg

	## locked screen
	gsettings set org.gnome.desktop.screensaver picture-uri ~/lock.jpg
}

function restore_firefox
{
	yaourt --noconfirm -S firefox-developer-edition
}

function restore_chrome
{
	sudo pacman --noconfirm -S google-chrome
}

function restore_pick-colour-picker
{
	yaourt --noconfirm -S pick-colour-picker
}

function restore_deepin-screen-recorder
{
	sudo pacman --noconfirm -S deepin-screen-recorder
}

function restore_deepin-screenshot   
{
	sudo pacman --noconfirm -S deepin-screenshot
}

function restore_ranger
{
	sudo  pacman --noconfirm -S ranger
}

function restore_nautilus
{
	 sudo pacman --noconfirm -S nautilus
	 cp $Config_DIR/config/nautilus/* ~/.config/nautilus/
}

function restore_custom_script
{
    cp /usr/local/bin/* ./config/script/
	sudo cp $Config_DIR/config/script/* /usr/local/bin/ -r
}

function restore_vi_mode
{
	cp $Config_DIR/config/readline/.editrc  $Config_DIR/config/readline/.inputrc  ~/
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
	sudo pacman --noconfirm -S bless cmake dconf-editor gimp meld netease-cloud-music teamviewer gnome-tweak-tool wireshark-qt tcpdump htop openssh

	## ssh
	sudo pacman --noconfirm -S openssh

	## virtualbox
	sudo pacman --noconfirm -S virtualbox virtualbox-guest-modules-arch virtualbox-guest-iso virtualbox-guest-utils virtualbox-host-modules-arch virtualbox-ext-oracle
	
	## java
	yaourt --noconfirm -S jdk
	sudo archlinux-java set java-8-jdk

	## clipse for jee
	# sudo pacman --noconfirm -S eclipse-jee

	## android-studio
	# sudo pacmcan --noconfirm -S android-studio

	# ## mysql
	# sudo pacman --noconfirm -S mariadb mysql-workbench
	# sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	# # start
	# sudo systemctl start mariadb
	# # config
	# mysql_secure_installation
	# # jdbc
	# yaourt --noconfirm -S mariadb-jdbc
	# sudo ln -s /usr/share/java/mariadb-jdbc/mariadb-java-client.jar /usr/lib/jvm/default-runtime/lib/ext/

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

	## create_ap for wifi
	sudo pacman --noconfirm -S create_ap

	#  smaller bar
	mkdir -p ~/.config/gtk-3.0
    cp $Config_DIR/config/gtk-3.0/* ~/.config/gtk-3.0/ -r

	## gtk bookmarks
	mkdir -p ~/Windows
	mkdir -p ~/Github
	mkdir -p ~/Temp
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

function restore_postman
{
	yaourt --noconfirm -S postman-bin
}

function restore_tim
{
	echo 
	# yaourt --noconfirm -S deepin-wine-tim
	#  to do
}

function restore_vscode
{
	yaourt --noconfirm -S visual-studio-code-bin
	
	# config
	mkdir -p ~/.config/Code/User
	cp $Config_DIR/config/vscode/keybindings.json ~/.config/Code/User/
	cp $Config_DIR/config/vscode/settings.json ~/.config/Code/User/
	cp $Config_DIR/config/vscode/vsicons.settings.json ~/.config/Code/User/
	cp $Config_DIR/config/vscode/snippets ~/.config/Code/User/ -r

	# extensions
	extensions=$(cat $Config_DIR/config/vscode/extensions.list | xargs)
	mkdir -p ~/.vscode/extensions
	cd ~/.vscode/extensions
	mkdir -p $extensions
}