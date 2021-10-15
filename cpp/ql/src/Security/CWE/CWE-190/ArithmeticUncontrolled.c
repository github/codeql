int main(int argc, char** argv) {
	int i = rand();
	// BAD: potential overflow
	int j = i + 1000;

	// ...

	int n = rand();
	int k;
	// GOOD: use a guard to prevent overflow
	if (n < INT_MAX-1000)
		k = n + 1000;
	else
		k = INT_MAX;
}
