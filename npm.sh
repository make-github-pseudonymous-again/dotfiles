#!/usr/bin/env sh

if [ $(id -u) != "0" ]
then
echo 'must be run as root'
exit 1
fi

npm i -g semver
npm i -g npm
npm i -g n
npm i -g jshint
npm i -g peerflix
npm i -g torrentflix
npm i -g uglify-js
npm i -g npm-check-updates
npm i -g jspm
npm i -g xyz
npm i -g yo
npm i -g grunt-cli
npm i -g gulp
npm i -g tick
npm i -g speed-test
npm i -g man-n
npm i -g np
npm i -g babel-cli
npm i -g esdoc
npm i -g ava-codemods
npm i -g xo
