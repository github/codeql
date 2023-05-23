
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


void *memset(void *, int, unsigned);

void call_memset(void *p, unsigned size)
{
  memset(p, 0, size); // GOOD
}

void test_missing_call_context(unsigned char *unrelated_buffer, unsigned size) {
  unsigned char* buffer = (unsigned char*)malloc(size);
  call_memset(unrelated_buffer, size + 5);
  call_memset(buffer, size);
}

bool unknown();

void repeated_alerts(unsigned size, unsigned offset) {
  unsigned char* buffer = (unsigned char*)malloc(size);
  while(unknown()) {
    ++size;
  }
  memset(buffer, 0, size); // BAD [NOT DETECTED]
}

void set_string(string_t* p_str, char* buffer) {
    p_str->string = buffer;
}

void test_flow_through_setter(unsigned size) {
    string_t str;
    char* buffer = (char*)malloc(size);
    set_string(&str, buffer);
    memset(str.string, 0, size + 1); // BAD
}

void* my_alloc(unsigned size);

void foo(unsigned size) {
    int* p = (int*)my_alloc(size); // BAD
    memset(p, 0, size + 1);
}

void test6(unsigned long n, char *p) {
  while (unknown()) {
    n++;
    p = (char *)malloc(n);
    memset(p, 0, n); // GOOD
  }
}

void test7(unsigned n) {
    char* p = (char*)malloc(n);
    if(!p) {
        p = (char*)malloc(++n);
    }
    memset(p, 0, n); // GOOD [FALSE POSITIVE]
}