// Semmle test case for rule TaintedPath.ql (User-controlled data in path expression)
// Associated with CWE-022: Improper Limitation of a Pathname to a Restricted Directory. http://cwe.mitre.org/data/definitions/22.html

///// Library routines /////

typedef struct {} FILE;
#define FILENAME_MAX 1000
typedef unsigned long size_t;

FILE *fopen(const char *filename, const char *mode);
int sprintf(char *s, const char *format, ...);
size_t strlen(const char *s);
char *strncat(char *s1, const char *s2, size_t n);
