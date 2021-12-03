
typedef long unsigned int size_t;

extern "C" {
    extern size_t strlen (const char *__s) throw ()
                   __attribute__ ((__pure__))
                   __attribute__ ((__nonnull__ (1)));
}

void fun(void) {
    static constexpr const char *fn = "file.ext";
    static constexpr size_t len = strlen(fn);
}

