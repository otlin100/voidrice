#!/bin/sh
# Profile file. Runs on login.

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export DISPLAY=":0.0"
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="brave-beta"
export READER="zathura"
export FILE="lf"
export BIB="$HOME/Documents/LaTeX/uni.bib"
export REFER="$HOME/Documents/referbib"
export SUDO_ASKPASS="$HOME/.local/bin/mytools/dmenupass"
export SSH_ASKPASS="$HOME/.local/bin/mytools/dmenupass"
export GIT_ASKPASS="$HOME/.local/bin/mytools/dmenupass_git"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/config"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export SSH_AUTH_SOCK=$(gpgconf --homedir $GNUPGHOME --list-dirs agent-ssh-socket)
export CONDARC="$XDG_CONFIG_HOME/anaconda/.condarc"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/gopass"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export JAVA_HOME="/usr/lib/jvm/zulu-11"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Duser.home=$XDG_DATA_HOME/java"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export GOPATH="$XDG_DATA_HOME/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Workstation specific
export BATTERY="BAT1"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '')"; a="${a%_}"
export LESS_TERMCAP_md="$(printf '%b' '')"; a="${a%_}"
export LESS_TERMCAP_me="$(printf '%b' '')"; a="${a%_}"
export LESS_TERMCAP_so="$(printf '%b' '')"; a="${a%_}"
export LESS_TERMCAP_se="$(printf '%b' '')"; a="${a%_}"
export LESS_TERMCAP_us="$(printf '%b' '')"; a="${a%_}"
export LESS_TERMCAP_ue="$(printf '%b' '')"; a="${a%_}"

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx "$XDG_CONFIG_HOME/X11/xinitrc"

# Switch escape and caps if tty:
sudo -n loadkeys ~/.local/bin/ttymaps.kmap 2>/dev/null

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"
