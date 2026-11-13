#include "wrappers.h"
int source();
void sink(int);

// Storage-backed bodies: unlike a call to makeValue/assign, these do not create
// abstract Element contents themselves. Unsupported constructor tests inspect
// the direct return value; subsequent accessor flow needs an explicit model.
void *operator new(decltype(sizeof(0)), void *address) noexcept { return address; }
namespace BloombergLP { namespace bdlb {
template<class TYPE>
template<class... ARGS>
TYPE& NullableValue<TYPE>::makeValueInplace(ARGS&&... args) {
  d_value = TYPE(static_cast<ARGS&&>(args)...);
  return d_value;
}
template<class TYPES>
template<class TYPE, class... ARGS>
TYPE& VariantImp<TYPES>::createInPlace(ARGS&&... args) {
  return *new (static_cast<void*>(d_storage)) TYPE(static_cast<ARGS&&>(args)...);
}
} }

struct Constructed {
  int value;
  Constructed(int ignored, int used) : value(used) {}
};

void multiArgumentNullable() {
  BloombergLP::bdlb::NullableValue<Constructed> n;
  sink(n.makeValueInplace(0, source()).value); // $ ir
}
void ignoredArgumentNullable() {
  BloombergLP::bdlb::NullableValue<Constructed> n;
  sink(n.makeValueInplace(source(), 0).value);
}
void multiArgumentVariant() {
  BloombergLP::bdlb::Variant<Constructed> v;
  sink(v.createInPlace<Constructed>(0, source()).value); // $ ir
}
void ignoredArgumentVariant() {
  BloombergLP::bdlb::Variant<Constructed> v;
  sink(v.createInPlace<Constructed>(source(), 0).value);
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
  sink(n.makeValueInplace(input)); // $ ir
}
void variantScalarConversion() {
  ConvertedNumber input = {source()};
  sink(static_cast<int>(input)); // $ ir
  BloombergLP::bdlb::Variant<int> v;
  sink(v.createInPlace<int>(input)); // $ ir
}
void ignoredScalarConversions() {
  IgnoredNumber input = {source()};
  BloombergLP::bdlb::NullableValue<int> n;
  sink(n.makeValueInplace(input));
  BloombergLP::bdlb::Variant<int> v;
  sink(v.createInPlace<int>(input));
}

// Pointer conversions must retain their base-subobject semantics.
using namespace BloombergLP::bdlb;
struct PointerBase { int member; };
struct PointerPrefix { long padding; };
struct PointerDerived : PointerPrefix, PointerBase { int other; };
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

// makeValue also constructs directly in storage (through optional::emplace in BDE).
namespace BloombergLP { namespace bdlb {
template<class TYPE> template<class U>
TYPE& NullableValue<TYPE>::makeValue(U&& value) {
  d_value = TYPE(static_cast<U&&>(value));
  return d_value;
}
} }
void nullablePointerAssignmentConversion() {
  PointerDerived data;
  data.member = source();
  PointerDerived *ptr = &data;
  NullableValue<PointerBase*> n;
  sink(n.makeValue(ptr)->member); // $ ir
  sink(n.value()->member); // $ ir
}
enum class Choice { Clean };
void enumEmplacement() {
  Choice input = static_cast<Choice>(source());
  NullableValue<Choice> n;
  sink(static_cast<int>(n.makeValueInplace(input))); // $ ir
  sink(static_cast<int>(n.value())); // $ ir
  VariantImp<Types<Choice>> v;
  sink(static_cast<int>(v.createInPlace<Choice>(input))); // $ ir
  sink(static_cast<int>(v.the<Choice>())); // $ ir
}
void cleanEnumEmplacement() {
  NullableValue<Choice> n;
  n.makeValueInplace(Choice::Clean);
  sink(static_cast<int>(n.value()));
  VariantImp<Types<Choice>> v;
  v.createInPlace<Choice>(Choice::Clean);
  sink(static_cast<int>(v.the<Choice>()));
}

void cleanBaseMember() {
  PointerDerived data;
  data.member = 0;
  data.other = source();
  PointerDerived *ptr = &data;
  NullableValue<PointerBase*> n;
  n.makeValueInplace(ptr);
  sink(n.value()->member);
  VariantImp<Types<PointerBase*>> v;
  v.createInPlace<PointerBase*>(ptr);
  sink(v.the<PointerBase*>()->member);
}

PointerDerived *pointerSource();
void pointerSink(PointerDerived *);
void pointerSink(PointerBase *);
void pointerValueIdentity() {
  PointerDerived *ptr = pointerSource();
  NullableValue<PointerDerived*> same;
  pointerSink(same.makeValueInplace(ptr)); // $ value
  pointerSink(same.value()); // $ value
  NullableValue<PointerBase*> adjusted;
  pointerSink(adjusted.makeValueInplace(ptr));
  pointerSink(adjusted.value());
  NullableValue<PointerBase*> assigned;
  pointerSink(assigned.makeValue(ptr));
  pointerSink(assigned.value());
  VariantImp<Types<PointerDerived*>> sameVariant;
  pointerSink(sameVariant.createInPlace<PointerDerived*>(ptr)); // $ value
  pointerSink(sameVariant.the<PointerDerived*>()); // $ value
  VariantImp<Types<PointerBase*>> adjustedVariant;
  pointerSink(adjustedVariant.createInPlace<PointerBase*>(ptr));
  pointerSink(adjustedVariant.the<PointerBase*>());
}

enum Number { Zero };
void enumToIntEmplacement() {
  Number input = static_cast<Number>(source());
  NullableValue<int> n;
  n.makeValueInplace(input);
  sink(n.value()); // $ ir
  Variant<int> v;
  v.createInPlace<int>(input);
  sink(v.the<int>()); // $ ir
}
