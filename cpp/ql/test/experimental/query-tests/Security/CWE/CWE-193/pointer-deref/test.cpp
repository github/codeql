char *malloc(int size);

void test1(int size) {
    char* p = malloc(size);
    char* q = p + size;
    char a = *q; // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test12(int size) {
    char* p = malloc(size);
    char* q = p + size - 1;
    char a = *q; // GOOD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test9(int size) {
    char* p = malloc(size + 1);
    char* q = p + (size + 1);
    char a = *q; // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test10(int size) {
    char* p = malloc(size - 1);
    char* q = p + (size - 1);
    char a = *q; // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

char* mk_array(int size, char** end) {
    char* begin = malloc(size);
    *end = begin + size;

    return begin;
}

void test11(int size) {
    char* end;
    char* begin = mk_array(size, &end);

    for (char* p = begin; p != end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = begin; p <= end; ++p) {
        *p = 0; // BAD
    }

    for (char* p = begin; p < end; ++p) {
        *p = 0; // GOOD
    }
}

struct array_t {
    char* begin;
    char* end;
};

array_t mk_array(int size) {
    array_t arr;
    arr.begin = malloc(size);
    arr.end = arr.begin + size;

    return arr;
}

void test2(int size) {
    array_t arr = mk_array(size);

    for (char* p = arr.begin; p != arr.end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr.begin; p <= arr.end; ++p) {
        *p = 0; // BAD
    }

    for (char* p = arr.begin; p < arr.end; ++p) {
        *p = 0; // GOOD
    }
}

void test3_callee(array_t arr) {
    for (char* p = arr.begin; p != arr.end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr.begin; p <= arr.end; ++p) {
        *p = 0; // BAD
    }

    for (char* p = arr.begin; p < arr.end; ++p) {
        *p = 0; // GOOD
    }
}

void test3(int size) {
    test3_callee(mk_array(size));
}

void test4(int size) {
    array_t arr;
    char* p = malloc(size);
    arr.begin = p;
    arr.end = p + size;

    for (int i = 0; i < arr.end - arr.begin; i++) {
        *(arr.begin + i) = 0; // GOOD
    }

    for (int i = 0; i != arr.end - arr.begin; i++) {
        *(arr.begin + i) = 0; // GOOD
    }

    for (int i = 0; i <= arr.end - arr.begin; i++) {
        *(arr.begin + i) = 0; // BAD [NOT DETECTED]
    }
}

array_t *mk_array_p(int size) {
    array_t *arr = (array_t*) malloc(sizeof(array_t));
    arr->begin = malloc(size);
    arr->end = arr->begin + size;

    return arr;
}

void test5(int size) {
    array_t *arr = mk_array_p(size);

    for (char* p = arr->begin; p != arr->end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr->begin; p <= arr->end; ++p) {
        *p = 0; // BAD
    }

    for (char* p = arr->begin; p < arr->end; ++p) {
        *p = 0; // GOOD
    }
}

void test6_callee(array_t *arr) {
    for (char* p = arr->begin; p != arr->end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr->begin; p <= arr->end; ++p) {
        *p = 0; // BAD
    }

    for (char* p = arr->begin; p < arr->end; ++p) {
        *p = 0; // GOOD
    }
}

void test6(int size) {
    test6_callee(mk_array_p(size));
}
