## Build 
**Cage dependencies**  
- [Arch](https://github.com/cage-kiosk/cage/blob/eaeab71ffa3ab5884df09c5664c00e368ca2585e/.github/workflows/main.yml#L32) `pacman -Syu --noconfirm xcb-util-wm seatd git clang meson libinput libdrm mesa libxkbcommon wayland wayland-protocols xorg-server-xwayland scdoc hwdata`  
- [Alpine](https://github.com/cage-kiosk/cage/blob/eaeab71ffa3ab5884df09c5664c00e368ca2585e/.github/workflows/main.yml#L26) `apk add build-base xcb-util-wm-dev libseat-dev clang git eudev-dev mesa-dev libdrm-dev libinput-dev libxkbcommon-dev pixman-dev wayland-dev meson wayland-protocols xwayland-dev scdoc-doc hwdata`
 ```
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
```
If build fails, check if upstream cage and wlroots source code can build normally on your system:  
Cage: https://github.com/cage-kiosk/cage  
wlroots: https://gitlab.freedesktop.org/wlroots

## Usage
Install the latest version of XtMapper from https://github.com/Xtr126/XtMapper/actions/workflows/build-apk.yml only to use cage. Use nightly.link if you are not logged in.

Step 1 - Stop any running instance of waydroid prior to launching cage by restarting the service first:

        $ systemctl restart waydroid-container.service
Step 2 - Run the [cage_xtmapper.sh](https://github.com/Xtr126/cage/blob/master/cage_xtmapper.sh) script.  

        $ sudo -E ./cage_xtmapper.sh --user $(whoami) --window-width 1280 --window-height 720 --window-no-title-bar
Enable cursor on subsurface if cursor is invisible:
  
        $ waydroid prop set persist.waydroid.cursor_on_subsurface true
Reboot the system or restart the service when running cage again after closing it:

        $ systemctl restart waydroid-container.service
- wlroots x11 and wayland backends were modified to use a custom resolution set by the `XTMAPPER_WIDTH` and `XTMAPPER_HEIGHT` environment variables.  
- Wayland only - Hide window title bar when `WLR_NO_DECORATION=1` or `--window-no-title-bar` is set.  
- Use F11 or any other key defined in  [togglekey.h](https://github.com/Xtr126/cage/blob/master/togglekey.h) to toggle between XtMapper or Waydroid handling mouse input.
    
