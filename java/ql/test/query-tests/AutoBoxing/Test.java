class Test {
	void unbox(Integer i, Boolean b) {
		// NOT OK
		int j = i + 19;
		// OK
		if (i == null);
		// NOT OK
		if (i == 42);
		// NOT OK
		j += i;
		// NOT OK
		int k = i;
		// NOT OK
		bar(b);
		// NOT OK
		int l = i == null ? 0 : i;
	}

	void bar(boolean b) {}

	Integer box(int i) {
		Integer[] is = new Integer[1];
		// NOT OK
		is[0] = i;
		// NOT OK
		Integer j = i;
		// NOT OK
		return i == -1 ? null : i;
	}

	void rebox(Integer i) {
		// NOT OK
		i += 19;
	}
}