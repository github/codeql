#pragma once

#include <swift/AST/DiagnosticConsumer.h>

namespace codeql {

class TrapDomain;

class CodeQLDiagnosticsConsumer : public swift::DiagnosticConsumer {
 public:
  explicit CodeQLDiagnosticsConsumer(TrapDomain& targetFile) : trap(targetFile) {}
  void handleDiagnostic(swift::SourceManager& sourceManager,
                        const swift::DiagnosticInfo& diagInfo) override;

 private:
  static std::string getDiagMessage(swift::SourceManager& sourceManager,
                                    const swift::DiagnosticInfo& diagInfo);
  TrapDomain& trap;
};

}  // namespace codeql
