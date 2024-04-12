#!/bin/bash
source ./build-common.sh || exit 1

pkgver="1.7.0"

sha256sum=3c062bf0ba1606b2edfe9f455f628f70bc9cdd892decc1c940042e6aff6b8ab6
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
