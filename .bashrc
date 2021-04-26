# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

[ -n "$PS1" ] && source ~/.bash_profile; # -n PS1 tests if we have a prompt

# use fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# If you use vi mode on bash, you need to add set -o vi before source ~/.fzf.bash
# in your .bashrc, so that it correctly sets up key bindings for vi mode.
# This is currently done in ~/.bash_profile
