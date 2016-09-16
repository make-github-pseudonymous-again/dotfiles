# disable Software Control Flow (c-s,c-q)
# http://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

# disable fish greeting
set fish_greeting

set fish_key_bindings fish_vi_key_bindings

set -U EDITOR vim
set -U VISUAL vim

. ~/.config/fish/prompt.fish
. ~/.config/fish/aliases.fish
