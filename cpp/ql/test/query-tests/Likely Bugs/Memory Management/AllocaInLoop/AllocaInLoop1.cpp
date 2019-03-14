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

void *__builtin_alloca(int sz);
#define alloca __builtin_alloca
typedef unsigned long size_t;

int printf(const char *restrict format, ...);
void *memcpy(void *restrict dst, const void *restrict src, size_t len);

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
				b1 = (char*) alloca(w1);  // [FLAG]
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
					b1 = (char*) alloca(w1);  // [FLAG]
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
					b1 = (char*) alloca(w1);  // [FLAG]
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
