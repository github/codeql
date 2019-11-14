
__attribute__((format(printf, 2, 3)))
void myMultiplyDefinedPrintf(const char *extraArg, const char *format, ...); // this declaration does not match the definition

__attribute__((format(printf, 2, 3)))
void myMultiplyDefinedPrintf2(const char *extraArg, const char *format, ...);

void test_custom_printf2()
{
  myMultiplyDefinedPrintf("%i", "%f", 1); // GOOD
  myMultiplyDefinedPrintf("%i", "%f", 1.0f); // BAD [NOT DETECTED]
  myMultiplyDefinedPrintf2("%i", "%f", 1); // GOOD (we can't tell which declaration is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf2("%i", "%f", 1.0f); // GOOD (we can't tell which declaration is correct so we have to assume this is OK)
}