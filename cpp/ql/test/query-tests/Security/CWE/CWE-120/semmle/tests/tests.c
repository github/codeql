//semmle-extractor-options: --edg --target --edg win64
// Semmle test cases for UnboundedWrite.ql, BadlyBoundedWrite.ql, OverrunWrite.ql and OverrunWriteFloat.ql
// Associated with CWE-120 http://cwe.mitre.org/data/definitions/120.html
// Each query is expected to find exactly the lines marked BAD in the section corresponding to it.

///// Library functions //////

typedef unsigned long long size_t;
int sprintf(char *s, const char *format, ...);
int snprintf(char *s, size_t n, const char *format, ...);
int scanf(const char *format, ...);
int sscanf(const char *s, const char *format, ...);

//// Test code /////

int main(int argc, char *argv[])
{
	if (argc < 1)
	{
		return;
	}

	// Test cases for UnboundedWrite.ql
	{
		char buffer100[100];
		int i;

		sprintf(buffer100, argv[0]); // BAD: argv[0] could be more than 100 characters
		sprintf(buffer100, "%s", argv[0]); // BAD: argv[0] could be more than 100 characters

		scanf("%s", buffer100); // BAD: the input could be more than 100 characters
		scanf("%i", i); // GOOD: no problems with non-strings
		scanf("%i %s", i, buffer100); // BAD: second format parameter may overflow
		sscanf(argv[0], "%s", buffer100); // BAD: argv[0] could be more than 100 characters
	}

	// Test cases for BadlyBoundedWrite.ql
	{
		char buffer110[110];

		snprintf(buffer110, 109, argv[0]); // GOOD
		snprintf(buffer110, 110, argv[0]); // GOOD
		snprintf(buffer110, 111, argv[0]); // BAD: this could still overrun the 110 character buffer
		snprintf(buffer110, 109, "%s", argv[0]); // GOOD
		snprintf(buffer110, 110, "%s", argv[0]); // GOOD
		snprintf(buffer110, 111, "%s", argv[0]); // BAD: this could still overrun the 110 character buffer
	}
	
	// Test cases for OverrunWrite.ql
	{
		char buffer10[10];

		sprintf(buffer10, "123456789"); // GOOD
		sprintf(buffer10, "1234567890"); // BAD: the null terminator of this string overruns the buffer
		sprintf(buffer10, "%.9s", "123456789"); // GOOD
		sprintf(buffer10, "%.9s", "1234567890"); // GOOD
		sprintf(buffer10, "%.10s", "123456789"); // GOOD
		sprintf(buffer10, "%.10s", "1234567890"); // BAD: the precision specified is too large for this buffer

		scanf("%8s", buffer10); // GOOD: restricted to 8 characters + null
		scanf("%9s", buffer10); // GOOD: restricted to 9 characters + null
		scanf("%10s", buffer10); // BAD: null can overflow
		scanf("%11s", buffer10); // BAD: string can overflow
	}

	// More complex tests for OverrunWrite.ql
	{
		char buffer5[5];
		char *str4, *str24, *str35;

		str4 = "1234";
		strcpy(buffer5, str4); // GOOD: str4 fits in the buffer

		str24 = "12";
		if (argc == 1)
		{
			str24 = "1234";
		}
		strcpy(buffer5, str24); // GOOD: both possible strings fit in the buffer

		str35 = "123";
		if (argc == 1)
		{
			str35 = "12345";
		}
		strcpy(buffer5, str35); // BAD: if str35 is "12345", it overflows the buffer

		str35 = "abc";
		strcpy(buffer5, str35); // GOOD: str35 is guaranteed to fit now

		strcpy(buffer5, (argc == 2) ? "1234" : "abcd"); // GOOD: both of the strings fit

		strcpy(buffer5, (argc == 2) ? "1234" : "abcde"); // BAD: "abcde" overflows the buffer
	}

	// Test cases for OverrunWriteFloat.ql
	{
		char buffer256[256];
		char buffer999[999];
		double bigval = 1e304;

		sprintf(buffer256, "%e", bigval); // GOOD
		sprintf(buffer256, "%f", bigval); // BAD: this %f representation may need more than 256 characters
		sprintf(buffer256, "%g", bigval); // GOOD
		sprintf(buffer256, "%e%f%g", bigval, bigval, bigval); // BAD: the %f representation may need more than 256 characters

		// GOOD: a 999 character buffer is sufficient in all of these cases
		sprintf(buffer999, "%e", bigval); // GOOD
		sprintf(buffer999, "%f", bigval); // GOOD
		sprintf(buffer999, "%g", bigval); // GOOD
		sprintf(buffer999, "%e%f%g", bigval, bigval, bigval); // GOOD
	}

	// Test cases for %p
	{
		char buffer1[1];
		char buffer16[16];
		char buffer17[17];
		char buffer49[49];
		sprintf(buffer1, "%p", argv); // BAD
		sprintf(buffer16, "%p", argv); // BAD
		sprintf(buffer17, "%p", argv); // GOOD
		sprintf(buffer49, "%p and then a few more words", argv); // GOOD
	}

	return 0;
}

typedef char MyCharArray[10];

void test_fn2()
{
	MyCharArray myBuffer10;

	sprintf(myBuffer10, "%s", "123456789"); // GOOD
	sprintf(myBuffer10, "%s", "1234567890"); // BAD: buffer overflow
}

// ---

typedef struct
{
	char *string;
	int value;
} StringStruct;

#define GETSTRING(x) ((x)->string)
#define GETVALUE(x) ((x)->value)
#define MAX_INT_LEN (11)

void testStringStruct(StringStruct *ss)
{
	snprintf(GETSTRING(ss), sizeof("Number: "), "Number: %i", GETVALUE(ss)); // BAD: potential buffer overflow [NOT DETECTED]
	snprintf(GETSTRING(ss), sizeof("Number: ") + MAX_INT_LEN, "Number: %i", GETVALUE(ss)); // GOOD
}

// ---

typedef struct
{
	int size;
	char data[0];
} VarSizeStruct;

void testVarSizeStruct()
{
	char buffer[sizeof(VarSizeStruct) + 10];
	VarSizeStruct *s = buffer;

	snprintf(s->data, 10, "abcdefghijklmnopqrstuvwxyz"); // GOOD
}
