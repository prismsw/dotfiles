#!/usr/bin/zsh

xbacklight | awk '{print int($1)"%"}'
