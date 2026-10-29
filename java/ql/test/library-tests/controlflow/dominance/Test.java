class Test {
	int test(int x, int w, int z) {
		int j;
		long y = 50;

		// if-else, multiple statements in block
		if (x > 0) {
			y = 20;
			z = 10;
		} else {
			y = 30;
		}

		z = (int) (x + y);

		// if-else with return in one branch
		if (x < 0)
			y = 40;
		else
			return z;

		// this is not the start of a BB due to the return
		z = 10;

		// single-branch if-else
		if (x == 0) {
			y = 60;
			z = 10;
		}

		z += x;

		// while loop
		while (x > 0) {
			y = 10;
			x--;
		}

		z += y;

		// for loop
		for (j = 0; j < 10; j++) {
			y = 0;
			w = 10;
		}

		z += w;

		// nested control flow
		for (j = 0; j < 10; j++) {
			y = 30;
			if (z > 0)
				if (y > 0) {
					w = 0;
					break;
				} else {
					w = 20;
				}
			else {
				w = 10;
				continue;
			}
			x = 0;
		}

		z += x + y + w;

		// nested control-flow

		w = 40;
		return w;
	}

	int test2(int a) {
		/* Some more complex flow control */
		int b;
		int c;
		c = 0;
		while(true) {
			b = 10;
			if (a > 100) {
				c = 10;
				b = c;
			}
			if (a == 10)
				break;
			if (a == 20)
				return c;
		}
		return b;
	}

}