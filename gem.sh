#!/usr/bin/env sh

if [ $(id -u) != "0" ]
then
echo 'must be run as root'
exit 1
fi

gem update --system
gem i git-up --no-user-install
gem i mime-types-data --no-user-install

