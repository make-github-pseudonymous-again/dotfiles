function __new_completions

  set cmd (commandline -po)

  set CONFIG "$HOME/.config/new"
  set MODELS "$CONFIG/models"

  if test (count $cmd) -le 1
    ls --color=never "$MODELS"
  else
    ls --color=never "$MODELS" | grep --color=never "^$cmd[2]"
  end

end
