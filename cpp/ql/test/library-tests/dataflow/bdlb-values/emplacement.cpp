#include "wrappers.h"
int source();
void sink(int);

// Reduced forwarding bodies. User-defined construction must remain visible.
namespace BloombergLP { namespace bdlb {
template<class TYPE>
template<class... ARGS>
TYPE& NullableValue<TYPE>::makeValueInplace(ARGS&&... args) {
  TYPE made(static_cast<ARGS&&>(args)...);
  return makeValue(made);
}
template<class TYPES>
template<class TYPE, class... ARGS>
TYPE& VariantImp<TYPES>::createInPlace(ARGS&&... args) {
  TYPE made(static_cast<ARGS&&>(args)...);
  assign(made);
  return the<TYPE>();
}
} }

struct Constructed {
  int value;
  Constructed(int ignored, int used) : value(used) {}
};

void multiArgumentNullable() {
  BloombergLP::bdlb::NullableValue<Constructed> n;
  n.makeValueInplace(0, source());
  sink(n.value().value); // $ ir
}
void ignoredArgumentNullable() {
  BloombergLP::bdlb::NullableValue<Constructed> n;
  n.makeValueInplace(source(), 0);
  sink(n.value().value);
}
void multiArgumentVariant() {
  BloombergLP::bdlb::Variant<Constructed> v;
  v.createInPlace<Constructed>(0, source());
  sink(v.the<Constructed>().value); // $ ir
}
void ignoredArgumentVariant() {
  BloombergLP::bdlb::Variant<Constructed> v;
  v.createInPlace<Constructed>(source(), 0);
  sink(v.the<Constructed>().value);
}

// Scalar destinations can still require a user-defined input conversion.
struct ConvertedNumber {
  int payload;
  operator int() const { return payload; }
};
struct IgnoredNumber {
  int payload;
  operator int() const { return 0; }
};
void nullableScalarConversion() {
  ConvertedNumber input = {source()};
  sink(static_cast<int>(input)); // $ ir
  BloombergLP::bdlb::NullableValue<int> n;
  n.makeValueInplace(input);
  sink(n.value()); // $ ir
}
void variantScalarConversion() {
  ConvertedNumber input = {source()};
  sink(static_cast<int>(input)); // $ ir
  BloombergLP::bdlb::Variant<int> v;
  v.createInPlace<int>(input);
  sink(v.the<int>()); // $ ir
}
void ignoredScalarConversions() {
  IgnoredNumber input = {source()};
  BloombergLP::bdlb::NullableValue<int> n;
  n.makeValueInplace(input);
  sink(n.value());
  BloombergLP::bdlb::Variant<int> v;
  v.createInPlace<int>(input);
  sink(v.the<int>());
}

// Pointer conversions must retain their base-subobject semantics.
using namespace BloombergLP::bdlb;
struct PointerBase { int member; };
struct PointerDerived : PointerBase { int other; };
void nullableConstPointer() {
  PointerBase data = {source()};
  PointerBase *ptr = &data;
  NullableValue<const PointerBase*> v;
  sink(v.makeValueInplace(ptr)->member); // $ ir
  sink(v.value()->member); // $ ir
}
void variantConstPointer() {
  PointerBase data = {source()};
  PointerBase *ptr = &data;
  VariantImp<Types<const PointerBase*>> v;
  sink(v.createInPlace<const PointerBase*>(ptr)->member); // $ ir
  sink(v.the<const PointerBase*>()->member); // $ ir
}
void nullablePointerDerivedPointer() {
  PointerDerived data;
  data.member = source();
  PointerDerived *ptr = &data;
  NullableValue<PointerBase*> v;
  sink(v.makeValueInplace(ptr)->member); // $ ir
  sink(v.value()->member); // $ ir
}
void variantPointerDerivedPointer() {
  PointerDerived data;
  data.member = source();
  PointerDerived *ptr = &data;
  VariantImp<Types<PointerBase*>> v;
  sink(v.createInPlace<PointerBase*>(ptr)->member); // $ ir
  sink(v.the<PointerBase*>()->member); // $ ir
}
void constPointerControls() {
  PointerBase data = {source()};
  const PointerBase *ptr = &data;
  NullableValue<const PointerBase*> n;
  sink(n.makeValueInplace(ptr)->member); // $ ir
  VariantImp<Types<const PointerBase*>> v;
  sink(v.createInPlace<const PointerBase*>(ptr)->member); // $ ir
}
void derivedPointerControls() {
  PointerDerived data;
  data.member = source();
  PointerBase *ptr = &data;
  NullableValue<PointerBase*> n;
  sink(n.makeValueInplace(ptr)->member); // $ ir
  VariantImp<Types<PointerBase*>> v;
  sink(v.createInPlace<PointerBase*>(ptr)->member); // $ ir
}
