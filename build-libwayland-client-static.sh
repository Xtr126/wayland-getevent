#!/bin/bash
source ./build-common.sh || exit 1

sha256sum=1540af1ea698a471c2d8e9d288332c7e0fd360c8f1d12936ebb7e7cbc2425842
download_file wayland-1.22.0.tar.xz $sha256sum 'https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.22.0/downloads/wayland-1.22.0.tar.xz'

tar xf wayland-1.22.0.tar.xz || bsdtar -xf wayland-1.22.0.tar.xz
cd wayland-1.22.0

meson setup build \
    --prefix /usr --libdir lib \
    -Dlibraries=true \
    -Dscanner=true \
    -Dtests=false \
    -Ddocumentation=false \
    -Ddtd_validation=false \
    --prefer-static --default-library static
ninja -C build
meson install -C build --destdir "$SYSROOT_DIR"

cp "$SYSROOT_DIR"/usr/lib/libwayland-client.a ../../
