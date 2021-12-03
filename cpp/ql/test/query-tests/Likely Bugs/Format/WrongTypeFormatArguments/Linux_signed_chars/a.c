
__attribute__((format(printf, 1, 3)))
void myMultiplyDefinedPrintf(const char *format, const char *extraArg, ...)
{
	// ...
}
__attribute__((format(printf, 1, 3)))
void myMultiplyDefinedPrintf2(const char *format, const char *extraArg, ...);

void test_custom_printf1()
{
  myMultiplyDefinedPrintf("%i", "%f", 1); // GOOD
  myMultiplyDefinedPrintf("%i", "%f", 1.0f); // BAD [NOT DETECTED]
  myMultiplyDefinedPrintf2("%i", "%f", 1); // GOOD (we can't tell which declaration is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf2("%i", "%f", 1.0f); // GOOD (we can't tell which declaration is correct so we have to assume this is OK)
}
