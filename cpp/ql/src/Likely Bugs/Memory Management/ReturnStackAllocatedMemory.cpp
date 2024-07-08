Record *mkRecord(int value) {
	Record myRecord(value);

	return &myRecord; // BAD: return a pointer to `myRecord`, which is a stack-allocated object
}
