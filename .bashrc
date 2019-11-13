#!/bin/bash
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
shopt -s histappend
HISTSIZE= HISTFILESIZE= # Infinite history.
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

[ -f "$HOME/.config/fzf/fzf.bash" ] && source "$XDG_CONFIG_HOME"/fzf/fzf.bash
[ -f "$XDG_CONFIG_HOME/shell/shortcuts" ] && source "$XDG_CONFIG_HOME/shell/shortcuts"
[ -f "$XDG_CONFIG_HOME/shell/aliases" ] && source "$XDG_CONFIG_HOME/shell/aliases"

export GPG_TTY=$(tty)
source /usr/share/autojump/autojump.bash
