struct {
	short s : 4; //wrong: behavior of signed bit-field members varies across compilers
	unsigned int : 24; //correct: unsigned
} bits;
