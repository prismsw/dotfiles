#ck-launch-session gnome-session

# Fool xdg-open into thinking that we are in a DE
export DE=gnome
export GNOME_DESKTOP_SESSION_ID="01"

# Merge Xresources for colour schemes
xrdb -merge ~/.Xresources

# Start pulseaudio
start-pulseaudio-x11

# Start mpd
mpd

# Fix keyboard layout
setxkbmap -layout de -variant nodeadkeys

# Composite manager for transparency
xcompgr &

# Start awesome
exec awesome
