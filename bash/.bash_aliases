# -*- mode: sh; -*-

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    #eval "`dircolors -b`"
    #alias ls='ls --color=auto'
    alias ls='ls -G'
    alias grep='grep --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias rmpyc='find . -name \*.pyc -print0 | xargs -0 rm'
alias rmpyi='find . -name \*.pyi -print0 | xargs -0 rm'

alias yolo='fab -R prod up -f scripts/fabfile.py'

alias mux='tmuxinator'

# Time since epoch, in seconds
alias epoch='date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s"'

# Ring the bell - https://stackoverflow.com/a/30016842/52550
alias notify="tput bel"

# Unfuck managed preferences
alias unfuck="sudo rm -rf /Library/Managed\ Preferences/msherry && sudo pkill -9 -f cfprefsd"

# Find parent branch of current git branch. From https://stackoverflow.com/a/17843908/52550
alias parent="git show-branch | grep '*' | grep -v \"$(git rev-parse --abbrev-ref HEAD)\" | head -n1| sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^^~].*//'"

alias rebase_master='CUR_BRANCH=$(git branch --show-current) && git checkout master && git pull && git checkout $CUR_BRANCH   && sleep 10 && git rebase master'
