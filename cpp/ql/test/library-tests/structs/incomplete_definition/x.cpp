#include "a.h"

Bar *bar_x;

namespace unrelated {
  struct Foo {
    short val;
  };
}

struct ContainsAnotherFoo {
  class Foo {
    long val;
  };
};

// The type of `foo_x` should not refer to any of the above classes, none of
// which are named `Foo` in the global scope.
Foo *foo_x;

template<typename T>
class Template {
  T templateField;
};

Template<Foo *> *template_foo;

// Instantiation of the template with unrelated classes named `Foo` should not
// get mixed up with the instantiation above.
template class Template<unrelated::Foo *>;
template class Template<ContainsAnotherFoo::Foo *>;
