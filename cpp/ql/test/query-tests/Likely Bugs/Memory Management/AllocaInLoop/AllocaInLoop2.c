// semmle-extractor-options: --clang
int printf(const char *restrict format, ...);
int sprintf(char *restrict s, const char *restrict format, ...);
typedef unsigned long long size_t;
void *memcpy(void *restrict s1, const void *restrict s2, size_t n);
void *malloc(size_t size);
void free(void *ptr);

struct vtype { int i1, i2; };
extern int w1, w2;

void *_builtin_alloca(unsigned long sz);
#define alloca __builtin_alloca

// We forward-declare the Microsoft routines
//_alloca and _malloca here.  Since they do not
// originate from the <malloc.h> header, they
// should not be flagged by our queries
void *_alloca(size_t sz);
void *_malloca(size_t sz);
void _freea(void *ptr);

#define NULL (void *)0

// case 1: alloca called within a provably infinite loop
void foo(const struct vtype* vec, int count) {
	char iter;

    do {
        const struct vtype* v = vec + 2;
        char *b1 = 0;
        iter = 0;
        if (b1 == NULL) {
            if (w1 > w2) {
                // Allocate the buffer on heap
                b1 = (char *)malloc(w1);
            } else {
                // Allocate the buffer on stack
                b1 = (char*) alloca(w1);  // BAD
                iter = 1;
            }
        }
        memcpy(b1, v, w1);
        printf("%s\n", b1);
        if (w1 > w2) {
        	free(b1);
        }
    } while (iter);
}

// case 2: alloca called within nested do-while(0) loops
void bar(const struct vtype* vec, int count) {

    do {
        const struct vtype* v = vec + 2;
        char *b1 = 0;
        do {
        if (b1 == NULL) {
            if (w1 > w2) {
                // Allocate the buffer on heap
                b1 = (char *)malloc(w1);
            } else {
                // Allocate the buffer on stack
                b1 = (char*) alloca(w1);  // GOOD
            }
        }
        } while (0);
        memcpy(b1, v, w1);
        printf("%s\n", b1);
        if (w1 > w2) {
        	free(b1);
        }
    } while (0);
}

// case 3: alloca called outside any loops
void baz(int count) {

	char *buf = (char *)alloca(32); // GOOD
	sprintf(buf, "Value is %d\n", count);
	printf("%s", buf);
}

////// Negative Microsoft test cases

// case 4: _alloca directly contained in an unbounded loop
void foo_ms(const struct vtype* vec, int count) {
	for (int i = 0; i < count; i++) {
		const struct vtype* v = vec + i;
		char *b1 = 0;
		if (b1 == NULL) {
			if (w1 > w2) {
				// Allocate the buffer on heap
				(char *)malloc(w1);
			} else {
				// Allocate the buffer on stack
				b1 = (char*) _alloca(w1);  // GOOD
			}
		}
		memcpy(b1, v, w1);
		printf("%s\n", b1);
		if (w1 > w2) {
			free(b1);
		}
	}
}

// case 5: _malloca  contained in a do-while(0) that is in turn contained
//         in an unbounded loop
void bar_ms(const struct vtype* vec, int count) {
	for (int i = 0; i < count; i++) {
		const struct vtype* v = vec + i;
		char *b1 = 0;
		do {
			if (b1 == NULL) {
				if (w1 > w2) {
					// Allocate the buffer on heap
					b1 = (char *)malloc(w1);
				} else {
					// Allocate the buffer on stack
					b1 = (char*) _malloca(w1);  // GOOD
				}
			}
		} while (0);
		memcpy(b1, v, w1);
		printf("%s\n", b1);
		if (w1 > w2) {
			free(b1);
		} else {
			_freea(b1);
		}
	}
}

// case 6: _alloca  contained in an unbounded loop that is in turn contained
//         in a do-while(0)
void baz_ms(const struct vtype* vec, int count) {
	do {
		for (int i = 0; i < count; i++) {
			const struct vtype* v = vec + i;
			char *b1 = 0;
			if (b1 == NULL) {
				if (w1 > w2) {
					// Allocate the buffer on heap
					b1 = (char *)malloc(w1);
				} else {
					// Allocate the buffer on stack
					b1 = (char*) _alloca(w1);  // GOOD
				}
			}
			memcpy(b1, v, w1);
			printf("%s\n", b1);
			if (w1 > w2) {
				free(b1);
			}
		}
	} while (0);
}
