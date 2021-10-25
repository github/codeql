int f() {
	//wrong: register storage specifier used
	register int i; //these register definitions can crowd out the
	                //variables x1 to x5 that are used in the complex
	                //operation in the inner loop, leading to slower
	                //performance
	register int j;

	for (i = 0; i < HUGE_NUM; i++) {
		for (j = 0; j < HUGE_NUM; j++) {
			int x1, x2, x3, x4, x5;
			//complex CPU-intensive operation that accesses
			//x1 to x5 a large number of times
		}
	}
}
