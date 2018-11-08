
bool cond();

void test1()
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
			continue; // GOOD [never reached, if the condition changed so it was then the result would no longer apply] [FALSE POSITIVE]
		if (cond())
			break;
	}

	for (i = 0; false; i++)
	{
		if (cond())
			continue; // GOOD [never reached, if the condition changed so it was then the result would no longer apply] [FALSE POSITIVE]
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
}
