## Build 
    git clone https://github.com/Xtr126/cage
    cd cage
    git submodule update --init
    meson setup build
    ninja -C build

## Usage
    ./build/cage waydroid show-full-ui | sh -c  'while [[ -z $(adb shell getprop sys.boot_completed) ]]; do sleep 1; done; exec adb shell sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client'
    # establish adb connection in another terminal 
    adb connect <waydroid ip>
Edit line 775 in subprojects/wlroots/backend/wayland/output.c if you want to set a custom size for cage or force it through your window manager.
