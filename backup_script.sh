#!/bin/bash

## author: si9ma
## my blog: www.coolcodes.me
##
## add your backup function here
## function backup_<your config name>
##

#  log
exec 2> >(tee -a "installer.log")

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

    cp $background ./config/picture/background.png
    cp $lock ./config/picture/lock.png

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

function backup_ranger
{
    cp ~/.config/ranger/* ./config/ranger/ -r
}

function backup_nautilus
{
    cp ~/.config/nautilus/* ./config/nautilus/
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