#pragma once

// This file defines functors that can be specialized to define a mapping from arbitrary types to
// label tags

#include <type_traits>
#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

namespace detail {
// must be instantiated for default mapping from entities to tags
template <typename T>
struct ToTagFunctor;

// can be instantiated to override the default mapping for special cases
template <typename T>
struct ToTagConcreteOverride : ToTagFunctor<T> {};

// must be instantiated to map trap labels to the corresponding generated binding trap entry
template <typename Label>
struct ToBindingTrapFunctor;

// must be instantiated to map trap tags to the corresponding generated trap class
template <typename Tag>
struct ToTrapClassFunctor;
}  // namespace detail

template <typename T>
using TrapTagOf =
    typename detail::ToTagFunctor<std::remove_const_t<std::remove_pointer_t<T>>>::type;

template <typename T>
using ConcreteTrapTagOf =
    typename detail::ToTagConcreteOverride<std::remove_const_t<std::remove_pointer_t<T>>>::type;

template <typename T>
using TrapLabelOf = TrapLabel<TrapTagOf<T>>;

template <typename T>
using BindingTrapOf = typename detail::ToBindingTrapFunctor<TrapLabel<ConcreteTrapTagOf<T>>>::type;

template <typename T>
using TrapClassOf = typename detail::ToTrapClassFunctor<ConcreteTrapTagOf<T>>::type;

}  // namespace codeql
