#!/bin/bash

## author: si9ma
## my blog: www.coolcodes.me
##
## add your backup function here
## function backup_<your config name>
##

. log.sh

# backup terminator config
function backup_terminator
{
    mkdir -p ./config/terminator
    cp ~/.config/terminator/* ./config/terminator/ -r
}

# backup vim
function backup_vim
{
    mkdir -p ./config/vim/
    cp ~/.vimrc ./config/vim/ 
}

# backup git
function backup_git
{
    cp ~/.gitconfig ./config/git/
}

# backup oh-my-zsh
function backup_oh-my-zsh
{
    # zsh config
    cp ~/.zshrc ./config/zsh/

    # auto jump plugin
    cp ~/.local/share/autojump/autojump.txt ./config/zsh/

    # dircolors
    cp ~/.dircolors ./config/zsh/

    # zsh_history
    cp ~/.zsh_history ./config/zsh/
}

function backup_shadowsocks
{
    cp /etc/shadowsocks/shadowsocks.json ./config/shadowsocks
}

function backup_hexo
{
    rm ~/.hexo/public -rf
    rm ~/.hexo/.deploy_git ~/.hexo/.gitignore -rf
    mkdir -p ./config/hexo/config
    sudo pacman --noconfirm -S rsync
    rsync -av --exclude='public' --exclude='node_modules' --exclude='.git' ~/.hexo/ ./config/hexo/config/
    rm ./config/hexo/config/.git -rf
}

function backup_proxychains
{
    cp /etc/proxychains.conf ./config/proxychains/
}

# backup all gnome settings
function backup_gnome_settings
{
    dconf dump / >./config/gnome/gnome.config

    #  backup background and lock screen
    background=$(gsettings get org.gnome.desktop.background picture-uri)
    background=${background#"'"}
    background=${background#"file://"}
    background=${background%"'"}
    lock=$(gsettings get org.gnome.desktop.screensaver picture-uri)
    lock=${lock#"'"}
    lock=${lock#"file://"}
    lock=${lock%"'"}

    cp $background ./config/picture/background.jpg
    cp $lock ./config/picture/lock.jpg

    # gtk backup
	cp ~/.config/gtk-3.0/gtk.css ./config/gtk-3.0/gtk.css
}

function backup_firefox
{
    echo
    # to do
}

function backup_chrome
{
    echo
    # to do
}

function backup_pick-colour-picker
{
    echo
    # to do
}

function backup_deepin-screen-recorder
{
    echo
    # to do
}

function backup_deepin-screenshot   
{
    echo
    # to do
}

function backup_ranger
{
    echo
    #  to do
}

function backup_nautilus
{
    cp ~/.config/nautilus/* ./config/nautilus/
}

function backup_custom_script
{
    cp /usr/local/bin/* ./config/script/ -r
}

function backup_vi_mode
{
    cp ~/.editrc ./config/readline/
    cp ~/.inputrc ./config/readline/
}

function backup_touchpad
{
    cp /etc/X11/xorg.conf.d/70-synaptics.conf ./config/touchpad/
}

function backup_uninstall
{
    echo
    # to do
}

function backup_other
{
	#  smaller bar
    cp ~/.config/gtk-3.0/* ./config/gtk-3.0 -r

    # # input method
    # cp ~/.config/fcitx/ ./config/ -r
    # cp ~/.config/sogoupy ./config/sogou/ -r
    # cp ~/.config/sogoupy.users ./config/sogou/ -r
    # cp ~/.config/sogou-qimpanel  ./config/sogou/ -r

    #  font conf
    cp ~/.font.conf ./config/font/.font.conf

    # input method
    cp ~/.config/fcitx/ ./config/ -r
    rm ./config/sogou/* -rf
    cp ~/.config/SogouPY ./config/sogou/ -r
    rm ./config/sogou/SogouPY/*.bin ./config/sogou/SogouPY/sync -rf
    cp ~/.config/SogouPY.users ./config/sogou/ -r
    cp ~/.config/sogou-qimpanel  ./config/sogou/ -r
}

function backup_synapse
{
    cp ~/.config/synapse/config.json ./config/synapse/config.json
    cp ~/.config/autostart/synapse.desktop ./config/synapse/
}

function backup_gitkraken
{
    echo
    #  to do
}

function backup_inkscape
{
    echo 
    # to do
}

function backup_libreoffice     
{
    echo 
    # to do
}

function backup_postman
{
    echo
    #  to do
}

function backup_tim
{
    echo
    # to do
}

function backup_vscode
{
    cp ~/.config/Code/User/keybindings.json ./config/vscode/
    cp ~/.config/Code/User/settings.json ./config/vscode
    cp ~/.config/Code/User/vsicons.settings.json ./config/vscode
    cp ~/.config/Code/User/snippets ./config/vscode -r

    # extensions
    ls ~/.vscode/extensions >./config/vscode/extensions.list
}