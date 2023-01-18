#pragma once

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/config/SwiftExtractorState.h"

namespace codeql {

enum class TrapType {
  source,
  module,
  invocation,
};

std::optional<TrapDomain> createTargetTrapDomain(SwiftExtractorState& state,
                                                 const std::filesystem::path& target,
                                                 TrapType type);

}  // namespace codeql
