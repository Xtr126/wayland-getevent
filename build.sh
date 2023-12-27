#!/bin/bash
./build-libffi-static.sh  
./build-libwayland-client-static.sh  
./build-libxkbcommon-static.sh
./wayland-protocols.sh
source ./build-common.sh || exit 1
export PKG_CONFIG_PATH="$SYSROOT_DIR"/usr/lib/pkgconfig:"$SYSROOT_DIR"/usr/share/pkgconfig
cd ../
make static SYSROOT_DIR="$SYSROOT_DIR" CFLAGS=-I"$SYSROOT_DIR"/usr/include