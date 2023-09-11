#!/bin/bash
source ./build-common.sh || exit 1

if [ ! -f xkbcommon-1.5.0.zip ]; then
  curl -qgb "" -fLC - --retry 3 --retry-delay 3 -o xkbcommon-1.5.0.zip 'https://codeload.github.com/xkbcommon/libxkbcommon/zip/refs/tags/xkbcommon-1.5.0'
fi

if [ ! -f xkbcommon-1.5.0.zip ]; then
    echo Download xkbcommon-1.5.0.zip failed && exit 1
fi

sha256sum=ebbafde6d2d43a305c73c0830226ff38900565975ed6c52029957e9417ac5191
check_integrity xkbcommon-1.5.0.zip $sha256sum
tar xf bsdtar -xf xkbcommon-1.5.0.zip || bsdtar -xf xkbcommon-1.5.0.zip
cd libxkbcommon-xkbcommon-1.5.0
meson setup build \
    -Denable-x11=false \
    -Dxkb-config-root=/usr/share/X11/xkb \
    -Dx-locale-root=/usr/share/X11/locale \
    -Denable-docs=false \
    -Denable-tools=false \
    -Denable-wayland=false \
    --prefer-static --default-library static
ninja -C build
cp build/libxkbcommon.a ../../
