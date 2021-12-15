
__attribute__((format(printf, 1, 3)))
void myMultiplyDefinedPrintf(const char *format, const char *extraArg, ...)
{
	// ...
}

__attribute__((format(printf, 1, 3)))
void myMultiplyDefinedPrintf2(const char *format, const char *extraArg, ...);

char *getString();

void test_custom_printf1()
{
  myMultiplyDefinedPrintf("string", getString()); // GOOD
  myMultiplyDefinedPrintf(getString(), "string"); // BAD [NOT DETECTED]
  myMultiplyDefinedPrintf2("string", getString()); // GOOD (we can't tell which declaration is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf2(getString(), "string"); // GOOD (we can't tell which declaration is correct so we have to assume this is OK)
}
