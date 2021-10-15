void f(int j) {
	int i=0;
	for(i; i<10, j>0; ++i, --j) { //i < 10 has no effect, since the comma 
	                              //operator only returns the value of the last expression
		/* ... */
	}
}
