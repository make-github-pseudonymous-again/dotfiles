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

yaourt -S dmenu2
yaourt -S fasd
yaourt -S fzf
yaourt -S ttf-font-awesome
yaourt -S ruby-gpgme-1
yaourt -S sup-git
yaourt -S solaar
yaourt -S ipe
yaourt -S keybase-release
