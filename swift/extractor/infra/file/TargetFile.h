#pragma once

#include <string>
#include <fstream>
#include <optional>
#include <cerrno>

namespace codeql {

// Only the first process trying to create a `TargetFile` for a given `target` is allowed to do
// so, all others will have `create` return `std::nullopt`.
// The content streamed to the `TargetFile` is written to `workingDir/target`, and is moved onto
// `targetDir/target` on destruction.
class TargetFile {
  std::string workingPath;
  std::string targetPath;
  std::ofstream out;

 public:
  static std::optional<TargetFile> create(std::string_view target,
                                          std::string_view targetDir,
                                          std::string_view workingDir);

  ~TargetFile() { commit(); }

  TargetFile(TargetFile&& other) = default;
  // move assignment deleted as non-trivial and not needed
  TargetFile& operator=(TargetFile&& other) = delete;

  template <typename T>
  TargetFile& operator<<(T&& value) {
    errno = 0;
    out << value;
    checkOutput("write to file");
    return *this;
  }

 private:
  TargetFile(std::string_view target, std::string_view targetDir, std::string_view workingDir);

  bool init();
  void checkOutput(const char* action);
  void commit();
};

}  // namespace codeql
