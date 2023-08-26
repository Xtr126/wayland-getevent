#define _GNU_SOURCE
#include <stdlib.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>
#include <wayland-client.h>
#include "xdg-shell-client-protocol.h"
#include "pointer-constraints-unstable-v1-client-protocol.h"
#include "relative-pointer-unstable-v1-client-protocol.h"


static int
allocate_memfd(size_t size)
{
    int fd = syscall(SYS_memfd_create, "buffer", 0);
    if (fd < 0)
        return -1;
    int ret;
    do {
        ret = ftruncate(fd, size);
    } while (ret < 0 && errno == EINTR);
    if (ret < 0) {
        close(fd);
        return -1;
    }
    return fd;
}

/* Wayland code */
struct client_state {
    /* Globals */
    struct wl_display *wl_display;
    struct wl_registry *wl_registry;
    struct wl_shm *wl_shm;
    struct wl_compositor *wl_compositor;
    struct xdg_wm_base *xdg_wm_base;
    struct wl_seat *wl_seat;

    /* Objects */
    struct wl_surface *wl_surface;
    struct wl_pointer *wl_pointer;
    struct xdg_surface *xdg_surface;
    struct xdg_toplevel *xdg_toplevel;

    struct zwp_pointer_constraints_v1 *pointer_constraints;
    struct zwp_relative_pointer_manager_v1 *relative_pointer_manager;
    struct zwp_relative_pointer_v1 *relative_pointer;


    int32_t width, height;
    bool closed;
};

static void
wl_buffer_release(void *data, struct wl_buffer *wl_buffer)
{
    /* Sent by the compositor when it's no longer using this buffer */
    wl_buffer_destroy(wl_buffer);
}

static const struct wl_buffer_listener wl_buffer_listener = {
    .release = wl_buffer_release,
};

static struct wl_buffer *
draw_frame(struct client_state *state)
{
    int width = state->width, height = state->height;
    int stride = width * 4;
    int size = stride * height;

    int fd = allocate_memfd(size);
    if (fd == -1) {
        return NULL;
    }

    struct wl_shm_pool *pool = wl_shm_create_pool(state->wl_shm, fd, size);
    struct wl_buffer *buffer = wl_shm_pool_create_buffer(pool, 0,
            width, height, stride, WL_SHM_FORMAT_ARGB8888);
    wl_shm_pool_destroy(pool);
    close(fd);

    wl_buffer_add_listener(buffer, &wl_buffer_listener, NULL);
    return buffer;
}

static void
xdg_toplevel_configure(void *data,
		struct xdg_toplevel *xdg_toplevel, int32_t width, int32_t height,
		struct wl_array *states)
{
	struct client_state *state = data;
	if (width == 0 || height == 0) {
		/* Compositor is deferring to us */
		return;
	}
	state->width = width;
	state->height = height;
}

static void
xdg_toplevel_close(void *data, struct xdg_toplevel *toplevel)
{
	struct client_state *state = data;
	state->closed = true;
}

static const struct xdg_toplevel_listener xdg_toplevel_listener = {
	.configure = xdg_toplevel_configure,
	.close = xdg_toplevel_close,
};

static void
xdg_surface_configure(void *data,
        struct xdg_surface *xdg_surface, uint32_t serial)
{
    struct client_state *state = data;
    xdg_surface_ack_configure(xdg_surface, serial);

    struct wl_buffer *buffer = draw_frame(state);
    wl_surface_attach(state->wl_surface, buffer, 0, 0);
    wl_surface_commit(state->wl_surface);
}

static const struct xdg_surface_listener xdg_surface_listener = {
    .configure = xdg_surface_configure,
};

static void
xdg_wm_base_ping(void *data, struct xdg_wm_base *xdg_wm_base, uint32_t serial)
{
    xdg_wm_base_pong(xdg_wm_base, serial);
}

static const struct xdg_wm_base_listener xdg_wm_base_listener = {
    .ping = xdg_wm_base_ping,
};

void handle_relative_motion(void *data,
				struct zwp_relative_pointer_v1 *zwp_relative_pointer_v1,
				uint32_t utime_hi,
				uint32_t utime_lo,
				wl_fixed_t dx,
				wl_fixed_t dy,
				wl_fixed_t dx_unaccel,
				wl_fixed_t dy_unaccel)
{
    static double acc_x = 0;
    static double acc_y = 0;

    acc_x += wl_fixed_to_double(dx);
    acc_y += wl_fixed_to_double(dy);

    printf("REL_X %d\n", (int)acc_x);
    printf("REL_Y %d\n", (int)acc_y);

    acc_x -= (int)acc_x;
    acc_y -= (int)acc_y;
}


