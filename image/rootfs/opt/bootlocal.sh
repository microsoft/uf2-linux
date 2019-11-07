#!/bin/sh

# Start serial terminal
#grep -q console='tty\(S\|AMA\)0' /proc/cmdline && /usr/sbin/startserialtty &
/usr/sbin/startserialtty &

# Set CPU frequency governor to ondemand (default is performance)
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Load modules
/sbin/modprobe i2c-dev

/opt/menustart.sh &

# ------ Put other system startup commands below this line


