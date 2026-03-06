// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);

// defines type `myFunctionPointerType`, referencing `size_t`
typedef size_t (*myFunctionPointerType) ();

#include "include_twice.h"
