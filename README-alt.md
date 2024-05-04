## Build 
    git clone https://github.com/Xtr126/cage
    cd cage
    git submodule update --init
    patch -d subprojects/wlroots/ -p1 -i ../../0001-wlroots-confine-pointer.patch
    meson setup build --buildtype=release
    ninja -C build

## Usage
    systemctl restart waydroid-container.service
    export WLR_NO_DECORATION=1 XTMAPPER_WIDTH=1280 XTMAPPER_HEIGHT=720
     ./build/cage waydroid show-full-ui | sh -c  'while [[ -z $(waydroid prop get sys.boot_completed) ]]; do sleep 1; done; echo -en \'\\033[0;32m\'; exec sudo waydroid shell -- sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client --width=$XTMAPPER_WIDTH --height=$XTMAPPER_HEIGHT'

Enter your sudo password when prompted.  
By default cage starts with a hardcoded size of 1280x720. Edit line 775 in subprojects/wlroots/backend/wayland/output.c or force it through your window manager. 
