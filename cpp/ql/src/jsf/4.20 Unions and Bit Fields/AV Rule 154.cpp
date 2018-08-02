struct {
	short s : 4; //wrong: behavior of signed bit-field members vary across compilers
	unsigned int : 24; //correct: unsigned
} bits;
