LIBS=\
	 ./libwayland-client.a -lm -pthread -lrt ./libffi.a \
	 ./libxkbcommon.a

all: client.c
	$(CC) $(CFLAGS) \
		-g -std=c11 \
		-o client client.c \
		$(LIBS) -static

.DEFAULT_GOAL=all