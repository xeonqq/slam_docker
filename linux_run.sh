#!/bin/bash

xhost +SI:localuser:root
docker run  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --security-opt apparmor=unconfined \
--rm -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/qq/repo:/workspace -e DISPLAY=$DISPLAY  -p 5000:5000 -p 8888:8888 -it slam:latest /bin/zsh $@
