RM = rm -f

CFLAGS = -O3 -fPIC
CPPFLAGS = -DNDEBUG
INC = -I .
LDFLAGS =
LDLIBS = -lm

OBJECTS = ./last.o

Last.so: $(OBJECTS)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) $(LDFLAGS) -shared -o Last.so $(OBJECTS) $(LDLIBS)

./last.o: last.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) -c ./last.c

clean:
	$(RM) $(OBJECTS)
