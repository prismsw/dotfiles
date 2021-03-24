#!/usr/bin/zsh

setxkbmap -query | grep layout | awk '{print substr($2, 0, 2)}'
