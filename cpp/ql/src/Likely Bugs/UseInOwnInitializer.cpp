int f() {
	int x = x; // BAD: undefined behavior occurs here
	x = 0;
	return x;
}

int g() {
	int x = 0; // GOOD
	return x;
}
