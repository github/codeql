int f() {
	...
	if (error) {
		return -1;
	}
	...
	//wrong: no explicit return here, value returned is undefined
}
