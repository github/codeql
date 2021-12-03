/* Semmle test case for SizeCheck.ql
   Associated with CWE-131  http://cwe.mitre.org/data/definitions/131.html
   Each query is expected to find exactly the lines marked BAD in the section corresponding to it.
*/

///// Library functions //////

typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);

//// Test code /////

void bad0(void) {

    float *fptr = malloc(3); // BAD -- Too small
    double *dptr = malloc(5); // BAD -- Too small
    free(fptr);
    free(dptr);
}

void good0(void) {

    float *fptr = malloc(4); // GOOD -- Correct size
    double *dptr = malloc(8); // GOOD -- Correct size
    free(fptr);
    free(dptr);
}

void bad1(void) {

    float *fptr = malloc(sizeof(short)); // BAD -- Too small
    double *dptr = malloc(sizeof(float)); // BAD -- Too small
    free(fptr);
    free(dptr);
}

void good1(void) {

    float *fptr = malloc(sizeof(float)); // GOOD -- Correct size
    double *dptr = malloc(sizeof(double)); // GOOD -- Correct size
    free(fptr);
    free(dptr);
}

typedef struct _myStruct
{
	int x, y;
} MyStruct;

typedef union _myUnion
{
	MyStruct ms;
	char data[128];
} MyUnion;

void test_union() {
	MyUnion *a = malloc(sizeof(MyUnion)); // GOOD
	MyUnion *b = malloc(sizeof(MyStruct)); // BAD (too small)
}
