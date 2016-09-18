#!/usr/bin/env fish

# Create a new directory and enter it
function mkd
	mkdir -p $argv; and cd $argv[-1]
end

# "alert" for long running commands.  Use like so:
#   sleep 10; alert
function alert
	set -l last_cmd_status "$status"
	notify-send -u ([ $last_cmd_status = 0 ]; and echo low; or echo critical) ([ $last_cmd_status = 0 ]; and echo terminal; or echo error) $_
end

## copy history command
function ch
	set -l line (history | \
	eval "(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS" | \
	command sed 's/^\s*[0-9][0-9]*\s\s*//')
	echo -n "$line" | xsel -b
end
