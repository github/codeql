struct {
	int s : 4; //wrong: behavior of bit-field members with implicit signage vary across compilers
	unsigned int : 24; //correct: explicitly unsigned
	signed int : 4; //correct: explicitly signed
} bits;
