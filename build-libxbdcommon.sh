#!/bin/bash
source ./build-common.sh || exit 1

if [ ! -f xkbcommon-1.5.0.zip ]; then
curl 'https://codeload.github.com/xkbcommon/libxkbcommon/zip/refs/tags/xkbcommon-1.5.0' \
  -H 'authority: codeload.github.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en-GB;q=0.9,en;q=0.8' \
  -H 'dnt: 1' \
  -H 'referer: https://github.com/xkbcommon/libxkbcommon/releases/tag/xkbcommon-1.5.0' \
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
  -o xkbcommon-1.5.0.zip
fi

if [ ! -f xkbcommon-1.5.0.zip ]; then
    echo Download xkbcommon-1.5.0.zip failed && exit 1
fi

sha256sum=ebbafde6d2d43a305c73c0830226ff38900565975ed6c52029957e9417ac5191
check_integrity xkbcommon-1.5.0.zip $sha256sum
unzip -q xkbcommon-1.5.0.zip
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
