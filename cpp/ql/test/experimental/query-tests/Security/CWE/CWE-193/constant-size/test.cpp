#define MAX_SIZE 1024

struct ZeroArray {
    int size;
    int buf[0];
};

struct OneArray {
    int size;
    int buf[1];
};

struct BigArray {
    int size;
    int buf[MAX_SIZE];
};

struct ArrayAndFields {
    int buf[MAX_SIZE];
    int field1;
    int field2;
};

// tests for dynamic-size trailing arrays
void testZeroArray(ZeroArray *arr) {
    arr->buf[0] = 0;
}

void testOneArray(OneArray *arr) {
    arr->buf[1] = 0;
}

void testBig(BigArray *arr) {
    arr->buf[MAX_SIZE-1] = 0; // GOOD
    arr->buf[MAX_SIZE] = 0;   // BAD
    arr->buf[MAX_SIZE+1] = 0; // BAD

    for(int i = 0; i < MAX_SIZE; i++) {
        arr->buf[i] = 0; // GOOD
    }
    
    for(int i = 0; i <= MAX_SIZE; i++) {
        arr->buf[i] = 0; // BAD
    }
}

void testFields(ArrayAndFields *arr) {
    arr->buf[MAX_SIZE-1] = 0; // GOOD
    arr->buf[MAX_SIZE] = 0;   // BAD?
    arr->buf[MAX_SIZE+1] = 0; // BAD?

    for(int i = 0; i < MAX_SIZE; i++) {
        arr->buf[i] = 0; // GOOD
    }
    
    for(int i = 0; i <= MAX_SIZE; i++) {
        arr->buf[i] = 0; // BAD?
    }

    for(int i = 0; i < MAX_SIZE+2; i++) {
        arr->buf[i] = 0; // BAD?
    }
    // is this different if it's a memcpy?
}

void assignThroughPointer(int *p) {
    *p = 0; // ??? should the result go at a flow source?
}

void addToPointerAndAssign(int *p) {
    p[MAX_SIZE-1] = 0; // GOOD
    p[MAX_SIZE] = 0; // BAD
}

void testInterproc(BigArray *arr) {
    assignThroughPointer(&arr->buf[MAX_SIZE-1]); // GOOD
    assignThroughPointer(&arr->buf[MAX_SIZE]); // BAD

    addToPointerAndAssign(arr->buf);
}

#define MAX_SIZE_BYTES 4096

void testCharIndex(BigArray *arr) {
    char *charBuf = (char*) arr->buf;

    charBuf[MAX_SIZE_BYTES - 1] = 0; // GOOD
    charBuf[MAX_SIZE_BYTES] = 0; // BAD
}

void testEqRefinement() {
    int arr[MAX_SIZE];

    for(int i = 0; i <= MAX_SIZE; i++) {
        if(i != MAX_SIZE) {
            arr[i] = 0; // GOOD
        }
    }
}

void testEqRefinement2() {
    int arr[MAX_SIZE];

    int n = 0;

    for(int i = 0; i <= MAX_SIZE; i++) {
        if(n == 0) {
            if(i == MAX_SIZE) {
                break;
            }
            n = arr[i]; // GOOD
            continue;
        }

        if (i == MAX_SIZE || n != arr[i]) {
            if (i == MAX_SIZE) {
                break;
            }
            n = arr[i]; // GOOD
        }
    }
}

void testStackAllocated() {
    char *arr[MAX_SIZE];

    for(int i = 0; i <= MAX_SIZE; i++) {
        arr[i] = 0; // BAD
    }
}

int strncmp(const char*, const char*, int);

char testStrncmp2(char *arr) {
    if(strncmp(arr, "<test>", 6) == 0) {
        arr += 6;
    }
    return *arr; // GOOD [FALSE POSITIVE]
}

void testStrncmp1() {
    char asdf[5];
    testStrncmp2(asdf);
}

void countdownBuf1(int **p) {
  *--(*p) = 1; // GOOD [FALSE POSITIVE]
  *--(*p) = 2; // GOOD
  *--(*p) = 3; // GOOD
  *--(*p) = 4; // GOOD
}

void countdownBuf2() {
  int buf[4];

  int *x = buf + 4;

  countdownBuf1(&x);
}

int access(int *p) {
    return p[0];
}


// unrolled loop style seen in crypto code.
int countdownLength1(int *p, int len) {
    while(len > 0) {
        access(p);
        p[1] = 1;
        p[2] = 2;
        p[3] = 3;
        p[4] = 4;
        p[5] = 5;
        p[6] = 6; // BAD [FALSE NEGATIVE]
        p[7] = 7; // BAD [FALSE NEGATIVE]
        p += 8;
        len -= 8;
    }

    return p[5];
}

int callCountdownLength() {
    
    int buf[6];

    return countdownLength1(buf, 6);
}

int countdownLength2() {
    int buf[6];
    int len = 6;
    int *p = buf;
    
    if(len % 8) {
        return -1;
    }

    while(len > 0) {
        p[0] = 0;
        p[1] = 1;
        p[2] = 2;
        p[3] = 3;
        p[4] = 4;
        p[5] = 5;
        p[6] = 6; // GOOD
        p[7] = 7; // GOOD
        p += 8;
        len -= 8;
    }

    return p[5];
}