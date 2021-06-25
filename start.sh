#!/bin/bash
# https://github.com/bengreenier/docker-xvfb/blob/master/docker/xvfb-startup.sh
Xvfb :99 -ac -screen 0 "$XVFB_RES" -nolisten tcp $XVFB_ARGS &
XVFB_PROC=$!
sleep 1
export DISPLAY=:99
"$@"
# Create copy advopt.txt to NOSODATA volume
cp advopt.txt NOSODATA/advopt.txt
./Noso
kill $XVFB_PROC
