#pragma once

#include <filesystem>

namespace codeql {
std::filesystem::path resolvePath(const std::filesystem::path& path);

inline std::filesystem::path resolvePath(std::string_view path) {
  return resolvePath(std::filesystem::path{path});
}

inline std::filesystem::path resolvePath(const std::string& path) {
  return resolvePath(std::filesystem::path{path});
}
}  // namespace codeql
