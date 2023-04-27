/* Semmle test case for NoSpaceForZeroTerminator.ql
   Associated with CWE-131  http://cwe.mitre.org/data/definitions/131.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/
///// Library functions //////

typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);
char *strcpy(char *s1, const char *s2);

//// Test code /////

void bad0(char *str) {
    // BAD -- Not allocating space for '\0' terminator
    char *buffer = malloc(strlen(str));
    strcpy(buffer, str);
    free(buffer);
}

void good0(char *str) {
    // GOOD -- Allocating extra byte for terminator
    char *buffer = malloc(strlen(str)+1);
    strcpy(buffer, str);
    free(buffer);
}


void bad1(char *str) {
    int len = strlen(str);
    // BAD -- Not allocating space for '\0' terminator
    char *buffer = malloc(len);
    strcpy(buffer, str);
    free(buffer);
}

void good1(char *str) {
    int len = strlen(str);
    // GOOD -- Allocating extra byte for terminator
    char *buffer = malloc(len+1);
    strcpy(buffer, str);
    free(buffer);
}


void bad2(char *str) {
    int len = strlen(str);
    // BAD -- Not allocating space for '\0' terminator
    char *buffer = malloc(len);
    strcpy(buffer, str);
    free(buffer);
}

void good2(char *str) {
    int len = strlen(str)+1;
    // GOOD -- Allocating extra byte for terminator
    char *buffer = malloc(len);
    strcpy(buffer, str);
    free(buffer);
}

void bad3(char *str) {
    // BAD -- Not allocating space for '\0' terminator
    char *buffer = malloc(strlen(str) * sizeof(char));
    strcpy(buffer, str);
    free(buffer);
}

void good3(char *str) {
    // GOOD -- Allocating extra byte for terminator
    char *buffer = malloc((strlen(str) + 1) * sizeof(char));
    strcpy(buffer, str);
    free(buffer);
}

void *memcpy(void *s1, const void *s2, size_t n);

void good4(char *str) {
	// GOOD -- allocating a non zero-terminated string
	int len = strlen(str);
	char *buffer = malloc(len);

	memcpy(buffer, str, len);

	free(buffer);
}
