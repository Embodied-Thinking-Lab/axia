CFLAGS = -Wall -Wextra -O2
LIBS = -lm

FK: main.c forward_kinematics.c
	gcc $^ $(CFLAGS) -o $@.o $(LIBS)

clean:
	rm -f *.o
