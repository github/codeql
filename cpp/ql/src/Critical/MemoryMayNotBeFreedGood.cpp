int* f() {
	int *buff = NULL;
	try {
		buff = malloc(SIZE*sizeof(int));
		do_stuff(buff);
		return buff;
	} catch (int do_stuff_exception) {
		if (buff != NULL) {
			free(buff);
		}
		return NULL; //returns NULL on error, having freed any allocated memory
	}
}
