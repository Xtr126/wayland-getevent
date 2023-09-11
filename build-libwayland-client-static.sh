#!/bin/bash
source ./build-common.sh || exit 1

if [ ! -f wayland-1.22.0.tar.xz ]; then
    curl -qgb "" -fLC - --retry 3 --retry-delay 3 -o wayland-1.22.0.tar.xz 'https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.22.0/downloads/wayland-1.22.0.tar.xz'
fi

sha256sum=1540af1ea698a471c2d8e9d288332c7e0fd360c8f1d12936ebb7e7cbc2425842
check_integrity wayland-1.22.0.tar.xz $sha256sum

tar xf wayland-1.22.0.tar.xz || bsdtar -xf wayland-1.22.0.tar.xz
cd wayland-1.22.0
meson setup build \
    -Dlibraries=true \
    -Dscanner=false \
    -Dtests=false \
    -Ddocumentation=false \
    -Ddtd_validation=false \
    --prefer-static --default-library static
ninja -C build
cp build/src/libwayland-client.a ../../
