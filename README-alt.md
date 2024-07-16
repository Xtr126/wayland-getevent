## Build 
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
If build fails, check if upstream cage and wlroots source code can build normally on your system:  
Cage: https://github.com/cage-kiosk/cage  
wlroots: https://gitlab.freedesktop.org/wlroots

## Usage
    sudo -E ./cage_xtmapper.sh --user $(whoami) --window-width 1280 --window-height 720 --window-no-title-bar
    
Enter your sudo password when prompted.  
- Enable cursor on subsurface if cursor is invisible:
  
        $ waydroid prop set persist.waydroid.cursor_on_subsurface true
- Reboot the system or restart the service when running cage again after closing it:

        $ systemctl restart waydroid-container.service
- wlroots x11 and wayland backends were modified to use a custom resolution set by the `XTMAPPER_WIDTH` and `XTMAPPER_HEIGHT` environment variables.  
- Wayland only - Hide window title bar when `WLR_NO_DECORATION=1` or `--window-no-title-bar` is set.  
- Use F11 or any other key defined in  [togglekey.h](https://github.com/Xtr126/cage/blob/master/togglekey.h) to toggle between XtMapper or Waydroid handling mouse input.
    
