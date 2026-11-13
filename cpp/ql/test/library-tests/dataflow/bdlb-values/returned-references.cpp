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

struct PointerDerived;
PointerDerived *pointerSource();
void pointerSink(PointerDerived *);
void nullableCopyValue() {
  NullableValue<PointerDerived*> src, dst;
  src.makeValue(pointerSource());
  dst = static_cast<const NullableValue<PointerDerived*>&>(src);
  pointerSink(dst.value()); // $ value
}

void nullableDoublePointerWrite() {
  NullableValue<int**> n;
  **n.value() = source();
  sink(**n.value()); // $ ir
}
void variantDoublePointerWrite() {
  Variant<int**> v;
  **v.the<int**>() = source();
  sink(**v.the<int**>()); // $ ir
}

void nullableEmplaceDoublePointerWrite() {
  NullableValue<int**> n;
  int **p = 0;
  **n.makeValueInplace(p) = source();
  sink(**n.value()); // $ ir
}
void nullableMakeDoublePointerWrite() {
  NullableValue<int**> n;
  int **p = 0;
  **n.makeValue(p) = source();
  sink(**n.value()); // $ ir
}
void variantEmplaceDoublePointerWrite() {
  Variant<int**> v;
  int **p = 0;
  **v.createInPlace<int**>(p) = source();
  sink(**v.the<int**>()); // $ ir
}
void publicVariantCopyMove(BloombergLP::bslma::Allocator *allocator) {
  Variant<int> src;
  src.assign(source());
  Variant<int> copy(src);
  sink(copy.the<int>()); // $ ir
  Variant<int> moved(static_cast<Variant<int>&&>(copy));
  sink(moved.the<int>()); // $ ir
  Variant<int> allocated(src, allocator);
  sink(allocated.the<int>()); // $ ir
  Variant<int> movedAllocated(static_cast<Variant<int>&&>(allocated), allocator);
  sink(movedAllocated.the<int>()); // $ ir
  Variant<int> dst;
  sink((dst = src).the<int>()); // $ ir
  sink(dst.the<int>()); // $ ir
  sink((dst = static_cast<Variant<int>&&>(src)).the<int>()); // $ ir
  sink(dst.the<int>()); // $ ir
}
void allocatorMoves(BloombergLP::bslma::Allocator *allocator,
                    const bsl::allocator<char>& nullableAllocator) {
  VariantImp<Types<int>> src;
  src.assign(source());
  VariantImp<Types<int>> dst(static_cast<VariantImp<Types<int>>&&>(src), allocator);
  sink(dst.the<int>()); // $ ir
  NullableValue<int> n;
  n.makeValue(source());
  NullableValue<int> copy(n, nullableAllocator);
  sink(copy.value()); // $ ir
  NullableValue<int> moved(static_cast<NullableValue<int>&&>(copy), nullableAllocator);
  sink(moved.value()); // $ ir
}

void numberedVariant2(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant2<PointerDerived*, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant3(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant3<PointerDerived*, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant4(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant4<PointerDerived*, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant5(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant5<PointerDerived*, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant6(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant6<PointerDerived*, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant7(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant7<PointerDerived*, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant8(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant8<PointerDerived*, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant9(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant9<PointerDerived*, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant10(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant10<PointerDerived*, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant11(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant11<PointerDerived*, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant12(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant12<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant13(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant13<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant14(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant14<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant15(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant15<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant16(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant16<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant17(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant17<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant18(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant18<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}

void numberedVariant19(BloombergLP::bslma::Allocator *allocator) {
  using V = Variant19<PointerDerived*, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int>;
  V src, assigned;
  src.assign(pointerSource());
  V copy(src, allocator);
  pointerSink(copy.the<PointerDerived*>()); // $ value
  V moved(static_cast<V&&>(copy), allocator);
  pointerSink(moved.the<PointerDerived*>()); // $ value
  assigned = src;
  pointerSink(assigned.the<PointerDerived*>()); // $ value
  pointerSink((assigned = static_cast<V&&>(moved)).the<PointerDerived*>()); // $ value
}
