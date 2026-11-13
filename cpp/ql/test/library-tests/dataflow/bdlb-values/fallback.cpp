#include "wrappers.h"
using namespace BloombergLP::bdlb;
int source(); void sink(int);

void containedValueOr() {
  NullableValue<int> n;
  n.makeValue(source());
  sink(n.valueOr(0)); // $ ir
}
void defaultValueOr() {
  NullableValue<int> n;
  sink(n.valueOr(source())); // $ ir
}
void cleanValueOr() {
  NullableValue<int> n;
  n.makeValue(0);
  sink(n.valueOr(0));
}
void containedAddressOr() {
  NullableValue<int> n;
  n.makeValue(source());
  int fallback = 0;
  sink(*n.addressOr(&fallback)); // $ ir
  sink(*n.valueOr(&fallback)); // $ ir
  sink(*n.valueOrNull()); // $ ir
}
void defaultAddressOr() {
  NullableValue<int> n;
  int fallback = source();
  sink(*n.addressOr(&fallback)); // $ ir
  sink(*n.valueOr(&fallback)); // $ ir
}
void emptyValueOrNull() {
  NullableValue<int> n;
  const int *p = n.valueOrNull();
  if (p) sink(*p);
}
void cleanAddressOr() {
  NullableValue<int> n;
  n.makeValue(0);
  int fallback = 0;
  sink(*n.addressOr(&fallback));
  sink(*n.valueOr(&fallback));
  sink(*n.valueOrNull());
}
void containedPointerValueOr() {
  int input = source();
  int *p = &input;
  int clean = 0;
  int *fallback = &clean;
  NullableValue<int*> n;
  n.makeValue(p);
  sink(*n.valueOr(fallback)); // $ ir
}
void defaultPointerValueOr() {
  int input = source();
  int *fallback = &input;
  NullableValue<int*> n;
  sink(*n.valueOr(fallback)); // $ ir
}
void pointerAccessorWrite() {
  NullableValue<int*> n;
  **n.valueOrNull() = source();
  sink(*n.value()); // $ ir
}
void addressOrWrite() {
  NullableValue<int*> n;
  int *fallback = 0;
  **n.addressOr(&fallback) = source();
  sink(*n.value()); // $ ir
}
void pointerValueOrWrite() {
  NullableValue<int*> n;
  int *fallback = 0;
  **n.valueOr(&fallback) = source();
  sink(*n.value()); // $ ir
}
// Returning by value must not create a writable alias to the contained scalar.
void valueOrCopyWrite() {
  NullableValue<int> n;
  n.makeValue(0);
  int copy = n.valueOr(0);
  copy = source();
  sink(n.value());
}
