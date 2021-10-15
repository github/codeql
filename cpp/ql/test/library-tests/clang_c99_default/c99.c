// NB: In C89, "restrict" is a normal identifier, whereas in C99 it is a keyword with special meaning.
int f(void* restrict, void* restrict);
// semmle-extractor-options: --clang
