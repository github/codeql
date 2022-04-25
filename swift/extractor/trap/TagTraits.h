#ifndef SWIFT_TRAP_TAGTRAITS_H_
#define SWIFT_TRAP_TAGTRAITS_H_

#include <type_traits>

namespace codeql::trap {

template <typename T>
struct ToTagFunctor;
template <typename T>
struct ToTagOverride : ToTagFunctor<T> {};

template <typename T>
using ToTag = typename ToTagOverride<std::remove_const_t<T>>::type;

}  // namespace codeql::trap

#endif  // SWIFT_TRAP_TAGTRAITS_H_
