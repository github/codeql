void no_argument();

void one_argument(int x);

void calls() {
	no_argument(1) // BAD: `no_argument` will accept and ignore the argument
	
	one_argument(1); // GOOD: `one_argument` will accept and use the argument
	
	no_argument(); // GOOD: `no_argument` has not been passed an argument
}