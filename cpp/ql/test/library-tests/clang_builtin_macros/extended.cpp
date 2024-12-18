// semmle-extractor-options: --clang --edg --c++11 --edg --nullptr

static int has_nullptr_f = __has_feature(cxx_nullptr);
static int has_nullptr_e = __has_extension(cxx_nullptr);
