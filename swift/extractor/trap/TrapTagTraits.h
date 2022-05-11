#pragma once

#include <type_traits>

namespace codeql {

template <typename T>
struct ToTagFunctor;
template <typename T>
struct ToTagOverride : ToTagFunctor<T> {};

template <typename T>
using ToTag = typename ToTagOverride<std::remove_const_t<T>>::type;

template <typename T>
struct TagToBindingTrapFunctor;

template <typename Tag>
using TagToBindingTrap = typename TagToBindingTrapFunctor<Tag>::type;

}  // namespace codeql
