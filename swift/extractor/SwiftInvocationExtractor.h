#pragma once

#include <memory>

#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>

#include "swift/extractor/SwiftExtractorConfiguration.h"
#include "swift/extractor/SwiftExtractorState.h"
#include "swift/extractor/trap/TrapDomain.h"
namespace codeql {
void extractSwiftInvocation(const SwiftExtractorConfiguration& config,
                            SwiftExtractorState& state,
                            swift::CompilerInstance& compiler,
                            TrapDomain& domain);
}  // namespace codeql
