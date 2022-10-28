#pragma once

#include <filesystem>
#include <functional>

// workaround for https://cplusplus.github.io/LWG/issue3657
// notice that theoretically by the standard you are not allowed to specialize on std types...
// but it works, and this is recognized as a defect of the standard.
// Using a non-standard Hasher type would be a huge pain, as the automatic hash implementation of
// std::variant would not kick in (we use std::filesystem::path in a variant used as a map key).
// We can reconsider when the fix to the above issue hits clang, which might require a version check
// here
namespace std {
template <>
struct std::hash<std::filesystem::path> {
  std::size_t operator()(const std::filesystem::path& path) const { return hash_value(path); }
};
}  // namespace std
