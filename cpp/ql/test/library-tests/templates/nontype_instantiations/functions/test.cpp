// codeql-extractor-compiler-options: -Xsemmle--trap_container=folder -Xsemmle--trap-compression=none
template <int i>
int addToSelf() { return i + i; };

int bar() { return addToSelf<10>(); }
