typedef unsigned long size_t;
void *memset(void *s, int c, size_t n);
void *__builtin_memset(void *s, int c, size_t n);
typedef int errno_t;
typedef unsigned int rsize_t;
errno_t memset_s(void *dest, rsize_t destsz, int ch, rsize_t count);
char *strcpy(char *dest, const char *src);
void *memcpy(void *dest, const void *src, size_t n);
void *malloc(size_t size);
void free(void *ptr);

extern void use_pw(char *pw);

#define PW_SIZE 32

struct mem {
	int a;
	char b[PW_SIZE];
	int c;
};

void func(char buff[128], unsigned long long sz) { // GOOD
    memset(buff, 0, PW_SIZE);
}

char *func2(char buff[128], unsigned long long sz) { // GOOD
    memset(buff, 0, PW_SIZE);
    return buff;
}

void func3(unsigned long long sz) { // BAD
    char buff[128]; 
    memset(buff, 0, PW_SIZE);
}

void func4(unsigned long long sz) { // GOOD
    char buff[128]; 
    memset(buff, 0, PW_SIZE);
    strcpy(buff, "Hello");
}

void func5(unsigned long long sz) { // GOOD
    char buff[128]; 
    memset(buff, 0, PW_SIZE);
    if (sz > 5) {
        strcpy(buff, "Hello");
    }
}

void func6(unsigned long long sz) { // BAD
    struct mem m; 
    memset(&m, 0, PW_SIZE);
}

void func7(unsigned long long sz) { // GOOD
    struct mem m; 
    memset(&m, 0, PW_SIZE);
    m.a = 15;
}

void func8(unsigned long long sz) { // BAD
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    memset(m, 0, PW_SIZE);
}

void func9(unsigned long long sz) { // GOOD
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    memset(m, 0, PW_SIZE);
    free(m);
}

void func10(unsigned long long sz) { // GOOD
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    memset(m, 0, PW_SIZE);
    m->a = sz;
}

void func11(unsigned long long sz) { // GOOD
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    ::memset(m, 0, PW_SIZE);
    if (sz > 5) {
    	strcpy(m->b, "Hello");
    }
}

