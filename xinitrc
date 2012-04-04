#ck-launch-session gnome-session
xrdb -merge ~/.Xresources
start-pulseaudio-x11
setxkbmap -layout de -variant nodeadkeys
xcompgr &
exec awesome
