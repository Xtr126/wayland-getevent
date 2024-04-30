## Build and run
    git clone https://github.com/Xtr126/cage
    cd cage
    git submodule update --init
    meson setup build
    ninja -C build
    ./build/cage waydroid show-full-ui
Edit line 775 in subprojects/wlroots/backend/wayland/output.c if you want to set a custom size for cage or force it through your window manager.
