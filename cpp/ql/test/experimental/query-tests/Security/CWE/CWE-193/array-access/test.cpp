char *malloc(int size);

void test1(int size) {
    char *arr = malloc(size);
    for (int i = 0; i < size; i++) {
        arr[i] = 0; // GOOD
    }

    for (int i = 0; i <= size; i++) {
        arr[i] = i; // BAD
    }
}

typedef struct {
    int size;
    char *p;
} array_t;

array_t mk_array(int size) {
    array_t arr;
    arr.p = malloc(size);
    arr.size = size;

    return arr;
}

void test2(int size) {
    array_t arr = mk_array(size);

    for (int i = 0; i < arr.size; i++) {
        arr.p[i] = 0; // GOOD
    }

    for (int i = 0; i <= arr.size; i++) {
        arr.p[i] = i; // BAD
    }
}

void test3_callee(array_t arr) {
    for (int i = 0; i < arr.size; i++) {
        arr.p[i] = 0; // GOOD
    }

    for (int i = 0; i <= arr.size; i++) {
        arr.p[i] = i; // BAD
    }
}

void test3(int size) {
    test3_callee(mk_array(size));
}

void test4(int size) {
    array_t arr;
    arr.p = malloc(size);
    arr.size = size;

    for (int i = 0; i < arr.size; i++) {
        arr.p[i] = 0; // GOOD
    }

    for (int i = 0; i <= arr.size; i++) {
        arr.p[i] = i; // BAD
    }
}

array_t *mk_array_p(int size) {
    array_t *arr = (array_t*) malloc(sizeof(array_t));
    arr->p = malloc(size);
    arr->size = size;

    return arr;
}

void test5(int size) {
    array_t *arr = mk_array_p(size);

    for (int i = 0; i < arr->size; i++) {
        arr->p[i] = 0; // GOOD
    }

    for (int i = 0; i <= arr->size; i++) {
        arr->p[i] = i; // BAD
    }
}

void test6_callee(array_t *arr) {
    for (int i = 0; i < arr->size; i++) {
        arr->p[i] = 0; // GOOD
    }

    for (int i = 0; i <= arr->size; i++) {
        arr->p[i] = i; // BAD
    }
}

void test6(int size) {
    test6_callee(mk_array_p(size));
}

void test7(int size) {
    char *arr = malloc(size);
    for (char *p = arr; p < arr + size; p++) {
        *p = 0; // GOOD
    }

    for (char *p = arr; p <= arr + size; p++) {
        *p = 0; // BAD [NOT DETECTED]
    }
}
