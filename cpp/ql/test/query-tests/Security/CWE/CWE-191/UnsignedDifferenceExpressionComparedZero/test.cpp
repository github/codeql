int getAnInt();

bool cond();

void test(unsigned x, unsigned y, bool unknown) {
	if(x - y > 0) { } // BAD

	unsigned total = getAnInt();
	unsigned limit = getAnInt();
	while(limit - total > 0) { // BAD
		total += getAnInt();
	}

	if(total <= limit) {
		while(limit - total > 0) { // GOOD [FALSE POSITIVE]
			total += getAnInt();
			if(total > limit) break;
		}
	}

	if(x >= y) {
		bool b = x - y > 0; // GOOD
	}

	if((int)(x - y) >= 0) { } // GOOD. Maybe an overflow happened, but the result is converted to the "likely intended" result before the comparison

	if(unknown) {
		y = x & 0xFF;
	} else {
		y = x;
	}
	bool b1 = x - y > 0; // GOOD [FALSE POSITIVE]

	x = getAnInt();
	y = getAnInt();
	if(y > x) {
		y = x - 1;
	}
	bool b2 = x - y > 0; // GOOD [FALSE POSITIVE]

	int N = getAnInt();
	y = x;
	while(cond()) {
		if(unknown) { y--; }
	}
	
	if(x - y > 0) { } // GOOD [FALSE POSITIVE]

	x = y;
	while(cond()) {
		if(unknown) break;
		y--;
	}

	if(x - y > 0) { } // GOOD [FALSE POSITIVE]

	y = 0;
	for(int i = 0; i < x; ++i) {
		if(unknown) { ++y; }
	}

	if(x - y > 0) { } // GOOD [FALSE POSITIVE]

	x = y;
	while(cond()) {
		if(unknown) { x++; }
	}

	if(x - y > 0) { } // GOOD [FALSE POSITIVE]

	int n = getAnInt();
	if (n > x - y) { n = x - y; }
	if (n > 0) {
  	y += n; // NOTE: `n` is at most `x - y` at this point.
  	if (x - y > 0) {} // GOOD [FALSE POSITIVE]
	}
}