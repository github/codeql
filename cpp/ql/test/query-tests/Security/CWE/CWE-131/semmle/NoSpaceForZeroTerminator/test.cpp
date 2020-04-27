/* Semmle test case for NoSpaceForZeroTerminator.ql
   Associated with CWE-131  http://cwe.mitre.org/data/definitions/131.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/

///// Library functions //////

typedef unsigned long size_t;

void *malloc(size_t size);
void free(void *ptr);
size_t wcslen(const wchar_t *s);
wchar_t* wcscpy(wchar_t* s1, const wchar_t* s2);
int sprintf(char *s, const char *format, ...);
int wprintf(const wchar_t *format, ...);
char *strcat(char *s1, const char *s2);
size_t strlen(const char *s);
int strcmp(const char *s1, const char *s2);

//// Test code /////

void bad1(wchar_t *wstr) {
    // BAD -- Not allocating space for '\0' terminator
    wchar_t *wbuffer = (wchar_t *)malloc(wcslen(wstr));
    wcscpy(wbuffer, wstr);
    free(wbuffer);
}

void bad2(wchar_t *wstr) {
    // BAD -- Not allocating space for '\0' terminator
    wchar_t *wbuffer = (wchar_t *)malloc(wcslen(wstr) * sizeof(wchar_t));
    wcscpy(wbuffer, wstr);
    free(wbuffer);
}

void good1(wchar_t *wstr) {
    // GOOD -- Allocating extra character for terminator
    wchar_t *wbuffer = (wchar_t *)malloc((wcslen(wstr) + 1) * sizeof(wchar_t));
    wcscpy(wbuffer, wstr);
    free(wbuffer);
}

void bad3(char *str) {
    // BAD -- zero-termination proved by sprintf (as destination)
    char *buffer = (char *)malloc(strlen(str));
    sprintf(buffer, "%s", str);
    free(buffer);
}

void decode(char *dest, char *src);
void wdecode(wchar_t *dest, wchar_t *src);

void bad4(char *str) {
    // BAD -- zero-termination proved by wprintf (as parameter)
    char *buffer = (char *)malloc(strlen(str));
    decode(buffer, str);
    wprintf(L"%s", buffer);
    free(buffer);
}

void bad5(char *str) {
    // BAD -- zero-termination proved by strcat (as destination)
    char *buffer = (char *)malloc(strlen(str));
    buffer[0] = 0;
    strcat(buffer, str);
    free(buffer);
}

void bad6(char *str, char *dest) {
    // BAD -- zero-termination proved by strcat (as source)
    char *buffer = (char *)malloc(strlen(str));
    decode(buffer, str);
    strcat(dest, buffer);
    free(buffer);
}

void bad7(char *str, char *str2) {
    // BAD -- zero-termination proved by strcmp
    char *buffer = (char *)malloc(strlen(str));
    decode(buffer, str);
    if (strcmp(buffer, str2) == 0) {
        // ...
    }
    free(buffer);
}

void bad8(wchar_t *str) {
    // BAD -- zero-termination proved by wcslen
    wchar_t *wbuffer = (wchar_t *)malloc(wcslen(str));
    wdecode(wbuffer, str);
    if (wcslen(wbuffer) == 0) {
        // ...
    }
    free(wbuffer);
}

void good2(char *str, char *dest) {
    // GOOD -- zero-termination not proven
    char *buffer = (char *)malloc(strlen(str));
    decode(buffer, str);
    free(buffer);
}

void bad9(wchar_t *wstr) {
    // BAD -- using new
    wchar_t *wbuffer = new wchar_t[wcslen(wstr)];
    wcscpy(wbuffer, wstr);
    delete wbuffer;
}

void good3(char *str) {
    // GOOD -- zero-termination not required for this printf
    char *buffer = (char *)malloc(strlen(str));
    decode(buffer, str);
    wprintf(L"%p", buffer);
    free(buffer);
}

void good4(char *str) {
    // GOOD -- zero-termination not required for this printf
    char *buffer = (char *)malloc(strlen(str));
    decode(buffer, str);
    wprintf(L"%.*s", strlen(str), buffer);
    free(buffer);
}
