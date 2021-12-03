
void doThing(int *ptr);

void switchTest1(int i)
{
	int *ptr;
	int x, y;

	switch (i) {
		case 1:
			doThing(ptr); // ptr can't be assumed assigned here
			ptr = &x;
			doThing(ptr); // ptr can be assumed assigned here
			return;
		case 2:
			doThing(ptr); // ptr can't be assumed assigned here
			ptr = &y;
			doThing(ptr); // ptr can be assumed assigned here
			return;
		default:
			__assume(0);
				// This tells the optimizer that the default
				// cannot be reached. As so, it does not have to generate
				// the extra code to check that 'p' has a value
				// not represented by a case arm. This makes the switch
				// run faster.
	}

	doThing(ptr); // ptr can be assumed assigned here
}

void switchTest2(int i)
{
	int *ptr;
	int x, y;

	switch (i) {
		case 1:
			doThing(ptr); // ptr can't be assumed assigned here
			ptr = &x;
			doThing(ptr); // ptr can be assumed assigned here
			return;
		case 2:
			doThing(ptr); // ptr can't be assumed assigned here
			ptr = &y;
			doThing(ptr); // ptr can be assumed assigned here
			return;
	}

	doThing(ptr); // ptr can't be assumed assigned here
}
