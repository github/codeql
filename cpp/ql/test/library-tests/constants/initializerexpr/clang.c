typedef float MyType;
static const MyType a = 36;
static const MyType b = a;
static const MyType c = 2 * a;
// codeql-extractor-compiler: clang
