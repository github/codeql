// semmle-extractor-options: --clang
struct vtype {
	int i1, i2;
};
extern int w1, w2;

#ifdef _MSC_VER
#define restrict __restrict
#else
#define restrict __restrict__
#endif

void *__builtin_alloca(unsigned long sz);
#define alloca __builtin_alloca
typedef unsigned long long size_t;

int printf(const char *restrict format, ...);
void *memcpy(void *restrict s1, const void *restrict s2, size_t n);

// case 1: alloca directly contained in an unbounded loop
void foo(const struct vtype* vec, int count) {
	for (int i = 0; i < count; i++) {
		const vtype* v = vec + i;
		char *b1 = 0;
		if (b1 == nullptr) {
			if (w1 > w2) {
				// Allocate the buffer on heap
				b1 = new char[w1];
			} else {
				// Allocate the buffer on stack
				b1 = (char*) alloca(w1);  // BAD
			}
		}
		memcpy(b1, v, w1);
		printf("%s\n", b1);
		if (w1 > w2) {
			delete b1;
		}
	}
}

// case 2: alloca  contained in a do-while(0) that is in turn contained
//         in an unbounded loop
void bar(const struct vtype* vec, int count) {
	for (int i = 0; i < count; i++) {
		const vtype* v = vec + i;
		char *b1 = 0;
		do {
			if (b1 == nullptr) {
				if (w1 > w2) {
					// Allocate the buffer on heap
					b1 = new char[w1];
				} else {
					// Allocate the buffer on stack
					b1 = (char*) alloca(w1);  // BAD
				}
			}
		} while (0);
		memcpy(b1, v, w1);
		printf("%s\n", b1);
		if (w1 > w2) {
			delete b1;
		}
	}
}

// case 3: alloca  contained in an unbounded loop that is in turn contained
//         in a do-while(0)
void baz(const struct vtype* vec, int count) {
	do {
		for (int i = 0; i < count; i++) {
			const vtype* v = vec + i;
			char *b1 = 0;
			if (b1 == nullptr) {
				if (w1 > w2) {
					// Allocate the buffer on heap
					b1 = new char[w1];
				} else {
					// Allocate the buffer on stack
					b1 = (char*) alloca(w1);  // BAD
				}
			}
			memcpy(b1, v, w1);
			printf("%s\n", b1);
			if (w1 > w2) {
				delete b1;
			}
		}
	} while (0);
}

// case 4: alloca  contained in an unbounded loop, followed by break.
void case4() {
	char *buffer;

	do {
		buffer = (char*)alloca(1024); // GOOD

		break;
	} while (1);

	delete [] buffer;
}

// case 5: alloca  contained in an unbounded loop, followed by continue.
void case5() {
	char *buffer;

	do {
		buffer = (char*)alloca(1024); // BAD

		continue;
	} while (1);

	delete [] buffer;
}

// case 6: alloca  contained in an unbounded loop, followed by return.
char *case6() {
	char *buffer;

	do {
		buffer = (char*)alloca(1024); // GOOD

		return buffer;
	} while (1);
}
