
extern int printf(const char *fmt, ...);

#define GOODPRINTF(format, ...) \
	printf(format, __VA_ARGS__)

#define BADPRINTF(format, arg1, arg2, arg3) \
	printf(format, arg1, arg2, arg3)

void testMacros(int a, int b, int c)
{
	GOODPRINTF("%i %i\n", a, b, 0); // BAD: too many format arguments
	GOODPRINTF("%i %i %i\n", a, b, c); // GOOD
	GOODPRINTF("%i %i %i %i\n", a, b, c); // BAD: too few format arguments

	BADPRINTF("%i %i\n", a, b, 0); // BAD: too many format arguments
		// ^ here there are too many format arguments, but the design of the Macro forces the user
		//   to do this, and the extra argument is harmlessly ignored in practice.  Reporting these
		//   results can be extremely noisy (e.g. in openldap).
	BADPRINTF("%i %i %i\n", a, b, c); // GOOD
	BADPRINTF("%i %i %i %i\n", a, b, c); // BAD: too few format arguments
}
