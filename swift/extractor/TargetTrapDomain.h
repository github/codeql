#pragma once

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/config/SwiftExtractorConfiguration.h"

namespace codeql {

std::optional<TrapDomain> createTargetTrapDomain(const SwiftExtractorConfiguration& configuration,
                                                 const std::filesystem::path& target);

}  // namespace codeql
