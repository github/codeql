Record *mkRecord(int value) {
	Record *myRecord = new Record(value);

	return myRecord; // GOOD: returns a pointer to a `myRecord`, which is a heap-allocated object.
}
