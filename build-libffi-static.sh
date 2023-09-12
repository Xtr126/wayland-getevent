#!/bin/bash
source ./build-common.sh || exit 1

sha256sum=d66c56ad259a82cf2a9dfc408b32bf5da52371500b84745f7fb8b645712df676

download_file libffi-3.4.4.tar.gz $sha256sum 'https://github.com/libffi/libffi/releases/download/v3.4.4/libffi-3.4.4.tar.gz'

tar xf libffi-3.4.4.tar.gz || bsdtar -xf libffi-3.4.4.tar.gz
cd libffi-3.4.4

./configure --prefix=/ --enable-static --disable-multi-os-directory --disable-shared
mkdir out
make DESTDIR=$(pwd)/out install
cp out/lib/libffi.a ../../
