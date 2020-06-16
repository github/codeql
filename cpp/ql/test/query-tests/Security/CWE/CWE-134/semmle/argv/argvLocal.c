// Semmle test case for rule UncontrolledFormatString.ql (Uncontrolled format string).
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// This file tests different ways to use argv as an argument to printf.

typedef unsigned long size_t;
int printf(const char *format, ...);
void *memcpy(void *s1, const void *s2, size_t n);
void *malloc(size_t size);
void printWrapper(char *correct) {
	printf(correct);
}

int main(int argc, char **argv) {
	// GOOD: constant format
	printf("Correct");
	printWrapper("Correct");

	// GOOD: c1 is always a constant format
	char *c1 = "Correct";
	printf(c1);
	printWrapper(c1);

	// GOOD: c2 is always a constant format
	char *c2 = c1;
	printf(c2);
	printWrapper(c2);

	// GOOD: c3 is always a constant format
	char **c3 = &c2;
	printf(*c3);
	printWrapper(*c3);

	// GOOD: c4 is always a constant format
	char c4[5012];
	memcpy(c4, "Correct", 5012);
	printf(c4);
	printWrapper(c4);

	// GOOD: c5 is always a constant format
	char *c5 = c4;
	printf(c5);
	printWrapper(c5);

	// GOOD: c6 is always a constant format
	char *c6;
	*c6 = *c1;
	printf(c6);
	printWrapper(c6);
	
	// GOOD: constant format
	printf("Correct" + 1);
	printWrapper("Correct" + 1);
	
	// GOOD: c6 is always a constant format
	printf(c6++);
	printWrapper(--c6);
	
	// GOOD: c5 is always a constant format
	printf(1 ? "a" : c5);
	printWrapper(1 ? "a" : c5);
	
	// GOOD: both c5 and "a" are always constant
	printf(argv[1] ? "a" : c5);
	printWrapper(argv[1] ? "a" : c5);
	
	// GOOD: c7 equals "a", which is constant
	char *c7 = (argv[1] , "a");
	printf(c7);
	printWrapper(c7);

	// GOOD: c8 is always a constant format
	char *c8;
	*(&c8 + 1) = "a";
	printf(c8);
	printWrapper(c8);

	// GOOD: c9 is always a constant format
	char *c9;
	memcpy(1 ? c9++ : 0, "Correct", 5012);
	printf(c9);
	printWrapper(c9);

	// GOOD: c91 is always a constant format
	char *c91;
	memcpy(0 ? 0 : (char *)((int) c91 * 2), "Correct", 5012);
	printf(c91);
	printWrapper(c91);

	// GOOD: c10 is always a constant format
	int c10 = (int) "aaa";
	printf((char *) c10);
	printWrapper((char *) c10);

	// BAD: format comes from argv
	printf(argv[1]);
	printWrapper(argv[1]);

	// BAD: i1 value comes from argv
	char *i1;
	i1 = argv[1];
	printf(i1);
	printWrapper(i1);

	// BAD: i2 value comes from argv
	char **i2 = argv;
	printf(i2[0]);
	printWrapper(i2[0]);

	// BAD: i2 value comes from argv
	printf(*i2);
	printWrapper(*i2);

	// BAD: i3 value comes from argv
	char i3[5012];
	memcpy(i3, argv[1], 5012);
	printf(i3);
	printWrapper(i3);

	// BAD: i4 value comes from argv
	char *i4 = i3;
	printf(i4);
	printWrapper(i4);

	// BAD: i5 value comes from argv
	char i5[5012];
	i5[0] = argv[1][0];
	printf(i5);
	printWrapper(i5);
	
	// BAD: i5 value comes from argv
	printf(i5 + 1);
	printWrapper(i5 + 1);
	
	// BAD: i4 value comes from argv
	printf(i4++);
	printWrapper(--i4);

	// BAD: i5 value comes from argv, so in some cases the format come from argv
	printf(argv[1] ? "a" : i5);
	printWrapper(argv[1] ? "a" : i5);

	// BAD: i7 receives the value of i1, which comes from argv
	char *i7 = (argv[1] , i1);
	printf(i7);
	printWrapper(i7);

	// BAD: i8 value comes from argv
	char *i8;
	*(&i8) = argv[1];
	printf(i8);
	printWrapper(i8);

	// BAD: i9 value comes from argv
	char i9buf[32];
	char *i9 = i9buf;
	memcpy(1 ? ++i9 : 0, argv[1], 1);
	printf(i9);
	printWrapper(i9);

	// BAD: i91 value comes from argv
	char i91buf[64];
	char *i91 = &i91buf[0];
	memcpy(0 ? 0 : i91, argv[1] + 1, 1);
	printf(i91);
	printWrapper(i91);

	// BAD: i10 value comes from argv
	int i10 = (int) argv[1];
	printf((char *) i10);
	printWrapper((char *) i10);
}
