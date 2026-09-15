// Reduced public API; emplacement bodies are defined separately to test that
// arbitrary contained constructors remain analyzable.
namespace BloombergLP { namespace bslma { class Allocator; } namespace bdlb {
template<class TYPE> class NullableValue {
public:
  NullableValue();
  NullableValue(const NullableValue&);
  NullableValue(NullableValue&&);
  NullableValue& operator=(const NullableValue&);
  NullableValue& operator=(NullableValue&&);
  template<class U> TYPE& makeValue(U&& value);
  TYPE& makeValue();
  TYPE& value();
  const TYPE& value() const;
  template<class... ARGS> TYPE& makeValueInplace(ARGS&&... args);
  bool isNull() const;
};
template<class TYPES> class VariantImp {
public:
  VariantImp();
  VariantImp(const VariantImp&, bslma::Allocator * = 0);
  VariantImp(VariantImp&&);
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
template<class... T> class Variant : public VariantImp<Types<T...>> {};
} }
