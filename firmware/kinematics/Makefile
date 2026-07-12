CFLAGS = -Wall -Wextra -O2
LIBS = -lraylib -lm

visualizer: visualizer.c forward_kinematics.c
	gcc $^ $(CFLAGS) -o $@ $(LIBS)

clean:
	rm -f *.o
