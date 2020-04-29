## To use distcc:
### On the server side execute the folloing:
 intall distcc just like inside the docker, and execute also: update-distcc-symlinks
 to launch the distccd daemon:
 distccd --daemon --verbose --log-file /tmp/distccd.log --allow 192.168.0.0/24 --listen=192.168.0.29
 Note: the server side must have the exact same version of gcc/g++/clang++
 by default, distccd uses 3632 as the port


### On the client side 
 the DISTCC_HOSTS env variable must contain the server ip i.e. 
 DISTCC_HOSTS='localhost 192.168.0.29'
 in clion need to set env variable CCACHE_PREFIX=distcc inorder to call ccache using distcc
 make -j 20  
 distccmon-text 3 # debug whether distcc is working
 set env variable DISTCC_VERBOSE=1 for debug distcc on the client side
 in CMakeList.txt for CMAKE_CXX_FLAGS the -march=native, must not be set, otherwise distcc will not work

