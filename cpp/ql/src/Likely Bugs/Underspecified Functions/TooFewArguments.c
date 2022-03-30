void one_argument();

void calls() {
	one_argument(1); // GOOD: `one_argument` will accept and use the argument
	
	one_argument(); // BAD: `one_argument` will receive an undefined value
}

void one_argument(int x);
