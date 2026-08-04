class Test {
	void unbox(Integer i, Boolean b) {
		// NOT OK
		int j = i + 19; // $ Alert
		// OK
		if (i == null);
		// NOT OK
		if (i == 42); // $ Alert
		// NOT OK
		j += i; // $ Alert
		// NOT OK
		int k = i; // $ Alert
		// NOT OK
		bar(b); // $ Alert
		// NOT OK
		int l = i == null ? 0 : i; // $ Alert
	}

	void bar(boolean b) {}

	Integer box(int i) {
		Integer[] is = new Integer[1];
		// NOT OK
		is[0] = i; // $ Alert
		// NOT OK
		Integer j = i; // $ Alert
		// NOT OK
		return i == -1 ? null : i; // $ Alert
	}

	void rebox(Integer i) {
		// NOT OK
		i += 19; // $ Alert
	}
}
