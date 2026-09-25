// Reduced C++11+ APIs; bodies are absent except in the emplacement regression.
namespace std {
template<class T> class optional {
public:
  optional();
  optional(const optional&);
  optional(optional&&);
  template<class U = T> optional(U&&);
  optional& operator=(const optional&);
  optional& operator=(optional&&);
  template<class U = T> optional& operator=(U&&);
  T& value(); const T& value() const;
  T& operator*(); const T& operator*() const;
  T *operator->(); const T *operator->() const;
  template<class... Args> T& emplace(Args&&...);
  void reset(); bool has_value() const;
};
}
namespace BloombergLP { namespace bslstl {
struct Optional_OptNoSuchType { Optional_OptNoSuchType(int); };
template<class T, bool ALLOC = false> class Optional_Base {
public:
  T& value(); const T& value() const;
  T& operator*(); const T& operator*() const;
  T *operator->(); const T *operator->() const;
  template<class... Args> T& emplace(Args&&...);
  void reset(); bool has_value() const;
};
#ifdef TEST_STD_BACKED
template<class T> class Optional_Base<T, false> : public std::optional<T> {};
#endif
} }
namespace bsl {
template<class T> class optional : public BloombergLP::bslstl::Optional_Base<T> {
public:
  optional();
  optional(const optional&);
  optional(optional&&);
  template<class U = T> optional(U&&,
    BloombergLP::bslstl::Optional_OptNoSuchType = 0,
    BloombergLP::bslstl::Optional_OptNoSuchType = 0);
  optional& operator=(const optional&);
  optional& operator=(optional&&);
  template<class U = T> optional& operator=(U&&);
};
}
