# disable Software Control Flow (c-s,c-q)
# http://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon 1>/dev/null 2>&1

# disable fish greeting
set fish_greeting

# set fish_key_bindings fish_vi_key_bindings
# fzf_key_bindings

set -g EDITOR vim
set -g VISUAL vim

. ~/.config/fish/exports.fish
. ~/.config/fish/aliases.fish
. ~/.config/fish/functions.fish
. ~/.config/fish/prompt.fish
