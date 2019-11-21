// codeql-extractor-compiler: clang
// semmle-extractor-compiler-options: -std=c++11 -Xsemmle--nullptr
static int has_nullptr_f = __has_feature(cxx_nullptr);
static int has_nullptr_e = __has_extension(cxx_nullptr);
