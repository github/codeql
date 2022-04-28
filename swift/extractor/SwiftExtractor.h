#pragma once

#include "SwiftExtractorConfiguration.h"
#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>
#include <memory>

namespace codeql {
void extractSwiftFiles(const SwiftExtractorConfiguration& config,
                       swift::CompilerInstance& compiler);
}  // namespace codeql
