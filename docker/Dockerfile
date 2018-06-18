# ------------------------------------------------------------------------------
# Pull base image
FROM sdthirlwall/raspberry-pi-cross-compiler
MAINTAINER Michal Moskal <michal@moskal.me>

USER root

RUN curl https://deb.nodesource.com/node_6.x/pool/main/n/nodejs/nodejs_6.11.0-1nodesource1~jessie1_amd64.deb > node.deb \
 && dpkg -i node.deb \
 && rm node.deb

RUN apt-get install mtools cpio bc p7zip-full squashfs-tools 


RUN mkdir -p /picore/kernel
WORKDIR /picore/kernel
RUN curl http://www.tinycorelinux.net/9.x/armv6/releases/RPi/src/kernel/linux-rpi-4.9.22.tar.xz  > linux-rpi-4.9.22.tar.xz
RUN tar xf linux-rpi-4.9.22.tar.xz
RUN mv linux-rpi-4.9.22 linux-rpi
RUN rm linux-rpi-4.9.22.tar.xz
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
RUN mkdir rootfsv7
RUN cd rootfsv7 && zcat ../boot/9.0.3v7.gz | cpio -i -H newc -d

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

RUN useradd -m build
USER root
COPY go.js /home/build

