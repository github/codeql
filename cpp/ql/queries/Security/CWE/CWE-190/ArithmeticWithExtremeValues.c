int main(int argc, char** argv) {
	int i = INT_MAX;
	// BAD: overflow
	int j = i + 1;

	// ...

	int l = INT_MAX;
	// GOOD: no overflow
	long k = (long)l + 1;
}
