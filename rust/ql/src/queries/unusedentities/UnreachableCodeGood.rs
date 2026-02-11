fn fib(input: u32) -> u32 {
	if (input == 0) {
		return 0;
	} else if (input == 1) {
		return 1;
	} else {
		return fib(input - 1) + fib(input - 2);
	}
}
