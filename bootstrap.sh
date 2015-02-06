#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync \
		--exclude ".git/" \
		--exclude ".gitmodules" \
		--exclude "bootstrap.sh" \
		--exclude "apt-get.sh" \
		--exclude "npm.sh" \
		--exclude "gem.sh" \
		--exclude "modules" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		-avhL --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
