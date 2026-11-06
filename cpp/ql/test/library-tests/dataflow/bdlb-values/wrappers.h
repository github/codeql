// Reduced public API with concrete storage for the body-analysis regressions.
// Storage-backed methods never populate the models through other modeled APIs.
namespace bsl { template<class T> class allocator {}; }
namespace BloombergLP { namespace bslma { class Allocator; } namespace bdlb {
template<class TYPE> class NullableValue {
  TYPE d_value;
public:
  NullableValue();
  NullableValue(const NullableValue&);
  NullableValue(NullableValue&&);
  NullableValue(const NullableValue&, const bsl::allocator<char>&);
  NullableValue(NullableValue&&, const bsl::allocator<char>&);
  NullableValue& operator=(const NullableValue&);
  NullableValue& operator=(NullableValue&&);
  template<class U> TYPE& makeValue(U&& value);
  TYPE& makeValue();
  TYPE& value();
  const TYPE& value() const;
  template<class... ARGS> TYPE& makeValueInplace(ARGS&&... args);
  bool isNull() const;
  TYPE valueOr(const TYPE&) const;
  const TYPE *valueOr(const TYPE *) const; // Deprecated pointer overload.
  const TYPE *addressOr(const TYPE *) const;
  const TYPE *valueOrNull() const;
};
template<class TYPES> class VariantImp {
  alignas(16) unsigned char d_storage[256];
public:
  VariantImp();
  VariantImp(const VariantImp&, bslma::Allocator * = 0);
  VariantImp(VariantImp&&);
  VariantImp(VariantImp&&, bslma::Allocator *);
  VariantImp& operator=(const VariantImp&);
  VariantImp& operator=(VariantImp&&);
  template<class TYPE> VariantImp& assign(const TYPE& value);
  template<class TYPE> VariantImp& assign(TYPE&& value);
  template<class TYPE> TYPE& the();
  template<class TYPE> const TYPE& the() const;
  template<class TYPE, class... ARGS> TYPE& createInPlace(ARGS&&... args);
  void reset();
  bool isUnset() const;
};
template<class... TYPES> struct Types {};
// Public variants declare their own special members; they are not inherited.
#define DECLARE_VARIANT(NAME) \
template<class... T> class NAME : public VariantImp<Types<T...>> { \
public: \
  NAME(); \
  NAME(const NAME&, bslma::Allocator * = 0); \
  NAME(NAME&&); \
  NAME(NAME&&, bslma::Allocator *); \
  NAME& operator=(const NAME&); \
  NAME& operator=(NAME&&); \
};
DECLARE_VARIANT(Variant)
DECLARE_VARIANT(Variant2)
DECLARE_VARIANT(Variant3)
DECLARE_VARIANT(Variant4)
DECLARE_VARIANT(Variant5)
DECLARE_VARIANT(Variant6)
DECLARE_VARIANT(Variant7)
DECLARE_VARIANT(Variant8)
DECLARE_VARIANT(Variant9)
DECLARE_VARIANT(Variant10)
DECLARE_VARIANT(Variant11)
DECLARE_VARIANT(Variant12)
DECLARE_VARIANT(Variant13)
DECLARE_VARIANT(Variant14)
DECLARE_VARIANT(Variant15)
DECLARE_VARIANT(Variant16)
DECLARE_VARIANT(Variant17)
DECLARE_VARIANT(Variant18)
DECLARE_VARIANT(Variant19)
#undef DECLARE_VARIANT
} }
