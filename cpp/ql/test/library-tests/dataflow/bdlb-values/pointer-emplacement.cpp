#include "wrappers.h"
using namespace BloombergLP::bdlb;
int source(); void sink(int);
struct Record { int member; };
void nullablePointerEmplacement() {
  Record record = {source()};
  Record *p = &record;
  NullableValue<Record*> n;
  sink(n.makeValueInplace(p)->member); // $ ir
  sink(n.value()->member); // $ ir
}
void variantPointerEmplacement() {
  Record record = {source()};
  Record *p = &record;
  VariantImp<Types<Record*>> v;
  sink(v.createInPlace<Record*>(p)->member); // $ ir
  sink(v.the<Record*>()->member); // $ ir
}
void nullableControl() {
  Record record = {source()};
  Record *p = &record;
  NullableValue<Record*> n;
  sink(n.makeValue(p)->member); // $ ir
  sink(n.value()->member); // $ ir
}
void variantControl() {
  Record record = {source()};
  Record *p = &record;
  VariantImp<Types<Record*>> v;
  v.assign(p);
  sink(v.the<Record*>()->member); // $ ir
}

void scalarConversionEmplacement() {
  int input = source();
  NullableValue<double> n;
  sink(n.makeValueInplace(input)); // $ ir
  sink(n.value()); // $ ir
  VariantImp<Types<double>> v;
  sink(v.createInPlace<double>(input)); // $ ir
  sink(v.the<double>()); // $ ir
}
