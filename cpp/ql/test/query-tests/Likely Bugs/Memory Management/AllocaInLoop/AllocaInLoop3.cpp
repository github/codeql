// semmle-extractor-options: --clang
int printf(const char *format, ...);
void *memcpy(void *dst, const void *src, int len);

struct vtype { int i1, i2; };
extern int w1, w2;

void *__builtin_alloca(int sz);
#define alloca __builtin_alloca

void foo(const struct vtype* vec, int count) {
	bool iter;

    do {
        const vtype* v = vec + 2;
        char *b1 = 0;
        iter = false;
        if (b1 == nullptr) {
            if (w1 > w2) {
                // Allocate the buffer on heap
                b1 = new char[w1];
            } else {
                // Allocate the buffer on stack
                b1 = (char*) alloca(w1);
                iter = true;
            }
        }
        memcpy(b1, v, w1);
        printf("%s\n", b1);
        if (w1 > w2) {
            delete b1;
        }
    } while (0);
}
