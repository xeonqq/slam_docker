FROM spmallick/opencv-docker:opencv
MAINTAINER Qian Qian (xeonqq@gmail.com)

# this docker adds all the dependencies to compile orb_slam2
RUN apt-get -y update 
RUN apt-get install -y tree feh vim-gnome firefox xauth libglew-dev ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev libjpeg-dev libpng12-dev libtiff5-dev libopenexr-dev zsh htop silversearcher-ag
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN wget -P /tmp/ https://download.jetbrains.com/cpp/CLion-2019.3.2.tar.gz
RUN tar -xvf /tmp/CLion-2019.3.2.tar.gz -C /root
RUN git clone https://github.com/stevenlovegrove/Pangolin.git /root/installation/Pangolin
RUN cd /root/installation/Pangolin && mkdir build && cd build && cmake .. && cmake --build . && make install

RUN apt-get install -y clang-6.0

RUN git clone https://github.com/raulmur/ORB_SLAM2 /root/installation/ORB_SLAM2

# needed to allow clang to compile the source code
RUN sed -i 's,stdint-gcc,stdint,g' /root/installation/ORB_SLAM2/Thirdparty/DBoW2/DBoW2/FORB.cpp
RUN sed -i 's,stdint-gcc,stdint,g' /root/installation/ORB_SLAM2/src/ORBmatcher.cc

# we use clang, since it uses much less memory than gcc and is faster
RUN cd /root/installation/ORB_SLAM2 && CXX=clang++-6.0 CC=clang-6.0 ./build.sh
ENV PATH "$PATH:/root/clion-2019.3.2/bin"
