#!/bin/sh

# Enable Natural Scrolling
xinput set-prop 11 283 1

# Disables middle button, use left and right together to simulate
xinput set-prop 11 293 1

feh --bg-fill ~/Imagens/Espaco.jpg
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
gnome-settings-daemon &
#xmodmap ~/.xmodmap
