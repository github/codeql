#include <stdarg.h>

int va_copy_test(va_list va) {
    va_list va2;
    va_copy(va2, va);
    return 0;
}
// semmle-extractor-options: --microsoft
