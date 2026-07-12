CFLAGS=-Wall -Wextra

forward: forward_kinematics.c
	gcc $< $(CFLAGS) -o $@ -lm

clean:
	rm -f *.o
