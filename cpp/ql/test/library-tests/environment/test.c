#include "stdlib.h"

void test(char *name) {
    getenv("HOME");
    getenv(name);
    secure_getenv("QUERY_STRING");
}
