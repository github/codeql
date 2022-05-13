#pragma once

// This file defines functors that can be specialized to define a mapping from arbitrary types to
// label tags

#include <type_traits>

namespace codeql {

namespace detail {
template <typename T>
struct ToTagFunctor;
template <typename T>
struct ToTagOverride : ToTagFunctor<T> {};

}  // namespace detail

template <typename T>
using ToTag = typename detail::ToTagOverride<std::remove_const_t<T>>::type;

}  // namespace codeql
