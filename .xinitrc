#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrdb -load ~/.Xresources

xset s off
xset -dpms
xset s noblank

xset r rate 200 30

exec i3
