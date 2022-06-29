#pragma once

#include <string>
#include <vector>

namespace codeql {
struct SwiftExtractorConfiguration {
  // The location for storing TRAP files to be imported by CodeQL engine.
  std::string trapDir;
  // The location for storing extracted source files.
  std::string sourceArchiveDir;
  // A temporary directory that exists during database creation, but is deleted once the DB is
  // finalized.
  std::string scratchDir;
  // A temporary directory that contains TRAP files before they moved into the final destination.
  // Subdirectory of the scratchDir.
  std::string tempTrapDir;

  // The original arguments passed to the extractor. Used for debugging.
  std::vector<std::string> frontendOptions;
};
}  // namespace codeql
