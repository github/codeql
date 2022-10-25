#pragma once

#include <string>
namespace codeql {

// wrapper around `std::string` mainly intended to unambiguously go into an `std::variant`
// TODO probably not needed once we can use `std::filesystem::path`
struct FilePath {
  FilePath() = default;
  FilePath(const std::string& path) : path{path} {}
  FilePath(std::string&& path) : path{std::move(path)} {}

  std::string path;

  bool operator==(const FilePath& other) const { return path == other.path; }
};
}  // namespace codeql

namespace std {
template <>
struct hash<codeql::FilePath> {
  size_t operator()(const codeql::FilePath& value) { return hash<string>{}(value.path); }
};
}  // namespace std
