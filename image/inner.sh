#!/bin/sh

set -ex
# build uf2
cd /build/uf2daemon
make

for suff in "" "3" ; do
k=4.9.22-piCore
if [ "X$suff" = "X3" ]; then
k=4.19.81-piCore-v7
fi

cd /picore/boot$suff
# remove stuff we don't support yet anyway
rm *_cd.* *_x.* *_db.*
if [ "X$suff" = "X" ]; then
rm *v7*
else
rm 11.*gz
rm kernel41981.img kernel41981v7l.img
fi
# overlay files
cp -r /build/image/boot$suff/* .

# extract TCZs
cd /picore
rm -rf sq
mkdir sq
for f in /build/built/tcz$suff/*.tcz ; do
  unsquashfs $f
  cp -r squashfs-root/* sq/
  rm -rf squashfs-root
done
r=rootfs$suff
cp sq/usr/local/bin/gdbserver $r/usr/bin/
cp -r sq/lib $r/
# copy alsa stuff
mkdir -p $r/usr/local/bin/ $r/usr/local/share/ $r/usr/local/lib/ $r/usr/local/sbin/
cp -ar sq/usr/local/bin/a* $r/usr/local/bin/
cp -ar sq/usr/local/sbin $r/usr/local/
cp -ar sq/usr/local/lib/lib* sq/usr/local/lib/alsa* $r/usr/local/lib/
cp -ar sq/usr/local/share/alsa $r/usr/local/share/

if [ "X$suff" = "X3" ]; then
tar zxf /build/built/modules.tar.gz
cp `find modules -name snd\*.ko` $r/lib/modules/$k/kernel/drivers/
else
for mod in snd-soc-core snd-bcm2835 snd-pcm-dmaengine snd-pcm snd-timer snd-compress snd ; do
  p=`find sq -name $mod.ko`
  cp $p $r/lib/modules/$k/kernel/drivers/
done
fi
#cp -r sq/* $r/
#cp -ra sq /build/

cp -r /build/image/rootfs/* $r/
cp /build/uf2daemon/uf2d $r/sbin/

cd $r
patch -p1 < /build/image/rootfs$suff.patch

# kernel modules
cd /picore/kernel$suff/linux-rpi
patch drivers/usb/gadget/function/f_mass_storage.c < /build/kernel/f_mass_storage.c.sync.patch
./mkusb.sh
dst=/picore/$r/lib/modules/$k/kernel

for d in drivers/usb/dwc2 drivers/usb/gadget \
  drivers/usb/gadget/legacy drivers/usb/gadget/function drivers/usb/gadget/udc ; do
  mkdir -p $dst/$d
  cp $d/*.ko $dst/$d
done

# create new image
cd /picore/$r
find | cpio -o -R 0:0 -H newc | gzip -4 > ../boot$suff/rootfs.gz

# Copy out results to host
mkdir -p /build/built
cp -r /picore/boot$suff /build/built/boot$suff

done
