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

void pointer_size_larger_than_array_element_size() {
    unsigned char buffer[100]; // getByteSize() = 100
    int *ptr = (int *)buffer; // pai.getElementSize() will be sizeof(int) = 4 -> size = 25

    ptr[24] = 0; // GOOD: writes bytes 96, 97, 98, 99
    ptr[25] = 0; // BAD: writes bytes 100, 101, 102, 103
}

struct vec2 { int x, y; };
struct vec3 { int x, y, z; };

void pointer_size_smaller_than_array_element_size_but_does_not_divide_it() {
    vec3 array[3]; // getByteSize() = 9 * sizeof(int)
    vec2 *ptr = (vec2 *)array; // pai.getElementSize() will be 2 * sizeof(int) -> size = 4

    ptr[3] = vec2{}; // GOOD: writes ints 6, 7
    ptr[4] = vec2{}; // BAD: writes ints 8, 9
}

void pointer_size_larger_than_array_element_size_and_does_not_divide_it() {
    vec2 array[2]; // getByteSize() = 4 * sizeof(int) = 4 * 4 = 16
    vec3 *ptr = (vec3 *)array; // pai.getElementSize() will be 3 * sizeof(int) -> size = 1

    ptr[0] = vec3{}; // GOOD: writes ints 0, 1, 2
    ptr[1] = vec3{}; // BAD: writes ints 3, 4, 5 [NOT DETECTED]
}
