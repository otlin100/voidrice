#!/bin/bash
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE= # Infinite history.
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

[ -f "$HOME/.shortcuts" ] && source "$HOME/.shortcuts" # Load shortcut aliases
[ -f "$HOME/.aliasrc" ] && source "$HOME/.aliasrc"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. /opt/anaconda/etc/profile.d/conda.sh
source /usr/share/nvm/init-nvm.sh
source ~/.bash-git-prompt/gitprompt.sh

GIT_PROMPT_ONLY_IN_REPO=1
git_prompt_toggle

export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bind -x '"\C-p": $EDITOR $(fzf);'
