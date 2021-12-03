/* Semmle test case for SizeCheck2.ql
   Associated with CWE-131  http://cwe.mitre.org/data/definitions/131.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/

///// Library functions //////

typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);

//// Test code /////

void bad0(void) {

    long long *lptr = malloc(27); // BAD -- Not a multiple of sizeof(long long)
    double *dptr = malloc(33); // BAD -- Not a multiple of sizeof(double)
    free(lptr);
    free(dptr);
}

void good0(void) {

    float *fptr = malloc(24); // GOOD -- An integral multiple
    double *dptr = malloc(56); // GOOD -- An integral multiple
    free(fptr);
    free(dptr);
}

void bad1(void) {

    long long *lptr = malloc(sizeof(long long)*7/2); // BAD -- Not a multiple of sizeof(long long)
    double *dptr = malloc(sizeof(double)*5/2); // BAD -- Not a multiple of sizeof(double)
    free(lptr);
    free(dptr);
}

void good1(void) {

    long long *lptr = malloc(sizeof(long long)*5); // GOOD -- An integral multiple
    double *dptr = malloc(sizeof(double)*7); // GOOD -- An integral multiple
    free(lptr);
    free(dptr);
}



