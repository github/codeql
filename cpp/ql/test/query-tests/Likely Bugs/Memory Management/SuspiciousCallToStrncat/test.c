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

void strncat_test1(char *s) {
  char buf[80];
  strncat(buf, s, sizeof(buf) - strlen(buf) - 1); // GOOD
  strncat(buf, s, sizeof(buf) - strlen(buf));  // BAD
}

void* malloc(size_t);

void strncat_test2(char *s) {
  int len = 80;
  char* buf = (char *)malloc(len);
  strncat(buf, s, len - strlen(buf) - 1); // GOOD
  strncat(buf, s, len - strlen(buf));  // BAD [NOT DETECTED]
}

struct buffers
{
  char array[50];
  char* pointer;
};

void strncat_test3(char* s, struct buffers* buffers) {
  unsigned len_array = strlen(buffers->array);
  unsigned max_size = sizeof(buffers->array);
  unsigned free_size = max_size - len_array;
  strncat(buffers->array, s, free_size); // BAD
}

#define MAX_SIZE 80

void strncat_test4(char *s) {
  char buf[MAX_SIZE];
  strncat(buf, s, MAX_SIZE - strlen(buf) - 1); // GOOD
  strncat(buf, s, MAX_SIZE - strlen(buf));  // BAD
  strncat(buf, "...", MAX_SIZE - strlen(buf)); // BAD
}

void strncat_test5(char *s) {
  int len = 80;
  char* buf = (char *) malloc(len + 1);
  strncat(buf, s, len - strlen(buf) - 1); // GOOD
  strncat(buf, s, len - strlen(buf)); // GOOD
}

void strncat_test6() {
  {
  char dest[60];
  dest[0] = '\0';
  // Will write `dest[0 .. 5]`
  strncat(dest, "small", sizeof(dest)); // GOOD [FALSE POSITIVE]
  }

  {
  char dest[60];
  memset(dest, 'a', sizeof(dest));
  dest[54] = '\0';
  // Will write `dest[54 .. 59]`
  strncat(dest, "small", sizeof(dest)); // GOOD [FALSE POSITIVE]
  }
}