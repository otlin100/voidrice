#!/bin/sh

wal -R

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

redshift -P -O 5000

xset r rate 200 50

exec i3
