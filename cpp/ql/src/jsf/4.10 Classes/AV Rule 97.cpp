void f(char buf[]) { //wrong: uses an array as a parameter type
	int length = sizeof(buf); //will return sizeof(char*), not the size of the array passed
	...
}
