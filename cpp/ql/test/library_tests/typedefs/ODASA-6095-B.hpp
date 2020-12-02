#include "ODASA-6095-A.hpp"

template <typename X>
struct MyTemplate2 {
  static X field;
  typedef decltype(MyTemplate2<X>::field) mytype2;
};

extern template class MyTemplate<MyTemplate2<char>::mytype2>;
