// semmle-extractor-options: --expect_errors

#include "test.h"

void function_with_errors() {
    auto x = no_such_function();
    x+2;
    no_such_function();
    ADD(x+1, nsf2());
    f(1);
    f();
}

uint32_t fn2() {
    this is a syntax error;
    so_is_this(;
}
