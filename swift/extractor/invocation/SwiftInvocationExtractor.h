#pragma once

#include <memory>

#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>

#include "swift/extractor/config/SwiftExtractorState.h"
#include "swift/extractor/trap/TrapDomain.h"

namespace codeql {

void extractSwiftInvocation(const SwiftExtractorState& state,
                            swift::CompilerInstance& compiler,
                            TrapDomain& trap);
}  // namespace codeql
