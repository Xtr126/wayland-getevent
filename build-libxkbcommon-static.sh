#!/bin/bash
source ./build-common.sh || exit 1

pkgver="1.6.0"

sha256sum=ea2322ef49d0c015dccc90acf629442071a561564d401261635fbcc04ec6c420
download_file xkbcommon-$pkgver.zip $sha256sum https://codeload.github.com/xkbcommon/libxkbcommon/zip/refs/tags/xkbcommon-$pkgver

bsdtar -xf xkbcommon-$pkgver.zip || unzip -q xkbcommon-$pkgver.zip
cd libxkbcommon-xkbcommon-$pkgver

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

cp "$SYSROOT_DIR"/usr/lib/libxkbcommon.a ../
