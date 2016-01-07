#!/usr/bin/env sh

if [ $(id -u) != "0" ]
then
echo 'must be run as root'
exit 1
fi

pacman -Syu

pacman -S --needed --noconfirm lsb-release
pacman -S --needed --noconfirm ranger
pacman -S --needed --noconfirm cmake
pacman -S --needed --noconfirm make
pacman -S --needed --noconfirm xorg-xrdb
pacman -S --needed --noconfirm clang
pacman -S --needed --noconfirm gcc
pacman -S --needed --noconfirm curl
pacman -S --needed --noconfirm wget
pacman -S --needed --noconfirm zip unzip
pacman -S --needed --noconfirm git
pacman -S --needed --noconfirm rsync
pacman -S --needed --noconfirm terminator
pacman -S --needed --noconfirm bash-completion
pacman -S --needed --noconfirm gvim
pacman -S --needed --noconfirm firefox
pacman -S --needed --noconfirm evince
pacman -S --needed --noconfirm nodejs npm
pacman -S --needed --noconfirm pypy3
pacman -S --needed --noconfirm python-pip
pacman -S --needed --noconfirm python-lxml
pacman -S --needed --noconfirm go
pacman -S --needed --noconfirm transmission-gtk
pacman -S --needed --noconfirm base-devel
pacman -S --needed --noconfirm vlc
pacman -S --needed --noconfirm testdisk
pacman -S --needed --noconfirm pkgfile
pacman -S --needed --noconfirm bind-tools
pacman -S --needed --noconfirm pstoedit python2-numpy python2-lxml uniconvertor
pacman -S --needed --noconfirm inkscape
pacman -S --needed --noconfirm thefuck
pacman -S --needed --noconfirm tk
pacman -S --needed --noconfirm ack
pacman -S --needed --noconfirm at
pacman -S --needed --noconfirm cups
pacman -S --needed --noconfirm acpi
pacman -S --needed --noconfirm xorg-xkill
pacman -S --needed --noconfirm xclip
pacman -S --needed --noconfirm gnupg
pacman -S --needed --noconfirm pass

pacman -S --needed --noconfirm newsbeuter

pacman -S --needed --noconfirm offlineimap
pacman -S --needed --noconfirm msmtp

pacman -S --needed --noconfirm openssh
pacman -S --needed --noconfirm python2-keyring
pacman -S --needed --noconfirm python-keyring

# json CLI processor

pacman -S --needed --noconfirm jq

# replace ugly default font
pacman -S --needed --noconfirm extra/ttf-dejavu

# disk usage

pacman -S --needed --noconfirm ncdu

# iphone / USB

pacman -S --needed --noconfirm usbmuxd gvfs-afc
pacman -S --needed --noconfirm tumbler thunar

# image manipulation

pacman -S --needed --noconfirm scrot
pacman -S --needed --noconfirm screenfetch
pacman -S --needed --noconfirm libjpeg-turbo gifsicle optipng
pacman -S --needed --noconfirm feh imagemagick
pacman -S --needed --noconfirm gimp

# libre office

pacman -S --needed --noconfirm libreoffice-still

# latex

pacman -S --needed --noconfirm extra/texlive-bibtexextra \
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

pacman -S --needed --noconfirm xfig transfig geogebra
pacman -S --needed --noconfirm xorg-xwininfo xorg-xprop
