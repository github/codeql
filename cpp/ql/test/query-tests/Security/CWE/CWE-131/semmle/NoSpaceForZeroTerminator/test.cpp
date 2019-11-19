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






//// Test code /////

void bad1(wchar_t *wstr) {
    // BAD -- Not allocating space for '\0' terminator
    wchar_t *wbuffer = (wchar_t *)malloc(wcslen(wstr));
    wcscpy(wbuffer, wstr);
    free(wbuffer);
}

void bad2(wchar_t *wstr) {
    // BAD -- Not allocating space for '\0' terminator [NOT DETECTED]
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
