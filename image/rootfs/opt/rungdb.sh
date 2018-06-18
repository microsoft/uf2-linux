#!/bin/sh
killall gdbserver 2>/dev/null
sleep 3
gdbserver --multi /dev/ttyGS0
