// The extractor will not see a complete definition of Foo for this file.

#include "h.h"

// We want to check that these two variables don't get duplicated in the
// database.
void (*some_func_ptr)(struct Foo *foo);
struct Foo* foo_ptr1;
FooPtr foo_ptr2;

// This definition is incompatible with the one in a.c, so...
struct Bar {
  unsigned long bar_x;
};

// ...we'd expect this declaration to create a separate variable in the db
extern struct Bar bar;
