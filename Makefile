WAYLAND_SCANNER = $(shell pkg-config --variable=wayland_scanner wayland-scanner)

WAYLAND_PROTOCOLS_DIR = $(shell pkg-config wayland-protocols --variable=pkgdatadir)
XDG_SHELL_PROTOCOL = $(WAYLAND_PROTOCOLS_DIR)/stable/xdg-shell/xdg-shell.xml

LIBS=./libwayland-client.a ./libffi.a ./libxkbcommon.a

xdg-shell-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(XDG_SHELL_PROTOCOL) xdg-shell-client-protocol.h

xdg-shell-protocol.c:
	$(WAYLAND_SCANNER) private-code $(XDG_SHELL_PROTOCOL) xdg-shell-protocol.c

all: client.c xdg-shell-client-protocol.h xdg-shell-protocol.c $(LIBS)
	$(CC) $(CFLAGS) \
		-g -std=c11 \
		-o client client.c xdg-shell-protocol.c \
		$(LIBS) -static

.DEFAULT_GOAL=all

.PHONY: clean
clean:
	$(RM) client xdg-shell-protocol.c xdg-shell-client-protocol.h
