function __code_completions

  set cmd (commandline -po)

  set CACHEDIR "$XDG_CACHE_HOME"
  if test -z "$CACHEDIR"
    set CACHEDIR "$HOME/.cache"
  end
  if test -n "$CACHEDIR"
    set CACHE "$CACHEDIR/dmenu_run"
  else
    set CACHE "$HOME/.dmenu_cache"
  end

  if stest -dqr -n "$CACHE" $PATH
    stest -flx $PATH | sort -u > "$CACHE"
  end

  if test (count $cmd) -le 1
    cat "$CACHE"
  else
    cat "$CACHE" | grep --color=never "^$cmd[2]"
  end

end
