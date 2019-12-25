#!/bin/bash

IP=$(ifconfig en1 | grep inet | awk '$1=="inet" {print $2}')
/usr/X11/bin/xhost +
/usr/X11/bin/xhost + "$IP"
docker run -v /Users/JIng/repo/:/workspace -e DISPLAY=host.docker.internal:0 -p 5000:5000 -p 8888:8888 -it slam:latest /bin/zsh $@
