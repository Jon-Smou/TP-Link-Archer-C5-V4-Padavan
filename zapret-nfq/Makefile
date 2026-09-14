CC ?= gcc
CFLAGS += -O3 -Wall
LIBS = -lnetfilter_queue -lnfnetlink -lpthread

OBJECTS = main.o nfqws.o packets.o conntrack.o protocol.o \
          helpers.o crypto.o darkstat.o srv.o

all: nfqws

nfqws: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) $(LIBS) -o nfqws

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o nfqws
