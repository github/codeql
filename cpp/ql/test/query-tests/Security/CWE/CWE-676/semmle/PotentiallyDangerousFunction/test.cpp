char *gets();

void testOtherGets() {
	char *s;

	s = gets(); // GOOD: this is not the gets from stdio.h
}
