#!/bin/bash

xhost +SI:localuser:root
docker run \
--rm -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME"/.gitconfig:/root/.gitconfig -v "$HOME"/repo:/workspace \
--privileged \
-e DISPLAY=$DISPLAY   \
-p 5000:5000 -p 8888:8888 -it slam:latest /bin/zsh $@
