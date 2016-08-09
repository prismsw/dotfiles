#!/usr/bin/zsh

if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | grep layout | awk '{print $2}')
    case $layout in
        us)
            setxkbmap de -variant nodeadkeys
            ;;
        en_US)
            setxkbmap de -variant nodeadkeys
            ;;
        *)
            setxkbmap en_US
            ;;
    esac
fi

# Rerun xmodmap
xmodmap ~/.Xmodmap
