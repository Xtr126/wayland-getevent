A tool like Android getevent that is being developed for use in [XtMapper](https://github.com/Xtr126/XtMapper) to support waydroid.  
Requires wayland-protocols for building.   

    $ make
    $ ./client
## Usage
Push client binary when container is running with adb

    $ adb push ./client /data/local/tmp
Or copy it (requires root privileges)

    # cp -a ./client ~/.local/share/waydroid/data/local/tmp/client
Enter waydroid shell 

    # waydroid shell
Execute binary and pipe in wayland events

    export XDG_RUNTIME_DIR=$(getprop waydroid.xdg_runtime_dir) 
    export WAYLAND_DISPLAY=$(getprop waydroid.wayland_display) 
    /data/local/tmp/client | sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client
