
int myNothingFunction()
{
	// does nothing

	return 0;
}

int __attribute__((__weak__)) myWeakNothingFunction()
{
	// does nothing, but we could be overridden at the linker stage with a non-weak definition
	// from elsewhere in the program.

	return 0;
}

void testWeak() {
	myNothingFunction(); // BAD
	myWeakNothingFunction(); // GOOD
}
