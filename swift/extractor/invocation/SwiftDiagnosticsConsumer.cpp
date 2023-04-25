#include "swift/extractor/invocation/SwiftDiagnosticsConsumer.h"
#include "swift/extractor/trap/generated/TrapEntries.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/infra/SwiftDiagnosticKind.h"

#include <swift/AST/DiagnosticEngine.h>
#include <swift/Basic/SourceManager.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/raw_ostream.h>
#include <string>

using namespace codeql;

void SwiftDiagnosticsConsumer::handleDiagnostic(swift::SourceManager& sourceManager,
                                                const swift::DiagnosticInfo& diagInfo) {
  auto message = getDiagMessage(sourceManager, diagInfo);
  DiagnosticsTrap diag{};
  diag.id = trap.createLabel<DiagnosticsTag>();
  diag.kind = translateDiagnosticsKind(diagInfo.Kind);
  diag.text = message;
  trap.emit(diag);
  locationExtractor.attachLocation(sourceManager, diagInfo.Loc, diagInfo.Loc, diag.id);
}

std::string SwiftDiagnosticsConsumer::getDiagMessage(swift::SourceManager& sourceManager,
                                                     const swift::DiagnosticInfo& diagInfo) {
  llvm::SmallString<256> text;
  llvm::raw_svector_ostream out(text);
  swift::DiagnosticEngine::formatDiagnosticText(out, diagInfo.FormatString, diagInfo.FormatArgs);
  return text.str().str();
}
