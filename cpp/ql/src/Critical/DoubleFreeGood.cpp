int* f() {
	int *buff = malloc(SIZE*sizeof(int));
	do_stuff(buff);
	free(buff); // GOOD: buff is only freed once.
	int *new_buffer = malloc(SIZE*sizeof(int));
	return new_buffer;
}
