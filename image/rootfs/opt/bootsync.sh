#!/bin/sh
# put other system startup commands here, the boot process will wait until they complete.
# Use bootlocal.sh for system startup commands that can run in the background 
# and therefore not slow down the boot process.
/usr/bin/sethostname box
set -x
modprobe snd_pcm_oss
modprobe nbd
modprobe dwc2
modprobe libcomposite
mkdir /sd
mount /dev/mmcblk0p1 /sd/
/sbin/uf2d /dev/nbd0
/opt/bootlocal.sh &
