/* Semmle test case for OverflowStatic.ql
   Associated with CWE-131  http://cwe.mitre.org/data/definitions/131.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/

///// Library functions //////


typedef struct {} FILE;

typedef unsigned long size_t;
typedef void *va_list;

int sprintf(char *s, const char *format, ...);
int snprintf(char *s, size_t n, const char *format, ...);
char *fgets(char *s, int n, FILE *stream);
char *strncpy(char *s1, const char *s2, size_t n);
char *strncat(char *s1, const char *s2, size_t n);
void *memcpy(void *s1, const void *s2, size_t n);
void *memmove(void *s1, const void *s2, size_t n);
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);

//// Test code /////

void bad0(char *src, FILE *f, va_list ap) {
    char buffer[40];

    fgets(buffer, 41, f); // BAD: Too many characters read
    strncpy(buffer, src, 43); // BAD: Too many characters copied
    buffer[0] = 0;
    strncat(buffer, src, 44); // BAD: Too many characters copied
    memcpy(buffer, src, 45); // BAD: Too many characters copied
    memmove(buffer, src, 46); // BAD: Too many characters copied
    snprintf(buffer, 47, "%s", src);  // BAD: Too many characters copied
    vsnprintf(buffer, 48, "%s", ap);  // BAD: Too many characters copied
}

void good0(char *src, FILE *f, va_list ap) {
    char buffer[60];
    fread(buffer, sizeof(char), 51, f); // GOOD
    fgets(buffer, 52, f); // GOOD
    strncpy(buffer, src, 53); // GOOD
    buffer[0] = 0;
    strncat(buffer, src, 54); // GOOD
    memcpy(buffer, src, 55); // GOOD
    memmove(buffer, src, 56); // GOOD
    snprintf(buffer, 57, "%s", src);  // GOOD
    vsnprintf(buffer, 58, "%s", ap);  // GOOD
}

