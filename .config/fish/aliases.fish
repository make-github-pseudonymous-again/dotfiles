# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
abbr -a -- - 'cd -'

# fasd aliases
alias v='f -e vim' # quick opening files with vim
alias m='f -e vlc' # quick opening files with vlc
alias j='fasd_cd -d'     # cd, same functionality as j in autojump
alias o='a -e xdg-open' # quick opening files with xdg-open

# Shortcuts
alias db="cd ~/dropbox"
alias dl="cd ~/downloads"
alias dt="cd ~/desktop"
alias u="cd ~/ulb"
alias h="history"
alias t="touch"
alias r="ranger"
alias q="exit"
alias lvl="echo $SHLVL"

alias g="git"
alias gl="git log"
alias gd="git diff"
alias gds="git diff --staged"
alias ga="git add"
alias gc="git commit"
alias gaa="git add --all ."
alias gca="git commit -a"
alias gps="git push"
alias gpl="git pull"
alias gst="git status"
alias gdt="git diff --word-diff-regex=."
alias gdts="git diff --word-diff-regex=. --staged"
alias gdw="git diff --color-words"
alias gdws="git diff --color-words --staged"

alias udpate="update"
alias up="update"

# ff to find a file
alias ff="fzf"

# errors from journal
alias errors="journalctl -b -p err|less"

# List all files colorized in long format
alias l="ls -lF --color"

# List all files colorized in long format, including dot files
alias la="ls -laF --color"

# List only directories
alias lsd="ls -lF --color | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls --color"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use Git's colored diff when available
command -v git > /dev/null; and alias diff="git diff --no-index --color-words"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D."; and date; and time cat; and date'

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null; or alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null; or alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null; or alias sha1sum="shasum"

# URL-encode strings
#alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS
	alias "$method"="lwp-request -m '$method'"
end

# Make Grunt print stack traces by default
command -v grunt > /dev/null; and alias grunt="grunt --stack"

# Lock the screen (when going AFK)
alias afk="system.LS"

# youtube-dl
alias vdl='youtube-dl'
alias adl='youtube-dl -f140 --'

# thefuck aliases
# THIS IS WAY TOO SLOW
# eval $(thefuck --alias fu)
function fu --description 'Run previous console command with sudo'
  commandline "sudo $history[1]"
end
function fuu -d "Correct your previous console command"
  set -l fucked_up_command $history[1]
  env TF_ALIAS=fuu PYTHONIOENCODING=utf-8 thefuck $fucked_up_command | read -l unfucked_command
  if [ "$unfucked_command" != "" ]
    eval $unfucked_command
    history --delete $fucked_up_command
    history --merge ^ /dev/null
  end
end
alias fuuu=fuu
alias fuuuu=fuu
alias fuk=fuu
alias fuuk=fuu
alias fuuuk=fuu
alias fuc=fuu
alias fuuc=fuu
alias fuuuc=fuu
alias fuck=fuu
alias fuuck=fuu
alias fuuuck=fuu
