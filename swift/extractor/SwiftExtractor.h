#pragma once

#include "swift/extractor/config/SwiftExtractorState.h"
#include <swift/AST/SourceFile.h>
#include <swift/Frontend/Frontend.h>
#include <memory>

namespace codeql {
void extractSwiftFiles(SwiftExtractorState& state, swift::CompilerInstance& compiler);
void extractExtractLazyDeclarations(SwiftExtractorState& state, swift::CompilerInstance& compiler);

class Logger;
namespace main_logger {
Logger& logger();
}
}  // namespace codeql
