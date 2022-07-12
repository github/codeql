#pragma once

#include <string>
#include <fstream>
#include <iostream>
#include <cstdio>
#include <cerrno>
#include <system_error>
#include <sstream>

namespace codeql {

// Only the first process trying to open an `ExclusiveFile` for a given `target` is allowed to do
// so, all others will have an instance with `owned() == false` and failing on any other operation.
// The content streamed to the `ExclusiveFile` is written to `working`, and is moved onto target
// only when `commit()` is called
class ExclusiveFile {
  std::string workingPath;
  std::string targetPath;
  std::ofstream out;

 public:
  ExclusiveFile(std::string working, std::string target);

  bool owned() const;
  void commit();

  template <typename T>
  ExclusiveFile& operator<<(T&& value) {
    errno = 0;
    out << value;
    checkOutput("write to file");
    return *this;
  }

 private:
  void checkOutput(const char* action);
};

}  // namespace codeql
