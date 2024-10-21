> [!NOTE]
> While we work on packaging our modified version of cage for popular distributions, [Use this](./README-alt.md) if you cannot build cage.

## Build 
**Cage dependencies**  
- [Arch](https://github.com/cage-kiosk/cage/blob/eaeab71ffa3ab5884df09c5664c00e368ca2585e/.github/workflows/main.yml#L32) `pacman -Syu xcb-util-wm seatd git clang meson libinput libdrm mesa libxkbcommon wayland wayland-protocols xorg-server-xwayland scdoc hwdata`  
- [Alpine](https://github.com/cage-kiosk/cage/blob/eaeab71ffa3ab5884df09c5664c00e368ca2585e/.github/workflows/main.yml#L26) `apk add build-base xcb-util-wm-dev libseat-dev clang git eudev-dev mesa-dev libdrm-dev libinput-dev libxkbcommon-dev pixman-dev wayland-dev meson wayland-protocols xwayland-dev scdoc-doc hwdata`
- Fedora `dnf install gcc gnupg2 meson libwayland-server libxkbcommon-devel libdisplay-info libliftoff hwdata lcms2 libdrm libinput libseat vulkan libwayland-client pixman-devel wayland-devel wayland-protocols-devel libdrm-devel libxcb-devel xcb-util-renderutil-devel seatd libseat-devel systemd-devel git patch`
 ```
    git clone https://github.com/Xtr126/cage
    cd cage
    git submodule update --init
    patch -d subprojects/wlroots/ -p1 -i ../../0001-wlroots-wayland-confine-pointer.patch 
    patch -d subprojects/wlroots/ -p1 -i ../../0002-wayland-decoration-envvar.patch
    patch -d subprojects/wlroots/ -p1 -i ../../0003-wlroots-wayland-backend-custom-size.patch
    patch -d subprojects/wlroots/ -p1 -i ../../0004-wlroots-x11-backend-custom-size.patch
    meson setup build --buildtype=release
    ninja -C build
```
If build fails, check if upstream cage and wlroots source code can build normally on your system:  
Cage: https://github.com/cage-kiosk/cage  
wlroots: https://gitlab.freedesktop.org/wlroots

## Usage
Install the latest version of XtMapper from https://github.com/Xtr126/wayland-getevent/releases/tag/latest only to use cage.  

Run the [cage_xtmapper.sh](https://github.com/Xtr126/cage/blob/master/cage_xtmapper.sh) script.  

        $ sudo -E ./cage_xtmapper.sh --user $(whoami) --window-width 1280 --window-height 720 --window-no-title-bar
Enable cursor on subsurface if cursor is invisible:
  
        $ waydroid prop set persist.waydroid.cursor_on_subsurface true
- wlroots x11 and wayland backends were modified to use a custom resolution set by the `XTMAPPER_WIDTH` and `XTMAPPER_HEIGHT` environment variables.  
- Wayland only - Hide window title bar when `WLR_NO_DECORATION=1` or `--window-no-title-bar` is set.  
- Use F10 or any other key defined in  [togglekey.h](https://github.com/Xtr126/cage/blob/master/togglekey.h) to toggle between XtMapper or Waydroid handling mouse input.
- Direct touchmap mode feature doesn't work, see https://github.com/Xtr126/wayland-getevent/issues/14#issuecomment-2415811259 for alternate method.


**Why no pre-built binaries?**
cage and wlroots are system software that needs to interface with the GPU driver and kernel, so it's not preferred to distribute binaries instead of building them.
Usually they are installed with system package manager.
Upstream cage and wlroots projects also distribute only source code.
In my opinion, cage and wlroots are easiest to build on archlinux, even upstream cage uses archlinux/alpine for their CI build.
Most Arch Linux systems running wayland already have the dependencies to build wlroots/cage, they can build straight-away. I always had dependency issues when trying to build them on Ubuntu, debian. If you found the dependencies please make a pull request.

