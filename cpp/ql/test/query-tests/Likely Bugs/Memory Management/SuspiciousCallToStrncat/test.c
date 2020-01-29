/* Semmle test case for SuspiciousCallToStrncat.ql
   Associated with CWE-131  http://cwe.mitre.org/data/definitions/131.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/

///// Library functions //////
typedef unsigned long size_t;
char *strcpy(char *s1, const char *s2);
char *strncat(char *s1, const char *s2, size_t n);
size_t strlen(const char *s);

//// Test code /////

void good0(char *s) {
	char buf[80];
	strcpy(buf, "s = ");
	strncat(buf, s, sizeof(buf)-5); // GOOD
	strncat(buf, ".", 1); // BAD [NOT DETECTED] -- there might not be even 1 character of space
}

void bad0(char *s) {
	char buf[80];
	strcpy(buf, "s = ");
	strncat(buf, s, sizeof(buf));  // BAD -- Forgot to allow for "s = "
	strncat(buf, ".", 1); // BAD [NOT DETECTED] -- there might not be even 1 character of space
}

void good1(char *s) {
	char buf[80];
	strcpy(buf, "s = ");
	strncat(buf, s, sizeof(buf)-strlen("s = ")); // GOOD
	strncat(buf, ".", sizeof(buf)-strlen("s = ")-strlen(s)); // GOOD
}

void bad1(char *s) {
	char buf[80];
	strcpy(buf, "s = ");
	strncat(buf, s, sizeof(buf)-strlen("s = ")); // GOOD
	strncat(buf, ".", 1); // BAD [NOT DETECTED] -- Need to check if any space is left
}

