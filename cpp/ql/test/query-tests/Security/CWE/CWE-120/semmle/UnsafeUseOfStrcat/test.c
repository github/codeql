/* Semmle test case for UnsafeUseOfStrcat.ql
   Associated with CWE-120  http://cwe.mitre.org/data/definitions/120.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/

///// Library functions //////

typedef unsigned long size_t;
char *strcpy(char *s1, const char *s2);
char *strcat(char *s1, const char *s2);
size_t strlen(const char *s);
void *malloc(size_t size);
void free(void *ptr);

//// Test code /////

static void bad0(char *s) {
	char buf[80];
	strcpy(buf, "s: ");
	strcat(buf, s);  // BAD -- s may be too long and overflow the buffer
}

static void good0(char *s) {
	char buf[80];
	strcpy(buf, "s: ");
	if(strlen(s) < 77)
		strcat(buf, s);  // GOOD
}

static void bad1(char *s, int len) {
    char *buf = malloc(len+4);
    strcpy(buf, "s: ");
    strcat(buf, s);  // BAD -- s may be too long and overflow the buffer
}

static void good1(char *s, int len) {
    char *buf = malloc(len+4);
    strcpy(buf, "s: ");
    if (strlen(s) <= len)
		strcat(buf, s);  // GOOD
}
