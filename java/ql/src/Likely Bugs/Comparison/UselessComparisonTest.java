void method(int x) {
	while(x >= 0) {
		// do stuff
		x--;
	}
	if (x < 0) { // BAD: always true
		// do more stuff
	}
}