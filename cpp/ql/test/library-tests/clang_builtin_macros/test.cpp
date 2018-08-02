// For the canonical behaviour, run: clang -E -w test.cpp
#define __builtin_TRAP __builtin_trap
#define BAR "bar.h"
// semmle-extractor-options: --edg --clang --expect_errors
#if defined(__has_include)
static int has_include = 1;
#else
static int has_include = 0;
#endif
static int has_builtin_trap = __has_builtin(__builtin_trap);
static int has_builtin_TRAP = __has_builtin(__builtin_TRAP);
static int has_builtin_door = __has_builtin(__builtin_door);
static int has_feature_cxx_rvalue_references = __has_feature(cxx_rvalue_references);
static int has_feature_crr_xvalue_xefexences = __has_feature(crr_xvalue_xefexences);
static int has_extension_cxx_rvalue_references = __has_feature(cxx_rvalue_references);
static int has_extension_crr_xvalue_xefexences = __has_feature(crr_xvalue_xefexences);
static int has_attribute_unused = __has_attribute(unused);
static int has_attribute_unused__ = __has_attribute(__unused__);
static int has_attribute_recycle = __has_attribute(recycle);
static int has_present_include = __has_include("bar.h");
static int has_macro_include = __has_include(BAR);
static int has_missing_include = __has_include("foo.h");
static int has_missing_include_next = __has_include_next("foo.h");
static int has_missing_system_include = __has_include(<foo.h>);

static int has_nullptr_f = __has_feature(cxx_nullptr);
static int has_nullptr_e = __has_extension(cxx_nullptr);
static int has_nullptr__ = __has_extension(__cxx_nullptr__);

static int objc_array_literals = __has_feature(objc_array_literals);
static int objc_dictionary_literals = __has_feature(objc_dictionary_literals);
static int objc_boxed_expressions = __has_feature(objc_boxed_expressions);
static int objc_made_up_thing = __has_feature(objc_made_up_thing);

#if __has_builtin(__builtin_trap)
static int if_has_builtin_trap = 1;
#else
static int if_has_builtin_trap = 0;
#endif

#if __has_builtin(__builtin_TRAP)
static int if_has_builtin_TRAP = 1;
#else
static int if_has_builtin_TRAP = 0;
#endif

#if __has_include("bar.h")
static int if_has_present_include = 1;
#else
static int if_has_present_include = 0;
#endif

#if __has_include(BAR)
static int if_has_macro_include = 1;
#else
static int if_has_macro_include = 0;
#endif

static int has_malformed_include = __has_include(bar_h);

static int include_level_0 = __INCLUDE_LEVEL__;
#include "h1.h"

