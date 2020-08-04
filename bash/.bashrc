# ~/.bashrc: executed by
# bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# For homebrew
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

export PATH=~/projects/flycheck-pycheckers/bin/:$PATH

# Python virtualenv stuff
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# Homedir /bin
export PATH=~/bin:$PATH

# Decent editor
export EDITOR=emacsclient

# RBenv ruby stuff
if [ -d $HOME/.rbenv ]; then
    export PATH=$HOME/.rbenv/shims:$PATH
    export PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
    # rbenv completion
    if [ -e ~/.rbenv/completions/rbenv.bash ]; then
        source ~/.rbenv/completions/rbenv.bash
    fi
fi

# Tmuxinator
[ -e ~/bin/tmuxinator.bash ] && source ~/bin/tmuxinator.bash

# Homebrew completion
if [ -f "$(brew --repository)"/Library/Contributions/brew_bash_completion.sh ]; then
    source "$(brew --repository)"/Library/Contributions/brew_bash_completion.sh
elif [ -f "$(brew --prefix)"/etc/bash_completion ]; then
    source "$(brew --prefix)"/etc/bash_completion
fi

# For berks
# Currently breaks some homebrew installs, so disabled
#export SSL_CERT_FILE="$(brew --prefix)/share/ca-bundle.crt"

# don't put duplicate lines in the history. See bash(1) for more options
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Don't lose bash history -
# http://www.aloop.org/2012/01/19/flush-commands-to-bash-history-immediately/
export PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# for use in the prompt later
git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export -f git_branch

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color-XXX|screen-color-XXX) # XXX because this actually sucks
        PS1='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\e[32m$(git_branch)\[\e[00m\]\$ '
        ;;
    *)
        PS1='\u@\h:\w$(git_branch)\$ '
        ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Clojure stuff
# This worked with monolithic clojure-contrib, but not new-style
# export CLOJURE_EXT=~/opt/clojure:~/opt/clojure-contrib/src/main/clojure
export CLOJURE_EXT=~/opt/clojure:~/opt/clojure-contrib/modules
PATH=$PATH:~/opt/clojure-contrib/launchers/bash
alias clj=clj-env-dir
PATH=$PATH:~/opt/leiningen

# MacTex
if [ -d /usr/texbin ]; then
    export PATH=/usr/texbin:$PATH
fi
if [ -d /Library/TeX/texbin ]; then
    export PATH=/Library/TeX/texbin:$PATH
fi

# http://www.sontek.net/blog/2010/12/28/tips_and_tricks_for_the_python_interpreter.html
# and https://github.com/sontek/dotfiles/blob/master/_pythonrc.py
[ -e ~/.pythonrc.py ] && export PYTHONSTARTUP=~/.pythonrc.py

# AWS cli completion
complete -C aws_completer aws

# Rust-related
export PATH="$HOME/.cargo/bin:$PATH"

if [ -e ~/.common ]; then
    for f in ~/.common/*; do
        . "$f"
    done
fi

# Company overrides come last because they may e.g. have company-specific
# modifications to paths
if [ -e ~/.bash_company ]; then
    for f in ~/.bash_company/*; do
        . "$f"
    done
fi

# Utils

# Ready-to-copy escape sequences for colors -
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[31mforeground colors\e[m\n"
	printf "Values 40..47 are \e[41mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

# GPG related, see https://github.com/keybase/keybase-issues/issues/1712
export GPG_TTY=$(tty)

# For John the Ripper, jumbo
# http://www.ylabs.co.kr/index.php?mid=board_pen_test&document_srl=30969&listStyle=viewer&page=1
export PATH=/usr/local/share/john/:$PATH

# If arc is installed via git clone (vs brew)
if [ -e ~/bin/arcanist/bin ]; then
    export PATH=~/bin/arcanist/bin:$PATH
fi


# Per https://confluence.team.affirm.com/pages/viewpage.action?pageId=135532051
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
