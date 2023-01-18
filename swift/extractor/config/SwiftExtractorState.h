#pragma once

#include <vector>
#include <filesystem>

#include <swift/AST/Decl.h>

#include "swift/extractor/config/SwiftExtractorConfiguration.h"

namespace codeql {
struct SwiftExtractorState {
  const SwiftExtractorConfiguration configuration;

  // All the trap files related to this extraction. This may also include trap files generated in a
  // previous run but that this run requested as well. Paths are relative to `configuration.trapDir`
  std::vector<std::filesystem::path> traps;
};

}  // namespace codeql
