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

alias yolo='fab -R prod up -f scripts/fabfile.py'

alias mux='tmuxinator'

# Time since epoch, in seconds
alias epoch='date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s"'
