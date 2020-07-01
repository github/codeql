void three_arguments(int x, int y, int z);

void calls() {
	int three = 3;
	three_arguments(1, 2, three); // GOOD
	three_arguments(1, 2, &three); // BAD
}
