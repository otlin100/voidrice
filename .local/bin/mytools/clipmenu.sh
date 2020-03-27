#!/usr/bin/env bash

case "$1" in
    show)
        dmen clip ;;
    clean)
        clipdel -d ".*" && notify-send "Clipboard Content deleted" || notify-send "Errors occurred while Clean Up" ;;
esac
