#ifndef SWIFT_EXTRACTOR_INCLUDE_EXTRACTOR_TRAP_TAGTRAITS_H
#define SWIFT_EXTRACTOR_INCLUDE_EXTRACTOR_TRAP_TAGTRAITS_H

#include <type_traits>

namespace codeql::trap {

template <typename T>
struct ToTagFunctor;
template <typename T>
struct ToTagOverride : ToTagFunctor<T> {};

template <typename T>
using ToTag = typename ToTagOverride<std::remove_const_t<T>>::type;

}  // namespace codeql::trap

#endif  // SWIFT_EXTRACTOR_INCLUDE_EXTRACTOR_TRAP_TAGTRAITS_H
