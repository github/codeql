#pragma once

#include <memory>

#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>

#include "swift/extractor/config/SwiftExtractorConfiguration.h"
#include "swift/extractor/trap/TrapDomain.h"

namespace codeql {

void extractSwiftInvocation(const SwiftExtractorConfiguration& config,
                            swift::CompilerInstance& compiler,
                            codeql::TrapDomain& trap);
}  // namespace codeql
