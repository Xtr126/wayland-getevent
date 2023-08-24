WAYLAND_SCANNER = $(shell pkg-config --variable=wayland_scanner wayland-scanner)

WAYLAND_PROTOCOLS_DIR = $(shell pkg-config wayland-protocols --variable=pkgdatadir)
XDG_SHELL_PROTOCOL = $(WAYLAND_PROTOCOLS_DIR)/stable/xdg-shell/xdg-shell.xml
POINTER_CONSTRAINTS_PROTOCOL = $(WAYLAND_PROTOCOLS_DIR)/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml
RELATIVE_POINTER_PROTOCOL = $(WAYLAND_PROTOCOLS_DIR)/unstable/relative-pointer/relative-pointer-unstable-v1.xml

WL_HEADERS = xdg-shell-client-protocol.h  pointer-constraints-unstable-v1-client-protocol.h relative-pointer-unstable-v1-client-protocol.h
WL_CODE = xdg-shell-protocol.c pointer-constraints-protocol.c relative-pointer-protocol.c

LIBS=./libwayland-client.a ./libffi.a ./libxkbcommon.a

xdg-shell-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(XDG_SHELL_PROTOCOL) xdg-shell-client-protocol.h

xdg-shell-protocol.c:
	$(WAYLAND_SCANNER) private-code $(XDG_SHELL_PROTOCOL) xdg-shell-protocol.c

pointer-constraints-unstable-v1-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(POINTER_CONSTRAINTS_PROTOCOL) pointer-constraints-unstable-v1-client-protocol.h

pointer-constraints-protocol.c:
	$(WAYLAND_SCANNER) private-code $(POINTER_CONSTRAINTS_PROTOCOL) pointer-constraints-protocol.c

relative-pointer-unstable-v1-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(RELATIVE_POINTER_PROTOCOL) relative-pointer-unstable-v1-client-protocol.h

relative-pointer-protocol.c:
	$(WAYLAND_SCANNER) private-code $(RELATIVE_POINTER_PROTOCOL) relative-pointer-protocol.c

all: client.c $(WL_HEADERS) $(WL_CODE) $(LIBS)
	$(CC) $(CFLAGS) \
		-g -std=c11 \
		-o client client.c $(WL_HEADERS) $(WL_CODE) \
		$(LIBS) -static

.DEFAULT_GOAL=all

.PHONY: clean
clean:
	$(RM) client $(WL_HEADERS) $(WL_CODE)
