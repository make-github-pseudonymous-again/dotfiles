
# Make vim the default editor
set -gx EDITOR "vim"
set -gx VISUAL "vim"

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

# fzf config
set -l FZF_FIND_CMD find
command -v bfs > /dev/null; and set -l FZF_FIND_CMD bfs

set -l FZFCMD "command $FZF_FIND_CMD -L . \
-name .git -prune -o \
-name node_modules -prune -o \
-type d -print -o \
-type f -print -o \
-type l -print 2>/dev/null \
| sed 1d | cut -b3-" 2>/dev/null

set -x FZF_DEFAULT_COMMAND $FZFCMD
#set -x FZF_DEFAULT_OPTS $FZFOPTS # DOES NOT WORK ?

set -x FZF_CTRL_T_COMMAND $FZFCMD
set -x FZF_CTRL_T_OPTS $FZFOPTS

set -x FZF_ALT_C_COMMAND "command $FZF_FIND_CMD -L . \
-name .git -prune -o \
-name node_modules -prune -o \
-type d -print -o \
-type l -print 2>/dev/null \
| sed 1d | cut -b3-" 2>/dev/null
set -x FZF_ALT_C_OPTS "--preview 'ls -la {} | head -$LINES'"

# ssh-agent socket
#set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket" # ssh-agent.service
set -x SSH_AUTH_SOCK (gnome-keyring-daemon --start | awk -F "=" '$1 == "SSH_AUTH_SOCK" { print $2 }') # gnome-keyring with PAM

# ipe styles
if test -d $HOME/.ipe/styles
  set -gx IPESTYLES $HOME/.ipe/styles
end
