#include "wrappers.h"
using namespace BloombergLP::bdlb;
int source(); void sink(int);
void nullableCopyResult() {
  NullableValue<int> src, dst; src.makeValue(source());
  sink((dst = static_cast<const NullableValue<int>&>(src)).value()); // $ ir
  sink(dst.value()); // $ ir
}
void nullableMoveResult() {
  NullableValue<int> src, dst; src.makeValue(source());
  sink((dst = static_cast<NullableValue<int>&&>(src)).value()); // $ ir
  sink(dst.value()); // $ ir
}
void variantCopyResult() {
  VariantImp<Types<int>> src, dst; src.assign(source());
  sink((dst = static_cast<const VariantImp<Types<int>>&>(src)).the<int>()); // $ ir
  sink(dst.the<int>()); // $ ir
}
void variantMoveResult() {
  VariantImp<Types<int>> src, dst; src.assign(source());
  sink((dst = static_cast<VariantImp<Types<int>>&&>(src)).the<int>()); // $ ir
  sink(dst.the<int>()); // $ ir
}
void makeReference() {
  NullableValue<int> n;
  n.makeValue(0) = source();
  sink(n.value()); // $ ir
}
void nullableEmplaceReference() {
  NullableValue<int> n;
  n.makeValueInplace(0) = source();
  sink(n.value()); // $ ir
}
void variantEmplaceReference() {
  VariantImp<Types<int>> v;
  v.createInPlace<int>(0) = source();
  sink(v.the<int>()); // $ ir
}

void nullableCopyResultWrite() {
  NullableValue<int> a, b;
  b.makeValue(0);
  (a = static_cast<const NullableValue<int>&>(b)).value() = source();
  sink(a.value()); // $ ir
}

void nullableMoveResultWrite() {
  NullableValue<int> a, b;
  b.makeValue(0);
  (a = static_cast<NullableValue<int>&&>(b)).value() = source();
  sink(a.value()); // $ ir
}

void variantCopyResultWrite() {
  VariantImp<Types<int>> a, b;
  b.assign(0);
  (a = static_cast<const VariantImp<Types<int>>&>(b)).the<int>() = source();
  sink(a.the<int>()); // $ ir
}

void variantMoveResultWrite() {
  VariantImp<Types<int>> a, b;
  b.assign(0);
  (a = static_cast<VariantImp<Types<int>>&&>(b)).the<int>() = source();
  sink(a.the<int>()); // $ ir
}
