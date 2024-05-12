#pragma once

#include <filesystem>

namespace codeql {
struct PathHash {
  auto operator()(const std::filesystem::path& path) const {
    return std::filesystem::hash_value(path);
  }
};
}  // namespace codeql
