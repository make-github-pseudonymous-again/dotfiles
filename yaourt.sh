#!/usr/bin/env sh

if [ $(id -u) == "0" ]
then
echo 'must NOT be run as root'
exit 1
fi

yaourt -S ttf-font-awesome
yaourt -S ruby-gpgme-1
yaourt -S sup-git
