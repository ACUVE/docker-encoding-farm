#!/bin/bash

# Fetch Sources

cd /usr/local/src

git clone --depth 1 --recursive https://github.com/l-smash/l-smash
git clone --depth 1 --recursive git://github.com/mbunkus/mkvtoolnix.git
git clone --depth 1 --recursive git://git.videolan.org/x264.git
hg clone https://bitbucket.org/multicoreware/x265
git clone --depth 1 --recursive git://github.com/mstorsjo/fdk-aac.git
git clone --depth 1 --recursive https://chromium.googlesource.com/webm/libvpx
git clone --depth 1 --recursive git://source.ffmpeg.org/ffmpeg
git clone --depth 1 --recursive git://git.opus-codec.org/opus.git
git clone --depth 1 --recursive https://github.com/mulx/aacgain.git

# Copy

cp -a /usr/local/src/x264 /usr/local/src/x264_10
cp -a /usr/local/src/x265 /usr/local/src/x265_10

# Build L-SMASH

cd /usr/local/src/l-smash
./configure
make -j 8
make install

# Build libx264

cd /usr/local/src/x264
./configure --enable-static
make -j 8
make install

# Build libx265

cd /usr/local/src/x265/build/linux
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../../source
make -j 8
make install

# Build libfdk-aac

cd /usr/local/src/fdk-aac
autoreconf -fiv
./configure --disable-shared
make -j 8
make install

# Build libvpx

cd /usr/local/src/libvpx
./configure --disable-examples
make -j 8
make install

# Build libopus

cd /usr/local/src/opus
./autogen.sh
./configure --disable-shared
make -j 8
make install

# Build ffmpeg.

cd /usr/local/src/ffmpeg
./configure --extra-libs="-ldl" --enable-gpl --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libfreetype --enable-nonfree
make -j 8
make install

# Build mkvtoolnix

cd /usr/local/src/mkvtoolnix
./autogen.sh
./configure
rake
rake install

# Build aacgain

cd /usr/local/src/aacgain/mp4v2
./configure && make -k -j 8 # some commands fail but build succeeds
cd /usr/local/src/aacgain/faad2
./configure && make -k -j 8 # some commands fail but build succeeds
cd /usr/local/src/aacgain
./configure && make -j 8 && make install

# Build x264_10

cd /usr/local/src/x264_10
./configure --enable-static --bit-depth=10
make -j 8
cp x264 /usr/bin/x264_10

# Build x265_10

cd /usr/local/src/x265_10/build/linux
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DENABLE_SHARED=OFF -DHIGH_BIT_DEPTH=ON ../../source
make -j 8
cp x265 /usr/bin/x265_10

# Remove all tmpfile 

rm -rf /usr/local/src
