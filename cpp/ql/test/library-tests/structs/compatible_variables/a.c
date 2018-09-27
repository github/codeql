#include "h.h"

// Provide a complete definition of Foo.
struct Foo {
  int foo_x;
};

// This definition is incompatible with the one in b.c, so...
struct Bar {
  int bar_y;
};

// ...we'd expect this declaration to create a separate variable in the db
extern struct Bar bar;
