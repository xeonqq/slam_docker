#!/bin/bash

xhost +SI:localuser:root
docker run  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --security-opt apparmor=unconfined \
--rm -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/qq/repo:/workspace \
--privileged \
-e DISPLAY=$DISPLAY   \
-v /usr/lib/nvidia-384:/usr/lib/nvidia-384 \
-v /usr/lib32/nvidia-384:/usr/lib32/nvidia-384 \
--device /dev/dri \
-p 5000:5000 -p 8888:8888 -it slam:latest /bin/zsh $@
