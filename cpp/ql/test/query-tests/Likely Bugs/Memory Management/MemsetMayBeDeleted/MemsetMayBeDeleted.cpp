extern "C" {
	typedef unsigned long long size_t;
	void *memset(void *s, int c, unsigned long n);
	void *__builtin_memset(void *s, int c, unsigned long n);
	typedef int errno_t;
	typedef unsigned int rsize_t;
	errno_t memset_s(void *dest, rsize_t destsz, int ch, rsize_t count);
	char *strcpy(char *dest, const char *src);
	void *memcpy(void *dest, const void *src, unsigned long n);
	void *malloc(unsigned long size);
	void free(void *ptr);
	extern void use_pw(char *pw);
}

#define PW_SIZE 32

struct mem {
	int a;
	char b[PW_SIZE];
	int c;
};

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.22: not deleted
void func(char buff[128], unsigned long long sz) {
    memset(buff, 0, PW_SIZE); // GOOD
}

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.22: not deleted
char *func2(char buff[128], unsigned long long sz) { 
    memset(buff, 0, PW_SIZE); // GOOD
    return buff;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func3(unsigned long long sz) { 
    char buff[128]; 
    memset(buff, 0, PW_SIZE); // BAD
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func4(unsigned long long sz) {
    char buff[128]; 
    memset(buff, 0, PW_SIZE); // BAD [NOT DETECTED]
    strcpy(buff, "Hello");
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func5(unsigned long long sz) {
    char buff[128]; 
    memset(buff, 0, PW_SIZE); // BAD [NOT DETECTED]
    if (sz > 5) {
        strcpy(buff, "Hello");
    }
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func6(unsigned long long sz) {
    struct mem m; 
    memset(&m, 0, PW_SIZE); // BAD
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func7(unsigned long long sz) { 
    struct mem m; 
    memset(&m, 0, PW_SIZE); // BAD
    m.a = 15;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func8(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func9(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
    free(m);
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func10(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
    m->a = sz;
    m->c = m->a + 1; 
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func11(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    ::memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
    if (sz > 5) {
    	strcpy(m->b, "Hello");
    }
}

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.22: not deleted
int func12(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
    memset(m, 0, sz); // GOOD
    return m->c;
}

int funcN1() {
	char pw[PW_SIZE];
	char *pw_ptr = pw;
	memset(pw, 0, PW_SIZE); // GOOD
	use_pw(pw_ptr);
	return 0;
}

char pw_global[PW_SIZE];
int funcN2() {
	use_pw(pw_global);
	memset(pw_global, 0, PW_SIZE); // GOOD
	return 0;
}

int funcN3(unsigned long long sz) {
    struct mem m;
    memset(&m, 0, sizeof(m)); // GOOD
    return m.a;
}

void funcN(int num) {
	char pw[PW_SIZE];
	int i;

	for (i = 0; i < num; i++)
	{
		use_pw(pw);
		memset(pw, 0, PW_SIZE); // GOOD
	}
}

class MyClass
{
public:
	void set(int _x) {
		x = _x;
	}

	int get()
	{
		return x;
	}

	void clear1() {
		memset(&x, 0, sizeof(x)); // GOOD
	}

	void clear2() {
		memset(&(this->x), 0, sizeof(this->x)); // GOOD
	}

private:
	int x;
};
