#pragma once

#include "swift/extractor/SwiftExtractorConfiguration.h"
#include "swift/extractor/SwiftExtractorState.h"
#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>
#include <memory>

namespace codeql {
void extractSwiftFiles(const SwiftExtractorConfiguration& config,
                       SwiftExtractorState& state,
                       swift::CompilerInstance& compiler);
}  // namespace codeql
