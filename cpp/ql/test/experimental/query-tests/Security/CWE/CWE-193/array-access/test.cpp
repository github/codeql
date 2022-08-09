char *malloc(int size);

void test1(int size) {
    char *arr = malloc(size);
    for (int i = 0; i < size; i++) {
        arr[i] = 0;
    }

    for (int i = 0; i <= size; i++) {
        arr[i] = i;
    }
}

typedef struct {
    int size;
    char *p;
} array_t;

array_t mk_array(int size) {
    array_t arr;
    arr.size = size;
    arr.p = malloc(size);

    return arr;
}

void test2(int size) {
    array_t arr = mk_array(size);

    for (int i = 0; i < arr.size; i++) {
        arr.p[i] = 0;
    }

    for (int i = 0; i <= arr.size; i++) {
        arr.p[i] = i;
    }
}

void test3_callee(array_t arr) {
    for (int i = 0; i < arr.size; i++) {
        arr.p[i] = 0;
    }

    for (int i = 0; i <= arr.size; i++) {
        arr.p[i] = i;
    }
}

void test3(int size) {
    test3_callee(mk_array(size));
}

void test4(int size) {
    array_t arr;
    arr.size = size;
    arr.p = malloc(size);

    for (int i = 0; i < arr.size; i++) {
        arr.p[i] = 0;
    }

    for (int i = 0; i <= arr.size; i++) {
        arr.p[i] = i;
    }
}

array_t *mk_array_p(int size) {
    array_t *arr = (array_t*) malloc(sizeof(array_t));
    arr->size = size;
    arr->p = malloc(size);

    return arr;
}

void test5(int size) {
    array_t *arr = mk_array_p(size);

    for (int i = 0; i < arr->size; i++) {
        arr->p[i] = 0;
    }

    for (int i = 0; i <= arr->size; i++) {
        arr->p[i] = i;
    }
}

void test6_callee(array_t *arr) {
    for (int i = 0; i < arr->size; i++) {
        arr->p[i] = 0;
    }

    for (int i = 0; i <= arr->size; i++) {
        arr->p[i] = i;
    }
}

void test6(int size) {
    test6_callee(mk_array_p(size));
}