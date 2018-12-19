#!/bin/sh

set -ex
# build uf2
cd /build/uf2daemon
make

cd /picore/boot
# remove stuff we don't support yet anyway
rm *v7* *_cd.* *_x.* *_db.*
# overlay files
cp -r /build/image/boot/* .

# extract TCZs
cd /picore
mkdir sq
for f in /build/built/tcz/*.tcz ; do
  unsquashfs $f
  cp -r squashfs-root/* sq/
  rm -rf squashfs-root
done
cp sq/usr/local/bin/gdbserver rootfs/usr/bin/
cp -r sq/lib rootfs/
# copy alsa stuff
mkdir -p rootfs/usr/local/bin/ rootfs/usr/local/share/ rootfs/usr/local/lib/ rootfs/usr/local/sbin/
cp -ar sq/usr/local/bin/a* rootfs/usr/local/bin/
cp -ar sq/usr/local/sbin rootfs/usr/local/
cp -ar sq/usr/local/lib/lib* sq/usr/local/lib/alsa* rootfs/usr/local/lib/
cp -ar sq/usr/local/share/alsa rootfs/usr/local/share/
for mod in snd-pcm-oss snd-mixer-oss snd-soc-core snd-bcm2835 snd-pcm-dmaengine snd-pcm snd-timer snd-compress snd ; do
  p=`find sq -name $mod.ko`
  cp $p rootfs/lib/modules/4.9.22-piCore/kernel/drivers/
done

#cp -r sq/* rootfs/
#cp -ra sq /build/

cp -r /build/image/rootfs/* rootfs/
cp /build/uf2daemon/uf2d rootfs/sbin/

cd rootfs
patch -p1 < /build/image/rootfs.patch

# kernel modules
cd /picore/kernel/linux-rpi
patch drivers/usb/gadget/function/f_mass_storage.c < /build/kernel/f_mass_storage.c.sync.patch
./mkusb.sh
dst=/picore/rootfs/lib/modules/4.9.22-piCore/kernel

for d in drivers/usb/dwc2 drivers/usb/gadget \
  drivers/usb/gadget/legacy drivers/usb/gadget/function drivers/usb/gadget/udc ; do
  mkdir -p $dst/$d
  cp $d/*.ko $dst/$d
done

# create new image
cd /picore/rootfs
find | cpio -o -R 0:0 -H newc | gzip -4 > ../boot/9.0.3.gz

# Copy out results to host
mkdir -p /build/built
cp -r /picore/boot /build/built/boot
