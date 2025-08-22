
extern int printf(const char *fmt, ...);

void test(int i, const char *str)
{
	printf("\n"); // GOOD
	printf("\n", i); // BAD (too many format arguments)

	printf("%i\n"); // BAD (too few format arguments)
	printf("%i\n", i); // GOOD
	
	printf("%*s\n", str); // BAD (too few format arguments)
	printf("%*s\n", i, str); // GOOD

	printf("%i %i %i\n", 1, 2); // BAD (too few format arguments)
	printf("%i %i %i\n", 1, 2, 3); // GOOD

	// indexed format arguments
	printf("%2$i \n", 1); // BAD (too few format arguments)
	printf("%2$i \n", 1, 2); // GOOD
	printf("%2$i \n", 1, 2, 3); // BAD (too many format arguments)
	printf("%2$i %2$i %2$i \n", 1, 2); // GOOD
	printf("%2$02i %1$4.2f \n", 3.3333f, 6); // GOOD
	{
		int width, num;

		printf("%2$*1$d", 0, width, num); // BAD (too many format arguments)
		printf("%2$*1$d", width, num); // GOOD
		printf("%2$*1$d", width); // BAD (too few format arguments)

		printf("%1$*2$d", 0, num, width); // BAD (too many format arguments) [INCORRECT MESSAGE]
		printf("%1$*2$d", num, width); // GOOD [FALSE POSITIVE]
		printf("%1$*2$d", width); // BAD (too few format arguments) [NOT DETECTED]
	}
	{
		int precision;
		float num;

		printf("%2$.*4$f", 0, 0, num, 0, precision); // BAD (too many format arguments) [INCORRECT MESSAGE]
		printf("%2$.*4$f", 0, num, 0, precision); // GOOD [FALSE POSITIVE]
		printf("%2$.*4$f", num, 0, precision); // BAD (too few format arguments) [INCORRECT MESSAGE]
	}

	printf("%@ %i %i", 1, 2); // GOOD

	printf("%Y", 1, 2); // GOOD (unknown format character, this might be correct)
	printf("%1.1Y", 1, 2); // GOOD (unknown format character, this might be correct)
	printf("%*.*Y", 1, 2); // GOOD (unknown format character, this might be correct)

	// Implicit logger function declaration
	my_logger(0, "%i %i %i %i %i %i\n", 1, 2, 3, 4, 5, 6); // GOOD
	my_logger(0, "%i %i %i\n", 1, 2, 3); // GOOD
	my_logger(0, "%i %i %i\n", 1, 2); // BAD (too few format arguments)
}

// A spurious definition of my_logger
extern void my_logger(int param, char *fmt, int, int, int, int, int);
