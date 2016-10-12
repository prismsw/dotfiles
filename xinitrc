xcalib ~/dotfiles/LP140WF1_SPK1.icm

# Fool xdg-open into thinking that we are in a DE
export DE=gnome
export GNOME_DESKTOP_SESSION_ID="01"

# Merge Xresources for colour schemes
xrdb -merge ~/.Xresources

# Start pulseaudio
start-pulseaudio-x11

# Keybindings
xbindkeys

# Keyboard controlled cursor
keynav &

# Key remapping
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

# Disable touchpad when typing
#
#syndaemon -t -k -i 2 -d &

# Restore volume levels
alsactl -f ~/.asoundrc restore
# Hack to get the PulseAudio volume down from max to the stored settings
# One could also remove "flat-volumes=no" from /etc/pulse/daemon.conf, but it will cause weird interference with the VLC volume controls
#amixer set Master 1+
#amixer set Master 1-

# Autostart irssi
#screen -dmS irssi irssi&

# Composite manager for transparency
#compton -f -I 0.05 -O 0.05 -D 3 &

# Cursor theme fix
#xsetroot -cursor_name left_ptr &

# Wallpaper
#nitrogen --set-auto /home/simon/Pictures/wallpaper

# Needed to get xmobar from cabal to work
#PATH=$PATH:/home/simon/.cabal/bin

export _JAVA_AWT_WM_NONREPARENTING=1
wmname LG3D

# Notifications
dunst &

# Battery monitoring
batterymon -i 1 -e "/usr/bin/systemctl hibernate || /usr/bin/systemctl suspend" -c "3" -n "5" &

# Start awesome
# exec awesome
exec xmonad
