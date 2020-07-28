#!/usr/bin/env sh

profile="${1:-default}"
find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name '*.'"$profile" | head -1
