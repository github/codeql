#include "optional.h"
int source(); void sink(int);
struct Ignore {
  int value;
  Ignore(int) : value(0) {}
};
struct Use { int value; Use(int input) : value(input) {} };
namespace std {
template<class T> template<class U>
optional<T>::optional(U&& input) {
  **this = T(static_cast<U&&>(input));
}
}
namespace bsl {
template<class T> template<class U>
optional<T>::optional(U&& input,
  BloombergLP::bslstl::Optional_OptNoSuchType,
  BloombergLP::bslstl::Optional_OptNoSuchType) {
  **this = T(static_cast<U&&>(input));
}
}
void conversions() {
  std::optional<Use> used(source());
  sink(used->value); // $ ir
  bsl::optional<Use> bused(source());
  sink(bused->value); // $ ir
  std::optional<Ignore> a(source());
  sink(a->value);
  bsl::optional<Ignore> b(source());
  sink(b->value);
}
