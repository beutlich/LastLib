RM = rm -f

CFLAGS = -O3 -fPIC -Wall -pedantic -std=c99
CPPFLAGS = -DNDEBUG
INC = -I .
LDFLAGS = -shared
LDLIBS = -lm

OBJECTS = ./last.o

Last.so: $(OBJECTS)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) $(LDFLAGS) -o $@ $(OBJECTS) $(LDLIBS)

./last.o: last.c fmuTemplate.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) -c ./last.c

clean:
	$(RM) $(OBJECTS)
