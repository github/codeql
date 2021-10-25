// semmle-extractor-options: --edg --trap_container=folder --edg --trap-compression=none
template <int i>
int addToSelf() { return i + i; };

int bar() { return addToSelf<10>(); }
