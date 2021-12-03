
extern void *f1 (void *px, const void *py, int ii)
            __attribute__((nonnull (1, 2)));

extern void *f2 (void *px, const void *py, int ii)
            __attribute__((nonnull ()));

extern void *f3 (void *px, const void *py, int ii)
            __attribute__((nonnull));

