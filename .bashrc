#!/bin/bash
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE= # Infinite history.
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

source /usr/share/nvm/nvm.sh --no-use

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
[ -f "$XDG_CONFIG_HOME/bash/shortcuts" ] && source "$XDG_CONFIG_HOME/bash/shortcuts" # Load shortcut aliases
[ -f "$XDG_CONFIG_HOME/bash/aliases" ] && source "$XDG_CONFIG_HOME/bash/aliases"

export GPG_TTY=$(tty)
bind -x '"\C-p": $EDITOR $(fzf);'
