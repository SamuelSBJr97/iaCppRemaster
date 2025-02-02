#!/bin/bash

sudo apt update
sudo apt install -y build-essential cmake git pkg-config libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev gfortran openexr libatlas-base-dev python3-dev python3-numpy libtbb2 libtbb-dev libdc1394-22-dev

git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

cd /content/opencv
mkdir build
cd /content/opencv/build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=/content/opencv_contrib/modules \
      -D WITH_CUDA=OFF \
      -D BUILD_opencv_python3=ON \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_java=OFF \
      -D BUILD_EXAMPLES=OFF ..

make -j$(nproc)
sudo make install
sudo ldconfig

g++ -o /content/iaCppRemaster/iaCppRemaster /content/iaCppRemaster/src/iaCppRemaster.cpp `pkg-config --cflags --libs opencv4`