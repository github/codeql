#pragma once

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/config/SwiftExtractorState.h"

namespace codeql {

std::optional<TrapDomain> createTargetTrapDomain(SwiftExtractorState& state,
                                                 const std::filesystem::path& target);

}  // namespace codeql
