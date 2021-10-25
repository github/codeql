
int myFunction();

void check(int result)
{
	if (result != 0)
	{
		throw "check failed";
	}
}

int main()
{
	int err;

	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD
	if (myFunction() != 0) return 1; // GOOD

	err = myFunction(); // GOOD
	if (err != 0) return 1;

	check(myFunction()); // GOOD

	myFunction(); // BAD (return value is ignored)

	(void)myFunction(); // GOOD
}
