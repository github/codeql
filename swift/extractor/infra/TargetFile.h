#pragma once

#include <string>
#include <fstream>
#include <iostream>
#include <cstdio>
#include <cerrno>
#include <system_error>
#include <sstream>

namespace codeql {

// Only the first process trying to open an `TargetFile` for a given `target` is allowed to do
// so, all others will have an instance with `good() == false` and failing on any other operation.
// The content streamed to the `TargetFile` is written to `workingDir/target`, and is moved onto
// `targetDir/target` only when `commit()` is called
class TargetFile {
  std::string workingPath;
  std::string targetPath;
  std::ofstream out;

 public:
  TargetFile(std::string_view target, std::string_view targetDir, std::string_view workingDir);

  bool good() const;
  void commit();

  template <typename T>
  TargetFile& operator<<(T&& value) {
    errno = 0;
    out << value;
    checkOutput("write to file");
    return *this;
  }

 private:
  void checkOutput(const char* action);
};

}  // namespace codeql
