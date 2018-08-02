
struct myStruct
{
	int a, b;
};

int main()
{
	myStruct s1, s2;

	for (s1.a = 0; s1.a < 10; s1.a++) // GOOD
	{
		for (s1.b = 0; s1.b < 10; s1.b++) // GOOD
		{
			for (s2.a = 0; s2.a < 10; s2.a++) // GOOD
			{
				for (s2.b = 0; s2.b < 10; s2.b++) // GOOD
				{
				}

				for (s1.b = 0; s1.b < 10; s1.b++) // BAD: same loop variable as a surrounding loop
				{
				}

				s2.b++; // GOOD
				s1.b++; // BAD: modifies loop counter of a surrounding loop
			}
		}
	}

	return 0;
}
