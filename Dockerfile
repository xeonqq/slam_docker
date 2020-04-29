FROM spmallick/opencv-docker:opencv
MAINTAINER Qian Qian (xeonqq@gmail.com)

# this docker adds all the dependencies to compile orb_slam2
RUN apt-get -y update
RUN apt-get install -y tree feh vim-gnome firefox xauth libglew-dev ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev libjpeg-dev libpng12-dev libtiff5-dev libopenexr-dev zsh htop silversearcher-ag
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN wget -qO- https://download.jetbrains.com/cpp/CLion-2019.3.2.tar.gz | tar -xzvf - -C /root/
RUN git clone https://github.com/stevenlovegrove/Pangolin.git /root/installation/Pangolin
RUN cd /root/installation/Pangolin && mkdir build && cd build && cmake .. && cmake --build . && make install

RUN apt-get install -y clang-6.0 htop
RUN git clone https://github.com/xeonqq/shell_tools.git ~/bin
ENV PATH "$PATH:$HOME/bin"
RUN echo 'alias -s cpp="~/bin/run-cpp"' >> ~/.zshrc


RUN git clone --recurse-submodules https://github.com/xeonqq/my_vim_plugins.git ~/.vim
RUN ln -s ~/.vim/.vimrc ~/.vimrc

RUN git clone https://github.com/raulmur/ORB_SLAM2 /root/installation/ORB_SLAM2

# needed to allow clang to compile the source code
RUN sed -i 's,stdint-gcc,stdint,g' /root/installation/ORB_SLAM2/Thirdparty/DBoW2/DBoW2/FORB.cpp
RUN sed -i 's,stdint-gcc,stdint,g' /root/installation/ORB_SLAM2/src/ORBmatcher.cc

# we use clang, since it uses much less memory than gcc and is faster
RUN cd /root/installation/ORB_SLAM2 && CXX=clang++-6.0 CC=clang-6.0 ./build.sh
ENV PATH "$PATH:/root/clion-2019.3.2/bin"

RUN apt-get install -y mesa-utils freeglut3-dev module-init-tools
ADD NVIDIA-Linux-x86_64-390.116.run /tmp/nvidia/NVIDIA.run
RUN /tmp/nvidia/NVIDIA.run -s -N --no-kernel-module
RUN rm /tmp/nvidia/NVIDIA.run
RUN printf "set multiple-cursors\nset surround\nset ReplaceWithRegister" >> ~/.ideavim
RUN cd /home && wget http://downloads.sourceforge.net/project/boost/boost/1.72.0/boost_1_72_0.tar.gz \
  && tar xfz boost_1_72_0.tar.gz \
  && rm boost_1_72_0.tar.gz \
  && cd boost_1_72_0 \
  && ./bootstrap.sh --prefix=/usr/local --with-libraries=program_options \
  && ./b2 install \
  && cd /home \
  && rm -rf boost_1_72_0
RUN apt-get install -y ccache
RUN apt-get install -y iputils-ping libiberty-dev xclip
RUN wget -qO-  "https://github.com/distcc/distcc/releases/download/v3.3.3/distcc-3.3.3.tar.gz" | tar -xzvf - -C /tmp/
RUN cd /tmp/distcc-3.3.3 && ./configure && make && make install && rm -rf /tmp/distcc-3.3.3
RUN update-distcc-symlinks
ENV DISTCC_HOSTS='localhost 192.168.0.29'

