#!/usr/bin/env sh

xrandr --fb 0x0 --output LVDS --primary --auto --panning 0x0+0+0 --output HDMI-0 --off --output DisplayPort-0 --auto
xrandr --output DisplayPort-0 --right-of LVDS
~/bin/wallpaper.refresh

