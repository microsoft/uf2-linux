#!/bin/sh
ok=1
while : ; do
    if kill -0 `cat /tmp/pxt-pid` 2>/dev/null ; then
      ok=1
    else
      if [ $ok = 0 ] ; then
        if test -x /sd/prj/.menu.elf ; then
          /sd/prj/.menu.elf
        fi
        sleep 5
        ok=1
      else
        ok=0
      fi
    fi
    sleep 0.5
done
