typedef enum {
	RED,
	ORANGE,
	YELLOW,
	GREEN,
	BLUE,
	INDIGO,
	VIOLET
} colors;

int f(colors c) {
	switch (c) {
	case RED:
		//...
	case GREEN:
		//...
	case BLUE:
		//...
		//wrong: does not use all enum values, and has no default
	}

	switch(c) {
	case RED:
		//...
	case GREEN:
		//...
	default:
		//correct: does not use all enum values, but has a default
	}
}
