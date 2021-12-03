// Semmle test case for rule UncontrolledFormatString.ql (Uncontrolled format string).
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// This file tests different ways to ignore branchs in code that will never be executed.

int printf(const char *format, ...);
int func();

int globalZero = 0;
int globalOne = 1;
int globalUnknown;

int inv(int a) {
	return !a;
}

int main(int argc, char **argv) {
	int varZero = 0;
	int varOne = 1;
	
	globalUnknown = func();
	
	// GOOD: condition is false and it never goes inside the if
	char *c1;
	if (0)
		c1 = argv[1];
	printf(c1);
	
	// GOOD: condition is false and it never goes inside the if
	char *c2;
	if (1 == 0)
		c2 = argv[1];
	printf(c2);
	
	// GOOD: condition is false and it never goes inside the if
	char *c3;
	if (!1)
		c3 = argv[1];
	printf(c3);
	
	// GOOD: varZero is 0 so condition is false and it never goes inside the if
	char *c4;
	if (varZero)
		c4 = argv[1];
	printf(c4);
	
	// GOOD: varOne is 1 so condition is false and it never goes inside the if
	char *c5;
	if (!varOne)
		c5 = argv[1];
	printf(c5);
	
	// GOOD: condition is false and it never goes inside the if
	char *c6;
	if (varOne == varZero)
		c6 = argv[1];
	printf(c6);
	
	// GOOD: globalZero is 0 so condition is false and it never goes inside the if
	char *c7;
	if (globalZero)
		c7 = argv[1];
	printf(c7);
	
	// GOOD: inv(1) returns 0 and it never goes inside the if
	// But we can't handle this case because currently we don't analyse arguments in function calls
	char *c8;
	if (inv(1))
		c8 = argv[1];
	printf(c8);

	// BAD: condition is true and it always goes inside the if
	char *i1;
	if (1)
		i1 = argv[1];
	printf(i1);
	
	// BAD: condition is true and it always goes inside the if
	char *i2;
	if (0 == 0)
		i2 = argv[1];
	printf(i2);
	
	// BAD: condition is true and it always goes inside the if
	char *i3;
	if (!0)
		i3 = argv[1];
	printf(i3);
	
	// BAD: varOne is 1 so condition is true and it always goes inside the if
	char *i4;
	if (varOne)
		i4 = argv[1];
	printf(i4);
	
	// BAD: varZero is 0 so condition is true and it always goes inside the if
	char *i5;
	if (!varZero)
		i5 = argv[1];
	printf(i5);
	
	// BAD: condition is true and it always goes inside the if
	// But our analysis only handle booleans, so it isn't able the detect that both values are the same (we can handle only 0 == 0)
	char *i6;
	if (varOne == varOne)
		i6 = argv[1];
	printf(i6);
	
	// BAD: globalOne is 1 so condition is true and it always goes inside the if
	char *i7;
	if (globalOne)
		i7 = argv[1];
	printf(i7);
	
	// BAD: we don't know the value of globalUnknown so we have to assume it can be true
	char *i8;
	if (globalUnknown)
		i8 = argv[1];
	printf(i8);
	
	// BAD: inv(0) returns 1 and it always goes inside the if
	char *i9;
	if (inv(0))
		i9 = argv[1];
	printf(i9);
	
	return 0;
	
	// GOOD: because it is after a return and never will be reached
	char *c9;
	c9 = argv[1];
	printf(c9);
}
