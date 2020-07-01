FILE* f() {
	try {
		FILE *fp = fopen("foo.txt", "w");
		do_stuff(fp);
		return fp; //if there are no exceptions, the file pointer is returned correctly
	} catch (int do_stuff_exception) {
		return NULL; //returns NULL on error, but does not close fp
	}
}