static const struct zwp_relative_pointer_v1_listener relative_pointer_listener = {
    handle_relative_motion,
};

static void
wl_seat_capabilities(void *data, struct wl_seat *wl_seat, uint32_t capabilities)
{
       struct client_state *state = data;

       bool have_pointer = capabilities & WL_SEAT_CAPABILITY_POINTER;

       if (have_pointer && state->wl_pointer == NULL) {
            state->wl_pointer = wl_seat_get_pointer(state->wl_seat);
            state->relative_pointer = zwp_relative_pointer_manager_v1_get_relative_pointer(
                            state->relative_pointer_manager, state->wl_pointer);
            zwp_relative_pointer_v1_add_listener(state->relative_pointer, &relative_pointer_listener, &state);

            zwp_pointer_constraints_v1_confine_pointer(state->pointer_constraints, state->wl_surface, state->wl_pointer, NULL, ZWP_POINTER_CONSTRAINTS_V1_LIFETIME_PERSISTENT);

       } else if (!have_pointer && state->wl_pointer != NULL) {
               wl_pointer_release(state->wl_pointer);
               state->wl_pointer = NULL;
       }
}

static void
wl_seat_name(void *data, struct wl_seat *wl_seat, const char *name)
{
    /* This space deliberately left blank */
}

static const struct wl_seat_listener wl_seat_listener = {
       .capabilities = wl_seat_capabilities,
       .name = wl_seat_name,
};

static void
registry_global(void *data, struct wl_registry *wl_registry,
        uint32_t name, const char *interface, uint32_t version)
{
    struct client_state *state = data;
    if (strcmp(interface, wl_shm_interface.name) == 0) {
        state->wl_shm = wl_registry_bind(
                wl_registry, name, &wl_shm_interface, 1);
    } else if (strcmp(interface, wl_compositor_interface.name) == 0) {
        state->wl_compositor = wl_registry_bind(
                wl_registry, name, &wl_compositor_interface, 4);
    } else if (strcmp(interface, xdg_wm_base_interface.name) == 0) {
        state->xdg_wm_base = wl_registry_bind(
                wl_registry, name, &xdg_wm_base_interface, 1);
        xdg_wm_base_add_listener(state->xdg_wm_base,
                &xdg_wm_base_listener, state);
    } else if (strcmp(interface, "zwp_pointer_constraints_v1") == 0) {
        state->pointer_constraints = (struct zwp_pointer_constraints_v1 *)wl_registry_bind(
                wl_registry, name, &zwp_pointer_constraints_v1_interface, 1);
    } else if (strcmp(interface, "zwp_relative_pointer_manager_v1") == 0) {
        state->relative_pointer_manager = (struct zwp_relative_pointer_manager_v1 *)wl_registry_bind(
                wl_registry, name, &zwp_relative_pointer_manager_v1_interface, 1);
    } else if (strcmp(interface, wl_seat_interface.name) == 0) {
               state->wl_seat = wl_registry_bind(
                               wl_registry, name, &wl_seat_interface, 7);
               wl_seat_add_listener(state->wl_seat,
                               &wl_seat_listener, state);
    }
}

static void
registry_global_remove(void *data,
        struct wl_registry *wl_registry, uint32_t name)
{
    /* This space deliberately left blank */
}

static const struct wl_registry_listener wl_registry_listener = {
    .global = registry_global,
    .global_remove = registry_global_remove,
};

int
main(int argc, char *argv[])
{
    struct client_state state = { 0 };
    state.width = 640;
	state.height = 480;
    state.wl_display = wl_display_connect(NULL);
    state.wl_registry = wl_display_get_registry(state.wl_display);
    wl_registry_add_listener(state.wl_registry, &wl_registry_listener, &state);
    wl_display_roundtrip(state.wl_display);

    state.wl_surface = wl_compositor_create_surface(state.wl_compositor);
    state.xdg_surface = xdg_wm_base_get_xdg_surface(
            state.xdg_wm_base, state.wl_surface);
    xdg_surface_add_listener(state.xdg_surface, &xdg_surface_listener, &state);
    state.xdg_toplevel = xdg_surface_get_toplevel(state.xdg_surface);

    xdg_toplevel_add_listener(state.xdg_toplevel, &xdg_toplevel_listener, &state);

    xdg_toplevel_set_title(state.xdg_toplevel, "XtMapper");
    xdg_toplevel_set_maximized(state.xdg_toplevel);
    wl_surface_commit(state.wl_surface);

    while (wl_display_dispatch(state.wl_display) && !state.closed) {
        /* This space deliberately left blank */
    }

    return 0;
}
