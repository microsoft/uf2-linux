#!/bin/sh
set -x
rm /tmp/msd-ok
killall gdbserver 2>/dev/null
rmmod g_multi
