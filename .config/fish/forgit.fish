abbr --add gaf forgit::add
abbr --add gdf "forgit::diff * .*"

set -gx FORGIT_STASH_FZF_OPTS '
--bind="ctrl-d:reload(git stash drop $(cut -d: -f1 <<<{}) 1>/dev/null && git stash list)"
'

set -gx FORGIT_LOG_FZF_OPTS '
--bind="ctrl-e:execute(echo {} |grep -Eo [a-f0-9]+ |head -1 |xargs git show |nvim -)"
'
