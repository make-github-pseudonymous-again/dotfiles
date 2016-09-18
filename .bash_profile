# disable Software Control Flow (c-s,c-q)
# http://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

# Add `~/.bin` to the `$PATH`
# (already done in .xprofile)
#if [ -d "$HOME/.bin" ] ; then
#	export PATH="$HOME/.bin:$PATH";
#fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you do not want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,misc,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize;

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar;

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi;

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "firefox" killall;

# Init fasd
# eval "$(fasd --init auto)"
fasd_cache="$HOME/.fasd-init-cache"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init auto >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
alias v='f -e vim' # quick opening files with vim
alias m='f -e vlc' # quick opening files with vlc
alias j='fasd_cd -d'     # cd, same functionality as j in autojump
alias o='a -e xdg-open' # quick opening files with xdg-open
_fasd_bash_hook_cmd_complete v m j o

# bind vi keys
set -o vi

# use fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#If you use vi mode on bash, you need to add set -o vi before source ~/.fzf.bash
#in your .bashrc, so that it correctly sets up key bindings for vi mode.
