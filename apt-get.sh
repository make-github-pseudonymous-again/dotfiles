#!/usr/bin/env sh


# UPDATE

apt-get update -y
apt-get upgrade -y


# PACKAGES

apt-get install -y pkg-config
apt-get install -y i3
apt-get install -y vim-gtk

apt-get install -y curl wget
apt-get install -y git mercurial subversion

apt-get install -y g++ clang

apt-get install -y python python3
apt-get install -y python-pip python3-pip
apt-get install -y bpython bpython3

apt-get install -y openjdk-7-jdk openjdk-7-jre
apt-get install -y openjdk-8-jdk openjdk-8-jre

apt-get install -y libmagickwand-dev imagemagick

apt-get install -y terminator
apt-get install -y ranger nautilus baobab
apt-get install -y dnsutils ngrep tcpdump libwww-perl

apt-get install -y texlive*
apt-get install -y gimp ipe inkscape
apt-get install -y klavaro
apt-get install -y libreoffice
apt-get install -y usb-creator-gtk
apt-get install -y transmission-gtk
apt-get install -y mplayer

apt-get install -y apache2 php5 mysql-server mysql-client phpmyadmin php5-imagick filezilla
apt-get install -y php5-intl php-apc

apt-get install -y sloccount
