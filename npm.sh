#!/usr/bin/env sh

if [ $(id -u) != "0" ]
then
echo 'must be run as root'
exit 1
fi

npm i -g n
npm i -g json
npm i -g jshint
npm i -g peerflix
npm i -g torrentflix
npm i -g uglify-js
npm i -g npm-check-updates
npm i -g jspm
npm i -g duo
npm i -g bower
npm i -g ender
npm i -g spm
npm i -g jamjs
npm i -g component
npm i -g xyz
npm i -g yo
npm i -g grunt-cli
npm i -g gulp
npm i -g tick
npm i -g speed-test
npm i -g man-n
