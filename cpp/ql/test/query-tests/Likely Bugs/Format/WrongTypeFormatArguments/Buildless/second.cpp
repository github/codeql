// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);

// defines type `myFunctionPointerType`
typedef int (*myFunctionPointerType) ();

#include "include_twice.h"
