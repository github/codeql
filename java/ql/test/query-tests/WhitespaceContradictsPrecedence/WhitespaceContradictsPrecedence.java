public class WhitespaceContradictsPrecedence {
	int bad(int x) {
		return x + x>>1; 
	}

	int ok1(int x) {
		return x + x >> 1; 
	}

	int ok2(int x) {
		return x+x >> 1; 
	}

	int ok3(int x) {
		return x + (x>>1); 
	}

	int ok4(int x, int y, int z) {
		return x + y + z;
	}
	
	int ok5(int x, int y, int z) {
		return x + y+z;
	}

	int ok6(int x) {
		return x + x>> 1; 
	}
}