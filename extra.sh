#!/usr/bin/env sh

if [ $(id -u) == "0" ] ; then
echo 'must NOT be run as root'
exit 1
fi

cd /tmp

git clone https://github.com/gauteh/abunchoftags || exit $?
cd abunchoftags/dist/archlinux || exit $?
makepkg -si

cd /tmp

rm -rf abunchoftags
