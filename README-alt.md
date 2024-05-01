## Build 
    git clone https://github.com/Xtr126/cage
    cd cage
    git submodule update --init
    meson setup build --buildtype=release
    ninja -C build

## Usage
    ./build/cage waydroid show-full-ui | sh -c  'while [[ -z $(waydroid prop get sys.boot_completed) ]]; do sleep 1; done; exec sudo waydroid shell -- sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client --width=1280 --height=720'
Enter your sudo password when prompted.  
By default cage starts with a hardcoded size of 1280x720. Edit line 775 in subprojects/wlroots/backend/wayland/output.c or force it through your window manager. 
