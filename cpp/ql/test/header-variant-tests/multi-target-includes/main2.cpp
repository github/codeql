// semmle-extractor-options: -I${testdir}/subdir2 --edg --set_flag --edg stack_referenced_include_directories
// main2.cpp
#include "common.h"

#define DEFINED_HEADER "define2.h"

#include "defines_issue.h"
