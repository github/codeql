typedef unsigned long size_t;
typedef long ssize_t;

#include "common.h"

template <typename T>
struct S {
  int get_int();
  T get_template_value();
};

template <typename U>
void template_func_calling_printf(S<U> &obj) {
  ::printf("%d\n", obj.get_int());
  ::printf("%d\n", obj.get_template_value());
}

void instantiate() {
  S<int>  s_int;
  S<long> s_long;

  template_func_calling_printf(s_int);  // ok
  template_func_calling_printf(s_long); // not ok (long -> int)
}
