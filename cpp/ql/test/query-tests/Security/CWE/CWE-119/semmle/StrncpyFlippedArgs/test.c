/* Semmle test case for StrncpyFlippedArgs.ql
   Associated with CWE-131  http://cwe.mitre.org/data/definitions/131.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/

///// Library functions //////

extern char *strncpy(char *dest, const char *src, unsigned int sz);
extern unsigned int strlen(const char *s);

//// Test code /////

void good0(char *arg) {
	char buf[80];
	// GOOD: Checks size of destination
	strncpy(buf, arg, sizeof(buf));
}

void bad0(char *arg) {
	char buf[80];
	// BAD: Checks size of source
	strncpy(buf, arg, strlen(arg));

}

void good1(const char *buf, char *arg) {
	// GOOD: Checks size of destination
	strncpy(buf, arg, sizeof(buf));
}

void bad1(const char *buf, char *arg) {
	// BAD: Checks size of source
	strncpy(buf, arg, strlen(arg));
}

