#pragma once

#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/extractor/config/SwiftExtractorConfiguration.h"

namespace codeql {

std::optional<TargetFile> createTargetTrapFile(const SwiftExtractorConfiguration& configuration,
                                               const std::filesystem::path& target);

}  // namespace codeql
