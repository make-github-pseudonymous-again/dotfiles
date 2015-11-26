#!/usr/bin/env sh

if [ $(id -u) != "0" ]
then
echo 'must be run as root'
exit 1
fi

pacman -Syu

pacman -S --noconfirm lsb-release
pacman -S --noconfirm ranger
pacman -S --noconfirm cmake
pacman -S --noconfirm make
pacman -S --noconfirm xorg-xrdb
pacman -S --noconfirm clang
pacman -S --noconfirm gcc
pacman -S --noconfirm curl
pacman -S --noconfirm wget
pacman -S --noconfirm zip unzip
pacman -S --noconfirm git
pacman -S --noconfirm rsync
pacman -S --noconfirm terminator
pacman -S --noconfirm gvim
pacman -S --noconfirm firefox
pacman -S --noconfirm nodejs npm
pacman -S --noconfirm python-pip
pacman -S --noconfirm python-lxml
pacman -S --noconfirm transmission-gtk
pacman -S --noconfirm base-devel
pacman -S --noconfirm vlc
pacman -S --noconfirm testdisk
pacman -S --noconfirm pkgfile
pacman -S --noconfirm bind-tools
pacman -S --noconfirm pstoedit python2-numpy python2-lxml uniconvertor
pacman -S --noconfirm inkscape
pacman -S --noconfirm thefuck
pacman -S --noconfirm ack

pacman -S --noconfirm offlineimap
pacman -S --noconfirm msmtp

pacman -S --noconfirm openssh
pacman -S --noconfirm python2-keyring
pacman -S --noconfirm python-keyring

# replace ugly default font
pacman -S --noconfirm extra/ttf-dejavu

# disk usage

pacman -S --noconfirm ncdu

# iphone / USB

pacman -S --noconfirm usbmuxd gvfs-afc
pacman -S --noconfirm tumbler thunar

# image manipulation

pacman -S --noconfirm scrot
pacman -S --noconfirm libjpeg-turbo gifsicle optipng
pacman -S --noconfirm feh imagemagick
pacman -S --noconfirm gimp

# libre office

pacman -S --noconfirm libreoffice-still

# latex

pacman -S --noconfirm extra/texlive-bibtexextra \
extra/texlive-bin \
extra/texlive-core \
extra/texlive-fontsextra \
extra/texlive-formatsextra \
extra/texlive-games \
extra/texlive-genericextra \
extra/texlive-htmlxml \
extra/texlive-humanities \
extra/texlive-langchinese \
extra/texlive-langcjk \
extra/texlive-langcyrillic \
extra/texlive-langextra \
extra/texlive-langgreek \
extra/texlive-langjapanese \
extra/texlive-langkorean \
extra/texlive-latexextra \
extra/texlive-music \
extra/texlive-pictures \
extra/texlive-plainextra \
extra/texlive-pstricks \
extra/texlive-publishers \
extra/texlive-science

pacman -S --noconfirm xfig transfig geogebra
