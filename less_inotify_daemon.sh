#!/bin/sh
nohup /usr/local/bin/less_inotify.sh $1 $2 0<&- &>/dev/null &
