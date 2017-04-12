#!/usr/bin/zsh

xbacklight -get | awk '{print int($1)"%"}'
