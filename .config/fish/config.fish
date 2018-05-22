# disable Software Control Flow (c-s,c-q)
# http://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon 1>/dev/null 2>&1

# disable fish greeting
set fish_greeting

# set fish_key_bindings fish_vi_key_bindings
# fzf_key_bindings

. ~/.config/fish/exports.fish
. ~/.config/fish/aliases.fish
. ~/.config/fish/functions.fish
. ~/.config/fish/prompt.fish

function fish_vi_cursor; end

if status --is-login
	/usr/bin/systemctl --user import-environment PATH NODE_PATH
	/usr/bin/systemctl --user start environment.target
	if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
		exec startx -- -keeptty
	end
end
