class TestDeclarations {
	int declarationTests(int a) {
		/* Some more complex flow control */
		int b, c;
		b = 0;
		c = 0;
		while(true)
		{
			b = 10;
			if (a > 100)
			{
				c = 10;
				b = c;
			}
			if (a == 10)
				break;
			if (a == 20)
				return c;
		}
		int x,y;
		x = 3;
		y = 4;
		return b;
	}
}