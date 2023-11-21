A tool like Android getevent that is being developed for use in [XtMapper](https://github.com/Xtr126/XtMapper) to support waydroid.
## Building 
    $ make
You can also download executable binary from last successful build: [GitHub actions](https://github.com/Xtr126/wayland-getevent/actions)

---
Building the client from source.
---
Depends on libwayland-client and libxkbcommon.
You will need to have some system dependencies such as a C compiler installed for compiling it from source with make.  

    # Arch Linux
    sudo pacman -S wayland-protocols libxkbcommon
    
    # Ubuntu
    sudo apt install wayland-protocols libwayland-client0 libwayland-dev libxkbcommon-dev


Download the source
```
git clone https://github.com/Xtr126/wayland-getevent
cd wayland-getevent
```
Run make to build the client binary

    $ make

A script build.sh is included to download all dependencies and build without requiring libxkbcommon, wayland to be installed on system. Requires meson and ninja. 

    $ ./build.sh
You can also download executable binary from last successful build: [GitHub actions](https://github.com/Xtr126/wayland-getevent/actions)

---
Usage
---

    $ chmod a+x ./client
    $ ./client
Push client binary when container is running with adb

    $ adb push ./client /data/local/tmp
Or copy it (requires root privileges)

    # cp -a ./client ~/.local/share/waydroid/data/local/tmp/client
Enter waydroid shell 

    sudo waydroid shell
Execute binary and pipe in wayland events

    export XDG_RUNTIME_DIR=$(getprop waydroid.xdg_runtime_dir) 
    export WAYLAND_DISPLAY=$(getprop waydroid.wayland_display) 
    /data/local/tmp/client | sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client
This will create an invisible wayland window named "XtMapper" from which keyboard and mouse input events are captured and then forwarded to XtMapper.  
For it to work as intended, it's size should be same as that of the waydroid window and overlay the waydroid window.  

![image](https://github.com/Xtr126/wayland-getevent/assets/80520774/bd0d3df7-eb92-4816-8c67-506175709f23)
