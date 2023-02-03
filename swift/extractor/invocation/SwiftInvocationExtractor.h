#pragma once

#include <memory>

#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>

#include "swift/extractor/config/SwiftExtractorState.h"
#include "swift/extractor/trap/TrapDomain.h"

namespace codeql {

void extractSwiftInvocation(SwiftExtractorState& state,
                            swift::CompilerInstance& compiler,
                            codeql::TrapDomain& trap);
}  // namespace codeql
