Record *mkRecord(int value) {
	Record myRecord(value);

	return &myRecord; // BAD: returns a pointer to `myRecord`, which is a stack-allocated object.
}
