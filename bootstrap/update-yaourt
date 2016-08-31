#!/usr/bin/env sh

if [ $(id -u) == "0" ] ; then
echo 'must NOT be run as root'
exit 1
fi

cd /tmp

function fail {
	echo 'could not install yaourt'
	exit 1
}

if ! which yaourt 1>/dev/null 2>&1 ; then
echo 'installing yaourt'
wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz || fail
tar -xvf package-query.tar.gz && rm package-query.tar.gz
sh -c 'cd package-query && makepkg -si' || { rm -r package-query && fail ; }
rm -r package-query
wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz || fail
tar -xvf yaourt.tar.gz && rm yaourt.tar.gz
sh -c 'cd yaourt && makepkg -si' || { rm -r yaourt && fail ; }
rm -r yaourt
fi

if ! which yaourt 1>/dev/null 2>&1 ; then
fail
fi

yaourt -S --needed dmenu2
yaourt -S --needed fasd
yaourt -S --needed ttf-font-awesome
yaourt -S --needed solaar
yaourt -S --needed ipe
yaourt -S --needed astroid
yaourt -S --needed pdftk-bin
yaourt -S --needed yank-git
yaourt -S --needed hangups-git
yaourt -S --needed untex
yaourt -S --needed git-latexdiff
yaourt -S --needed ruby-coderay
yaourt -S --needed python-semantic_version
yaourt -S --needed xkblayout-state
