#!/bin/bash
source ./build-common.sh || exit 1

sha256sum=ebbafde6d2d43a305c73c0830226ff38900565975ed6c52029957e9417ac5191
download_file xkbcommon-1.5.0.zip $sha256sum 'https://codeload.github.com/xkbcommon/libxkbcommon/zip/refs/tags/xkbcommon-1.5.0'

bsdtar -xf xkbcommon-1.5.0.zip || unzip -q xkbcommon-1.5.0.zip
cd libxkbcommon-xkbcommon-1.5.0

meson setup build \
    --prefix /usr --libdir lib \
    -Denable-x11=false \
    -Dxkb-config-root=/usr/share/X11/xkb \
    -Dx-locale-root=/usr/share/X11/locale \
    -Denable-docs=false \
    -Denable-tools=false \
    -Denable-wayland=false \
    -Denable-xkbregistry=false \
    --prefer-static --default-library static
ninja -C build
meson install -C build --destdir "$SYSROOT_DIR"

cp "$SYSROOT_DIR"/usr/lib/libxkbcommon.a ../../
