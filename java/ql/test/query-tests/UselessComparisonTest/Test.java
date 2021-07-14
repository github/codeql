class Test {
	private int z;
	void test(int x) {
		z = getInt();
		if (x < 0 || z < 0) {
			throw new Error();
		}
		int y = 0;
		if (x >= 0) y++; // useless test due to test in line 5 being false
		if (z >= 0) y++; // useless test due to test in line 5 being false
		while(x >= 0) {
			if (y < 10) {
				z++;
				if (y == 15) z++; // useless test due to test in line 12 being true
				y++;
				z--;
			} else if (y > 7) { // useless test due to test in line 12 being false
				y--;
			}
			if (!(y != 5) && z >= 0) { // z >= 0 is always true due to line 5 (and z being increasing)
				int w = y < 3 ? 0 : 1; // useless test due to test in line 20 being true
			}
			x--;
		}
	}
	void test2(int x) {
		if (x != 0) {
			int w = x == 0 ? 1 : 2; // useless test due to test in line 27 being true
			x--;
		} else if (x == 0) { // useless test due to test in line 27 being false
			x++;
		}
	}
	int getInt() { return 0; }
}
