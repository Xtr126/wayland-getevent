## Build 
    git clone https://github.com/Xtr126/cage
    cd cage
    git submodule update --init
    meson setup build --buildtype=release
    ninja -C build

## Usage
    ./build/cage waydroid show-full-ui | sh -c  'while [[ -z $(waydroid prop get sys.boot_completed) ]]; do sleep 1; done; exec sudo waydroid shell -- sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client'
Enter your sudo password when asked.  
Edit line 775 in subprojects/wlroots/backend/wayland/output.c if you want to set a custom size for cage or force it through your window manager. Default is 1280x720.
