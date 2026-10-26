#if defined(__has_include)
static int has_include = 1;
#else
static int has_include = 0;
#endif

#if __has_include("bar.h")
static int has_present_include = 1;
#else
static int has_present_include = 0;
#endif

#define BAR "bar.h"
#if __has_include(BAR)
static int has_macro_include = 1;
#else
static int has_macro_include = 0;
#endif

#if __has_include("foo.h")
static int has_missing_include = 1;
#else
static int has_missing_include = 0;
#endif

#if __has_include_next("foo.h")
static int has_missing_include_next = 1;
#else
static int has_missing_include_next = 0;
#endif

#if __has_include(<foo.h>)
static int has_missing_system_include = 1;
#else
static int has_missing_system_include = 0;
#endif

// semmle-extractor-options: --gnu_version 40902 -D__has_include(STR)=__has_include__(STR) -D__has_include_next(STR)=__has_include_next__(STR)
