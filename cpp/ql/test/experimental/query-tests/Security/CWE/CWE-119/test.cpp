
typedef unsigned size_t;
int sprintf(char *s, const char *format, ...);
int snprintf(char *s, size_t n, const char *format, ...);
int scanf(const char *format, ...);
int sscanf(const char *s, const char *format, ...);
char *malloc(size_t size);
char *strncpy(char *dst, const char *src, size_t n);

typedef struct
{
	char *string;
	unsigned size;
} string_t;

string_t *mk_string_t(int size) {
    string_t *str = (string_t *) malloc(sizeof(string_t));
    str->string = malloc(size);
    str->size = size;
    return str;
}

void test1(int size, char *buf) {
    string_t *str = mk_string_t(size);

    strncpy(str->string, buf, str->size); // GOOD
}

void strncpy_wrapper(string_t *str, char *buf) {
    strncpy(str->string, buf, str->size); // GOOD
}

void test2(int size, char *buf) {
    string_t *str = mk_string_t(size);
    strncpy_wrapper(str, buf);
}

void test3(unsigned size, char *buf, unsigned anotherSize) {
    string_t *str = mk_string_t(size);

    strncpy(str->string, buf, str->size); // GOOD
    strncpy(str->string, buf, str->size + 1); // BAD

    strncpy(str->string, buf, size); // GOOD
    strncpy(str->string, buf, size + 1); // BAD [NOT DETECTED]

    if(anotherSize < str->size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < str->size + 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < size + 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size + 1) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= size + 1) {
        strncpy(str->string, buf, anotherSize); // BAD [NOT DETECTED]
    }

    if(anotherSize <= str->size + 2) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= size + 2) {
        strncpy(str->string, buf, anotherSize); // BAD [NOT DETECTED]
    }
}

string_t *mk_string_t_plus_one(int size) {
    string_t *str = (string_t *) malloc(sizeof(string_t));
    str->string = malloc(size + 1);
    str->size = size + 1;
    return str;
}

void test4(unsigned size, char *buf, unsigned anotherSize) {
    string_t *str = mk_string_t_plus_one(size);

    strncpy(str->string, buf, str->size); // GOOD
    strncpy(str->string, buf, str->size + 1); // BAD

    strncpy(str->string, buf, size); // GOOD
    strncpy(str->string, buf, size + 1); // GOOD

    if(anotherSize < str->size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < str->size + 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < size + 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size + 1) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= size + 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size + 2) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= size + 2) {
        strncpy(str->string, buf, anotherSize); // BAD [NOT DETECTED]
    }
}

void test5(unsigned size, char *buf, unsigned anotherSize) {
    string_t *str = (string_t *) malloc(sizeof(string_t));
    str->string = malloc(size - 1);
    str->size = size - 1;

    strncpy(str->string, buf, str->size); // GOOD
    strncpy(str->string, buf, str->size - 1); // GOOD
    strncpy(str->string, buf, str->size + 1); // BAD

    strncpy(str->string, buf, size); // BAD
    strncpy(str->string, buf, size - 1); // GOOD
    strncpy(str->string, buf, size + 1); // BAD

    if(anotherSize < str->size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size - 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= size) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= size - 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < str->size + 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize < size + 1) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize < size - 1) {
        strncpy(str->string, buf, anotherSize); // GOOD
    }

    if(anotherSize <= str->size + 1) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= size + 1) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= str->size + 2) {
        strncpy(str->string, buf, anotherSize); // BAD
    }

    if(anotherSize <= size + 2) {
        strncpy(str->string, buf, anotherSize); // BAD
    }
}

