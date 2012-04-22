#ck-launch-session gnome-session

# Fool xdg-open into thinking that we are in a DE
export DE=gnome
export GNOME_DESKTOP_SESSION_ID="01"

# Merge Xresources for colour schemes
xrdb -merge ~/.Xresources

# Fix keyboard layout
setxkbmap -layout de -variant nodeadkeys

# Start pulseaudio
start-pulseaudio-x11

# Restore volume levels
alsactl -f ~/.asoundrc restore
# Hack to get the PulseAudio volume down from max to the stored settings
# One could also remove "flat-volumes=no" from /etc/pulse/daemon.conf, but it will cause weird interference with the VLC volume controls
amixer set Master 1+
amixer set Master 1-

# Start mpd
mpd &

# Autostart irssi
screen -dmS irssi irssi&

# Composite manager for transparency
xcompmgr -fF -I 0.1 -O 0.1 &

# Cursor theme fix
xsetroot -cursor_name left_ptr &

# Start awesome
exec awesome
