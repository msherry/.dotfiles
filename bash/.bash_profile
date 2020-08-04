# ~/.bash_profile: executed by bash(1) for login shells.


if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

PYENV=`which pyenv`
if [ -x "$PYENV" ]; then
    eval "$(pyenv init -)"
fi

export PATH="/usr/local/opt/node@8/bin:$PATH"

# opam configuration
test -r /Users/marcsherry/.opam/opam-init/init.sh && . /Users/marcsherry/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
