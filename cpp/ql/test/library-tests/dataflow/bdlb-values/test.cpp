#include "wrappers.h"
int source();
void sink(int);
using namespace BloombergLP::bdlb;

void nullableReadWrite() {
  NullableValue<int> n;
  int input = source();
  sink(n.makeValue(input)); // $ ir
  sink(n.value()); // $ ir
  const NullableValue<int>& cn = n;
  sink(cn.value()); // $ ir
  sink(n.isNull());
}
void nullableReferenceWrite() {
  NullableValue<int> n;
  n.makeValue();
  n.value() = source();
  sink(n.value()); // $ ir
}
void nullableCopyMove() {
  NullableValue<int> n;
  n.makeValue(source());
  NullableValue<int> copy(n);
  NullableValue<int> moved(static_cast<NullableValue<int>&&>(copy));
  sink(moved.value()); // $ ir
}
void nullablePointer() {
  int input = source();
  int *p = &input;
  NullableValue<int*> n;
  n.makeValue(p);
  sink(*n.value()); // $ ir
}
struct Payload { int value; };
void nullableObject() {
  Payload input = {source()};
  NullableValue<Payload> n;
  n.makeValue(input);
  sink(n.value().value); // $ ir
}
void variantReadWrite() {
  Variant<int> v;
  int input = source();
  v.assign(input);
  sink(v.the<int>()); // $ ir
  sink(v.isUnset());
}
void variantReferenceWrite() {
  Variant<int> v;
  v.assign(0);
  v.the<int>() = source();
  sink(v.the<int>()); // $ ir
}
void variantPointer() {
  int input = source();
  int *p = &input;
  Variant<int*> v;
  v.assign(p);
  sink(*v.the<int*>()); // $ ir
}
void variantCopy() {
  VariantImp<Types<int>> v;
  v.assign(source());
  VariantImp<Types<int>> copy(v);
  sink(copy.the<int>()); // $ ir
}

void scalarEmplacement() {
  NullableValue<int> n;
  int input = source();
  sink(n.makeValueInplace(input)); // $ ir
  sink(n.value()); // $ ir
  Variant<int> v;
  sink(v.createInPlace<int>(input)); // $ ir
  sink(v.the<int>()); // $ ir
}

void variantReplacementAndResetStatus() {
  Variant<int> v;
  v.assign(0);
  v.assign(source());
  sink(v.the<int>()); // $ ir
  v.reset();
  sink(v.isUnset());
}
