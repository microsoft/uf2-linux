#!/bin/sh
set -xe
test -f /tmp/msd-ok && exit
modprobe g_multi file=/dev/nbd0 iSerialNumber=123456789 stall=0
touch /tmp/msd-ok
#/opt/rungdb.sh &
