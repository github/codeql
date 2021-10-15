
bool cond();

void test1(int x)
{
	int i;

	// --- do loops ---

	do
	{
		if (cond())
			continue; // BAD
		if (cond())
			break;
	} while (false);

	do
	{
		if (cond())
			continue;
		if (cond())
			break;
	} while (true);

	do
	{
		if (cond())
			continue;
		if (cond())
			break;
	} while (cond());

	// --- while, for loops ---

	while (false)
	{
		if (cond())
			continue; // GOOD [never reached, if the condition changed so it was then the result would no longer apply]
		if (cond())
			break;
	}

	for (i = 0; false; i++)
	{
		if (cond())
			continue; // GOOD [never reached, if the condition changed so it was then the result would no longer apply]
		if (cond())
			break;
	}

	// --- nested loops ---

	do
	{
		do
		{
			if (cond())
				continue; // BAD
			if (cond())
				break;
		} while (false);
	} while (true);

	do
	{
		do
		{
			if (cond())
				continue; // GOOD
			if (cond())
				break;
		} while (true);
	} while (false);

	do
	{
		switch (x)
		{
		case 1:
			// do [1]

			break; // break out of the switch

		default:
			// do [2]

			continue; // GOOD; break out of the loop entirely, skipping [3]
		};

		// do [3]

	} while (0);
}
