#pragma once

#include <string>
#include <vector>

namespace codeql {
struct SwiftExtractorConfiguration {
  // The location for storing TRAP files to be imported by CodeQL engine.
  std::string trapDir;
  // The location for storing extracted source files.
  std::string sourceArchiveDir;
  // The arguments passed to the extractor. Used for debugging.
  std::vector<std::string> frontendOptions;
};
}  // namespace codeql
