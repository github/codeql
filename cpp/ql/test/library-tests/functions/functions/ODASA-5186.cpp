#include "ODASA-5186.hpp"

template <class T>
struct MyClass : public NEQ_helper<MyClass<T>> {
  bool operator==(const MyClass& other) const { return true; }
};

bool test() {
  MyClass<int> x;
  MyClass<int> y;

  // This is a regression test for a bug found during the investigation of
  // ODASA-5186. Due to a bug in the extractor, the call to `operator!=`
  // below did not have a target (that is, `FunctionCall.getTarget()` had
  // no results). The bug was related to #include files, because the call
  // had a target if we manually included the contents of ODASA-5186.hpp.
  return (x != y);
}
