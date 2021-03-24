#!/usr/bin/sh
rfkill list wifi | grep yes > /dev/null
RET=$?
# grep found an yes entry
[ $RET -eq 0 ] && echo 'blocked'
[ $RET -ne 0 ] && echo ''
exit 0
