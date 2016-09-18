function fish_mode_prompt --description 'Displays the current mode'

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

function prompt_git --description 'Git part of the prompt'

	set -l s ''
	set -l branchName ''

	# Check if the current directory is in a Git repository.
	git rev-parse --is-inside-work-tree 1>/dev/null 2>&1
	if test $status -eq 0

		# check if the current directory is in .git before running git checks
		if [ (git rev-parse --is-inside-git-dir 2>/dev/null) = 'false' ]

			# Ensure the index is up to date.
			git update-index --really-refresh -q 1>/dev/null 2>&1;

			# Check for uncommitted changes in the index.
			git diff --quiet --ignore-submodules --cached
			if test $status -ne 0
				set s "$s"'+'
			end

			# Check for unstaged changes.
			git diff-files --quiet --ignore-submodules --
			if test $status -ne 0
				set s "$s"'!'
			end

			# Check for untracked files.
			set gitlsfiles (git ls-files --others --exclude-standard)
			if test "$gitlsfiles"
				set s "$s"'?'
			end

			# Check for stashed files.
			git rev-parse --verify refs/stash 1>/dev/null 2>&1
			if test $status -eq 0
				set s "$s"'$'
			end

		end

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		set -l branchName (git symbolic-ref --quiet --short HEAD 2>/dev/null ; or git rev-parse --short HEAD 2>/dev/null ; or echo '(unknown)')

		if test "$s"
			set s " [$s]"
		end

		set_color -o white
		echo -n " on "
		set_color normal

		set_color -o magenta
		echo -n "$branchName"
		set_color normal

		set_color -o cyan
		echo -n "$s";
		set_color normal

	else
		return
	end

end

function fish_prompt --description 'Left prompt'

	set_color -o EDD599
	echo -n (date +%T)
	set_color normal

	echo -n ' '

	set_color -o green
	echo -n (whoami)
	set_color normal

	set_color -o white
	echo -n ' at '
	set_color normal

	if test "$SSH_TTY"
		set_color -o red
	else
		set_color -o yellow
	end
	echo -n (hostname)
	set_color normal

	set_color -o white
	echo -n ' in '
	set_color normal

	set_color -o blue
	echo -n (prompt_pwd)
	set_color normal

	echo -n (prompt_git)

	echo

	set_color -o white
	if [ (id -u) = '0' ]
		echo -n '# '
	else
		echo -n '$ '
	end
	set_color normal

end

set -g last_cmd_duration_notify 0

function last_cmd_duration_notify_hook --on-event fish_postexec
	set -g last_cmd_duration_notify 1
end

function fish_right_prompt --description 'Right prompt'

	set -l last_status $status
	set -l last_cmd_line "$history[1]"
	set -l last_cmd_duration $CMD_DURATION

	# Show last execution time and notify if it took long enough
	if test "$last_cmd_duration"

		set_color -o EDD599
		echo -n "$last_cmd_duration ms "
		set_color normal

		switch (echo $last_cmd_line | cut -d' ' -f1)
		case man ranger r less vim
		case '*'
			if test $last_cmd_duration -gt 10000
				if test $last_cmd_duration_notify -eq 1
					set -g last_cmd_duration_notify 0
					notify-send -u critical "$last_cmd_line" "Returned $last_status, took $last_cmd_duration milliseconds"
				end
			end
		end

	end

	if test $last_status -gt 0
		set_color -o red
	else
		set_color -o green
	end

	printf "%3s" "$last_status"

	set_color normal

	if test "$SSH_TTY"
		set_color -o white
		echo -n 
		set_color normal
	end

end
