#include "a.h"
#include <a.h>
#include "b.h"
static int has_angle_b = __has_include(<b.h>);

// codeql-extractor-compiler: clang
// codeql-extractor-compiler-options: -I${testdir}/dir2 -iquote ${testdir}/dir1
