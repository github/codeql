#pragma once

#include <string>
#include <fstream>
#include <optional>
#include <cerrno>
#include <filesystem>

namespace codeql {

// Only the first process trying to create a `TargetFile` for a given `target` is allowed to do
// so, all others will have `create` return `std::nullopt`.
// The content streamed to the `TargetFile` is written to `workingDir/target`, and is moved onto
// `targetDir/target` on destruction.
class TargetFile {
  std::filesystem::path workingPath;
  std::filesystem::path targetPath;
  std::ofstream out;

 public:
  static std::optional<TargetFile> create(const std::filesystem::path& target,
                                          const std::filesystem::path& targetDir,
                                          const std::filesystem::path& workingDir);

  ~TargetFile() { commit(); }

  TargetFile(TargetFile&& other) = default;
  // move assignment deleted as non-trivial and not needed
  TargetFile& operator=(TargetFile&& other) = delete;

  template <typename T>
  TargetFile& operator<<(T&& value) {
    errno = 0;
    out << value;
    checkOutput("write to");
    return *this;
  }

  const std::filesystem::path& target() const { return targetPath; }

 private:
  TargetFile(const std::filesystem::path& target,
             const std::filesystem::path& targetDir,
             const std::filesystem::path& workingDir);

  bool init();
  void checkOutput(const char* action);
  void commit();
};

}  // namespace codeql
