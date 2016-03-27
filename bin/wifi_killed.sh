#!/usr/bin/sh
rfkill list wifi | grep yes
RET=$?
# grep found an yes entry
[ $RET -eq 0 ] && echo '(!)'
[ $RET -ne 0 ] && echo ''
exit 0
