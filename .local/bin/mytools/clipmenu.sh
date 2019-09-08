#!/usr/bin/env bash
. "${HOME}/.local/bin/vars.sh"

export CM_DIR=$XDG_CACHE_HOME
export CM_HISTLENGTH=12

case "$1" in
    show)
        dmen clip ;;
    clean)
        clipdel -d ".*" && notify-send "Clipboard Content deleted" || notify-send "Errors occurred while Clean Up" ;;
esac
