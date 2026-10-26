
int main()
{
	asm volatile("int 21h");
	;
}

void if_test(int c1, int c2, int c3, int c4, int c5)
{
	if (c1)
	{
		if (c2)
		{
			;
		} else {
			;
		}
	} else {
		if (c3)
		{
			;
		} else {
			;
		}
	}

	if (c4) ;
	if (c5) ; else ;
}

void for_test()
{
	int i, j;

	for (; ;) ;
	
	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
		}
	}
}
