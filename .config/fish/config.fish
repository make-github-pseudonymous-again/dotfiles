set fish_key_bindings fish_vi_key_bindings

set -U EDITOR vim
set -U VISUAL vim

function fish_mode_prompt --description 'Displays the current mode'

	echo

	switch $fish_bind_mode
		case default
			set_color --bold --background red white
			echo -n '[N]'
		case insert
			set_color --bold --background green white
			echo -n '[I]'
		case visual
			set_color --bold --background magenta white
			echo -n '[V]'
	end
	set_color normal
	echo -n ' '

end

function prompt_git

	set -l s ''
	set -l branchName ''

	# Check if the current directory is in a Git repository.
	if [ (git rev-parse --is-inside-work-tree 1>/dev/null 2>&1; echo "$status") -eq '0' ]

		# check if the current directory is in .git before running git checks
		if [ (git rev-parse --is-inside-git-dir 2>/dev/null) = 'false' ]

			# Ensure the index is up to date.
			git update-index --really-refresh -q 1>/dev/null 2>&1;

			# Check for uncommitted changes in the index.
			if [ (git diff --quiet --ignore-submodules --cached; echo "$status") -ne '0' ]
				set s "$s"'+'
			end

			# Check for unstaged changes.
			if [ (git diff-files --quiet --ignore-submodules --; echo "$status") -ne '0' ]
				set s "$s"'!'
			end

			# Check for untracked files.
			if [ -n "(git ls-files --others --exclude-standard)" ]
				set s "$s"'?'
			end

			# Check for stashed files.
			if [ (git rev-parse --verify refs/stash 1>/dev/null 2>&1; echo "$status") -eq '0' ]
				set s "$s"'$'
			end

		end

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		set -l branchName (git symbolic-ref --quiet --short HEAD 2>/dev/null ; or git rev-parse --short HEAD 2>/dev/null ; or echo '(unknown)')

		if test -n "$s"
			set s " [$s]"
		end

		set_color -o white
		echo -n " on "
		set_color -o magenta
		echo -n "$branchName"
		set_color -o cyan
		echo -n "$s";
		set_color normal

	else
		return
	end

end

function fish_prompt --description 'Left prompt'

	set_color -o white
	echo -n (date +%T)

	set_color normal
	echo -n ' '

	set_color -o green
	echo -n (whoami)

	set_color -o white
	echo -n ' at '

	set_color -o yellow
	echo -n (hostname)

	set_color -o white
	echo -n ' in '

	set_color -o blue
	echo -n (prompt_pwd)
	set_color normal

	echo -n (prompt_git)

	echo

	set_color -o white
	echo -n '$ '
	set_color normal

end

function fish_right_prompt --description 'Right prompt'

	set -l last_status $status
	set -l last_cmd_duration $CMD_DURATION

	# Show last execution time and notify if it took long enough
	if test -n "$last_cmd_duration"

		set_color -o white
		echo -n "$last_cmd_duration ms "
		set_color normal

		if test "$last_cmd_duration" -gt 10000
			set -l last_cmd_line "$history[1]"
			notify-send -u low "$last_cmd_line" "Returned $last_status, took $last_cmd_duration seconds"
		end

	end

	if test $last_status -gt 0
		set_color -o red
	else
		set_color -o green
	end

	echo -n "$last_status"

	set_color normal


end
