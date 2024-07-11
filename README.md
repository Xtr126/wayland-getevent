A tool like Android getevent that is being developed for use in [XtMapper](https://github.com/Xtr126/XtMapper) to support waydroid.  
Download executable binary from [releases](https://github.com/Xtr126/wayland-getevent/releases).  
It is advisable to build the client from source instead so that it can link against the system libraries.  

---
Usage
---

    $ chmod a+x ./client
    $ ./client | sudo waydroid shell -- sh /sdcard/Android/data/xtr.keymapper/files/xtMapper.sh --wayland-client
## Important
- This [hack](https://github.com/casualsnek/waydroid_script?tab=readme-ov-file#granting-full-permission-for-apps-data-hack) may be needed if xtMapper.sh can't be found. It will also fail to write the script if waydroid container is rooted. In that case unroot the waydroid container and try again. The app doesn't require root access to work.  
Or write the script manually with the command from [Alternate method](https://xtr126.github.io/XtMapper-docs/guides/activation/):

      $ echo 'exec <app_process command here> "$@"' | sudo tee ~/.local/share/waydroid/data/media/0/Android/data/xtr.keymapper/files/xtMapper.sh
- If cursor is invisible, enable cursor on subsurface

      $ waydroid prop set persist.waydroid.cursor_on_subsurface true 
- This will create an invisible wayland window named "XtMapper" from which keyboard and mouse input events are captured and then forwarded to XtMapper. 
- Minimize the client window and click on start button in XtMapper app, then maximize the client window back.  
- For it to work as intended, it's size should be same as that of the waydroid window and overlay the waydroid window.    
- If it launched fine, "using wayland client" will be output on the terminal.  
- [Auto Profiling](https://xtr126.github.io/XtMapper-docs/features/auto_profiling/) should be disabled in settings.
> [!NOTE]
> This tool has been discontinued. An alternative version by using a modified version of cage as passthrough compositor is being worked on. [More details](./README-alt.md)

![image](https://github.com/Xtr126/wayland-getevent/assets/80520774/bd0d3df7-eb92-4816-8c67-506175709f23)

---
Building the client from source
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

A script build.sh is included to download all dependencies and build a static binary without requiring libxkbcommon, wayland to be installed on system. Requires meson and ninja.

    $ ./build.sh
