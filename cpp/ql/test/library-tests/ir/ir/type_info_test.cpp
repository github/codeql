#include <typeinfo>

void type_info_test(int x) {
  const std::type_info &t1 = typeid(x);
  const std::type_info &t2 = typeid(int);
}

// semmle-extractor-options: -I.
