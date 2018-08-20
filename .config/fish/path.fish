
# Add `~/.bin` to the `$PATH`
if test -d $HOME/.bin
  set -gx PATH $HOME/.bin $PATH
end

# ruby gems
set -gx RUBY_PATH (ruby -e 'print Gem.user_dir')/bin
if test -d $RUBY_PATH
  set -gx PATH $RUBY_PATH $PATH
end

# node path
#set -gx NODE_PATH /usr/local/share/.config/yarn/global/node_modules:/usr/lib/node_modules
set -gx NODE_PATH /usr/lib/node_modules
