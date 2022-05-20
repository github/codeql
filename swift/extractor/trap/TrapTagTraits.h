#pragma once

// This file defines functors that can be specialized to define a mapping from arbitrary types to
// label tags

#include <type_traits>

namespace codeql {

namespace detail {
// must be instantiated for default mapping from entities to tags
template <typename T>
struct ToTagFunctor;

// can be instantiated to override the default mapping for special cases
template <typename T>
struct ToTagOverride : ToTagFunctor<T> {};

// must be instantiated to map trap labels to the corresponding generated binding trap entry
template <typename Label>
struct ToBindingTrapFunctor;
}  // namespace detail

template <typename T>
using TrapTagOf = typename detail::ToTagOverride<std::remove_const_t<T>>::type;

template <typename T>
using TrapLabelOf = TrapLabel<TrapTagOf<T>>;

template <typename T>
using BindingTrapOf = typename detail::ToBindingTrapFunctor<TrapLabelOf<T>>::type;

}  // namespace codeql
