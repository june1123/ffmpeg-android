#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd ffmpeg

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac

make clean

./configure \
--target-os="$TARGET_OS" \
--cross-prefix="$CROSS_PREFIX" \
--arch="$NDK_ABI" \
--cpu="$CPU" \
--enable-runtime-cpudetect \
--sysroot="$NDK_SYSROOT" \
--disable-everything \
--enable-decoder=aac,h264,mjpeg,mpeg2video,mpeg4 \
--enable-encoder=aac,mpeg4,libx264 \
--enable-protocol=concat,file \
--enable-demuxer=aac,avi,h264,image2,matroska,pcm_s16le,mov,m4v,rawvideo,wav \
--enable-muxer=mp4 \
--enable-parser=aac,h264,mjpeg,mpeg4video,mpegaudio,mpegvideo,png \
--enable-bsf=aac_adtstoasc \
--enable-filter=transpose,scale,setdar,setsar,copy,anull \
--enable-gpl \
--enable-libx264 \
--enable-pic \
--enable-pthreads \
--enable-version3 \
--enable-hardcoded-tables \
--enable-yasm \
--disable-shared \
--enable-static \
--disable-doc \
--pkg-config="${2}/ffmpeg-pkg-config" \
--prefix="${2}/build/${1}" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS" \
--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-libs="-lm" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

make -j${NUMBER_OF_CORES} && make install || exit 1

popd
