# ------------------------------------------------------------------------------
# Pull base image
FROM sdthirlwall/raspberry-pi-cross-compiler
MAINTAINER Michal Moskal <michal@moskal.me>

USER root

RUN curl https://deb.nodesource.com/node_6.x/pool/main/n/nodejs/nodejs_6.11.0-1nodesource1~jessie1_amd64.deb > node.deb \
 && dpkg -i node.deb \
 && rm node.deb

RUN apt-get  update
RUN apt-get install -y mtools cpio bc p7zip-full squashfs-tools bison flex libssl-dev fatcat

# RPI0

RUN mkdir -p /picore/kernel
WORKDIR /picore/kernel
RUN curl http://www.tinycorelinux.net/9.x/armv6/releases/RPi/src/kernel/linux-rpi-4.9.22.tar.xz  > linux-rpi-4.9.22.tar.xz \
 && tar xf linux-rpi-4.9.22.tar.xz \
 && mv linux-rpi-4.9.22 linux-rpi \
 && rm linux-rpi-4.9.22.tar.xz
RUN curl http://www.tinycorelinux.net/9.x/armv6/releases/RPi/src/kernel/4.9.22-piCore.config.xz | xzcat > linux-rpi/.config
RUN curl http://www.tinycorelinux.net/9.x/armv6/releases/RPi/src/kernel/4.9.22-piCore_Module.symvers.xz | xzcat > linux-rpi/Module.symvers
RUN curl http://www.tinycorelinux.net/9.x/armv6/releases/RPi/src/kernel/4.9.22-piCore_System.map.xz | xzcat > linux-rpi/System.map

WORKDIR /picore/kernel/linux-rpi

RUN make ARCH=arm CROSS_COMPILE=/rpxc/bin/arm-linux-gnueabihf- modules_prepare
RUN echo "#!/bin/sh" > mkusb.sh
RUN echo "make ARCH=arm CROSS_COMPILE=/rpxc/bin/arm-linux-gnueabihf- SUBDIRS=drivers/usb -j10 modules" >> mkusb.sh
RUN chmod +x mkusb.sh
RUN ./mkusb.sh

RUN mkdir /picore/img
WORKDIR /picore/img
RUN curl http://www.tinycorelinux.net/9.x/armv6/releases/RPi/piCore-9.0.3.zip > picore.zip
RUN 7z x picore.zip
RUN mkdir /picore/boot
RUN mcopy -s -i piCore-9.0.3.img@@4096K ::* ../boot
WORKDIR /picore
RUN rm -rf img
RUN mkdir rootfs
RUN cd rootfs && zcat ../boot/9.0.3.gz | cpio -i -H newc -d

# RPI3

RUN mkdir -p /picore/kernel3
WORKDIR /picore/kernel3
RUN curl http://tinycorelinux.net/11.x/armv7/releases/RPi/src/kernel/linux-rpi-4.19.81.tar.xz  > linux-rpi.tar.xz \
 && tar xf linux-rpi.tar.xz \
 && mv linux-rpi-4.19.81 linux-rpi \
 && rm linux-rpi.tar.xz
#RUN curl http://www.tinycorelinux.net/10.x/armv7/releases/RPi/src/kernel/4.19.58-piCore-v7.config.xz | xzcat > linux-rpi/.config
RUN curl http://tinycorelinux.net/11.x/armv7/releases/RPi/src/kernel/Module.symvers > linux-rpi/Module.symvers
RUN curl http://tinycorelinux.net/11.x/armv7/releases/RPi/src/kernel/System.map > linux-rpi/System.map

RUN mkdir /picore/img3
WORKDIR /picore/img3
RUN curl http://tinycorelinux.net/11.x/armv7/test_releases/RPi/piCore-11.0alpha1a.zip > picore.zip
RUN mkdir /picore/boot3
RUN 7z x picore.zip \
  && dd if=piCore-11.0alpha1a.img of=fat.img bs=4194304 skip=1 count=23 \
  && fatcat fat.img -x /picore/boot3

WORKDIR /picore/kernel3/linux-rpi

COPY config .config
RUN make ARCH=arm CROSS_COMPILE=/rpxc/bin/arm-linux-gnueabihf- modules_prepare
RUN echo "#!/bin/sh" > mkusb.sh
RUN echo "make ARCH=arm CROSS_COMPILE=/rpxc/bin/arm-linux-gnueabihf- SUBDIRS=drivers/usb -j10 modules" >> mkusb.sh
RUN chmod +x mkusb.sh
RUN ./mkusb.sh

WORKDIR /picore
RUN rm -rf img3
RUN mkdir rootfs3
RUN cd rootfs3 && zcat ../boot3/11.0alpha1av7.gz | cpio -i -H newc -d

# Generic

WORKDIR /picore
RUN git clone https://github.com/WiringPi/WiringPi
WORKDIR /picore/WiringPi/wiringPi
# WiringPi build script doesn't do cross-compile
RUN arm-linux-gnueabihf-gcc -g -ffunction-sections -fdata-sections -Os -c *.c -I .
RUN arm-linux-gnueabihf-ar rcs libwiringPi.a *.o
RUN cp libwiringPi.a /rpxc/arm-linux-gnueabihf/lib/
RUN cp *.h /rpxc/arm-linux-gnueabihf/libc/usr/include/
WORKDIR /picore
RUN rm -rf WiringPi

RUN curl http://www.tinycorelinux.net/9.x/armv6/tcz/libasound.tcz > libasound.tcz
RUN curl http://www.tinycorelinux.net/9.x/armv6/tcz/libasound-dev.tcz > libasound-dev.tcz
RUN mkdir sq/
RUN unsquashfs libasound.tcz && cp -r squashfs-root/* sq/ && rm -rf squashfs-root
RUN unsquashfs libasound-dev.tcz && cp -r squashfs-root/* sq/ && rm -rf squashfs-root
RUN cp -a sq/usr/local/lib/libasound* /rpxc/arm-linux-gnueabihf/lib/
RUN cp -ar sq/usr/local/include/* /rpxc/arm-linux-gnueabihf/libc/usr/include/
RUN rm -rf sq

RUN useradd -m build
USER root
COPY go.js /home/build

