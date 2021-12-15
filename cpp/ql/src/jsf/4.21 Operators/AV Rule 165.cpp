//for this example, sizeof(short) == 2 bytes
short f(unsigned short c) {
	return -c; //unsigned value being negated
}

cout << f(100); //as expected, returns -100
cout << f(40000U); //returns 25536
// (negation finds the two's complement of the bit representation of 40000)
