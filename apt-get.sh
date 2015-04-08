#!/usr/bin/env sh


# UPDATE

apt-get update -y
apt-get upgrade -y


# PACKAGES

apt-get install -y build-essential cmake
apt-get install -y pkg-config
apt-get install -y i3
apt-get install -y vim-gtk

apt-get install -y curl wget
apt-get install -y git mercurial subversion

apt-get install -y g++ clang

apt-get install -y python-dev
apt-get install -y python python3
apt-get install -y python-pip python3-pip
apt-get install -y bpython bpython3

apt-get install -y ruby
apt-get install -y ruby-dev

apt-get install -y openjdk-7-jdk openjdk-7-jre
apt-get install -y openjdk-8-jdk openjdk-8-jre

apt-get install -y golang

apt-get install -y libmagickwand-dev imagemagick

apt-get install -y terminator
apt-get install -y ranger nautilus baobab ack-grep
apt-get install -y dnsutils ngrep tcpdump libwww-perl

apt-get install -y texlive texlive-base texlive-bibtex-extra texlive-binaries\
texlive-extra-utils texlive-font-utils texlive-fonts-recommended\
texlive-generic-recommended texlive-latex-base texlive-latex-extra\
texlive-latex-recommended texlive-math-extra texlive-pictures texlive-pstricks\
texlive-fonts-extra texlive-formats-extra texlive-games texlive-generic-extra\
texlive-humanities texlive-lang-arabic texlive-lang-chinese texlive-lang-cjk\
texlive-lang-cyrillic texlive-lang-english texlive-lang-french\
texlive-lang-greek texlive-lang-japanese texlive-lang-korean texlive-music\
texlive-plain-extra texlive-publishers texlive-science texlive-xetex

apt-get install -y scrot gimp ipe inkscape
apt-get install -y klavaro
apt-get install -y libreoffice
apt-get install -y usb-creator-gtk
apt-get install -y transmission-gtk
apt-get install -y mplayer

apt-get install -y apache2 php5 mysql-server mysql-client phpmyadmin php5-imagick filezilla
apt-get install -y php5-intl php-apc
apt-get install -y libjpeg-turbo-progs gifsicle optipng

apt-get install -y sloccount
apt-get install -y vlc

apt-get install -y npm
ln -s /usr/bin/nodejs /usr/bin/node
