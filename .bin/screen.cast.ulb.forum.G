#!/usr/bin/env sh

indefault=LVDS
exdefault=DisplayPort-0

# shellcheck disable=SC2046
screen.layout.double "$indefault" "$exdefault" --right-of \
  $(xrandr.list.internal | xrandr.filter.connected | xrandr.filter.not "$indefault") \
  $(xrandr.list.external | xrandr.filter.connected | xrandr.filter.not "$exdefault")

wallpaper.refresh
