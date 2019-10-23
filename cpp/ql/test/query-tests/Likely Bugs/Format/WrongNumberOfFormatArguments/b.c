
__attribute__((format(printf, 1, 2)))
void myMultiplyDefinedPrintf(const char *format, ...); // this declaration does not match the definition

__attribute__((format(printf, 1, 2)))
void myMultiplyDefinedPrintf2(const char *format, ...);

__attribute__((format(printf, 1, 2)))
void myMultiplyDefinedPrintf3(const char *format, ...);

void test_custom_printf2()
{
  myMultiplyDefinedPrintf("%i", 0); // BAD (too few format arguments)
  myMultiplyDefinedPrintf("%i", 0, 1); // GOOD
  myMultiplyDefinedPrintf("%i", 0, 1, 2); // BAD (too many format arguments)
  myMultiplyDefinedPrintf2("%i", 0); // GOOD (we can't tell which definition is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf2("%i", 0, 1); // GOOD (we can't tell which definition is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf2("%i", 0, 1, 2); // BAD (too many format arguments regardless of which definition is correct) [NOT DETECTED]
  myMultiplyDefinedPrintf3("%s", "%s"); // GOOD (we can't tell which definition is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf3("%s", "%s", "%s"); // GOOD (we can't tell which definition is correct so we have to assume this is OK)
  myMultiplyDefinedPrintf3("%s", "%s", "%s", "%s"); // BAD (too many format arguments regardless of which definition is correct) [NOT DETECTED]
}
