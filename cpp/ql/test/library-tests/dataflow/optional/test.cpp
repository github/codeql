#include "optional.h"
int source();
void sink(int);
struct Payload { int member; };

template<template<class> class O> void operations() {
  O<int> value(source());
  sink(value.value()); // $ ir
  sink(*value); // $ ir
  O<int> written(0);
  *written = source();
  sink(written.value()); // $ ir
  const O<int>& ref = value;
  sink(*ref); // $ ir
  sink(ref.value()); // $ ir
  O<int> copied(static_cast<const O<int>&>(value));
  sink(*copied); // $ ir
  O<int> moved(static_cast<O<int>&&>(copied));
  sink(*moved); // $ ir
  O<int> assigned;
  assigned = moved;
  sink(*assigned); // $ ir
  O<int> moveAssigned;
  moveAssigned = static_cast<O<int>&&>(assigned);
  sink(*moveAssigned); // $ ir
  O<int> scalar;
  scalar = source();
  sink(*scalar); // $ ir
  scalar.reset();
  sink(scalar.has_value());
  O<int> clean;
  clean = 0;
  sink(*clean);
  Payload payload = {source()};
  O<Payload> object(payload);
  sink(object->member); // $ ir
  const O<Payload>& constObject = object;
  sink(constObject->member); // $ ir
  O<Payload> writtenObject(Payload{0});
  writtenObject->member = source();
  sink((*writtenObject).member); // $ ir
  int integer = source();
  int *ptr = &integer;
  O<int*> pointer(ptr);
  sink(**pointer); // $ ir
}
void all() { operations<std::optional>(); operations<bsl::optional>(); }

void scalarEmplacement() {
  std::optional<int> a;
  sink(a.emplace(source())); // $ ir
  sink(*a); // $ ir
  bsl::optional<int> b;
  sink(b.emplace(source())); // $ ir
  sink(*b); // $ ir
}
