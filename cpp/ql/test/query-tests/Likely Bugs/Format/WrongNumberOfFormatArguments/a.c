
__attribute__((format(printf, 1, 3)))
void myMultiplyDefinedPrintf(const char *format, int extraArg, ...)
{
	// ...
}
__attribute__((format(printf, 1, 3)))
void myMultiplyDefinedPrintf2(const char *format, int extraArg, ...);

void test_custom_printf1()
{
  myMultiplyDefinedPrintf("%i", 0); // BAD (too few format arguments)
  myMultiplyDefinedPrintf("%i", 0, 1); // GOOD
  myMultiplyDefinedPrintf("%i", 0, 1, 2); // BAD (too many format arguments)
  myMultiplyDefinedPrintf2("%i", 0); // GOOD (we can't tell which definition is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf2("%i", 0, 1); // GOOD (we can't tell which definition is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf2("%i", 0, 1, 2); // GOOD (we can't tell which definition is correct so we have to assume this is OK)
}
