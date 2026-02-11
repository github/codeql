#include "a.h"
#include <a.h>
#include "b.h"
static int has_angle_b = __has_include(<b.h>);

// semmle-extractor-options: -I${testdir}/dir2 -iquote ${testdir}/dir1 --clang
