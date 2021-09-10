# ~/.bash_profile: executed by bash(1) for login shells.

# Profiling -- https://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup

# PS4='+ $(gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

export PATH=~/projects/flycheck-pycheckers/bin/:$PATH

# For homebrew
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

# For pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
PYENV=`which pyenv`
if [ -x "$PYENV" ]; then
    eval "$(pyenv init --path)"
fi


if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


# opam configuration
test -r /Users/marcsherry/.opam/opam-init/init.sh && . /Users/marcsherry/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true


# https://support.apple.com/en-us/HT208050
export BASH_SILENCE_DEPRECATION_WARNING=1


# Profiling, part 2

# set +x
# exec 2>&3 3>&-
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
