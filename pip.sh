#!/usr/bin/env sh

if [ $(id -u) != "0" ]
then
echo 'must be run as root'
exit 1
fi

pip3 install semantic_version
pip3 install lxml
pip3 install arrow
pip3 install ics
