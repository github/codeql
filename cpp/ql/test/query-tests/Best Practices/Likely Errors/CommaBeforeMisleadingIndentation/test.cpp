
void test(int i, int j, int (*foo)(int))
{
	if (i)
		(void)i,	// GOOD
		(void)j;

	if (i)
		(void)i,	// BAD
	(void)j;

	foo((i++, j++)); // GOOD
	foo((i++,        // GOOD
	     j++));
	foo((i++
	   , j++));      // GOOD
	foo((i++,
	j++));           // BAD (?)
}
