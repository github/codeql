#include "a.h"
#include "s.h" // include a complete definition of Thing

void g(Thing *thing) {
  Foo f;
  f.bar(thing);
  baz(thing);
}
