// semmle-extractor-options: -I${testdir}/subdir1 --edg --set_flag  --edg stack_referenced_include_directories
// main1.cpp
#include "common.h"

#define DEFINED_HEADER "define1.h"

#include "defines_issue.h"
