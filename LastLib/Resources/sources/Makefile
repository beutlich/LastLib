RM = rm -f

CFLAGS = -O3 -fPIC -Wall -pedantic
CPPFLAGS = -DNDEBUG
INC = -I .
LDFLAGS = -shared
LDLIBS = -lm

OBJECTS = ./last.o

Last.so: $(OBJECTS)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) $(LDFLAGS) -o $@ $(OBJECTS) $(LDLIBS)

./last.o: last.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) -c ./last.c

clean:
	$(RM) $(OBJECTS)
