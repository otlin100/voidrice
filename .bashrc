#!/bin/bash
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE= # Infinite history.
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

bind -x '"\C-p": $EDITOR $(fzf);'
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

export HISTFILE="$XDG_DATA_HOME"/bash/history
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export CONDARC="$XDG_CONFIG_HOME"/anaconda/.condarc
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export NVM_DIR="$XDG_DATA_HOME"/nvm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export _FASD_DATA="$XDG_DATA_HOME"/fasd/data

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh --no-use" # This loads nvm
[ -f "$XDG_CONFIG_HOME/bash_shortcuts" ] && source "$XDG_CONFIG_HOME/bash_shortcuts" # Load shortcut aliases
[ -f "$XDG_CONFIG_HOME/bash_aliases" ] && source "$XDG_CONFIG_HOME/bash_aliases"

export GPG_TTY=$(tty)
