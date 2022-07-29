#pragma once

#include "swift/extractor/infra/TargetFile.h"
#include "swift/extractor/SwiftExtractorConfiguration.h"

namespace codeql {

std::optional<TargetFile> createTargetTrapFile(const SwiftExtractorConfiguration& configuration,
                                               std::string_view target);

}  // namespace codeql
