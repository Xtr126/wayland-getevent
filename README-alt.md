## Build 
    git clone https://github.com/Xtr126/cage
    cd cage
    git submodule update --init
    patch -d subprojects/wlroots/ -p1 -i ../../0001-wlroots-wayland-confine-pointer.patch 
    patch -d subprojects/wlroots/ -p1 -i ../../0002-wayland-decoration-envvar.patch
    patch -d subprojects/wlroots/ -p1 -i ../../0003-wlroots-wayland-backend-custom-size.patch
    patch -d subprojects/wlroots/ -p1 -i ../../0004-wlroots-x11-backend-custom-size.patch
    patch -d subprojects/wlroots/ -p1 -i ../../0005-wlroots-x11-confine-pointer.patch
    meson setup build --buildtype=release
    ninja -C build

## Usage
    systemctl restart waydroid-container.service
    export WLR_NO_DECORATION=1 XTMAPPER_WIDTH=1280 XTMAPPER_HEIGHT=720
    ./build/cage waydroid show-full-ui | sh -c  'while [[ -z $(waydroid prop get sys.boot_completed) ]]; do sleep 1; done; exec sudo waydroid shell -- sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client --width=$XTMAPPER_WIDTH --height=$XTMAPPER_HEIGHT'
    

Enter your sudo password when prompted.  
wlroots x11 and wayland backends were modified to use a custom resolution set by the `XTMAPPER_WIDTH` and `XTMAPPER_HEIGHT` environment variables.  
Wayland only - Hide window title bar when `WLR_NO_DECORATION=1` is set.  
Use F11 or any other key defined in  [togglekey.h](https://github.com/Xtr126/cage/blob/master/togglekey.h) to toggle between letting XtMapper or Waydroid handle mouse input.
