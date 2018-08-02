
int main()
{
	char *str = "Hello, world!";
	char *char_ptr;
	int i, j, k;
	char c;

	// simple loop
	j = 0;
	for (i = 0; i < 10; i++)
	{
		i = 10; // BAD (for loop variable changed in body)
		j = 10;
	}
	
	// nested loops
	for (i = 0; i < 10; i++)
	{
		for (i = 0; i < 10; i++) // BAD (nested loops with same variable)
		{
			// ...
		}
	}
	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			i++; // BAD (for loop variable changed in body)
			j++; // BAD (for loop variable changed in body)
			k++;
		}
		
		for (i = 0; i < 10; i++) // BAD (nested loops with same variable)
		{
			j++;
		}
	}
	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			for (i = 0; i < 10; i++) // BAD (nested loops with same variable)
			{
				// ...
			}
		}
	}
	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			for (j = 0; j < 10; j++) // BAD (nested loops with same variable)
			{
				j++; // BAD (for loop variable changed in body)
			}
		}
	}

	// pointer loop
	for (char_ptr = str; *char_ptr != 0; char_ptr++)
	{
		 c = *char_ptr;
		 *char_ptr += 1;
		 char_ptr += 1; // BAD (for loop variable changed in body)
	}

	// more nested loops
	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; i++) // BAD (for loop variable changed in body)
		{
		}
		
		for (i = 0; j < 10; j++) // BAD (for loop variable changed in body)
		{
		}
	}

	return 0;
}