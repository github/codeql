void one_argument();

void calls() {
	
	one_argument(1); // GOOD: `one_argument` will accept and use the argument
	
	one_argument(1, 2); // BAD: `one_argument` will use the first argument but ignore the second
}

void one_argument(int x);
