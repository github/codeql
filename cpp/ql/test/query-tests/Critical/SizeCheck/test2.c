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

// --- custom allocators ---

void *MyMalloc1(size_t size) { return malloc(size); }
void *MyMalloc2(size_t size);

void customAllocatorTests()
{
    double *dptr1 = MyMalloc1(33); // BAD -- Not a multiple of sizeof(double) [NOT DETECTED]
    double *dptr2 = MyMalloc2(33); // BAD -- Not a multiple of sizeof(double) [NOT DETECTED]
}

// --- variable length data structures ---

typedef unsigned char uint8_t;

typedef struct _MyVarStruct1 {
    size_t dataLen;
    uint8_t data[0];
} MyVarStruct1;

typedef struct _MyVarStruct2 {
    size_t dataLen;
    uint8_t data[1];
} MyVarStruct2;

typedef struct _MyVarStruct3 {
    size_t dataLen;
    uint8_t data[];
} MyVarStruct3;

typedef struct _MyFixedStruct {
    size_t dataLen;
    uint8_t data[1024];
} MyFixedStruct;

void varStructTests() {
    MyVarStruct1 *a = malloc(sizeof(MyVarStruct1) + 127); // GOOD
    MyVarStruct2 *b = malloc(sizeof(MyVarStruct2) + 127); // GOOD
    MyVarStruct3 *c = malloc(sizeof(MyVarStruct3) + 127); // GOOD
    MyFixedStruct *d = malloc(sizeof(MyFixedStruct) + 127); // BAD --- Not a multiple of sizeof(MyFixedStruct)
}
