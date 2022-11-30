#pragma once

#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/extractor/SwiftExtractorConfiguration.h"
#include "swift/extractor/SwiftExtractorState.h"

namespace codeql {

std::optional<TargetFile> createTargetTrapFile(const SwiftExtractorConfiguration& configuration,
                                               SwiftExtractorState& state,
                                               const std::filesystem::path& target);

}  // namespace codeql
