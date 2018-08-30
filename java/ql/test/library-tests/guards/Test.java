class Test {
	private int z;
	void test(int x) {
		z = 0;
		if (x < 0) {
			throw new Exception();
		}
		int y = 0;
		while(x >= 0) {
			if (z >= 0)
				y++;
			if (y > 10) {
				z++;
				y++;
				z--;
			} else if (y < 10) {
				y--;
			} else if (y == 10) {
				y++;
			}
			x--;
		}
	}
	
	void test2(int x) {
		int y = 0;
		if (x > 5) {
			y++;
			int w = (x++ < 2) ? 0 : 1;
			y += x + w;
		} else {
			y++;
			if ((x = 4) < 4)
				y++;
			y += x;
		}
	}
}
