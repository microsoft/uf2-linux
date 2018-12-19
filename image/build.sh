#!/bin/sh

TCZ="gdb alsa-modules-4.9.22-piCore alsa-oss alsa-plugins alsa alsa-utils libasound libasound-dev"

f="$1"
if [ "X$f" = X ] ; then
  mkdir -p ../built/tcz
  for t in $TCZ ; do
    test -f ../built/tcz/$t.tcz || curl http://www.tinycorelinux.net/9.x/armv6/tcz/$t.tcz > ../built/tcz/$t.tcz
  done
  rm -rf ../built/boot
  f=/build/image/inner.sh
fi

docker run -i -t --rm -v `cd .. && pwd`:/build pext/rpi:alsa "$f"
