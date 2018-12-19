#!/bin/sh

docker build -t pext/rpi:alsa --squash -f Dockerfile . 
