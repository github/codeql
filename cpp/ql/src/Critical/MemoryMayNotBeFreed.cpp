int* f() {
	try {
		int *buff = malloc(SIZE*sizeof(int));
		do_stuff(buff);
		return buff;
	} catch (int do_stuff_exception) {
		return NULL; //returns NULL on error, but does not free memory
	}
}
