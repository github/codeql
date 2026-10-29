
template <int i>
int addToSelf() { return i + i; };

int bar() { return addToSelf<10>(); }
