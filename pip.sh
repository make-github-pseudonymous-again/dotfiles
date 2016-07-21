#!/usr/bin/env sh

if [ $(id -u) != "0" ]
then
echo 'must be run as root'
exit 1
fi

pip install cssselect
pip install lxml
pip install arrow
pip install ics
pip install tldr
pip install autopep8
pip install ptpython
