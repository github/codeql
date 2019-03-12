// semmle-extractor-options: --clang
struct vtype { int i1, i2; };
extern int w1, w2;

void *__builtin_alloca(int sz);
#define alloca __builtin_alloca

int printf(const char *format, ...);
void *memcpy(void *dst, const void *src, int len);

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
                b1 = (char*) alloca(w1);
            }
        }
        memcpy(b1, v, w1);
        printf("%s\n", b1);
        if (w1 > w2) {
            delete b1;
        }
    }
}
