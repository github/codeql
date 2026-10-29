#pragma once

#include <swift/AST/DiagnosticConsumer.h>
#include "swift/extractor/infra/SwiftLocationExtractor.h"
#include "swift/logging/SwiftLogging.h"

namespace codeql {

class TrapDomain;

class SwiftDiagnosticsConsumer : public swift::DiagnosticConsumer {
 public:
  explicit SwiftDiagnosticsConsumer(TrapDomain& targetFile)
      : trap(targetFile), locationExtractor(targetFile) {}
  void handleDiagnostic(swift::SourceManager& sourceManager,
                        const swift::DiagnosticInfo& diagInfo) override;

 private:
  static std::string getDiagMessage(swift::SourceManager& sourceManager,
                                    const swift::DiagnosticInfo& diagInfo);
  void forwardToLog(swift::SourceManager& sourceManager,
                    const swift::DiagnosticInfo& diagInfo,
                    const std::string& message);

  void forwardToLog(swift::SourceManager& sourceManager, const swift::DiagnosticInfo& diagInfo) {
    forwardToLog(sourceManager, diagInfo, getDiagMessage(sourceManager, diagInfo));
  }

  TrapDomain& trap;
  SwiftLocationExtractor locationExtractor;
  Logger logger{"compiler"};
};

}  // namespace codeql
