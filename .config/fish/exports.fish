
# Make vim the default editor
set -x EDITOR "vim"
set -x VISUAL "vim"

# DOES NOT WORK WELL WITH LAST_CMD_DURATION STUFF
# Make some commands not show up in history
# function ignorehistory --on-event fish_preexec
    # history --delete ls cd pwd exit date q gd gdw gaa gca gst gps r gds gdws
# end

# Prefer US English and use UTF-8
set -x LANG "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"

# Highlight section titles in manual pages
set -x LESS_TERMCAP_md (tput setaf 3)

# make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]
  set -x LESSOPEN "|/usr/bin/lesspipe.sh %s"
  set -x LESS_ADVANCED_PREPROCESSOR 1
end

set -l FZFCMD '( \
find . \
-name .git -prune -o \
-name node_modules -prune -o \
-type d -print -o \
-type f -print -o \
-type l -print \
| sed s/^..// \
) 2> /dev/null'
set -x FZF_DEFAULT_COMMAND "$FZFCMD"
set -x FZF_CTRL_T_COMMAND "$FZFCMD"

# ssh-agent socket
set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
