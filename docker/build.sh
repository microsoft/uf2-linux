#!/bin/sh

docker build -t pext/rpi:rpi3 --squash -f Dockerfile . 
