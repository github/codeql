#include "optional.h"
int source(); void sink(int);
struct Constructed {
  int value;
  Constructed(int ignored, int used) : value(used) {}
};
namespace std {
template<class T> template<class... Args>
T& optional<T>::emplace(Args&&... args) {
  T made(static_cast<Args&&>(args)...);
  *this = made;
  return **this;
}
}
namespace BloombergLP { namespace bslstl {
template<class T, bool B> template<class... Args>
T& Optional_Base<T, B>::emplace(Args&&... args) {
  T made(static_cast<Args&&>(args)...);
  **this = made;
  return **this;
}
} }
void constructors() {
  std::optional<Constructed> a;
  a.emplace(0, source());
  sink(a->value); // $ ir
  std::optional<Constructed> b;
  b.emplace(source(), 0);
  sink(b->value);
  bsl::optional<Constructed> c;
  c.emplace(0, source());
  sink(c->value); // $ ir
  bsl::optional<Constructed> d;
  d.emplace(source(), 0);
  sink(d->value);
}
