FROM ubuntu:16.04


RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    libboost-all-dev

# Install some dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    zlib1g-dev \
    libjpeg-dev \
    libwebp-dev \
    libpng-dev \
    libtiff5-dev \
    libjasper-dev \
    libopenexr-dev \
    libgdal-dev \
    libdc1394-22-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libx264-dev yasm \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libv4l-dev \
    libxine2-dev \
    libtbb-dev \
    libeigen3-dev \
    libx11-dev \
    libatlas-base-dev \
    libgtk-3-dev \
    libboost-python-dev \
    libomp-dev \
    libprotobuf-dev \
    libleveldb-dev \
    libsnappy-dev \
    libhdf5-serial-dev \
    protobuf-compiler \
    libprotobuf-dev \
    libleveldb-dev \
    libsnappy-dev \
    libhdf5-serial-dev \
    protobuf-compiler \
    libatlas-base-dev \
    libopenblas-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblmdb-dev

#change shell
SHELL ["/bin/bash", "-c"]
RUN cp /bin/bash /bin/sh

#Install Boost
RUN cd /root && \
    wget --no-check-certificate https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz && \
    tar xzf boost_1_65_1.tar.gz && \
    rm boost_1_65_1.tar.gz && \
    cd boost_1_65_1 && \
    chmod +x bootstrap.sh && \
    ./bootstrap.sh && \
    chmod +x b2 && \
    ./b2 install -j "$(nproc)"

#Disable git ssl verify
RUN git config --global http.sslVerify false

 #Install OpenBLAS
 RUN cd /root && \ 
     git clone https://github.com/xianyi/OpenBLAS && \
     cd OpenBLAS && \
     make FC=gfortran -j"$(nproc)" && \
     make PREFIX=/usr/local install

 #Install OpenCV
 RUN cd /root && \
     wget --no-check-certificate https://github.com/opencv/opencv/archive/3.2.0.zip && \
     unzip 3.2.0.zip && \
     rm 3.2.0.zip && \
     cd opencv-3.2.0 &&\
     mkdir build && \
     cd build && \
     cmake -DWITH_TBB=ON -DWITH_XINE=ON .. && \
     make -j"$(nproc)" && \
     make install && \
     ldconfig

#Install Dlib
RUN cd /root && \
    wget --no-check-certificate http://dlib.net/files/dlib-19.8.tar.bz2 && \
    tar xvf dlib-19.8.tar.bz2 && \
    rm dlib-19.8.tar.bz2 && \
    cd dlib-19.8/ && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS=-fPIC .. && \
    make -j"$(nproc)" && \
    make install

#Install Caffe
RUN cd /root && \
    git clone https://github.com/BVLC/caffe && \
    cd caffe && \
    git checkout 1.0 && \
    mkdir build && \
    cd build && \
    cmake -DCPU_ONLY=ON -DBUILD_python=OFF -DBUILD_python_layer=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    cmake -DBLAS=Open -DUSE_OPENMP=ON .. && \
    make all -j"$(nproc)" && \
    make test && \
    make runtest && \
    make install

#Install Face swap
RUN cd /root  && \
    git clone https://github.com/YuvalNirkin/face_swap && \
    cd face_swap && \
    mkdir build && \
    cd build && \
    cmake -DWITH_BOOST_STATIC=OFF -DBUILD_INTERFACE_PYTHON=OFF -DBUILD_SHARED_LIBS=OFF -DBUILD_APPS=ON -DBUILD_TESTS=OFF cmake -DCMAKE_INSTALL_PREFIX=/root/face_swap -DCMAKE_BUILD_TYPE=Release .. && \
    make -j"$(nproc)" && \
    make install && \
    mkdir /root/face_swap/models && \
    mkdir /root/face_swap/sources && \
    mkdir /root/face_swap/targets && \
    mkdir /root/face_swap/output && \
    export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH

WORKDIR /root/face_swap/bin
