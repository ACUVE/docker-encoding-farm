#!/bin/bash
set -xue

# Fetch Sources

cd /usr/local/src

git clone --depth 1 --recursive https://github.com/l-smash/l-smash
git clone --depth 1 --recursive git://git.videolan.org/x264.git
hg clone https://bitbucket.org/multicoreware/x265
git clone --depth 1 --recursive https://github.com/ultravideo/kvazaar.git
git clone --depth 1 --recursive git://github.com/mstorsjo/fdk-aac.git
git clone --depth 1 --recursive https://chromium.googlesource.com/webm/libvpx
git clone --depth 1 --recursive https://github.com/xiph/opus.git
git clone --depth 1 --recursive https://github.com/qyot27/libutvideo
git clone --depth 1 --recursive https://github.com/georgmartius/vid.stab.git
git clone --depth 1 --recursive git://source.ffmpeg.org/ffmpeg
git clone --depth 1 --recursive https://github.com/mulx/aacgain.git
git clone --depth 1 --recursive https://github.com/vapoursynth/vapoursynth.git
git clone --depth 1 --recursive https://github.com/FFMS/ffms2.git
git clone --depth 1 --recursive https://github.com/VFR-maniac/L-SMASH-Works.git
git clone --depth 1 --recursive https://github.com/VFR-maniac/VapourSynth-TNLMeans.git
git clone --depth 1 --recursive https://github.com/VFR-maniac/VapourSynth-FFT3DFilter.git
git clone --depth 1 --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain.git
git clone --depth 1 --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-IT.git
git clone --depth 1 --recursive https://github.com/dubhater/vapoursynth-mvtools.git
git clone --depth 1 --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DeLogo.git

# Copy

cp -a /usr/local/src/x264 /usr/local/src/x264_10

# Build L-SMASH

cd /usr/local/src/l-smash
./configure --prefix=/usr --enable-shared --disable-static
make -j 8
make install
ldconfig

# Build libx264

cd /usr/local/src/x264
./configure --prefix=/usr --enable-shared --enable-pic
make -j 8
make install
ldconfig

# Build x264_10

cd /usr/local/src/x264_10
./configure --enable-static --disable-shared --bit-depth=10
make -j 8
cp x264 /usr/bin/x264_10

# Build libx265

cd /usr/local/src/x265/build/linux
sed -i -e 's|^cmake|cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr|g' multilib.sh
MAKEFLAGS=-j8 ./multilib.sh
cd 8bit
make install
ldconfig

# Build libkvazaar

cd /usr/local/src/kvazaar/src
make -j 8
make install
ldconfig

# Build libfdk-aac

cd /usr/local/src/fdk-aac
./autogen.sh
./configure --prefix=/usr --enable-shared --disable-static --with-pic
make -j 8
make install
ldconfig

# Build libvpx

cd /usr/local/src/libvpx
./configure --prefix=/usr --enable-shared --disable-static --enable-pic --disable-examples
make -j 8
make install
ldconfig

# Build libopus

cd /usr/local/src/opus
./autogen.sh
./configure --prefix=/usr --disable-extra-programs
make -j 8
make install
ldconfig

# Build libutvideo
cd /usr/local/src/libutvideo
./configure --prefix=/usr --enable-pic --enable-shared --disable-static
make -j 8
make install
ldconfig

# Build libvidstab
cd /usr/local/src/vid.stab
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .
make -j 8
make install
ldconfig

# Build ffmpeg.

cd /usr/local/src/ffmpeg
./configure --prefix=/usr --extra-libs="-ldl" --enable-gpl --enable-nonfree --enable-pic --enable-shared --disable-static --disable-debug --enable-avresample --enable-libass --enable-fontconfig --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libutvideo --enable-libkvazaar --enable-libvidstab
make -j 8
make install
ldconfig

# Build aacgain

cd /usr/local/src/aacgain/mp4v2
./configure
make -k -j 8 || :
cd /usr/local/src/aacgain/faad2
./configure
make -k -j 8 || :
cd /usr/local/src/aacgain
./configure
make -j 8
make install

# Build VapourSynth

cd /usr/local/src/vapoursynth
./autogen.sh
./configure --prefix=/usr --enable-shared --disable-static --disable-ocr
make -j 8
make install
ldconfig

# Build ffms2

cd /usr/local/src/ffms2
./autogen.sh
./configure --enable-shared --disable-static --with-pic
make -j 8
cp src/core/.libs/libffms2.so /usr/lib/vapoursynth/libffms2.so

# Build LSMASHSource for VapourSynth

cd /usr/local/src/L-SMASH-Works/VapourSynth
./configure --extra-cflags=-fPIC
make -j 8
cp libvslsmashsource.so.* /usr/lib/vapoursynth/libvslsmashsource.so

# Build VapourSynth-TNLMeans

cd /usr/local/src/VapourSynth-TNLMeans
./configure
make -j 8
cp libvstnlmeans.so.* /usr/lib/vapoursynth/libvstnlmeans.so

# Build VapourSynth-FFT3DFilter

cd /usr/local/src/VapourSynth-FFT3DFilter
./configure
make -j 8
cp libvsfft3dfilter.so.* /usr/lib/vapoursynth/libvsfft3dfilter.so

# Build VapourSynth-AddGrain

cd /usr/local/src/VapourSynth-AddGrain
./configure --install=/usr/lib/vapoursynth
make -j 8
make install

# Build VapourSynth-IT

cd /usr/local/src/VapourSynth-IT
./configure --install=/usr/lib/vapoursynth
make -j 8
make install

# Build vapoursynth-mvtools

cd /usr/local/src/vapoursynth-mvtools
./autogen.sh
./configure --with-pic
make -j 8
cp .libs/libmvtools.so /usr/lib/vapoursynth/libmvtools.so

# Build VapourSynth-DeLogo

cd /usr/local/src/VapourSynth-DeLogo
./configure --install=/usr/lib/vapoursynth
make -j 8
make install
