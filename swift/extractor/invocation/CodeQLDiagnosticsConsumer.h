#pragma once

#include <swift/AST/DiagnosticConsumer.h>
#include "swift/extractor/infra/SwiftLocationExtractor.h"

namespace codeql {

class TrapDomain;

class CodeQLDiagnosticsConsumer : public swift::DiagnosticConsumer {
 public:
  explicit CodeQLDiagnosticsConsumer(TrapDomain& targetFile)
      : trap(targetFile), locationExtractor(targetFile) {}
  void handleDiagnostic(swift::SourceManager& sourceManager,
                        const swift::DiagnosticInfo& diagInfo) override;

 private:
  static std::string getDiagMessage(swift::SourceManager& sourceManager,
                                    const swift::DiagnosticInfo& diagInfo);
  TrapDomain& trap;
  SwiftLocationExtractor locationExtractor;
};

}  // namespace codeql
