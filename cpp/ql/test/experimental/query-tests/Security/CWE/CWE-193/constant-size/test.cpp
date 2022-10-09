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
