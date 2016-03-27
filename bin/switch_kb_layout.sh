#!/usr/bin/zsh

if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | awk 'END{print $2}')
    case $layout in
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
