void no_argument();

void three_arguments(int x, int y, int z);

void calls() {
	three_arguments(1, 2, 3); // GOOD
	three_arguments(1.0f, 2, 3.0f); // BAD: arguments 1 and 3 do not match parameters
}
