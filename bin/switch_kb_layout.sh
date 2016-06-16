#!/usr/bin/zsh

if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | grep layout | awk '{print $2}')
    case $layout in
        en_US)
            echo "Switching to german"
            setxkbmap de -variant nodeadkeys
            ;;
        *)
            echo "Switching to english"
            setxkbmap en_US
            ;;
    esac
fi
 
# Rerun xmodmap
xmodmap ~/.Xmodmap
