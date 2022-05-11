int open_file_bad() {
	// BAD - this uses arbitrary bytes from the stack as mode argument
        return open(FILE, O_CREAT)
}

int open_file_good() {
	// GOOD - the mode argument is supplied
        return open(FILE, O_CREAT, S_IRUSR | S_IWUSR)
}
