// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);

// defines type size_t plausibly
typedef unsigned long size_t;

#include "include_twice.h"
