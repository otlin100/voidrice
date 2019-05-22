#!/bin/bash
. "${HOME}/.cache/wal/colors.sh"
export CM_DIR=$XDG_CACHE_HOME
export CM_HISTLENGTH=12

case "$1" in
    show)
        clipmenu -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15" ;;
    clean)
        clipdel -d ".*" && notify-send "Clipboard Content deleted" || notify-send "Errors occurred while Clean Up";;
esac
