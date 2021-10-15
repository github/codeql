class Test {
	int field;

	int f(int param) {
		field = 3;
		int x = 1;
		int y;
		int z;
		if (param > 2) {
			x++;
			y = ++x;
			z = 3;
		} else {
			y = 2;
			y += 4;
			field = 10;
			z = 4;
		}
		;
		while (x < y) {
			if (param++ > 4) {
				break;
			}
			y -= 1;
		}
		;
		for (int i = 0; i<10; i++) {
			x += i;
		}
		;
		return x + y;
	}
}