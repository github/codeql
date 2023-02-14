//semmle-extractor-options: --edg --target --edg win64
// Semmle test cases for UnboundedWrite.ql, BadlyBoundedWrite.ql, OverrunWrite.ql and OverrunWriteFloat.ql
// Associated with CWE-120 http://cwe.mitre.org/data/definitions/120.html
// Each query is expected to find exactly the lines marked BAD in the section corresponding to it.

///// Library functions //////

typedef unsigned long long size_t;
char *strcpy(char *s1, const char *s2); 

//// Test code /////

typedef union {
	char *ptr;
	char buffer[15];
} MyUnion;

void unions_test(MyUnion *mu)
{
	char buffer[25];

	strcpy(mu, "1234567890"); // GOOD
	strcpy(&(mu->ptr), "1234567890"); // GOOD (dubious)
	strcpy(&(mu->buffer), "1234567890"); // GOOD
	strcpy(mu, "12345678901234567890"); // BAD [NOT DETECTED]
	strcpy(&(mu->ptr), "12345678901234567890"); // BAD
	strcpy(&(mu->buffer), "12345678901234567890"); // BAD
	
	mu->ptr = buffer;
	strcpy(mu->ptr, "1234567890"); // GOOD
	strcpy(mu->ptr, "12345678901234567890"); // GOOD
	strcpy(mu->ptr, "123456789012345678901234567890"); // BAD [NOT DETECTED]
}
