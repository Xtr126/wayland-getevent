#!/bin/bash
source ./build-common.sh || exit 1

sha256sum=7459799d340c8296b695ef857c07ddef24c5a09b09ab6a74f7b92640d2b1ba11
download_file wayland-protocols-1.32.tar.xz $sha256sum 'https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.32/downloads/wayland-protocols-1.32.tar.xz'

tar xf wayland-protocols-1.32.tar.xz || bsdtar -xf wayland-protocols-1.32.tar.xz
cd wayland-protocols-1.32

meson setup build \
    --prefix /usr --libdir lib \
    -Dtests=false 
ninja -C build
meson install -C build --destdir "$SYSROOT_DIR"

