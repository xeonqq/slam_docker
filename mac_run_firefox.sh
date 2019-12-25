#!/bin/bash

IP=$(ifconfig en1 | grep inet | awk '$1=="inet" {print $2}')
/usr/X11/bin/xhost +
/usr/X11/bin/xhost + "$IP"
docker run -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it slam:latest /bin/bash -c firefox
