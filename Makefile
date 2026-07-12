CFLAGS=-Wall -Wextra

rotation: rotation_matrix.c
	gcc $< $(CFLAGS) -o $@ -lm

clean:
	rm -f *.o